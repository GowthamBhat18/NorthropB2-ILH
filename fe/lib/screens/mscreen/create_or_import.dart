import 'package:flutter/material.dart';
import 'package:wall_et_ui/screens/mscreen/generate_mnemonic.dart';
import 'package:wall_et_ui/screens/mscreen/import_wallet.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateOrImportPage extends StatelessWidget {
  const CreateOrImportPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(children: [
        Container(
          width: 375.w,
          height: 812.h,
          color: Colors.white,
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
            // decoration: BoxDecoration(
            //     shape: BoxShape.rectangle,
            //     // color: Theme.of(context).colorScheme.primary,
            //     color: Colors.green),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header

              RichText(
                textAlign: TextAlign.center,
                text: TextSpan(
                  style: TextStyle(
                    fontSize: 24.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.w300,
                  ),
                  children: const [
                    TextSpan(
                        text: "NorthropB2",
                        style: TextStyle(fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),

              // Logo
              /* Container(
                width: double.infinity,
                alignment: Alignment.center,
                child: SizedBox(
                  width: 150,
                  height: 200,
                  child: Image.asset(
                    'assets/images/logo copy.png',
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              const SizedBox(height: 50.0), */

              // Login button
              Positioned(
                top: 686.h,
                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GenerateMnemonicPage(),
                        ),
                      );
                    },
                    child: Container(
                      height: 49.h,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Center(
                        child: Text(
                          'Create your wallet',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16.0),

              Positioned(
                top: 686.h,
                width: 375.w,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 30.w),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ImportWallet(),
                        ),
                      );
                    },
                    child: Container(
                      height: 49.h,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondary,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Center(
                        child: Text(
                          'Import from Seed',
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ]),
    );
  }
}
