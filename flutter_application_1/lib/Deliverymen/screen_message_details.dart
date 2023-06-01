import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'screen_message.dart';

class MessageDetailsPage extends StatefulWidget {
  final String title;
  final connector;
  final index;
  var id,
      sender,
      receiver,
      content,
      messageTime,
      senderAddress,
      orderSender,
      orderReceiver,
      orderID;
  MessageDetailsPage(
      {Key? key,
      required this.title,
      required this.index,
      required this.connector,
      required this.id,
      required this.sender,
      required this.receiver,
      required this.content,
      required this.messageTime,
      required this.senderAddress,
      required this.orderSender,
      required this.orderReceiver,
      required this.orderID})
      : super(key: key);
  @override
  State<MessageDetailsPage> createState() => _MessageDetailsPageState();
}

class _MessageDetailsPageState extends State<MessageDetailsPage> {
  @override
  Widget build(BuildContext context) {
    var index = widget.index;
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
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
          label: const Text('Reply'),
          icon: const Icon(Icons.reply),
        ),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('From',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(widget.sender.toString(),
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('To',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(children: [
                      Text(widget.receiver,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600))
                    ]),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Text('Message',
                            style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Row(
                      children: [
                        Flexible(
                            child: Text(widget.content.toString(),
                                style: TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.w600)))
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Flexible(
                            child: Text(
                                DateFormat('dd/MM/yyyy HH:mm')
                                    .format(widget.messageTime),
                                style: TextStyle(
                                    fontSize: 14, fontWeight: FontWeight.w400)))
                      ],
                    ),
                  ],
                ))));
  }
}
