import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall_et_ui/screens/login_screen.dart';
import 'package:wall_et_ui/screens/signup_screen.dart';

import 'mscreen/login_page.dart';

class LoginSignupScreen extends StatefulWidget {
  const LoginSignupScreen({Key? key}) : super(key: key);

  @override
  State<LoginSignupScreen> createState() => _LoginSignupScreenState();
}

class _LoginSignupScreenState extends State<LoginSignupScreen> {
  bool _isLoading = false;

  void _navigateToSignup() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SignupScreen(),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  void _navigateToLogin() async {
    setState(() {
      _isLoading = true;
    });
    await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LoginPagee(),
      ),
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: 375.w,
            height: 812.h,
            color: Colors.white,
          ),
          Positioned(
            top: -120.h,
            left: -155.w,
            child: Container(
              width: 734.w,
              height: 734.h,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F4F5),
              ),
            ),
          ),
          Positioned(
            top: -137.h,
            left: -180.w,
            child: Container(
              width: 734.w,
              height: 734.h,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ),
          Positioned(
            top: 212.h,
            left: 134.w,
            child: SizedBox(
              width: 106.w,
              height: 137.h,
              child: FittedBox(
                child: Image.asset('assets/images/HLogo.png'),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Positioned(
            top: 464.h,
            width: 375.w,
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 14.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w300,
                ),
                children: const [
                  TextSpan(text: "The Best Way to"),
                  TextSpan(
                      text: ' Transfer Money ',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  TextSpan(text: "Safely"),
                ],
              ),
            ),
          ),
          Positioned(
            top: 686.h,
            width: 375.w,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: InkWell(
                onTap: _navigateToSignup,
                child: Container(
                  height: 49.h,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(10.w),
                  ),
                  child: Center(
                    child: Text(
                      'Create new account',
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 759.h,
            width: 375.w,
            child: InkWell(
              onTap: _navigateToLogin,
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
