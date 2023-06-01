import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'package:intl/intl.dart';
import 'screen_message_details.dart';

Future<List<dynamic>> getMessages(orderID) async {
  final allMessages = await connector.getMessage(
      orderID: BigInt.from(orderID.toInt()), address: connector.address);
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
  print(messageCount);
  return [id, sender, receiver, content, messageTime];
}

getMessageCount(orderID) async {
  final allMessages = await connector.getMessage(
      orderID: BigInt.from(orderID.toInt()), address: connector.address);
  var messages = List.from(await allMessages);
  Future.delayed(Duration(seconds: 3));
  return messages.length;
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
                            print('sender ' +
                                index.toString() +
                                ' ' +
                                sender[index].toString());
                            print('receiver ' +
                                index.toString() +
                                ' ' +
                                receiver[index].toString());
                            return InkWell(
                                onTap: () {
                                  enterMessageDetailsPage(
                                      index,
                                      context,
                                      id[index],
                                      (sender[index].toString() ==
                                              orderSender.toString())
                                          ? "Parcel Sender"
                                          : (sender[index].toString() ==
                                                  orderReceiver.toString())
                                              ? "Parcel Recipient"
                                              : "You",
                                      (receiver[index].toString() ==
                                              orderSender.toString())
                                          ? "Parcel Sender"
                                          : (receiver[index].toString() ==
                                                  orderReceiver.toString())
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
                                                  (sender[index].toString() ==
                                                          orderSender
                                                              .toString())
                                                      ? "Parcel Sender"
                                                      : (sender[index]
                                                                  .toString() ==
                                                              orderReceiver
                                                                  .toString())
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
                                                  (receiver[index].toString() ==
                                                          orderSender
                                                              .toString())
                                                      ? "Parcel Sender"
                                                      : (receiver[index]
                                                                  .toString() ==
                                                              orderReceiver
                                                                  .toString())
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
                                            Flexible(
                                                child: Container(
                                                    height: 60,
                                                    width: 340,
                                                    child: Text(
                                                      content[index]
                                                                  .toString()
                                                                  .length >
                                                              30
                                                          ? content[index]
                                                                  .toString()
                                                                  .substring(
                                                                      0, 30) +
                                                              '...'
                                                          : content[index]
                                                              .toString(),
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600),
                                                    ))),
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
