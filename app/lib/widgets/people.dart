import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class People extends StatefulWidget {
  final List<String> people;
  final List<int> selected;

  const People({
    super.key,
    required this.people,
    required this.selected,
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("People", style: Theme.of(context).textTheme.titleSmall),
            const Text("Select all"),
          ],
        ),
        const SizedBox(height: 10.0),
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
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10000),
                            color: widget.selected.contains(i)
                                ? Theme.of(context).colorScheme.tertiary
                                : Theme.of(context).colorScheme.secondary,
                          ),
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
        const SizedBox(height: 5.0),
        Text(
          "${widget.selected.length} selected",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
