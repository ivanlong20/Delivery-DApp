import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

TextEditingController wallet_address = TextEditingController();
TextEditingController message = TextEditingController();

int? senderRecipientIndex;

Future<List<dynamic>> getMessages(orderID) async {
  final allMessages = await connector.getMessage(
      orderID: BigInt.from(orderID.toInt()), userType: "Deliverymen");
  var messages = List.from(await allMessages);
  var messageCount = messages.length;
  var id = [];
  var sender = [];
  var receiver = [];
  var content = [];
  var messageTime = [];

  for (int i = 0; i < messageCount; i++) {
    id.add(messages[i][0]);
    sender.add(messages[i][1]);
    receiver.add(messages[i][2]);
    content.add(messages[i][3]);
    messageTime.add(
        DateTime.fromMillisecondsSinceEpoch(messages[i][4].toInt() * 1000));
  }
  return [id, sender, receiver, content, messageTime];
}

getMessageCount(orderID) async {
  final allMessages = await connector.getMessage(
      orderID: BigInt.from(orderID.toInt()), userType: "Deliverymen");
  var messages = List.from(await allMessages);
  Future.delayed(Duration(seconds: 3));
  return messages.length;
}

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
    print((senderRecipientIndex == 0)
        ? widget.orderSender[0].toString()
        : widget.orderReceiver[0].toString());
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('To',
                    style:
                        TextStyle(fontSize: 24, fontWeight: FontWeight.w600)),
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
            // TextField(
            //   onChanged: (text) {
            //     setState(() {
            //       wallet_address.text = text;
            //     });
            //   },
            //   maxLines: 1,
            //   controller: wallet_address,
            //   decoration: InputDecoration(
            //       labelText: '  Enter Receiver\'s address',
            //       border: OutlineInputBorder(
            //           borderRadius: BorderRadius.circular(20))),
            // ),
            const SizedBox(height: 20),
            Row(
              children: [
                Text('Message',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600))
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
                              ? widget.orderSender[0].toString()
                              : widget.orderReceiver[0].toString(),
                          message.text,
                          widget.orderSender,
                          widget.orderReceiver),
                      print('send')
                    },
                child: Text('Send', style: TextStyle(fontSize: 18)))
          ],
        ),
      ),
    );
  }

  sendMessages(orderID, receiver, content, orderSender, orderReceiver) async {
    Future.delayed(Duration.zero, () => connector.openWalletApp());

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoadingPage()),
    );

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

class MessageListView extends StatelessWidget {
  var connector, orderID, orderSender, orderReceiver;
  MessageListView(
      this.connector, this.orderID, this.orderSender, this.orderReceiver);
  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<dynamic>(
            future: getMessageCount(orderID),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final messageCount = snapshot.data;
                return FutureBuilder(
                    future: getMessages(orderID),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        var id = snapshot.data?[0];
                        var sender = snapshot.data?[1];
                        var receiver = snapshot.data?[2];
                        var content = snapshot.data?[3];
                        var messageTime = snapshot.data?[4];
                        return ListView.separated(
                          padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                          itemCount: messageCount,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                                onTap: () {
                                  enterMessageDetailsPage(
                                      index,
                                      context,
                                      id[index],
                                      (sender[index] == orderSender)
                                          ? "Parcel Sender"
                                          : (sender[index] == orderReceiver)
                                              ? "Parcel Recipient"
                                              : "You",
                                      (receiver[index] == orderSender)
                                          ? "Parcel Sender"
                                          : (sender[index] == orderReceiver)
                                              ? "Parcel Recipient"
                                              : "You",
                                      content[index],
                                      messageTime[index],
                                      sender[index],
                                      orderSender,
                                      orderReceiver,
                                      orderID);
                                },
                                child: Container(
                                    decoration: BoxDecoration(
                                        color: const Color.fromARGB(
                                            255, 255, 255, 255),
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 255, 255, 255)),
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                    height: 150,
                                    child: Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            10, 10, 5, 5),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  'From: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  (sender[index] == orderSender)
                                                      ? "Parcel Sender"
                                                      : (sender[index] ==
                                                              orderReceiver)
                                                          ? "Parcel Recipient"
                                                          : "You",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  'To: ',
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w700),
                                                ),
                                                Text(
                                                  (receiver[index] ==
                                                          orderSender)
                                                      ? "Parcel Sender"
                                                      : (sender[index] ==
                                                              orderReceiver)
                                                          ? "Parcel Recipient"
                                                          : "You",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Flexible(
                                                    child: Text('Message:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .w700)))
                                              ],
                                            ),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Row(
                                              children: [
                                                Text(
                                                  content[index].toString(),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Text(
                                                  DateFormat('dd/MM/yyyy HH:mm')
                                                      .format(
                                                          messageTime[index]),
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.w100),
                                                )
                                              ],
                                            )
                                          ],
                                        ))));
                          },
                          separatorBuilder: (BuildContext context, int index) =>
                              const SizedBox(height: 20),
                        );
                      } else if (snapshot.hasError) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "No Message Available",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(
                                "Please check again later",
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 20),
                              ),
                            ]);
                      } else {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(
                              color: Color.fromARGB(255, 0, 0, 0),
                              strokeWidth: 4,
                            ),
                          ],
                        );
                      }
                    });
              } else if (snapshot.hasError) {
                return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "No Message Available",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Please check again later",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 20),
                      ),
                    ]);
              } else {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(
                      color: Color.fromARGB(255, 0, 0, 0),
                      strokeWidth: 4,
                    ),
                  ],
                );
              }
            }));
  }

  enterMessageDetailsPage(index, context, id, sender, receiver, content,
      messageTime, senderAddress, orderSender, orderReceiver, orderID) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageDetailsPage(
              title: 'Message Details',
              index: index,
              connector: connector,
              id: id,
              sender: sender,
              receiver: receiver,
              content: content,
              messageTime: messageTime,
              senderAddress: senderAddress,
              orderSender: orderSender,
              orderReceiver: orderReceiver,
              orderID: orderID)),
    );
  }
}

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
