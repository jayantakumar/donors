import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {this.shareKey,
      this.obscureText = false,
      this.keyboardType = TextInputType.text,
      this.labelText = "",
      this.focusNode,
      this.nextfocus,
      this.onChanged,
      this.errorText});
  final TextEditingController controller = new TextEditingController();
  final bool obscureText;
  final FocusNode focusNode, nextfocus;
  final String labelText, shareKey, errorText;
  final TextInputType keyboardType;
  final Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onEditingComplete: () {
        onChanged(controller.text);
      },
      focusNode: focusNode,
      keyboardType: keyboardType,
      //Storeval(shareKey, controller.text);

      textInputAction: TextInputAction.next,
      //cursorWidth: 3.0,
      onFieldSubmitted: (v) {
        if (nextfocus != null)
          FocusScope.of(context).requestFocus(nextfocus);
        else
          focusNode.unfocus();
      },
      //cursorRadius: Radius.circular(2),
      //autofocus: false,

      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
        errorText: errorText,
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Colors.red, width: 4),
        ),
        labelStyle: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black, width: 4),
          borderRadius: BorderRadius.circular(0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(0),
          borderSide: BorderSide(color: Colors.black54, width: 4),
        ),
        labelText: labelText,
      ),
    );
  }
}

void Storeval(String key, String val) async {
  SharedPreferences preferences = await SharedPreferences.getInstance();
  await preferences.setString(key, val);
  print(preferences.get(key));
}
