import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:wall_et_ui/screens/docs_screen.dart';
import 'package:wall_et_ui/widgets/horizontal_spacer.dart';
import 'package:wall_et_ui/widgets/primary_button.dart';
import 'package:wall_et_ui/widgets/vertical_spacer.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({Key? key}) : super(key: key);

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            children: const [
              ManageAccountsPage(),
            ],
          ),
        ),
      ),
    );
  }
}

class OnBoardingHeader extends StatelessWidget {
  const OnBoardingHeader({Key? key, required this.index}) : super(key: key);

  final int index;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 375.w,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
          ],
        ),
      ),
    );
  }
}

class ManageAccountsPage extends StatelessWidget {
  const ManageAccountsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 32.h,
          child: const OnBoardingHeader(index: 1),
        ),
        const OnBoardingTemplate(
          title: "Add all documents and manage",
          description:
              "You can add, view also manage all documents in one place at your ease. ",
          image: "illustration-1",
          index: 1,
        ),
        Positioned(
          bottom: 32.h,
          width: 375.w,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 30.w),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => DocsScreen(),
                ));
              },
              child: Container(
                height: 49.h,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.w),
                ),
                child: Center(
                  child: Text(
                    "Continue!",
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
      ],
    );
  }
}

class OnBoardingTemplate extends StatelessWidget {
  const OnBoardingTemplate(
      {Key? key,
      required this.title,
      required this.description,
      required this.image,
      required this.index})
      : super(key: key);

  final String title;
  final String description;
  final String image;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: 375.w,
          height: 279.42.h,
          child: FittedBox(
            child: Image.asset('assets/images/$image.png'),
            fit: BoxFit.fill,
          ),
        ),
        const VerticalSpacer(height: 65),
        Text(
          title,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const VerticalSpacer(height: 8),
        SizedBox(
          width: 240.w,
          child: Text(
            description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF1A1A1A).withOpacity(0.6),
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const VerticalSpacer(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            PageViewButton(
              isActive: index == 1,
            ),
            const HorizontalSpacer(width: 8),
            PageViewButton(
              isActive: index == 2,
            ),
            const HorizontalSpacer(width: 8),
            PageViewButton(
              isActive: index == 3,
            ),
          ],
        )
      ],
    );
  }
}

class PageViewButton extends StatelessWidget {
  const PageViewButton({Key? key, this.isActive = false}) : super(key: key);

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 5.h,
      width: 15.w,
      decoration: BoxDecoration(
        color: isActive
            ? Theme.of(context).colorScheme.primary
            : Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(35.w),
      ),
    );
  }
}
