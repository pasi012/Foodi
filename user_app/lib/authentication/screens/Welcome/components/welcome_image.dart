import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../constants.dart';

class WelcomeImage extends StatelessWidget {
  const WelcomeImage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "WELCOME TO Foodi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.sp),
        ),
        const SizedBox(height: defaultPadding * 2),
        Image.asset("assets/images/welcome.png", width: defaultPadding * 15.w, height: defaultPadding * 15.h,),
        const SizedBox(height: defaultPadding * 2),
      ],
    );
  }
}
