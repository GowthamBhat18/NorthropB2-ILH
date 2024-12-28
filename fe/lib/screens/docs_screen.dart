import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';

enum TransactionType { send, request }

class Transation {
  String userImage;
  String userName;
  String dateTime;
  double amount;
  TransactionType transactionType;

  Transation(
      {required this.userImage,
      required this.userName,
      required this.dateTime,
      required this.amount,
      required this.transactionType});
}

class DocsScreen extends StatelessWidget {
  DocsScreen({Key? key}) : super(key: key);

  final double padding = 20.0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
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
                ),
                Text(
                  "Documents",
                  style: TextStyle(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 24.w,
                  height: 24.h,
                  child: FittedBox(
                    child: SvgPicture.asset(
                      'assets/images/search_icon.svg',
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            ),
          ),
          const VerticalSpacer(height: 24),
          SizedBox(height: padding,),
          ElevatedButton(onPressed: (){}, child: const Text("Pick Image")),
          SizedBox(height: padding/2,),
          ElevatedButton(onPressed: (){}, child: const Text("Capture Photo")),
          SizedBox(height: padding/2,),
          ElevatedButton(onPressed: (){}, child: const Text("Pick Video")),
          SizedBox(height: padding/2,),
          ElevatedButton(onPressed: (){}, child: const Text("Capture Video")),
          SizedBox(height: padding/2,),
          ElevatedButton(onPressed: (){}, child: const Text("Pick Multiple Images")),
          SizedBox(height: padding/2,),
          const VerticalSpacer(height: 24),
        ],
      ),
    );
  }
}

