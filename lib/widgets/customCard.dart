import 'package:flutter/material.dart';

import '../utils/constants.dart';
class CustomCard extends StatelessWidget {
  Widget? title;
  Widget? subTitle;
  double? size;
  Widget? leading;
  ShapeBorder? shape;
  Function()? onTap;
   CustomCard({
     this.title,
     this.size = 150,
     this.leading,
     this.subTitle,
     this.shape,
     this.onTap,
     super.key,
   });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: size!+40,
        width: size,
        child:Column(
          children: [
            Card(
              shape:shape,
              clipBehavior: Clip.antiAlias,
              child: leading?? Image(image: NetworkImage(appImage)),
            ),
            title??Container(),
            subTitle??Container()
          ],
        )
      ),
    );
  }
}
