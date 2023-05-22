import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'screen_home.dart';
import 'screen_order.dart';
import 'screen_wallet.dart';
import '../etherscan_api.dart';
import 'screen_connect_metamask.dart';
import '../screen_user_selection.dart';

// final finalBalance = getBalance(getAddress());
// final network = getNetworkName(getNetwork());

TextEditingController wallet_address = TextEditingController();
TextEditingController message = TextEditingController();

class MessagePage extends StatefulWidget {
  final String title;
  var connector;
  MessagePage(
      {Key? key,
      required this.title,
      required this.connector})
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
                    connector: widget.connector)),
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(title: Text(widget.title)),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            DrawerHeader(
                child: Column(children: [
              Row(children: [
                Text(
                  'Balance',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 24),
                )
              ]),
              Row(children: [
                FutureBuilder<dynamic>(
                    // future: finalBalance,
                    builder: (BuildContext context,
                        AsyncSnapshot<dynamic> snapshot) {
                      if (snapshot.hasData) {
                        var balance = int.parse(snapshot.data) *
                            (1 / 1000000000000000000);
                        return Text(
                          balance.toStringAsFixed(5),
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      } else {
                        return Text(
                          '0',
                          style: TextStyle(
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontSize: 36,
                          ),
                        );
                      }
                    }),
                Text(' ETH',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                    ))
              ]),
              Row(
                children: [
                  // Text(network,
                  //     style: TextStyle(
                  //       color: Color.fromARGB(255, 0, 0, 0),
                  //       fontSize: 16,
                  //     ))
                ],
              )
            ])),
            ListTile(
              leading: Icon(Icons.local_shipping_rounded),
              title: Text('Send Package'),
              onTap: openHomePage,
            ),
            ListTile(
                leading: Icon(Icons.history),
                title: Text('Order Tracking & History'),
                onTap: openOrderPage),
            ListTile(
              leading: Icon(Icons.message),
              title: Text('Message'),
              onTap: openMessagePage,
            ),
            ListTile(
                leading: Icon(Icons.wallet),
                title: Text('Wallet'),
                onTap: openWalletPage),
            ListTile(
                leading: const Icon(Icons.logout),
                title: const Text('Logout'),
                onTap: logout)
          ],
        ),
      ),
      body: MessageListView(widget.connector),
    );
  }

  openWalletPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => WalletPage(
              title: 'Wallet',
              connector: widget.connector)),
    );
  }

  openHomePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
              title: 'Send Package',
              connector: widget.connector)),
    );
  }

  openOrderPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => OrderPage(
              title: 'Order Tracking & History',
              connector: widget.connector)),
    );
  }

  openMessagePage() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MessagePage(
              title: 'Message',
              connector: widget.connector)),
    );
  }

  logout() {
    // widget.connector.on(
    //     'disconnect',
    //     (payload) => setState(() {
    //           widget.session = null;
    //         }));
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => UserSelectionPage(title: 'Landing Page')),
    // );
  }
}

class NewMessagePage extends StatefulWidget {
  final String title;
  final connector;
  NewMessagePage(
      {Key? key,
      required this.title,
      required this.connector})
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
                      //           session: widget.session,
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
              title: 'Message Details',
              index: index,
              connector: connector)),
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
                      title: 'New Message',
                      connector: widget.connector)),
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
