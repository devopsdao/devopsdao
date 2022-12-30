import 'package:filter_list/filter_list.dart';
import 'package:flutter/material.dart';

class ChoiceChipSelectedWidget<T> extends StatefulWidget {
  const ChoiceChipSelectedWidget({
    Key? key,
    this.text,
    this.item,
    this.selected,
    this.onSelected,
    this.choiceChipBuilderSelected,
  }) : super(key: key);

  final String? text;
  final bool? selected;
  final void Function(bool)? onSelected;
  final T? item;

  /// Builder for custom choice chip
  final ChoiceChipBuilderSelected? choiceChipBuilderSelected;

  @override
  State<ChoiceChipSelectedWidget<T>> createState() => _ChoiceChipSelectedWidgetState<T>();
}

class _ChoiceChipSelectedWidgetState<T> extends State<ChoiceChipSelectedWidget<T>> with TickerProviderStateMixin  {

  // late final AnimationController _controller = AnimationController(
  //     duration: const Duration(milliseconds: 450),
  //     vsync: this,
  //     value: 1.0,
  // );
  // late final Animation<double> _animation = CurvedAnimation(
  //   parent: _controller,
  //   curve: Curves.fastOutSlowIn,
  // );

  @override
  void initState() {
    // _controller.forward();
    super.initState();

  }

  @override
  void dispose() {
    // _controller.dispose();
    super.dispose();
  }

  // final ChoiceChipBuilderSelected? choiceChipBuilderSelected;
  TextStyle? getSelectedTextStyle(BuildContext context) {
    return widget.selected!
        ? FilterListTheme.of(context).choiceChipTheme.selectedTextStyle
        : FilterListTheme.of(context).choiceChipTheme.textStyle;
  }

  Color? getBackgroundColor(BuildContext context) {
    return widget.selected!
        ? FilterListTheme.of(context).choiceChipTheme.selectedBackgroundColor
        : FilterListTheme.of(context).choiceChipTheme.backgroundColor;
  }

  OutlinedBorder? getShape(BuildContext context) {
    return widget.selected!
        ? FilterListTheme.of(context).choiceChipTheme.selectedShape
        : FilterListTheme.of(context).choiceChipTheme.shape;
  }

  BorderSide? getSide(BuildContext context) {
    return widget.selected!
        ? FilterListTheme.of(context).choiceChipTheme.selectedSide
        : FilterListTheme.of(context).choiceChipTheme.side;
  }

  @override
  Widget build(BuildContext context) {
    final theme = FilterListTheme.of(context).choiceChipTheme;
    return widget.choiceChipBuilderSelected != null
        ? GestureDetector(
            onTap: () {
              widget.onSelected!(true);
              // _controller.reverse();
              // Future.delayed(
              //     const Duration(milliseconds: 450), () {
              //
              // });
            },
            child: widget.choiceChipBuilderSelected!(context, widget.item, widget.selected)

            // ScaleTransition(
            //     scale: _animation,
            //     child: ),
          )
        : Padding(
            padding: theme.margin,
            child: ChoiceChip(
              labelPadding: theme.labelPadding,
              padding: theme.padding,
              backgroundColor: getBackgroundColor(context),
              selectedColor: theme.selectedBackgroundColor,
              label: Text('${widget.text}'),
              labelStyle: getSelectedTextStyle(context),
              visualDensity: theme.visualDensity,
              selected: widget.selected!,
              onSelected: widget.onSelected,
              elevation: theme.elevation,
              side: getSide(context),
              shape: getShape(context),
              shadowColor: theme.shadowColor,
              selectedShadowColor: theme.selectedShadowColor,
            ),
          );
  }
}

