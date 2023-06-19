import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';
import 'message_listview.dart';
import "../ethereum_connector.dart";


final finalBalance = connector.getBalance();
final network = connector.networkName;

TextEditingController wallet_address = TextEditingController();
TextEditingController message = TextEditingController();

int? senderRecipientIndex;

class MessagePage extends StatefulWidget {
  final String title;
  var connector, orderID, orderSender, orderReceiver;
  MessagePage(
      {Key? key,
      required this.title,
      required this.connector,
      required this.orderID,
      required this.orderSender,
      required this.orderReceiver})
      : super(key: key);
  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 240, 240, 240),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NewMessagePage(
                    title: 'New Message',
                    connector: widget.connector,
                    orderID: widget.orderID,
                    orderSender: widget.orderSender,
                    orderReceiver: widget.orderReceiver)),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text(widget.title)),
      body: MessageListView(widget.connector, widget.orderID,
          widget.orderSender, widget.orderReceiver),
    );
  }
}

class NewMessagePage extends StatefulWidget {
  final String title;
  final connector;
  var orderID, orderSender, orderReceiver;
  NewMessagePage(
      {Key? key,
      required this.title,
      required this.connector,
      required this.orderID,
      required this.orderSender,
      required this.orderReceiver})
      : super(key: key);
  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  final List<String> recipient = ['Parcel Sender', 'Parcel Receiver'];
  @override
  Widget build(BuildContext context) {
    print(widget.orderID);
    // print((senderRecipientIndex == 0)
    //     ? widget.orderSender[0].toString()
    //     : widget.orderReceiver[0].toString());
    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(title: Text(widget.title)),
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('To',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600)),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                    alignment: Alignment.topLeft,
                    child: Wrap(
                        spacing: 5,
                        children: List<Widget>.generate(2, (int index) {
                          return ChoiceChip(
                            label: Text(recipient[index]),
                            selected: senderRecipientIndex == index,
                            selectedColor: Color.fromARGB(255, 221, 221, 221),
                            onSelected: (bool selected) {
                              setState(() {
                                senderRecipientIndex = selected ? index : null;
                              });
                            },
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                          );
                        }))),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Text('Message',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w600))
                  ],
                ),
                const SizedBox(height: 20),
                TextField(
                  onChanged: (text) {
                    setState(() {
                      message.text = text;
                    });
                  },
                  maxLines: 5,
                  controller: message,
                  decoration: InputDecoration(
                      labelText: 'Enter your message',
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20))),
                ),
                const SizedBox(height: 40),
                FilledButton(
                    style: FilledButton.styleFrom(minimumSize: Size(400, 50)),
                    onPressed: () => {
                          sendMessages(
                              widget.orderID,
                              (senderRecipientIndex == 0)
                                  ? widget.orderSender.toString()
                                  : widget.orderReceiver.toString(),
                              message.text,
                              widget.orderSender,
                              widget.orderReceiver),
                        },
                    child: Text('Send', style: TextStyle(fontSize: 18)))
              ],
            ),
          ),
        ));
  }

  sendMessages(orderID, receiver, content, orderSender, orderReceiver) async {
    content = encrypter.encrypt(content, iv: iv).base64;
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    await connector.sendMessage(
        orderID: BigInt.from(orderID.toInt()),
        receiverAddress: receiver,
        content: content);
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Message Sent Successfully')));

    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MessagePage(
              title: 'Messages',
              connector: connector,
              orderID: orderID,
              orderSender: orderSender,
              orderReceiver: orderReceiver),
        ));
  }
}
