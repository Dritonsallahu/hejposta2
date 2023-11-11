import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class Performance extends StatefulWidget {
  const Performance({Key? key}) : super(key: key);

  @override
  State<Performance> createState() => _PerformanceState();
}

class _PerformanceState extends State<Performance> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:   Scaffold(
          body: Center(
            child: SfRadialGauge(
              title: GaugeTitle(
                  text: 'Performanca jote ditore',
                  textStyle:
                  TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
              enableLoadingAnimation: true,
              animationDuration: 4500,
              axes: <RadialAxis>[
                RadialAxis(minimum: 0, maximum: 150, pointers: <GaugePointer>[
                  NeedlePointer(value: 90, enableAnimation: true)
                ], ranges: <GaugeRange>[
                  GaugeRange(startValue: 0, endValue: 50, color: Colors.grey),
                  GaugeRange(startValue: 50, endValue: 100, color: Colors.lightBlueAccent),
                  GaugeRange(startValue: 100, endValue: 150, color: Colors.green)
                ], annotations: <GaugeAnnotation>[
                  GaugeAnnotation(
                      widget: Text(
                        'Mesatarisht mire!',
                        style:
                        TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                      ),
                      positionFactor: 0.5,
                      angle: 90)
                ])
              ],
            ),
          ),
        )
         );
  }
}
