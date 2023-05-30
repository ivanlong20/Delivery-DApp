import 'package:flutter/material.dart';
import 'screen_connect_metamask.dart';
import 'app_drawer.dart';

final finalBalance = connector.getBalance();
final network = connector.networkName;

TextEditingController wallet_address = TextEditingController();
TextEditingController message = TextEditingController();

getMessages(orderID) async {
  final allMessages = await connector.getMessage(
      orderID: BigInt.from(orderID), userType: "Deliverymen");
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
        DateTime.fromMillisecondsSinceEpoch(messages[i][6].toInt() * 1000));
  }
  return [id, sender, receiver, content, messageTime];
}

sendMessages(orderID, receiver, content) async {
  await connector.sendMessage(
      orderID: BigInt.from(orderID),
      receiverAddress: receiver,
      content: content);
}

class MessagePage extends StatefulWidget {
  final String title;
  var connector;
  MessagePage({Key? key, required this.title, required this.connector})
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
                    title: 'New Message', connector: widget.connector)),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text(widget.title)),
      drawer: AppDrawer(connector: widget.connector),
      body: MessageListView(widget.connector),
    );
  }
}

class NewMessagePage extends StatefulWidget {
  final String title;
  final connector;
  NewMessagePage({Key? key, required this.title, required this.connector})
      : super(key: key);
  @override
  State<NewMessagePage> createState() => _NewMessagePageState();
}

class _NewMessagePageState extends State<NewMessagePage> {
  @override
  Widget build(BuildContext context) {
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
            TextField(
              onChanged: (text) {
                setState(() {
                  wallet_address.text = text;
                });
              },
              maxLines: 1,
              controller: wallet_address,
              decoration: InputDecoration(
                  labelText: '  Enter Receiver\'s address',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20))),
            ),
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
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ItemInfoPage(
                      //           title: 'Item Details',
                      //           connector: widget.connector)),
                      // )
                    },
                child: Text('Send', style: TextStyle(fontSize: 18)))
          ],
        ),
      ),
    );
  }
}

class MessageListView extends StatelessWidget {
  var connector;
  MessageListView(this.connector);
  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      itemCount: 10,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
            onTap: () {
              enterMessageDetailsPage(index, context);
            },
            child: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 255, 255, 255),
                    border: Border.all(
                        color: const Color.fromARGB(255, 255, 255, 255)),
                    borderRadius: BorderRadius.circular(20)),
                height: 150,
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 10, 5, 5),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text(
                              'From: ',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            Text(
                              'adfasfsdf',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Flexible(
                                child: Text('Message:',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700)))
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Row(
                          children: [
                            Text(
                              'abcdefg',
                              style: TextStyle(fontWeight: FontWeight.w600),
                            )
                          ],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              '13/4/2023 12:00',
                              style: TextStyle(fontWeight: FontWeight.w100),
                            )
                          ],
                        )
                      ],
                    ))));
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 20),
    );
  }

  enterMessageDetailsPage(index, context) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessageDetailsPage(
              title: 'Message Details', index: index, connector: connector)),
    );
  }
}

class MessageDetailsPage extends StatefulWidget {
  final String title;
  final connector;
  final index;
  MessageDetailsPage(
      {Key? key,
      required this.title,
      required this.index,
      required this.connector})
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
                      title: 'New Message', connector: widget.connector)),
            );
          },
          label: const Text('Reply'),
          icon: const Icon(Icons.reply),
        ),
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Color.fromARGB(255, 255, 255, 255),
        ),
        body: Padding(
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
                  Text('Deliverymen Name',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
                ]),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Text('Wallet Address',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.w700)),
                  ],
                ),
                SizedBox(
                  height: 5,
                ),
                Row(children: [
                  Text('asdasdasdasdas',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w600))
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
                        child: Text('adaasddasdas',
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
                        child: Text('16/4/2023 12:00',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w400)))
                  ],
                ),
                Text(index.toString()),
              ],
            )));
  }
}
