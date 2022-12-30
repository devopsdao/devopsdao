import 'package:filter_list/filter_list.dart';
import 'package:filter_list/src/state/filter_state.dart';
import 'package:filter_list/src/state/provider.dart';
import 'package:filter_list/src/widget/choice_chip_widget.dart';
import 'package:flutter/material.dart';

import 'choice_chip_selected_widget.dart';

class ChoiceListSelected<T> extends StatelessWidget {
  const ChoiceListSelected({
    Key? key,
    required this.validateSelectedItem,
    this.choiceChipBuilderSelected,
    this.choiceChipLabel,
    this.enableOnlySingleSelection = false,
    this.validateRemoveItem,
  }) : super(key: key);
  final ValidateSelectedItem<T> validateSelectedItem;
  final ChoiceChipBuilderSelected? choiceChipBuilderSelected;
  final LabelDelegate<T>? choiceChipLabel;
  final bool enableOnlySingleSelection;
  final ValidateRemoveItem<T>? validateRemoveItem;

  List<Widget> _buildChoiceList(BuildContext context) {
    final theme = FilterListTheme.of(context).controlBarButtonTheme;
    final state = StateProvider.of<FilterState<T>>(context);
    final items = state.selectedItems;
    final selectedListData = state.selectedItems;
    if (items == null || items.isEmpty) {
      return const <Widget>[];
    }
    final List<Widget> choices = [];
    for (final item in items) {

      final selected = validateSelectedItem(selectedListData, item);
      choices.add(
        ChoiceChipSelectedWidget(
          choiceChipBuilderSelected: choiceChipBuilderSelected,
          item: item,
          onSelected: (value) {
            if (enableOnlySingleSelection) {
              state.clearSelectedList();
              state.addSelectedItem(item);
            } else {
              if (selected) {
                if (validateRemoveItem != null) {
                  final shouldDelete =
                      validateRemoveItem!(selectedListData, item);
                  state.selectedItems = shouldDelete;
                } else {
                  state.removeSelectedItem(item);
                }
              } else {
                state.addSelectedItem(item);
              }
            }
          },
          selected: selected,
          text: choiceChipLabel!(item),
        ),
      );
    }
    choices.add(
      SizedBox(
        // height: theme.height + 20,
        width: MediaQuery.of(context).size.width,
      ),
    );
    return choices;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FilterListTheme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
      child: SingleChildScrollView(
        child: ChangeNotifierProvider<FilterState<T>>(
          builder: (
            BuildContext context,
            FilterState<T> state,
            Widget? child,
          ) {
            return Wrap(
              alignment: theme.wrapAlignment,
              crossAxisAlignment: theme.wrapCrossAxisAlignment,
              runSpacing: theme.wrapSpacing,
              children: _buildChoiceList(context),
            );
          },
        ),
      ),
    );
  }
}
