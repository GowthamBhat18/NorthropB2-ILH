import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';
import 'package:wall_et_ui/screens/cards_screen.dart';

class AddCardScreen extends StatefulWidget {
  const AddCardScreen({Key? key}) : super(key: key);

  @override
  State<AddCardScreen> createState() => _AddCardScreenState();
}

class _AddCardScreenState extends State<AddCardScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final int cvvLength = 3;
  final int cardNumberMaxLength = 19;
  final int expiryDateMaxLength = 5;

  void _formatCardNumber(String input) {
    String formattedInput = input.replaceAll(RegExp(r'\D'), '');

    if (formattedInput.length > 4) {
      formattedInput = formattedInput.substring(0, 4) +
          '-' +
          formattedInput.substring(4, formattedInput.length);
    }
    if (formattedInput.length > 9) {
      formattedInput = formattedInput.substring(0, 9) +
          '-' +
          formattedInput.substring(9, formattedInput.length);
    }
    if (formattedInput.length > 14) {
      formattedInput = formattedInput.substring(0, 14) +
          '-' +
          formattedInput.substring(14, formattedInput.length);
    }

    _numberController.value = TextEditingValue(
      text: formattedInput,
      selection: TextSelection.collapsed(offset: formattedInput.length),
    );
  }

  void _formatExpiryDate(String input) {
    String formattedInput = input.replaceAll(RegExp(r'\D'), '');
    if (formattedInput.length > 2) {
      formattedInput = formattedInput.substring(0, 2) +
          '/' +
          formattedInput.substring(2, formattedInput.length);
    }
    _expiryController.value = TextEditingValue(
      text: formattedInput,
      selection: TextSelection.collapsed(offset: formattedInput.length),
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(
                15.w,
              ),
              height: 102.h,
              width: 375.w,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Colors.black.withOpacity(0.1),
                    width: 1.h,
                  ),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: FittedBox(
                        child: SvgPicture.asset(
                          'assets/images/back_icon.svg',
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  Text(
                    "Add Card",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                  ),
                ],
              ),
            ),
            const VerticalSpacer(height: 32),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Cardholder Name",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const VerticalSpacer(height: 8),
                  TextField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: "Enter your name as written on card",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: const Color(0xFF1A1A1A).withOpacity(0.1),
                          width: 1.sp,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.sp,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(height: 24),
                  Text(
                    "Card Number",
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF1A1A1A),
                    ),
                  ),
                  const VerticalSpacer(height: 8),
                  TextField(
                    inputFormatters: [
                      LengthLimitingTextInputFormatter(cardNumberMaxLength),
                    ],
                    onChanged: (value) {
                      _formatCardNumber(value);
                    },
                    controller: _numberController,
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    cursorColor: Theme.of(context).colorScheme.primary,
                    decoration: InputDecoration(
                      hintText: "Enter card number",
                      hintStyle: TextStyle(
                        fontSize: 14.sp,
                        color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: const Color(0xFF1A1A1A).withOpacity(0.1),
                          width: 1.sp,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.w),
                        borderSide: BorderSide(
                          color: Theme.of(context).colorScheme.primary,
                          width: 1.sp,
                        ),
                      ),
                    ),
                  ),
                  const VerticalSpacer(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "cvv/cvc",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const VerticalSpacer(height: 8),
                            TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(cvvLength),
                                CVVInputFormatter(),
                              ],
                              controller: _cvvController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              decoration: InputDecoration(
                                hintText: "123",
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF1A1A1A)
                                      .withOpacity(0.2494),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF1A1A1A)
                                        .withOpacity(0.1),
                                    width: 1.sp,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const HorizontalSpacer(width: 15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Exp. Date",
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF1A1A1A),
                              ),
                            ),
                            const VerticalSpacer(height: 8),
                            TextField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(
                                    expiryDateMaxLength),
                              ],
                              onChanged: (value) {
                                _formatExpiryDate(value);
                              },
                              controller: _expiryController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              cursorColor:
                                  Theme.of(context).colorScheme.primary,
                              decoration: InputDecoration(
                                hintText: "20/20",
                                hintStyle: TextStyle(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF1A1A1A)
                                      .withOpacity(0.2494),
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  borderSide: BorderSide(
                                    color: const Color(0xFF1A1A1A)
                                        .withOpacity(0.1),
                                    width: 1.sp,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10.w),
                                  borderSide: BorderSide(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    width: 1.sp,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 81.h,
        width: 375.w,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20.w),
            topRight: Radius.circular(20.w),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              offset: const Offset(0, -10),
              blurRadius: 10,
            ),
          ],
        ),
        child: Center(
          child: InkWell(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              height: 49.h,
              width: 345.w,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.w),
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Submit Card",
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
