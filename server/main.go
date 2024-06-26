package main

import (
	"encoding/json"
	"flag"
	"fmt"
	"log"
	"net/http"
	"strings"

	petname "github.com/dustinkirkland/golang-petname"
	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "0.0.0.0:5000", "http service address")
var upgrader = websocket.Upgrader{}

type Room = map[string]*websocket.Conn

var rooms = map[string]Room{}

type Message struct {
	Event string `json:"event"`
	Data  string `json:"data"`
}

func forward(c *websocket.Conn, mt int, data []byte, roomName string) {
	for _, other := range rooms[roomName] {
		if c == other {
			continue
		}

		other.WriteMessage(mt, data)
	}
}

func getPeople(roomName string) []string {
	// Send initial people
	people := []string{}
	for p := range rooms[roomName] {
		people = append(people, p)
	}

	return people
}

func mainLoop(c *websocket.Conn, roomName string, name string) {
	// TODO: handle in separate function?
	defer c.Close()
	for {
		mt, m, err := c.ReadMessage()
		if err != nil {
			log.Println("error reading, disconnecting:", err)
			delete(rooms[roomName], name)
			updatePeople(roomName)

			if len(rooms[roomName]) == 0 {
				delete(rooms, roomName)
			}

			break
		}

		var message Message
		err = json.Unmarshal(m, &message)
		if err != nil {
			panic(err)
		}

		switch message.Event {
		case "leaveRoom":
			delete(rooms[roomName], name)
			updatePeople(roomName)

			if len(rooms[roomName]) == 0 {
				delete(rooms, roomName)
			}
		default:
			forward(c, mt, m, roomName)
		}
	}
}

func updatePeople(roomName string) {
	people := getPeople(roomName)

	// Send people updated to everyone
	for _, c := range rooms[roomName] {
		encodedData, err := json.Marshal(people)
		if err != nil {
			panic(err)
		}
		payload, err := json.Marshal(Message{
			Data: string(encodedData), Event: "peopleUpdated",
		})
		if err != nil {
			panic(err)
		}

		c.WriteMessage(websocket.TextMessage, payload)
	}
}

func handleCreateRoom(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade:", err)
		return
	}

	// Read init message
	_, m, err := c.ReadMessage()
	if err != nil {
		log.Println("error reading, disconnecting:", err)
		return
	}

	var message Message
	err = json.Unmarshal(m, &message)
	if err != nil {
		panic(err)
	}

	if message.Event != "init" {
		panic("first event was not 'init'")
	}

	name := message.Data

	// Create room with this user in it
	// TODO: check for collisions
	roomName := strings.ToLower(petname.Generate(3, "-"))
	rooms[roomName] = Room{name: c}

	fmt.Printf("creating room %s\n", roomName)

	people := getPeople(roomName)
	data := map[string]interface{}{
		"people":   people,
		"roomName": roomName,
	}

	encodedData, err := json.Marshal(data)
	if err != nil {
		panic(err)
	}

	payload, err := json.Marshal(Message{
		Data:  string(encodedData),
		Event: "roomJoined",
	})
	if err != nil {
		panic(err)
	}

	c.WriteMessage(websocket.TextMessage, payload)

	mainLoop(c, roomName, name)
}

func handleJoinRoom(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade:", err)
		return
	}

	// Read init message
	_, m, err := c.ReadMessage()
	if err != nil {
		log.Println("error reading, disconnecting:", err)
		return
	}

	var message Message
	err = json.Unmarshal(m, &message)
	if err != nil {
		panic(err)
	}

	if message.Event != "init" {
		panic("first event was not 'init'")
	}

	name := message.Data

	// Create room with this user in it
	parts := strings.Split(r.URL.Path, "/")
	roomName := parts[len(parts)-1]

	if _, ok := rooms[roomName]; !ok {
		panic("room does not exist")
	}

	if _, ok := rooms[roomName][name]; ok {
		panic("person with that name is already in room")
	}

	rooms[roomName][name] = c

	fmt.Printf("joining room %s\n", roomName)

	people := getPeople(roomName)
	data := map[string]interface{}{
		"people":   people,
		"roomName": roomName,
	}

	// Room joined event
	encodedData, err := json.Marshal(data)
	if err != nil {
		panic(err)
	}
	payload, err := json.Marshal(Message{
		Data: string(encodedData), Event: "roomJoined",
	})
	if err != nil {
		panic(err)
	}

	c.WriteMessage(websocket.TextMessage, payload)

	updatePeople(roomName)
	mainLoop(c, roomName, name)
}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/create-room", handleCreateRoom)
	http.HandleFunc("/join-room/*", handleJoinRoom)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
