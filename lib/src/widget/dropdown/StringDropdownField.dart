import 'package:flutter/material.dart';
import 'package:helper_set/model_set.dart';

import 'MyDropdown.dart';
import 'MyDropdownDivider.dart';

class StringDropdownField<T extends DropdownModel> extends FormField<T> {
  final List<T>? data;
  final bool isActive;
  final TextStyle? errorStyle;
  final Color? colorText;
  final Color? colorBackground;

  final String? textHint;

  StringDropdownField(
      {Key? key,
      this.data,
      this.isActive = true,
      this.errorStyle,
      this.colorText,
      this.colorBackground,
      this.textHint,
      FormFieldSetter<T>? onSaved,
      FormFieldValidator<T>? validator,
      T? initialValue,
      Function(T)? onSelected})
      : super(
            key: key,
            onSaved: onSaved,
            validator: validator,
            initialValue: initialValue,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (FormFieldState<T> state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  MyDropdown<T>(
                    initialValue: initialValue,
                    colorText: colorText ?? Colors.black,
                    colorBackground: colorBackground ?? Color(0xffF6F7FB),
                    onSelected: (item) {
                      if (isActive) {
                        onSelected!(item);
                        state.didChange(item);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return List<PopupMenuEntry<T>>.generate(
                          (data!.length * 2 - 1), (int index) {
                        if (index.isEven) {
                          final item = data[index ~/ 2];
                          return PopUpObject<T>(value: item);
                        } else {
                          return MyDropdownDivider();
                        }
                      });
                    },
                    child: state.value == null
                        ? Text(
                            textHint ?? 'Pilih',
                          )
                        : DropdownObject(state.value),
                  ),
                  if (state.hasError)
                    Container(
                      padding: EdgeInsets.fromLTRB(4, 12, 4, 0),
                      child: Text(
                        state.errorText!,
                        style: errorStyle ?? TextStyle(color: Colors.red),
                        textAlign: TextAlign.start,
                      ),
                    )
                ],
              );
            });
}

class PopUpObject<T extends DropdownModel> extends PopupMenuEntry<T> {
  const PopUpObject({
    Key? key,
    this.value,
  }) : super(key: key);

  final T? value;

  @override
  _PopUpObjectItemState<T> createState() => _PopUpObjectItemState<T>();

  @override
  // double get height => 72.0;
  double get height => 32.0;

  @override
  bool represents(T? value) => this.value == value;
}

class _PopUpObjectItemState<T extends DropdownModel>
    extends State<PopUpObject<T>> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pop<T>(widget.value),
      child: Padding(
          padding: EdgeInsets.all(8.0), child: DropdownObject(widget.value)),
    );
  }
}

class DropdownObject<T extends DropdownModel?> extends StatelessWidget {
  final T data;

  DropdownObject(this.data);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.only(top: 4, bottom: 4),
        child: Text(data!.getText()),
      );
}
