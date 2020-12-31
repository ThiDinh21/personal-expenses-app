import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';

import './widgets/new_transaction_input.dart';
import './widgets/transaction_list.dart';
import './widgets/chart.dart';

import './models/constants.dart' as constants;
import './models/transaction.dart';

void main() {
  // WidgetsFlutterBinding.ensureInitialized();
  // SystemChrome.setPreferredOrientations([
  //   DeviceOrientation.portraitUp,
  //   DeviceOrientation.portraitDown,
  // ]);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Personal Expenses',
      theme: ThemeData(
        primarySwatch: constants.primaryThemeColor,
        accentColor: constants.secondaryThemeColor,
        errorColor: constants.errorThemeColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        fontFamily: 'Quicksand',
        textTheme: ThemeData.light().textTheme.copyWith(
            headline6: TextStyle(
              fontFamily: 'Quicksand',
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
            headline5: TextStyle(
              fontFamily: 'Quicksand',
              fontStyle: FontStyle.italic,
              fontSize: 12,
            )),
        appBarTheme: AppBarTheme(
          textTheme: ThemeData.light().textTheme.copyWith(
                  headline6: TextStyle(
                fontFamily: 'OpenSans',
                fontSize: 19,
                fontWeight: FontWeight.bold,
              )),
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          foregroundColor: Colors.white,
          backgroundColor: Theme.of(context).appBarTheme.color,
        ),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with WidgetsBindingObserver {
  final List<Transaction> _transactions = [];

  List<Transaction> get _getRecentTransactions {
    return _transactions.where((tx) {
      // Return list of all transactions happened in the span of this week
      // hence the .now() subtracts 7 days.
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7)));
    }).toList();
  }

  bool _showChart = false;

	@override
  void initState() {
    super.initState();
		WidgetsBinding.instance.addObserver(this);
  }

	@override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print(state);
  }

	@override
	dispose() {
		WidgetsBinding.instance.removeObserver(this);
		super.dispose();
	}

  void _startAddingNewTransaction(ctx) {
    showModalBottomSheet(
      context: ctx,
      builder: (_) {
        return GestureDetector(
          onTap: () {},
          child: NewTransactionInput(_addNewTransaction),
          // behavior: HitTestBehavior.opaque,
        );
      },
    );
  }

  void _addNewTransaction(String newTitle, double newAmount, DateTime newDate) {
    final newTx = Transaction(
      title: newTitle,
      amount: newAmount,
      id: DateTime.now().toString(),
      date: newDate,
    );

    setState(() {
      _transactions.add(newTx);
    });
  }

  void _deleteTransaction(String transactionID) {
    setState(() {
      _transactions.removeWhere((element) => element.id == transactionID);
    });
  }

  List<Widget> _buildLandscapeContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget transactionListWidget) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            'Show chart',
            style: Theme.of(context).textTheme.headline5,
          ),
          Switch.adaptive(
              activeColor: Theme.of(context).accentColor,
              value: _showChart,
              onChanged: (val) {
                setState(() {
                  _showChart = val;
                });
              }),
        ],
      ),
      _showChart
          ? Container(
              height: (mediaQuery.size.height -
                      mediaQuery.padding.top -
                      appBar.preferredSize.height) *
                  0.7,
              child: Chart(_getRecentTransactions),
            )
          : transactionListWidget
    ];
  }

  List<Widget> _buildPortraitContent(
      MediaQueryData mediaQuery, AppBar appBar, Widget transactionListWidget) {
    return [
      Container(
        height: (mediaQuery.size.height -
                mediaQuery.padding.top -
                appBar.preferredSize.height) *
            0.3,
        child: Chart(_getRecentTransactions),
      ),
      transactionListWidget
    ];
  }

  Widget _buildAppbar() {
    return Platform.isIOS
        ? CupertinoNavigationBar(
            middle: Text('Personal expenses'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: Icon(CupertinoIcons.add),
                  onTap: () => _startAddingNewTransaction(context),
                )
              ],
            ),
          )
        : AppBar(
            title: Text('Personal expenses'),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.add),
                onPressed: () => _startAddingNewTransaction(context),
              )
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bool isLandscape = (mediaQuery.orientation == Orientation.landscape);

    final PreferredSizeWidget appBar = _buildAppbar();

    final transactionListWidget = Container(
      height: (MediaQuery.of(context).size.height -
              MediaQuery.of(context).padding.top -
              appBar.preferredSize.height) *
          0.7,
      child: TransactionList(_transactions, _deleteTransaction),
    );

    final pageContent = SafeArea(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (isLandscape)
              ..._buildLandscapeContent(
                  mediaQuery, appBar, transactionListWidget),
            if (!isLandscape)
              ..._buildPortraitContent(
                  mediaQuery, appBar, transactionListWidget),
          ],
        ),
      ),
    );

    return Platform.isIOS
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(),
            child: null,
          )
        : Scaffold(
            appBar: appBar,
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Platform.isIOS
                ? Container()
                : FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => _startAddingNewTransaction(context),
                  ),
            body: pageContent,
          );
  }
}
