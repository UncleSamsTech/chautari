import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

class PhoneNumberField extends StatelessWidget {
  const PhoneNumberField({super.key, required this.phoneNumberController});
  final TextEditingController phoneNumberController;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12,vertical: 4),
      decoration: BoxDecoration(
          border: Border.all(), borderRadius: BorderRadius.circular(8)),
      child: InternationalPhoneNumberInput(
        onInputChanged: (PhoneNumber number) {
          print(number.phoneNumber);
        },
        onInputValidated: (bool value) {
          print(value);
        },
        selectorConfig: SelectorConfig(
          selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
          useBottomSheetSafeArea: true,
        ),
        ignoreBlank: false,
        selectorTextStyle: TextStyle(color: Colors.black),
        textFieldController: phoneNumberController,
        formatInput: true,
        textAlignVertical: TextAlignVertical.center,
        keyboardType:
            TextInputType.numberWithOptions(signed: true, decimal: true),
        inputBorder: InputBorder.none,
        
        onSaved: (PhoneNumber number) {
          print('On Saved: $number');
        },
      ),
    );
  }
}
