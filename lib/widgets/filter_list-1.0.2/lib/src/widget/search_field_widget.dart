import 'package:filter_list/src/theme/filter_list_theme.dart';
import 'package:flutter/material.dart';

class SearchFieldWidget<T> extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const SearchFieldWidget({
    Key? key,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final headerTheme = FilterListTheme.of(context).headerTheme;
    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius:
              BorderRadius.circular(headerTheme.searchFieldBorderRadius),
          color: headerTheme.searchFieldBackgroundColor,
        ),
        child: TextField(
          onChanged: onChanged,
          style: headerTheme.searchFieldTextStyle,
          decoration: InputDecoration(
            // fillColor: Colors.white,
            // filled: true,
            prefixIcon:
                Icon(Icons.search, color: headerTheme.searchFieldIconColor),
            hintText: headerTheme.searchFieldHintText,
            hintStyle: headerTheme.searchFieldHintTextStyle,
            labelText: headerTheme.searchFieldLabelText,
            labelStyle: const TextStyle(
                fontSize: 17.0, color: Colors.black54),
            border: headerTheme.searchFieldInputBorder,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15.0),
              borderSide: const BorderSide(
                color: Colors.blueAccent,
                width: 1.0,
              ),
            ),
          ),

        ),
      ),
    );
  }
}
