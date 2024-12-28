import 'dart:convert';

import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall_et_ui/screens/login_screen.dart';
import 'package:wall_et_ui/widgets/primary_button.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';
import 'package:http/http.dart' as http;

import '../base_url.dart';
import 'mscreen/login_page.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _rePasswordController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();
  bool _isLoading = false;
  int? genUserId;
  int genBalance = 2000;

  String? _validateField(String? value) {
    if (value == null || value.isEmpty) {
      return 'Enter Valid Amount.';
    }
    return null;
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
                "Failed to Create Account!",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 20.sp,
                    color: Colors.red[400]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _createUser() async {
    setState(() {
      _isLoading = true;
    });

    Map<String, dynamic> checkLogin = {
      "username": _userController.text,
      "email": _emailController.text,
      "password": _passwordController.text,
      "userType": 3,
    };
    print(checkLogin);

    try {
      final response = await http.post(
        Uri.parse(postCreateUserUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(checkLogin),
      );

      if (response.statusCode == 201) {
        await Future.delayed(Duration(seconds: 1));
        print(response.statusCode);
        print(response);
        final responseData = json.decode(response.body);
        genUserId = responseData['id'];
        _createBalance();
        _nfcDevice();
        _createBankAccount();
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => LoginPagee(),
          ),
        );
      } else {
        _showFailedDialog();
        print(response.statusCode);
        throw Exception('Failed to Create User!');
      }
    } catch (error) {
      print('Error: $error');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _createBalance() async {
    Map<String, dynamic> createBal = {
      "userId": genUserId,
      "balanceAmount": genBalance,
    };
    print(createBal);
    try {
      final response = await http.post(
        Uri.parse(postCreateBalanceUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createBal),
      );
    } catch (error) {
      print('Error: $error');
    }
    print('balance created!');
  }

  void _createBankAccount() async {
    Map<String, dynamic> createBalAcc = {
      "bankName": "ABC bank",
      "accountBigSerial": "1234567890123456",
      "accountType": "Savings",
      "ifscCode": "ABC01234567",
      "userId": genUserId,
    };
    print(createBalAcc);
    try {
      final response = await http.post(
        Uri.parse(postCreateBankAccountUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createBalAcc),
      );
    } catch (error) {
      print('Error: $error');
    }
    print('balanceAcc created!');
  }

  void _nfcDevice() async {
    Map<String, dynamic> createNfcDevice = {
      "userId": genUserId,
      "deviceInfo": "Active"
    };
    print(createNfcDevice);
    try {
      final response = await http.post(
        Uri.parse(postCreateNfcDeviceUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(createNfcDevice),
      );
    } catch (error) {
      print('Error: $error');
    }
    print('nfc created!');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Form(
            key: _formKey1,
            child: SingleChildScrollView(
              child: Container(
                width: 375.w,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/Background.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30.w,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const VerticalSpacer(height: 80),
                      Text(
                        "Signup and start transferring",
                        style: TextStyle(
                          fontSize: 32.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const VerticalSpacer(height: 62),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            width: 150.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F5),
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Center(
                              child: Text(
                                "Google",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 150.w,
                            height: 50.h,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3F4F5),
                              borderRadius: BorderRadius.circular(10.w),
                            ),
                            child: Center(
                              child: Text(
                                "Facebook",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                      const VerticalSpacer(height: 54),
                      Text(
                        "User Name",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      const VerticalSpacer(height: 8),
                      TextFormField(
                        validator: _validateField,
                        controller: _userController,
                        decoration: InputDecoration(
                          hintText: "Enter your user name",
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
                        ),
                      ),
                      const VerticalSpacer(height: 24),
                      Text(
                        "Email",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      const VerticalSpacer(height: 8),
                      TextFormField(
                        validator: _validateField,
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Enter your email",
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
                        ),
                      ),
                      const VerticalSpacer(height: 24),
                      Text(
                        "Password",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      const VerticalSpacer(height: 8),
                      TextFormField(
                        validator: _validateField,
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "Enter your password",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(
                            Icons.remove_red_eye_outlined,
                            size: 24.sp,
                            color: Colors.black.withOpacity(0.1953),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.w),
                            borderSide: BorderSide(
                              color: const Color(0xFF1A1A1A).withOpacity(0.1),
                              width: 1.sp,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpacer(height: 24),
                      Text(
                        "Renter password",
                        style: TextStyle(
                          fontSize: 14.sp,
                        ),
                      ),
                      const VerticalSpacer(height: 8),
                      TextFormField(
                        validator: _validateField,
                        controller: _rePasswordController,
                        decoration: InputDecoration(
                          hintText: "Enter your password again",
                          hintStyle: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xFF1A1A1A).withOpacity(0.2494),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          suffixIcon: Icon(
                            Icons.remove_red_eye_outlined,
                            size: 24.sp,
                            color: Colors.black.withOpacity(0.1953),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.w),
                            borderSide: BorderSide(
                              color: const Color(0xFF1A1A1A).withOpacity(0.1),
                              width: 1.sp,
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpacer(height: 54),
                      InkWell(
                        onTap: () {
                          if (_formKey1.currentState!.validate()) {
                            _createUser();
                          }
                        },
                        child: Container(
                          height: 49.h,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(10.w),
                          ),
                          child: Center(
                            child: Text(
                              'Create account',
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const VerticalSpacer(height: 24),
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => LoginPagee(),
                            ),
                          );
                        },
                        child: SizedBox(
                          width: 375.w,
                          child: Text(
                            "Already have account?",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const VerticalSpacer(height: 54),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
