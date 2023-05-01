import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:url_launcher/url_launcher_string.dart';

class ConnectMetamaskPage extends StatefulWidget {
  const ConnectMetamaskPage({super.key, required this.title});
  final String title;
  @override
  State<ConnectMetamaskPage> createState() => _ConnectMetamaskState();
}

class _ConnectMetamaskState extends State<ConnectMetamaskPage> {
  var _session, _uri;
  var connector = WalletConnect(
      bridge: 'https://bridge.walletconnect.org',
      clientMeta: const PeerMeta(
          name: 'Delivery DApp',
          description: 'A Dapp for Delivery',
          url: 'https://walletconnect.org',
          icons: [
            'https://files.gitbook.com/v0/b/gitbook-legacy-files/o/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ]));

  loginUsingMetamask(BuildContext context) async {
    if (!connector.connected) {
      try {
        var session = await connector.createSession(onDisplayUri: (uri) async {
          _uri = uri;
          await launchUrlString(uri, mode: LaunchMode.externalApplication);
        });
        print(session.accounts[0]);
        print(session.chainId);
        setState(() {
          _session = session;
        });
      } catch (exp) {
        print(exp);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final String assetName = 'assets/icon/metamask-fox.svg';
    final Widget svg = SvgPicture.asset(assetName);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
          child: FilledButton(
        style: FilledButton.styleFrom(
            minimumSize: Size(100, 75),
            maximumSize: Size(350, 75),
            backgroundColor: Color.fromARGB(255, 0, 0, 0)),
        onPressed: () {},
        child: FloatingActionButton.extended(
          label: Text(
              style: TextStyle(
                  color: Color.fromRGBO(255, 255, 255, 1),
                  fontSize: 22,
                  fontWeight: FontWeight.w600),
              'Login with Metamask'), // <-- Text
          backgroundColor: Colors.black,
          icon: Container(child: svg, width: 50, height: 50),
          onPressed: () => loginUsingMetamask(context),
        ),
      )),
    );
  }
}
