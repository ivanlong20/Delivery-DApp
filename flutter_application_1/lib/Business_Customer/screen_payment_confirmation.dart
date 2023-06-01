import 'package:flutter/material.dart';
import 'screen_home.dart';
import 'package:intl/intl.dart';
import 'screen_connect_metamask.dart';

class PaymentConfirmationPage extends StatefulWidget {
  final String title;
  final BigInt orderID;
  final DateTime date;
  final connector;
  PaymentConfirmationPage(
      {Key? key,
      required this.title,
      required this.orderID,
      required this.date,
      required this.connector})
      : super(key: key);

  @override
  State<PaymentConfirmationPage> createState() =>
      _PaymentConfirmationPageState();
}

class _PaymentConfirmationPageState extends State<PaymentConfirmationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Padding(
            padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Order ID:',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
                Text('#' + widget.orderID.toString(),
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                Text('Time: ',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.w500)),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(widget.date),
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontSize: 24,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 10),
                (paidBy == 0)
                    ? Column(children: [
                        Text('Status: ',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                        Text('Submitted',
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 40),
                        FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: Size(350, 50)),
                            onPressed: () => {payBySender()},
                            child:
                                Text('Pay Now', style: TextStyle(fontSize: 18)))
                      ])
                    : Column(children: [
                        Text('Status:',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontWeight: FontWeight.w500)),
                        Text('Submitted\n Pending to Pay by Recipent',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Color.fromARGB(255, 0, 0, 0),
                                fontSize: 24,
                                fontWeight: FontWeight.w700)),
                        const SizedBox(height: 40),
                        FilledButton(
                            style: FilledButton.styleFrom(
                                minimumSize: Size(350, 50)),
                            onPressed: () => {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage(
                                            title: 'Ship',
                                            connector: connector)),
                                  )
                                },
                            child:
                                Text('Return', style: TextStyle(fontSize: 18)))
                      ])
              ],
            )));
  }

  payBySender() async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );

    await connector.payBySender(
        orderID: widget.orderID, deliveryFee: BigInt.from(priceSender * 1e18));

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Payment Successful')));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => HomePage(title: 'Ship', connector: connector),
        ));
  }
}

class LoadingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 0, 0),
                      strokeWidth: 4,
                    ),
                    const SizedBox(height: 50),
                    Text('Waiting for Completion',
                        style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 24,
                            fontWeight: FontWeight.w500))
                  ],
                ))));
  }
}
