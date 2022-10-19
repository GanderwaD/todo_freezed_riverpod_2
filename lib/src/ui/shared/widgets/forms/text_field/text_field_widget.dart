/*
 * ---------------------------
 * File : text_field_widget.dart
 * ---------------------------
 * Author : Nesrullah Ekinci (nesmin)
 * Email : dev.nesmin@gmail.com
 * ---------------------------
 */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../form_decoration.dart';
import 'text_field_decoration.dart';

class TextFieldWidget extends StatelessWidget {
  const TextFieldWidget({
    super.key,
    this.margin,
    this.label,
    this.inputDecoration,
    this.keyboardType,
    this.controller,
    this.validator,
    this.onInputChanged,
    this.inputTextStyle,
    this.isEnabled = true,
    this.inputMaxLength,
    this.initialValue,
    this.inputFocusNode,
    this.inputAction,
    this.onInputSubmitted,
    this.inputBackgroundColor,
    this.labelText,
    this.inputMaxLines = 1,
    this.autovalidateMode,
    this.obscureText = false,
    this.enableSelection = true,
  });
  final EdgeInsets? margin;
  final Widget? label;
  final InputDecoration? inputDecoration;
  final TextInputType? keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final void Function(String)? onInputChanged;
  final TextStyle? inputTextStyle;
  final bool isEnabled;
  final int? inputMaxLength;
  final String? initialValue;
  final FocusNode? inputFocusNode;
  final TextInputAction? inputAction;
  final void Function(String)? onInputSubmitted;
  final Color? inputBackgroundColor;
  final String? labelText;
  final int? inputMaxLines;
  final bool obscureText;
  final bool enableSelection;
  final AutovalidateMode? autovalidateMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          labelText != null
              ? labelWidget(text: labelText ?? '')
              : label ?? const SizedBox.shrink(),
          TextFormField(
            
            enableInteractiveSelection: enableSelection,
            autovalidateMode:
                autovalidateMode ?? AutovalidateMode.onUserInteraction,
            initialValue: initialValue,
            enabled: isEnabled,
            maxLength: inputMaxLength,
            maxLines: inputMaxLines,
            maxLengthEnforcement: inputMaxLength != null
                ? MaxLengthEnforcement.truncateAfterCompositionEnds
                : MaxLengthEnforcement.none,
            buildCounter: inputMaxLength == null ? null : buildCounter,
            keyboardType: keyboardType,
            controller: controller,
            focusNode: inputFocusNode,
            textInputAction: inputAction,
            onFieldSubmitted: onInputSubmitted,
            onChanged: onInputChanged,
            obscureText: obscureText,
            validator: validator,
            style: inputTextStyle,
            decoration: inputDecoration ?? textFieldDecoration(),
          ),
        ],
      ),
    );
  }
}
