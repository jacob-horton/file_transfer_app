package main

import (
	"flag"
	"log"
	"net/http"

	"github.com/google/uuid"
	"github.com/gorilla/websocket"
)

var addr = flag.String("addr", "0.0.0.0:5000", "http service address")
var upgrader = websocket.Upgrader{}

var clients = map[string]*websocket.Conn{}

func forward(c *websocket.Conn, mt int, data []byte) {
	for _, other := range clients {
		if c == other {
			continue
		}

		other.WriteMessage(mt, data)
	}
}

func handleWebRTC(w http.ResponseWriter, r *http.Request) {
	c, err := upgrader.Upgrade(w, r, nil)
	if err != nil {
		log.Println("upgrade:", err)
		return
	}

	id := uuid.New().String()
	clients[id] = c

	defer c.Close()
	for {
		mt, m, err := c.ReadMessage()
		if err != nil {
			log.Println("error reading, disconnecting:", err)
			delete(clients, id)
			break
		}

		forward(c, mt, m)
	}
}

func main() {
	flag.Parse()
	log.SetFlags(0)
	http.HandleFunc("/", handleWebRTC)
	log.Fatal(http.ListenAndServe(*addr, nil))
}
