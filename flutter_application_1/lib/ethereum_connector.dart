//Reference: https://github.com/Anonymousgaurav/flutter_blockchain_payment

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'wallet_connector.dart';
import 'package:http/http.dart';
import 'package:walletconnect_dart/walletconnect_dart.dart';
import 'package:walletconnect_qrcode_modal_dart/walletconnect_qrcode_modal_dart.dart';
import 'package:web3dart/crypto.dart';
import 'package:web3dart/web3dart.dart';
import 'package:web_socket_channel/io.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'delivery.g.dart';
import 'package:encrypt/encrypt.dart' as encrypt;

final key = encrypt.Key.fromUtf8("FMCg2YYKfqT6USvl618/9d36YNBKNyVZ");
final iv = encrypt.IV.fromLength(16);
final encrypter = encrypt.Encrypter(encrypt.AES(key));

class WalletConnectEthereumCredentials extends CustomTransactionSender {
  WalletConnectEthereumCredentials({required this.provider});

  final EthereumWalletConnectProvider provider;

  @override
  Future<EthereumAddress> extractAddress() {
    throw UnimplementedError();
  }

  @override
  MsgSignature signToEcSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    // TODO: implement signToEcSignature
    throw UnimplementedError();
  }

  @override // TODO: implement address
  EthereumAddress get address => throw UnimplementedError();

  @override
  Future<String> sendTransaction(Transaction transaction) async {
    final hash = await provider.sendTransaction(
      from: transaction.from!.hex,
      to: transaction.to?.hex,
      data: transaction.data,
      gas: transaction.maxGas,
      gasPrice: transaction.gasPrice?.getInWei,
      value: transaction.value?.getInWei,
      nonce: transaction.nonce,
    );

    return hash;
  }

  @override
  Future<MsgSignature> signToSignature(Uint8List payload,
      {int? chainId, bool isEIP1559 = false}) {
    throw UnimplementedError();
  }
}

class EthereumConnector implements WalletConnector {
  late final WalletConnectQrCodeModal _connector;
  late final EthereumWalletConnectProvider _provider;
  final client = Web3Client('https://rpc.sepolia.org', Client());
  final EthereumAddress contractAddress =
      EthereumAddress.fromHex('0x1e006C774dc1DA14c4da21F41B5ddd99aD4bFBa4');

  EthereumConnector() {
    _connector = WalletConnectQrCodeModal(
      connector: WalletConnect(
        bridge: 'https://bridge.walletconnect.org',
        clientMeta: const PeerMeta(
          name: 'Delivery Dapp',
          description: 'Delivery Dapp',
          url: 'https://walletconnect.org',
          icons: [
            'https://gblobscdn.gitbook.com/spaces%2F-LJJeCjcLrr53DcT1Ml7%2Favatar.png?alt=media'
          ],
        ),
      ),
      // modalBuilder: (context, uri, callback, defaultModalWidget) {
      //   return defaultModalWidget.copyWith(
      //     cardColor: const Color.fromARGB(255, 236, 236, 236),
      //     platformOverrides: const ModalWalletPlatformOverrides(
      //       android: ModalWalletType.listMobile,
      //     ),
      //   );
      // }
    );

    _provider = EthereumWalletConnectProvider(_connector.connector);
  }

  void killSession() {
    _connector.connector.killSession();
  }

  @override
  Future<SessionStatus?> connect(BuildContext context) async {
    return await _connector.connect(context, chainId: 11155111);
  }

  @override
  void registerListeners(
    OnConnectRequest? onConnect,
    OnSessionUpdate? onSessionUpdate,
    OnDisconnect? onDisconnect,
  ) =>
      _connector.registerListeners(
        onConnect: onConnect,
        onSessionUpdate: onSessionUpdate,
        onDisconnect: onDisconnect,
      );

  //1. Create Order and Receive Payment
  @override
  Future<dynamic> callCreateDeliveryOrder(
      {required String receiverWalletAddress,
      required String senderAddress,
      required String senderDistrict,
      required String receiverAddress,
      required String receiverDistrict,
      required String packageDiscription,
      required BigInt packageHeight,
      required BigInt packageWidth,
      required BigInt packageDepth,
      required BigInt packageWeight,
      required bool payBySender,
      required BigInt deliveryFee,
      required BigInt productAmount}) async {
    final recipientrWalletAddress =
        EthereumAddress.fromHex(receiverWalletAddress);

    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var orderID, date;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription = delivery.orderCreatedEvents().take(1).listen((event) {
      orderID = event.orderID;
      final timestamp = event.timestamp;

      date = DateTime.fromMillisecondsSinceEpoch(timestamp.toInt() * 1000);

      print('$orderID created at $date');
    });

    senderAddress = encrypter.encrypt(senderAddress, iv: iv).base64;
    senderDistrict = encrypter.encrypt(senderDistrict, iv: iv).base64;
    receiverAddress = encrypter.encrypt(receiverAddress, iv: iv).base64;
    receiverDistrict = encrypter.encrypt(receiverDistrict, iv: iv).base64;
    packageDiscription = encrypter.encrypt(packageDiscription, iv: iv).base64;

    final deliveryAddressInfo = [
      senderAddress,
      senderDistrict,
      receiverAddress,
      receiverDistrict
    ];
    final packageInfo = [
      packageDiscription,
      packageHeight,
      packageWidth,
      packageDepth,
      packageWeight
    ];
    final paymentInfo = [
      payBySender,
      deliveryFee,
      productAmount,
      BigInt.from(0)
    ];
    Transaction transaction;

    transaction = Transaction(
      from: senderWalletAddress,
      maxGas: 1000000,
    );

    await delivery.createDeliveryOrder(senderWalletAddress,
        recipientrWalletAddress, deliveryAddressInfo, packageInfo, paymentInfo,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    final orderInfo = [orderID, date];
    return orderInfo;
  }

  // Cancel Order
  @override
  Future<dynamic> cancelOrder({required BigInt orderID}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var status;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription = delivery.orderCanceledEvents().take(1).listen((event) {
      status = event.status;

      print('$status');
    });

    Transaction transaction = Transaction(
      from: senderWalletAddress,
      maxGas: 500000,
    );

    await delivery.cancelOrder(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return status;
  }

  //2. Payment
  @override
  Future<dynamic> payBySender(
      {required BigInt orderID, required BigInt deliveryFee}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var state;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription =
        delivery.orderPaidBySenderEvents().take(1).listen((event) {
      state = event.status;

      print('$state State');
    });

    Transaction transaction = Transaction(
        from: senderWalletAddress,
        value: EtherAmount.fromBigInt(EtherUnit.wei, deliveryFee),
        maxGas: 100000);

    await delivery.payBySender(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return state;
  }

  //2. Payment
  @override
  Future<dynamic> payByRecipient(
      {required BigInt orderID, required BigInt totalAmount}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var state;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription =
        delivery.orderPaidByReceiverEvents().take(1).listen((event) {
      state = event.status;

      print('$state State');
    });

    Transaction transaction = Transaction(
        from: senderWalletAddress,
        value: EtherAmount.fromBigInt(EtherUnit.wei, totalAmount),
        maxGas: 500000);

    await delivery.payByReceipient(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return state;
  }

  //3. Deliverymen Accept Order
  @override
  Future<dynamic> deliveryAcceptOrder({required BigInt orderID}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var state;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription = delivery.orderAcceptedEvents().take(1).listen((event) {
      state = event.status;

      print('$state State');
    });
    Transaction transaction =
        Transaction(from: senderWalletAddress, maxGas: 100000);

    await delivery.acceptOrder(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return state;
  }

  //4. Deliverymen Pickup Order
  @override
  Future<dynamic> deliveryPickupOrder({required BigInt orderID}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var state;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription = delivery.orderPickedUpEvents().take(1).listen((event) {
      state = event.status;

      print('$state State');
    });
    Transaction transaction = Transaction(
      from: senderWalletAddress,
    );

    await delivery.orderPickedUp(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return state;
  }

  //5. Recipient confirm order received
  @override
  Future<dynamic> deliveryConfirmCompleted({required BigInt orderID}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);
    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    var state;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription =
        delivery.orderDeliveredEvents().take(1).listen((event) {
      state = event.status;

      print('$state State');
    });
    Transaction transaction = Transaction(
      from: senderWalletAddress,
    );

    await delivery.deliveryCompleted(orderID,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return state;
  }

  // For Deliverymen
  @override
  Future<dynamic> getPendingOrder() async {
    final delivery = Delivery(address: contractAddress, client: client);

    final order = await delivery.getPendingOrder();

    return order;
  }

  // For Deliverymen
  @override
  Future<dynamic> getDeliverymanOrder() async {
    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    final delivery = Delivery(address: contractAddress, client: client);

    final order = await delivery.getDeliverymanOrder(senderWalletAddress);
    print('$order');
    return order;
  }

  //For Business and Customer
  @override
  Future<dynamic> getOrderFromBusinessAndCustomer() async {
    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);

    final delivery = Delivery(address: contractAddress, client: client);

    final order = await delivery.getBusinessCustomerOrder(senderWalletAddress);
    // print('$order');
    return order;
  }

  @override
  Future<dynamic> sendMessage(
      {required BigInt orderID,
      required String receiverAddress,
      required String content}) async {
    final credentials = WalletConnectEthereumCredentials(provider: _provider);
    final senderWalletAddress =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);
    final receiverWalletAddress = EthereumAddress.fromHex(receiverAddress);

    var messageID, date;
    final delivery = Delivery(address: contractAddress, client: client);

    final subscription = delivery.messageSentEvents().take(1).listen((event) {
      messageID = event.messageID;
      date =
          DateTime.fromMillisecondsSinceEpoch(event.timestamp.toInt() * 1000);

      print('$messageID created at $date');
    });
    Transaction transaction = Transaction(
      from: senderWalletAddress,
    );

    await delivery.sendMessage(orderID, receiverWalletAddress, content,
        credentials: credentials, transaction: transaction);

    await subscription.asFuture();
    await subscription.cancel();

    return [messageID, date];
  }

  @override
  Future<dynamic> getMessage(
      {required BigInt orderID, required String address}) async {
    final delivery = Delivery(address: contractAddress, client: client);
    final callerWalletAddress = EthereumAddress.fromHex(address);

    final messages = await delivery.getMessage(orderID, callerWalletAddress);
    print(messages.toString() + "messages");
    return messages;
  }

  @override
  Future<String?> sendAmount({
    required String recipientAddress,
    required double amount,
  }) async {
    final sender =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);
    final recipient = EthereumAddress.fromHex(address);

    final etherAmount = EtherAmount.fromUnitAndValue(
        EtherUnit.szabo, (amount * 1000 * 1000).toInt());

    final transaction = Transaction(
      to: recipient,
      from: sender,
      gasPrice: EtherAmount.inWei(BigInt.one),
      maxGas: 100000,
      value: etherAmount,
    );

    final credentials = WalletConnectEthereumCredentials(provider: _provider);

    try {
      final txBytes = await client.sendTransaction(credentials, transaction);
      return txBytes;
    } catch (e) {
      print('Error: $e');
    }

    return null;
  }

  @override
  Future<void> openWalletApp() async => await _connector.openWalletApp();

  @override
  Future<double> getBalance() async {
    final address =
        EthereumAddress.fromHex(_connector.connector.session.accounts[0]);
    final amount = await client.getBalance(address);
    return amount.getValueInUnit(EtherUnit.ether).toDouble();
  }

  @override
  bool validateAddress({required String address}) {
    try {
      EthereumAddress.fromHex(address);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  String get networkName => _connector.connector.session.chainId == 11155111
      ? 'Sepolia Testnet'
      : 'Unknown';

  @override
  String get faucetUrl => 'https://faucet.dimensions.network/';

  @override
  String get address => _connector.connector.session.accounts[0];

  @override
  String get coinName => 'Eth';
}
