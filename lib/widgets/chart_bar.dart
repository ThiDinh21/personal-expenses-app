import 'package:flutter/material.dart';

import '../models/constants.dart' as constants;

class ChartBar extends StatelessWidget {
  final String label;
  final double spendingAmount;
  final double percentageTotalSpending;

  ChartBar({
    @required this.label,
    @required this.spendingAmount,
    @required this.percentageTotalSpending,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrain) {
      final maxHeight = constrain.maxHeight;
      return Column(
        children: <Widget>[
          Container(
            height: maxHeight * 0.15,
            child: FittedBox(
              child: Text(
                '€${spendingAmount.toStringAsFixed(0)}',
                style: Theme.of(context).textTheme.headline5,
              ),
            ),
          ),
          SizedBox(height: maxHeight * 0.05),
          Container(
            height: maxHeight * 0.6,
            width: 10,
            child: Stack(
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    color: constants.barChartBgColor,
                    border: Border.all(
                      color: Colors.black,
                      width: 0.5,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  child: FractionallySizedBox(
                    heightFactor: percentageTotalSpending,
                    child: Container(
                        decoration: BoxDecoration(
                      color: constants.barChartColor,
                      borderRadius: BorderRadius.circular(20),
                    )),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: maxHeight * 0.05),
          Container(
            height: maxHeight * 0.15,
            child: Text(label),
          ),
        ],
      );
    });
  }
}
