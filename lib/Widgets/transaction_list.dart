import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/transaction.dart';


class TransactionList extends StatelessWidget {
  final List<Transaction> transaction;
  final Function deleteTx;
  TransactionList(this.transaction, this.deleteTx);


  @override
  Widget build(BuildContext context) {
    return  transaction.isEmpty ?
    LayoutBuilder(builder: (ctx, constraints) {
      return  Column( children: <Widget>[
        Text('No transactions added yet!',  style: TextStyle ( fontFamily: 'Quicksand', fontSize: 18, fontWeight: FontWeight.bold,),),
        SizedBox(
          height: 20,
        ),
        Container(
            height: constraints.maxHeight * 0.6,
            child: Image.asset('assets/images/waiting.png', fit: BoxFit.cover,)),
      ],);
    },)

        : ListView.builder(
      itemBuilder: (ctx, index){
          return Card(
            elevation: 5,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
            child: ListTile(
              leading: CircleAvatar(
                radius: 20,
                child: Padding(
                  padding: EdgeInsets.all(6),
                  child: FittedBox
                    (child: Text('\$${transaction[index].amount}')),
                ),
              ),
              title: Text (
                transaction[index].title,
                  style: TextStyle ( fontFamily: 'Quicksand', fontSize: 18, fontWeight: FontWeight.bold,),
              ),
              subtitle: Text(DateFormat.yMMMd().format(transaction[index].date),
                  style: TextStyle ( fontFamily: 'Quicksand', fontSize: 16, fontWeight: FontWeight.bold,)),

              trailing: MediaQuery.of(context).size.width > 460 ? FlatButton.icon(
              icon:const Icon(Icons.delete),
              label:const Text('Delete'),
              textColor: Theme.of(context).errorColor,
              onPressed: () => deleteTx(transaction[index].id),
            ) : IconButton(icon: Icon(Icons.delete),
            color: Theme.of(context).errorColor,
              onPressed: () => deleteTx(transaction[index].id),
            ),
            ),

          );
      },
      itemCount: transaction.length,

    );

  }
}
