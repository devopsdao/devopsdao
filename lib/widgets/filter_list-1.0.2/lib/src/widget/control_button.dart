import 'package:filter_list/src/theme/theme.dart';
import 'package:flutter/material.dart';

class ControlButton extends StatelessWidget {
  const ControlButton({
    Key? key,
    required this.choiceChipLabel,
    this.onPressed,
    this.primaryButton = false,
  }) : super(key: key);
  final String choiceChipLabel;
  final VoidCallback? onPressed;
  final bool primaryButton;

  @override
  Widget build(BuildContext context) {
    final theme = ControlButtonTheme.of(context);
    final boxDecor = BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius),
        gradient: const LinearGradient(
          colors: [Color(0xfffadb00), Colors.deepOrangeAccent, Colors.deepOrange],
          stops: [0, 0.6, 1],
        )
    );
    final boxDecor2 = BoxDecoration(
        borderRadius: BorderRadius.circular(theme.borderRadius),
        border: Border.all(
            width: 0.5,
            color: Colors.black54
        ),
    );
    return InkWell(
      onTap: onPressed,
      child: Container(
        margin: const EdgeInsets.all(0.0),
        height: 54.0,
        width: theme.buttonWidth,
        alignment: Alignment.center,
        decoration: primaryButton ? boxDecor : boxDecor2,
        clipBehavior: Clip.antiAlias,
        child: Text(
          choiceChipLabel,
          textAlign: TextAlign.center,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: primaryButton ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
    );


    // return TextButton(
    //   style: ButtonStyle(
    //     shape: MaterialStateProperty.all(RoundedRectangleBorder(
    //       borderRadius: BorderRadius.all(Radius.circular(theme.borderRadius)),
    //     )),
    //     backgroundColor: MaterialStateProperty.all(
    //       primaryButton
    //           ? theme.primaryButtonBackgroundColor
    //           : theme.backgroundColor,
    //     ),
    //     elevation: MaterialStateProperty.all(theme.elevation),
    //     foregroundColor: MaterialStateProperty.all(
    //       primaryButton
    //           ? theme.primaryButtonTextStyle!.color
    //           : theme.textStyle!.color,
    //     ),
    //     textStyle: MaterialStateProperty.all(
    //       primaryButton ? theme.primaryButtonTextStyle : theme.textStyle,
    //     ),
    //     padding: MaterialStateProperty.all(theme.padding),
    //
    //   ),
    //
    //   onPressed: onPressed,
    //   clipBehavior: Clip.antiAlias,
    //   child: Text(
    //     choiceChipLabel,
    //     textAlign: TextAlign.center,
    //     overflow: TextOverflow.ellipsis,
    //   ),
    // );
  }
}
