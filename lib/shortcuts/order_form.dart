import 'package:flutter/material.dart';
import 'package:hejposta/my_code.dart';
import 'package:hejposta/settings/app_colors.dart';
import 'package:hejposta/settings/app_styles.dart';
import 'package:hejposta/views/postman/delivering_orders.dart';
import 'package:hejposta/views/postman/delivering_specific_order.dart';
import 'package:hejposta/views/postman/for_equalization.dart';
import 'package:hejposta/views/postman/waiting_orders.dart';

leftSideOrder(context,child,{double? height}) {
  return Container(
    width: getPhoneWidth(context) * 0.7 - 25,
    height: height ?? 80.0,
    decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), bottomLeft: Radius.circular(20)),
        color: Colors.white),
    child: Padding(
      padding: const EdgeInsets.all(3.0),
      child: child
    ),
  );
}

rightSideOrder(context) {
  return Stack(
    children: [
      Container(
        width: getPhoneWidth(context) * 0.3 - 25,
        height: 80,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(20),
                bottomRight: Radius.circular(20)),
            color: AppColors.bottomColorTwo),
        child: Center(
          child: Text(
            "10\nporosi",
            textAlign: TextAlign.center,
            style: AppStyles.getHeaderNameText(color: Colors.white, size: 15.0),
          ),
        ),
      ),
      Positioned(
          right: -2,
          top: 10,
          child:
          SizedBox(height: 60, child: Image.asset("assets/icons/8.png",color: Colors.white.withOpacity(0.7),))),
    ],
  );
}


rightSideDeliveringOrder(context) {
  return Text("");
}

orderGroupNumbers(context,text,{String? npritje,String? ndergese,String? perBarazim}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const WaitingOrders()));
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                "N'pritje",
                style: AppStyles.getHeaderNameText(
                    color: text == "wait" ? Colors.blueGrey[900]: Colors.white, size: 15.0),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: AppColors.onWaitingColor),
                child: Text(
                  npritje.toString(),
                  style: AppStyles.getHeaderNameText(
                      color: Colors.black, size: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const DeliveringOrders()));
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                " N'dergese",
                style: AppStyles.getHeaderNameText(
                    color: text == "delivering" ? Colors.blueGrey[900]: Colors.white, size: 15.0),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: AppColors.onDeliveringColor),
                child: Text(
                  ndergese.toString(),
                  style: AppStyles.getHeaderNameText(
                      color: Colors.white, size: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (_) => const ForEqualization()));
        },
        child: Container(
          color: Colors.transparent,
          child: Row(
            children: [
              Text(
                "Per barazim",
                style: AppStyles.getHeaderNameText(
                    color: text == "equalize" ? Colors.blueGrey[900]: Colors.white, size: 15.0),
              ),
              const SizedBox(
                width: 5,
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 4),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: AppColors.onWaitingColor),
                child: Text(
                  perBarazim.toString(),
                  style: AppStyles.getHeaderNameText(
                      color: Colors.white, size: 14.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}
