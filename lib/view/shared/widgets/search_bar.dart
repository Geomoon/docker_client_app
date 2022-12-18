import 'package:flutter/material.dart';

class SearchBar extends StatefulWidget {
  const SearchBar(
      {super.key, required this.hintText, required this.onSearch, this.width});

  final Function(String) onSearch;
  final String hintText;
  final double? width;

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? 500,
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              onSubmitted: (value) => widget.onSearch(value),
              style: const TextStyle(fontFamily: 'Inter', fontSize: 14),
              decoration: InputDecoration(
                  hintStyle: const TextStyle(fontWeight: FontWeight.normal),
                  hintText: widget.hintText,
                  border: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.outline))),
            ),
          ),
          const SizedBox(width: 10.0),
          SizedBox(
            height: 50,
            width: 50,
            child: IconButton(
              onPressed: () => widget.onSearch(_controller.text),
              icon: const Icon(Icons.search_rounded),
              style: IconButton.styleFrom(
                foregroundColor:
                    Theme.of(context).colorScheme.onSecondaryContainer,
                backgroundColor:
                    Theme.of(context).colorScheme.secondaryContainer,
                disabledBackgroundColor:
                    Theme.of(context).colorScheme.onSurface.withOpacity(0.12),
                hoverColor: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.08),
                focusColor: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.12),
                highlightColor: Theme.of(context)
                    .colorScheme
                    .onSecondaryContainer
                    .withOpacity(0.12),
              ),
            ),
          )
        ],
      ),
    );
  }
}
