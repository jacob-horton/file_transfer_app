import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:heroicons/heroicons.dart';

class People extends StatefulWidget {
  final List<String> people;
  final void Function(Set<int> selected) onSelectedChanged;

  const People({
    super.key,
    required this.people,
    required this.onSelectedChanged,
  });

  @override
  State<People> createState() => _PeopleState();
}

class _PeopleState extends State<People> {
  Set<int> selected = {};

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("People", style: Theme.of(context).textTheme.titleSmall),
            GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () {
                setState(() {
                  // TODO: handle this better
                  if (selected.length == widget.people.length) {
                    selected = {};
                  } else {
                    selected = List<int>.generate(
                      widget.people.length,
                      (i) => i,
                    ).toSet();
                  }
                });
              },
              child: Text(
                selected.length == widget.people.length
                    ? "Deselect all"
                    : "Select all",
              ),
            ),
          ],
        ),
        const SizedBox(height: 10.0),
        Expanded(
          child: CupertinoScrollbar(
            child: ListView.separated(
              padding: const EdgeInsets.only(top: 5.0, bottom: 10.0),
              shrinkWrap: true,
              itemBuilder: (context, i) => GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  setState(() {
                    if (selected.contains(i)) {
                      selected.remove(i);
                    } else {
                      selected.add(i);
                    }

                    widget.onSelectedChanged(selected);
                  });
                },
                child: Center(
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
                              color: selected.contains(i)
                                  ? Theme.of(context).colorScheme.tertiary
                                  : Theme.of(context).colorScheme.secondary,
                            ),
                          ),
                          const SizedBox(width: 10.0),
                          Text(widget.people[i]),
                          if (selected.contains(i))
                            Expanded(
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: HeroIcon(
                                  HeroIcons.checkCircle,
                                  color: Theme.of(context).colorScheme.tertiary,
                                  size: 20,
                                ),
                              ),
                            ),
                        ],
                      ),
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
          "${selected.isEmpty ? 'No one' : selected.length} selected",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
