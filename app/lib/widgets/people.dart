import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  final List<String> people;

  const People({
    super.key,
    required this.people,
  });

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("People"),
            Text("Select all"),
          ],
        ),
        Expanded(
          child: CupertinoScrollbar(
            child: ListView.separated(
              shrinkWrap: true,
              itemBuilder: (context, i) => Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Row(
                      children: [
                        Container(
                          width: 2,
                          height: 15,
                          color: Colors.red,
                        ),
                        const SizedBox(width: 10.0),
                        Text(widget.people[i]),
                        // Expanded(),
                      ],
                    ),
                  ),
                ),
              ),
              separatorBuilder: (context, _) => Divider(
                color: Theme.of(context).colorScheme.secondary,
              ),
              itemCount: widget.people.length,
            ),
          ),
        ),
      ],
    );
  }
}
