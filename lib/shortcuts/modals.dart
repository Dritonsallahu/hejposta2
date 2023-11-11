import 'package:flutter/material.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/settings/app_styles.dart';

showModalOne(context, child, height, {color}) {
  showModalBottomSheet(
      context: context,
      builder: (context){
        return Padding(
          padding: const EdgeInsets.only(bottom: 30, left: 18, right: 18),
          child: Container(
            width: getPhoneWidth(context),
            height: height,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: color ?? Colors.white),
            child: child,
          ),
        );
      },
      backgroundColor: Colors.transparent);
}

serverRespondErrorModal(context) {
  showDialog(
      context: context,
      builder: (context) {
        return Container(
          height: 200,
          child: AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
            title: Center(
                child: Text(
              "Duket sikur nje problem ka ndodhur ne server!",
              textAlign: TextAlign.center,
              style: AppStyles.getHeaderNameText(
                  color: Colors.grey[700], size: 20.0),
            )),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: getPhoneWidth(context) - 140,
                    child: Text(
                      "Kontaktoni administraten e postes per informata shtese",
                      textAlign: TextAlign.center,
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey, size: 16.0),
                    )),
              ],
            ),
            actions: [
              Center(
                child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Largo",
                      style: AppStyles.getHeaderNameText(
                          color: Colors.blueGrey, size: 15.0),
                    )),
              )
            ],
          ),
        );
      });
}
