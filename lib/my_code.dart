// ignore: file_names
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:random_string/random_string.dart';

// import 'Views/Login/auth_screen.dart';

Size getPhoneSize(BuildContext context) {
  return MediaQuery.of(context).size;
}

double getPhoneWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

double getPhoneHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double getSafeAreaFullHeight(BuildContext context) {
  var availableHeight = MediaQuery.of(context).size.height -
      MediaQuery.of(context).padding.top -
      MediaQuery.of(context).padding.bottom;
  return availableHeight;
}

bool checkIsAndroid(BuildContext context) {
  return Platform.isAndroid;
}

bool checkIsIOS(BuildContext context) {
  return Platform.isIOS;
}

Widget getSvgPicture({String? imageURL, double? height, Color? color}) {
  return SvgPicture.asset(
    '$imageURL',
    height: height,
  );
}

Widget getSvgPictureW(String imageURL, double height, double width) {
  return SvgPicture.asset(
    imageURL,
    height: height,
    width: width,
  );
}

Future<File?> convertWidgetToImage(globalKey) async {
  RenderRepaintBoundary? boundary =
      globalKey.currentContext!.findRenderObject() as RenderRepaintBoundary?;
  ui.Image? boxImage = await boundary!.toImage(pixelRatio: 4);
  ByteData? byteData =
      await boxImage.toByteData(format: ui.ImageByteFormat.png);
  Uint8List uint8list = byteData!.buffer.asUint8List();
  final tempDir = await getTemporaryDirectory();
  final file =
      await File('${tempDir.path}/${DateTime.now().hashCode}.jpg').create();
  file.writeAsBytesSync(uint8list);
  return file;
}

Widget getImageAsset(String image, double scale) {
  return Image.asset(image, scale: scale);
}

Widget getCircularProgressIndicator({Color? color}) {
  return CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(color!),
  );
}

Widget getNotiticationCard(String mesazhi, BuildContext context) {
  return Card(
      child: SizedBox(
    width: getPhoneWidth(context) - 50,
    child: Column(
      children: [
        Text(mesazhi),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(onPressed: () {}, child: const Text("Po")),
            TextButton(onPressed: () {}, child: const Text("Jo")),
          ],
        )
      ],
    ),
  ));
}

double getAppBarHeight() {
  return AppBar().preferredSize.height;
}

double getTopHeight(BuildContext context) {
  return MediaQuery.of(context).padding.top;
}

Widget getAppBarIcon({String? notification, Function? function}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      GestureDetector(
        onTap: () {
          function!();
        },
        child:
            getSvgPicture(imageURL: 'Assets/Icons/alertIcon.svg', height: 24),
      ),
      Positioned(
        top: -8,
        right: -8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 13,
          decoration: BoxDecoration(
              color: notification == '0' ? Colors.white : Colors.green,
              borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              '$notification',
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 8),
            ),
          ),
        ),
      )
    ],
  );
}

Widget getIphoneAppBarIcon({String? notification, Function? function}) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      GestureDetector(
        onTap: () {
          function!();
        },
        child:
            getSvgPicture(imageURL: 'Assets/Icons/alertIcon.svg', height: 24),
      ),
      Positioned(
        top: -8,
        right: -8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 13,
          decoration: BoxDecoration(
              color: notification == '0' ? Colors.white : Colors.green,
              borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              '$notification',
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 8),
            ),
          ),
        ),
      )
    ],
  );
}

Widget getMesazhiIcon(String number) {
  return Stack(
    clipBehavior: Clip.none,
    children: [
      Padding(
        padding: const EdgeInsets.only(right: 5),
        child:
            getSvgPicture(imageURL: 'Assets/Icons/mesazhiLogo.svg', height: 14),
      ),
      Positioned(
        top: -11,
        right: -8,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          height: 13,
          decoration: BoxDecoration(
              color: Colors.green, borderRadius: BorderRadius.circular(100)),
          child: Center(
            child: Text(
              number,
              style: GoogleFonts.nunito(color: Colors.white, fontSize: 8),
            ),
          ),
        ),
      )
    ],
  );
}

// ignore: non_constant_identifier_names
Widget get_date_for_iphone() {
  return CupertinoTheme(
    data: const CupertinoThemeData(
        textTheme: CupertinoTextThemeData(
            dateTimePickerTextStyle: TextStyle(
      color: Colors.white,
    ))),
    child: CupertinoDatePicker(
      backgroundColor: Colors.black,
      onDateTimeChanged: (time) {},
      mode: CupertinoDatePickerMode.dateAndTime,
      initialDateTime: DateTime.now(),
      use24hFormat: true,
    ),
  );
}

String getConfirmationCode() {
  var rng = Random();

  var wallID = rng.nextInt(999999);
  while (wallID.toString().length != 6) {
    var rng = Random();

    wallID = rng.nextInt(999999);
  }
  return wallID.toString();
}

String gjeneroShiferRandom(int pjesaPare, int pjesaDyte) {
  var a = randomAlphaNumeric(pjesaPare);
  var b = randomAlphaNumeric(pjesaDyte);
  return (a + b);
}

String gjeneroNumerRandom(int pjesaPare, int pjesaDyte) {
  var a = randomNumeric(pjesaPare);
  var b = randomNumeric(pjesaDyte);
  return (a + b);
}

void shfaqDialogun(
    {String? mesazhi,
    Color? color,
    double? width,
    double? height,
    BuildContext? context,
    String? titulli}) {
  showDialog(
      context: context!,
      builder: (context) {
        return Platform.isAndroid
            ? AlertDialog(
                title: Text(mesazhi!),
                content: SizedBox(
                  width: width,
                  height: 20,
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Largo'),
                  )
                ],
              )
            : CupertinoAlertDialog(
                title: Text(mesazhi!),
                content: SizedBox(
                  width: getPhoneWidth(context) - 80,
                  height: 20,
                ),
                insetAnimationCurve: Curves.bounceInOut,
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Largo'),
                  )
                ],
              );
      });
}

getDayText(String name, context) {
  if (name == "Mon") {
    return "Hene";
  } else if (name == "Tue") {
    return "Marte";
  } else if (name == "Wed") {
    return "Merkure";
  } else if (name == "Thu") {
    return "Enjte";
  } else if (name == "Fri") {
    return "Premte";
  } else if (name == "Sat") {
    return "Shtune";
  } else if (name == "Sun") {
    return "Diele";
  }
}

getDayName(DateTime date, context) {
  if (DateFormat("EEE").format(date) == "Mon") {
    return "Hene";
  } else if (DateFormat("EEE").format(date) == "Tue") {
    return "Marte";
  } else if (DateFormat("EEE").format(date) == "Wed") {
    return "Merkure";
  } else if (DateFormat("EEE").format(date) == "Thu") {
    return "Enjte";
  } else if (DateFormat("EEE").format(date) == "Fri") {
    return "Premte";
  } else if (DateFormat("EEE").format(date) == "Sat") {
    return "Shtune";
  } else if (DateFormat("EEE").format(date) == "Sun") {
    return "Diele";
  }
}

String? getMonthName(DateTime i, context) {
  if (i.month == 1) {
    return "Janar";
  } else if (i.month == 2) {
    return "Shkurt";
  } else if (i.month == 3) {
    return "Mars";
  } else if (i.month == 4) {
    return "Prill";
  } else if (i.month == 5) {
    return "Maj";
  } else if (i.month == 6) {
    return "Qershor";
  } else if (i.month == 7) {
    return "Korrik";
  } else if (i.month == 8) {
    return "Gusht";
  } else if (i.month == 9) {
    return "Shtator";
  } else if (i.month == 10) {
    return "Tetor";
  } else if (i.month == 11) {
    return "Nentor";
  } else if (i.month == 12) {
    return "Dhjetor";
  } else {
    return "Wrong";
  }
}

String? getMonthNameSQ(int i) {
  if (i == 1) {
    return "Janar";
  } else if (i == 2) {
    return "Shkurt";
  } else if (i == 3) {
    return "Mars";
  } else if (i == 4) {
    return "Prill";
  } else if (i == 5) {
    return "Maj";
  } else if (i == 6) {
    return "Qershor";
  } else if (i == 7) {
    return "Korrik";
  } else if (i == 8) {
    return "Gusht";
  } else if (i == 9) {
    return "Shtator";
  } else if (i == 10) {
    return "Tetor";
  } else if (i == 11) {
    return "Nentor";
  } else if (i == 12) {
    return "Dhjetor";
  } else {
    return "Wrong";
  }
}

checkUserStatus(response, context) {
  if (response == "unactive_token") {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Sesioni i qasjes ka mbaruar"),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (_) => AuthScreen()));
                  },
                  child: const Text("Largo"))
            ],
          );
        });
    return [];
  } else if (response == "blocked_used") {
    showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            title: const Text("Kjo llogari u bllokua"),
            content: const Text(
              "Kontaktoni qendren e spitalit per me teper informacione",
              textAlign: TextAlign.center,
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(builder: (_) => AuthScreen()));
                  },
                  child: const Text("Largo"))
            ],
          );
        });
  }


}
