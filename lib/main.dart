import 'package:flutter/material.dart';
import 'package:personal_expense_tracker_app/Widgets/charts.dart';
import 'package:personal_expense_tracker_app/Widgets/transaction_list.dart';
import 'package:personal_expense_tracker_app/models/transaction.dart';
import 'Widgets/newtransaction.dart';




void main() {
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: 'Expense Tracker',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        accentColor: Colors.amber,
        fontFamily: 'Quicksand',

        appBarTheme: AppBarTheme(
       )
      ),
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Transaction> _userTransaction = [];

  bool _showChart = false;

  List<Transaction> get _recentTransactions {
    return _userTransaction.where((tx) {
      return tx.date.isAfter(DateTime.now().subtract(Duration(days: 7),
      ),
      );
    }).toList();
  }

  void _addNewTransaction(String txTitle, double txAmount, DateTime choosenDate) {
    final newTx = Transaction(
      title: txTitle,
      amount: txAmount,
      date: choosenDate,
      id: DateTime.now().toString(),);

    setState(() {
      _userTransaction.add(newTx);
    });
  }

  void startAddNewTransaction( BuildContext ctx) {
    showModalBottomSheet( context: ctx, builder: (_) {
      return GestureDetector (
        onTap: () {},
        child: newTransaction(_addNewTransaction),
        behavior: HitTestBehavior.opaque,
      );
    }, );
  }

  void deleteTransac(String id){
    setState((){
      _userTransaction.removeWhere((tx) {
        return tx.id == id;
      });
    });
  }

  @override
  Widget build(BuildContext context){
    final mediaQuery = MediaQuery.of(context);
    final isLandscape = MediaQuery.of(context).orientation == Orientation.landscape;
    final appBar = AppBar(
      title: Text ('Expense Tracker', style: TextStyle ( fontFamily: 'OpenSans', fontSize: 20, fontWeight: FontWeight.bold,)),

      actions: <Widget>[
        IconButton( icon: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
        )
      ],
    );
    final txListWidget =  Container(
        height: (mediaQuery.size.height - appBar.preferredSize.height)* 0.7,
        child: TransactionList(_userTransaction, deleteTransac));
    return Scaffold(
      appBar: appBar,
      body: SingleChildScrollView(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget> [
            if (isLandscape) Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Show Chart'),
                Switch(value: _showChart, onChanged: (val){
                  setState(() {
                      _showChart = val;
                  });
                },)
              ],
            ),
          if (!isLandscape) Container(
              height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top)* 0.3,
              child: Chart(_recentTransactions)),
            if (!isLandscape) txListWidget,
          if (isLandscape) _showChart
          ? Container(
           height: (mediaQuery.size.height - appBar.preferredSize.height - mediaQuery.padding.top)* 0.7,
             child: Chart(_recentTransactions))
          : txListWidget
        ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
          onPressed: () => startAddNewTransaction(context),
      ),
    );
  }
}


