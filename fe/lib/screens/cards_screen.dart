import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wall_et_ui/base_url.dart';
import 'package:wall_et_ui/screens/add_card_screen.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';
import 'package:http/http.dart' as http;


class Card {
  final String cardNumber;
  final String cardHolderName;
  final String expiryDate;

  Card({
    required this.cardNumber,
    required this.cardHolderName,
    required this.expiryDate,
  });
}

class CardsScreen extends StatefulWidget {
  CardsScreen({Key? key}) : super(key: key);

  @override
  State<CardsScreen> createState() => _CardsScreenState();
}

class _CardsScreenState extends State<CardsScreen> {

  final List<Card> cards = [
    Card(
      cardNumber: "1234  5678  9123  4567",
      cardHolderName: "Bob",
      expiryDate: "02/23",
    ),
    Card(
      cardNumber: "1234  5678  9123  4567",
      cardHolderName: "Rob",
      expiryDate: "02/23",
    ),
    Card(
      cardNumber: "1234  5678  9123  4567",
      cardHolderName: "Tanya Robinson",
      expiryDate: "02/23",
    ),
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();

  final int cvvLength = 3;
  final int cardNumberMaxLength = 19;
  final int expiryDateMaxLength = 5;
  String _rawCardNumber = "";
  String _rawExp = "";

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Container(
          height: 300.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: FlareActor(
                  "assets/animations/Success Check.flr",
                  animation: "animate",
                ),
              ),
              const VerticalSpacer(height: 20),
              Text(
                "Card Added!",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 20.sp,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showFailedDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: Container(
          height: 250.h,
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
                height: 100.h,
                child: FlareActor(
                  "assets/animations/failed.flr",
                  animation: "failed",
                ),
              ),
              Text(
                "Failed to add Card",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Colors.red[400]
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addCard() async {
    setState(() {
      cards.add(
        Card(
          cardNumber: _numberController.text,
          cardHolderName: _nameController.text,
          expiryDate: _expiryController.text,
        ),
      );
    });
    Map<String, dynamic> addCard = {
      "bigSerial": _rawCardNumber,
      "type": "Visa",
      "expiryDate": _rawExp,
      "cardholderName": _nameController.text,
      "userId": 5
    };
    print(addCard);
    try {
      final response = await http.post(
        Uri.parse(postCreateCardUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(addCard),
      );

      if (response.statusCode == 201) {
        // Wait for a short duration to ensure the server processes the request
        await Future.delayed(Duration(seconds: 1));
        _showSuccessDialog();
      } else {
        _showFailedDialog();
        throw Exception('Failed to add!');
      }
    } catch (error) {
      print('Error: $error');
    }


    _nameController.clear();
    _numberController.clear();
    _expiryController.clear();
    _cvvController.clear();
  }

  void _formatCardNumber(String input) {
    String formattedInput = input.replaceAll(RegExp(r'\D'), '');
    _rawCardNumber = formattedInput;
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
    _rawExp = formattedInput;
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
                  SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/back_icon.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                  Text(
                    "My Cards",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AddCardScreen(),
                        ),
                      );
                    },
                    child: SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: FittedBox(
                        child: SvgPicture.asset(
                          'assets/images/add_icon.svg',
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(22.0),
              child: SizedBox(
                height: 170.h,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) => PaymentCard(
                    card: cards[index],
                  ),
                  separatorBuilder: (context, index) =>
                      const HorizontalSpacer(width: 15),
                  itemCount: cards.length,
                ),
              ),
            ),
            const VerticalSpacer(height: 7),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: const Color(0xFF8FA1B4).withOpacity(0.2965),
                      shape: BoxShape.circle),
                ),
                const HorizontalSpacer(width: 6),
                Container(
                  width: 8.w,
                  height: 8.h,
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      shape: BoxShape.circle),
                ),
                const HorizontalSpacer(width: 6),
                Container(
                  width: 6.w,
                  height: 6.h,
                  decoration: BoxDecoration(
                      color: const Color(0xFF8FA1B4).withOpacity(0.2965),
                      shape: BoxShape.circle),
                ),
              ],
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
                  TextFormField(
                    controller: _nameController,
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
                                LengthLimitingTextInputFormatter(expiryDateMaxLength),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            InkWell(
              onTap: _addCard,
              child: Container(
                height: 49.h,
                width: 281.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.w),
                  color: Theme.of(context).colorScheme.primary,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Save Changes",
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
            const HorizontalSpacer(width: 15),
            InkWell(
              onTap: () => _showConfimrationDialog(context),
              child: Container(
                height: 49.h,
                width: 49.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.w),
                  color: const Color(0xFFFB3640),
                ),
                child: Center(
                  child: SizedBox(
                    width: 24.w,
                    height: 24.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/remove_icon.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showConfimrationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        insetPadding: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        child: SizedBox(
          height: 373.h,
          width: 327.w,
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 10.w,
            ),
            child: Column(
              children: [
                const VerticalSpacer(height: 40),
                SizedBox(
                  width: 240.w,
                  height: 180.h,
                  child: FittedBox(
                    child: SvgPicture.asset(
                        'assets/images/remove_illustration.svg'),
                    fit: BoxFit.fill,
                  ),
                ),
                const VerticalSpacer(height: 24),
                Text(
                  "Are you sure to remove this card?",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                const VerticalSpacer(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 49.h,
                        width: 148.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.w),
                          color: Colors.transparent,
                        ),
                        child: Center(
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: Container(
                        height: 49.h,
                        width: 148.w,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.w),
                          color: const Color(0xFFFB3640),
                        ),
                        child: Center(
                          child: Text(
                            "Remove",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PaymentCard extends StatelessWidget {
  const PaymentCard({Key? key, required this.card}) : super(key: key);

  final Card card;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 285.w,
          height: 170.h,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          left: 5.w,
          top: 51.h,
          child: SizedBox(
            width: 396.w,
            height: 128.h,
            child: FittedBox(
              child: SvgPicture.asset(
                'assets/images/visa_logo.svg',
              ),
              fit: BoxFit.fitHeight,
            ),
          ),
        ),
        SizedBox(
          width: 285.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 32.13.w,
                    height: 10.38.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/visa_logo_small.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                //const VerticalSpacer(height: 7),
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 35.w,
                    height: 26.h,
                    child: FittedBox(
                      child: SvgPicture.asset(
                        'assets/images/visa_card_icon.svg',
                      ),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const VerticalSpacer(height: 8),
                Text(
                  card.cardNumber,
                  style: TextStyle(
                    fontSize: 16.sp,
                    color: Colors.white,
                  ),
                ),
                const VerticalSpacer(height: 21),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cardholder",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const VerticalSpacer(height: 4),
                        Text(
                          card.cardHolderName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                    const HorizontalSpacer(width: 50),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Exp. Date",
                          style: TextStyle(
                            fontSize: 10.sp,
                            color: Colors.white,
                          ),
                        ),
                        const VerticalSpacer(height: 4),
                        Text(
                          card.expiryDate,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
class CVVInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText = newValue.text;
    if (newText.length > 3) {
      newText = newText.substring(0, 3);
    }
    String maskedText = "";
    for (int i = 0; i < newText.length; i++) {
      maskedText += "*"; // Replace each character with an asterisk
    }
    return TextEditingValue(
      text: maskedText,
      selection: TextSelection.collapsed(offset: maskedText.length),
    );
  }
}
