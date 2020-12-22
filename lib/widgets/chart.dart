import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // For DateFormat.E()

import '../models/transaction.dart'; // For Transaction class
import './chart_bar.dart';

/// A Widget that displays chart that represent the total spending of the current week.
class Chart extends StatelessWidget {
  final List<Transaction> weeklyTransactions;

  List<Map<String, Object>> get groupedTransactionValues {
    /// Generate a List of (7 for each day of a week) Maps.
    /// Each Map Object contain the weekday(i.e. Monday) and the amount of money spent on that day.
    return List.generate(7, (index) {
      // subtract method take a Duration obj which itself takes a duration as parameter
      // In this case we take index(0->7) day(s)
      // weekDay will become today - index day(s)
      // i.e. if index == 0 -> weekday == today.
      // if index == 1 -> weekDay == yesterday and so on, go as far as a week back.
      final weekDay = DateTime.now().subtract(Duration(days: index));

      double totalSumDaily = 0;

      // Check all date/month/year to make sure it's the same day.
      // If it's the same day increament the totalSum by that day's transaction.
      for (var i = 0; i < weeklyTransactions.length; i++) {
        if (weeklyTransactions[i].date.day == weekDay.day &&
            weeklyTransactions[i].date.month == weekDay.month &&
            weeklyTransactions[i].date.year == weekDay.year) {
          totalSumDaily += weeklyTransactions[i].amount;
        }
      }
      // DateFormat.E().format() takes a DateTime obj and
      // return the written format of the week day of that day.
      return {
        'day': DateFormat.E().format(weekDay)[0],
        'amount': totalSumDaily,
      };
    });
  }

  double get totalWeekSpending {
    return groupedTransactionValues.fold(
        0.0, (sum, curr) => sum += curr['amount']);
  }

  Chart(this.weeklyTransactions);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Theme.of(context).primaryColor,
      child: Card(
        elevation: 0,
        margin: EdgeInsets.all(8),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: groupedTransactionValues
                .map((data) {
                  // Flexible widget makes each chart bar not invade others spaces
                  // when having a big title
                  return Expanded(
                    child: ChartBar(
                      label: data['day'],
                      spendingAmount: data['amount'],
                      percentageTotalSpending: (totalWeekSpending !=
                              0) // else divided by 0 -> crash
                          ? (data['amount'] as double) / totalWeekSpending
                          : 0,
                    ),
                  );
                })
                .toList()
                .reversed
                .toList(),
          ),
        ),
      ),
      elevation: 6,
    );
  }
}
