// Generated code, do not modify. Run `build_runner build` to re-generate!
// @dart=2.12
// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:web3dart/web3dart.dart' as _i1;

final _contractAbi = _i1.ContractAbi.fromJson(
  '[{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"acceptOrder","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"cancelOrder","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"address payable","name":"sender","type":"address"},{"internalType":"address payable","name":"receiver","type":"address"},{"components":[{"internalType":"string","name":"senderAddress","type":"string"},{"internalType":"string","name":"senderDistrict","type":"string"},{"internalType":"string","name":"receiverAddress","type":"string"},{"internalType":"string","name":"receiverDistrict","type":"string"}],"internalType":"struct Delivery.DeliveryAddressInfo","name":"_addressInfo","type":"tuple"},{"components":[{"internalType":"string","name":"packageDescription","type":"string"},{"internalType":"uint256","name":"packageHeight","type":"uint256"},{"internalType":"uint256","name":"packageWidth","type":"uint256"},{"internalType":"uint256","name":"packageDepth","type":"uint256"},{"internalType":"uint256","name":"packageWeight","type":"uint256"}],"internalType":"struct Delivery.Package","name":"_packageInfo","type":"tuple"},{"components":[{"internalType":"bool","name":"payBySender","type":"bool"},{"internalType":"uint256","name":"deliveryFee","type":"uint256"},{"internalType":"uint256","name":"productAmount","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"}],"internalType":"struct Delivery.Payment","name":"_paymentInfo","type":"tuple"}],"name":"createDeliveryOrder","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"deliveryCompleted","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[],"name":"InvalidState","type":"error"},{"inputs":[],"name":"OnlyDeliveryman","type":"error"},{"inputs":[],"name":"OnlyReceiver","type":"error"},{"inputs":[],"name":"OnlySender","type":"error"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"messageID","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"MessageSent","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderAccepted","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderCanceled","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"uint256","name":"orderID","type":"uint256"},{"indexed":false,"internalType":"uint256","name":"timestamp","type":"uint256"}],"name":"OrderCreated","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderDelivered","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderPaidByReceiver","type":"event"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderPaidBySender","type":"event"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"orderPickedUp","outputs":[],"stateMutability":"nonpayable","type":"function"},{"anonymous":false,"inputs":[{"indexed":false,"internalType":"string","name":"status","type":"string"}],"name":"OrderPickedUp","type":"event"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"payByReceipient","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"}],"name":"payBySender","outputs":[],"stateMutability":"payable","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"address","name":"receiver","type":"address"},{"internalType":"string","name":"content","type":"string"}],"name":"sendMessage","outputs":[],"stateMutability":"nonpayable","type":"function"},{"inputs":[{"internalType":"address","name":"","type":"address"}],"name":"balances","outputs":[{"internalType":"uint256","name":"","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"wallet_address","type":"address"}],"name":"getBusinessCustomerOrder","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"components":[{"internalType":"address payable","name":"sender","type":"address"},{"internalType":"address payable","name":"receiver","type":"address"},{"internalType":"address payable","name":"deliveryman","type":"address"}],"internalType":"struct Delivery.Address","name":"walletAddress","type":"tuple"},{"components":[{"internalType":"string","name":"senderAddress","type":"string"},{"internalType":"string","name":"senderDistrict","type":"string"},{"internalType":"string","name":"receiverAddress","type":"string"},{"internalType":"string","name":"receiverDistrict","type":"string"}],"internalType":"struct Delivery.DeliveryAddressInfo","name":"addressInfo","type":"tuple"},{"components":[{"internalType":"string","name":"packageDescription","type":"string"},{"internalType":"uint256","name":"packageHeight","type":"uint256"},{"internalType":"uint256","name":"packageWidth","type":"uint256"},{"internalType":"uint256","name":"packageDepth","type":"uint256"},{"internalType":"uint256","name":"packageWeight","type":"uint256"}],"internalType":"struct Delivery.Package","name":"packageInfo","type":"tuple"},{"components":[{"internalType":"bool","name":"payBySender","type":"bool"},{"internalType":"uint256","name":"deliveryFee","type":"uint256"},{"internalType":"uint256","name":"productAmount","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"}],"internalType":"struct Delivery.Payment","name":"paymentInfo","type":"tuple"},{"internalType":"enum Delivery.State","name":"orderStatus","type":"uint8"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"uint256[]","name":"messageID","type":"uint256[]"}],"internalType":"struct Delivery.Order[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"address","name":"wallet_address","type":"address"}],"name":"getDeliverymanOrder","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"components":[{"internalType":"address payable","name":"sender","type":"address"},{"internalType":"address payable","name":"receiver","type":"address"},{"internalType":"address payable","name":"deliveryman","type":"address"}],"internalType":"struct Delivery.Address","name":"walletAddress","type":"tuple"},{"components":[{"internalType":"string","name":"senderAddress","type":"string"},{"internalType":"string","name":"senderDistrict","type":"string"},{"internalType":"string","name":"receiverAddress","type":"string"},{"internalType":"string","name":"receiverDistrict","type":"string"}],"internalType":"struct Delivery.DeliveryAddressInfo","name":"addressInfo","type":"tuple"},{"components":[{"internalType":"string","name":"packageDescription","type":"string"},{"internalType":"uint256","name":"packageHeight","type":"uint256"},{"internalType":"uint256","name":"packageWidth","type":"uint256"},{"internalType":"uint256","name":"packageDepth","type":"uint256"},{"internalType":"uint256","name":"packageWeight","type":"uint256"}],"internalType":"struct Delivery.Package","name":"packageInfo","type":"tuple"},{"components":[{"internalType":"bool","name":"payBySender","type":"bool"},{"internalType":"uint256","name":"deliveryFee","type":"uint256"},{"internalType":"uint256","name":"productAmount","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"}],"internalType":"struct Delivery.Payment","name":"paymentInfo","type":"tuple"},{"internalType":"enum Delivery.State","name":"orderStatus","type":"uint8"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"uint256[]","name":"messageID","type":"uint256[]"}],"internalType":"struct Delivery.Order[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"_orderId","type":"uint256"},{"internalType":"string","name":"userType","type":"string"}],"name":"getMessage","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"receiver","type":"address"},{"internalType":"string","name":"content","type":"string"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],"internalType":"struct Delivery.Message[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[],"name":"getPendingOrder","outputs":[{"components":[{"internalType":"uint256","name":"id","type":"uint256"},{"components":[{"internalType":"address payable","name":"sender","type":"address"},{"internalType":"address payable","name":"receiver","type":"address"},{"internalType":"address payable","name":"deliveryman","type":"address"}],"internalType":"struct Delivery.Address","name":"walletAddress","type":"tuple"},{"components":[{"internalType":"string","name":"senderAddress","type":"string"},{"internalType":"string","name":"senderDistrict","type":"string"},{"internalType":"string","name":"receiverAddress","type":"string"},{"internalType":"string","name":"receiverDistrict","type":"string"}],"internalType":"struct Delivery.DeliveryAddressInfo","name":"addressInfo","type":"tuple"},{"components":[{"internalType":"string","name":"packageDescription","type":"string"},{"internalType":"uint256","name":"packageHeight","type":"uint256"},{"internalType":"uint256","name":"packageWidth","type":"uint256"},{"internalType":"uint256","name":"packageDepth","type":"uint256"},{"internalType":"uint256","name":"packageWeight","type":"uint256"}],"internalType":"struct Delivery.Package","name":"packageInfo","type":"tuple"},{"components":[{"internalType":"bool","name":"payBySender","type":"bool"},{"internalType":"uint256","name":"deliveryFee","type":"uint256"},{"internalType":"uint256","name":"productAmount","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"}],"internalType":"struct Delivery.Payment","name":"paymentInfo","type":"tuple"},{"internalType":"enum Delivery.State","name":"orderStatus","type":"uint8"},{"internalType":"uint256","name":"timestamp","type":"uint256"},{"internalType":"uint256[]","name":"messageID","type":"uint256[]"}],"internalType":"struct Delivery.Order[]","name":"","type":"tuple[]"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"messages","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"internalType":"address","name":"sender","type":"address"},{"internalType":"address","name":"receiver","type":"address"},{"internalType":"string","name":"content","type":"string"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],"stateMutability":"view","type":"function"},{"inputs":[{"internalType":"uint256","name":"","type":"uint256"}],"name":"orders","outputs":[{"internalType":"uint256","name":"id","type":"uint256"},{"components":[{"internalType":"address payable","name":"sender","type":"address"},{"internalType":"address payable","name":"receiver","type":"address"},{"internalType":"address payable","name":"deliveryman","type":"address"}],"internalType":"struct Delivery.Address","name":"walletAddress","type":"tuple"},{"components":[{"internalType":"string","name":"senderAddress","type":"string"},{"internalType":"string","name":"senderDistrict","type":"string"},{"internalType":"string","name":"receiverAddress","type":"string"},{"internalType":"string","name":"receiverDistrict","type":"string"}],"internalType":"struct Delivery.DeliveryAddressInfo","name":"addressInfo","type":"tuple"},{"components":[{"internalType":"string","name":"packageDescription","type":"string"},{"internalType":"uint256","name":"packageHeight","type":"uint256"},{"internalType":"uint256","name":"packageWidth","type":"uint256"},{"internalType":"uint256","name":"packageDepth","type":"uint256"},{"internalType":"uint256","name":"packageWeight","type":"uint256"}],"internalType":"struct Delivery.Package","name":"packageInfo","type":"tuple"},{"components":[{"internalType":"bool","name":"payBySender","type":"bool"},{"internalType":"uint256","name":"deliveryFee","type":"uint256"},{"internalType":"uint256","name":"productAmount","type":"uint256"},{"internalType":"uint256","name":"totalAmount","type":"uint256"}],"internalType":"struct Delivery.Payment","name":"paymentInfo","type":"tuple"},{"internalType":"enum Delivery.State","name":"orderStatus","type":"uint8"},{"internalType":"uint256","name":"timestamp","type":"uint256"}],"stateMutability":"view","type":"function"}]',
  'Delivery',
);

class Delivery extends _i1.GeneratedContract {
  Delivery({
    required _i1.EthereumAddress address,
    required _i1.Web3Client client,
    int? chainId,
  }) : super(
          _i1.DeployedContract(
            _contractAbi,
            address,
          ),
          client,
          chainId,
        );

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> acceptOrder(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[0];
    assert(checkSignature(function, 'ef18e9ed'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> cancelOrder(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[1];
    assert(checkSignature(function, '514fcac7'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> createDeliveryOrder(
    _i1.EthereumAddress sender,
    _i1.EthereumAddress receiver,
    dynamic _addressInfo,
    dynamic _packageInfo,
    dynamic _paymentInfo, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[2];
    assert(checkSignature(function, '85174abd'));
    final params = [
      sender,
      receiver,
      _addressInfo,
      _packageInfo,
      _paymentInfo,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> deliveryCompleted(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[3];
    assert(checkSignature(function, '82fb68ed'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> orderPickedUp(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[4];
    assert(checkSignature(function, '10c62488'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> payByReceipient(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[5];
    assert(checkSignature(function, 'b89713fd'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> payBySender(
    BigInt _orderId, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[6];
    assert(checkSignature(function, 'fa96e92f'));
    final params = [_orderId];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [transaction] parameter can be used to override parameters
  /// like the gas price, nonce and max gas. The `data` and `to` fields will be
  /// set by the contract.
  Future<String> sendMessage(
    BigInt _orderId,
    _i1.EthereumAddress receiver,
    String content, {
    required _i1.Credentials credentials,
    _i1.Transaction? transaction,
  }) async {
    final function = self.abi.functions[7];
    assert(checkSignature(function, '2da17371'));
    final params = [
      _orderId,
      receiver,
      content,
    ];
    return write(
      credentials,
      transaction,
      function,
      params,
    );
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<BigInt> balances(
    _i1.EthereumAddress $param14, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[8];
    assert(checkSignature(function, '27e235e3'));
    final params = [$param14];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as BigInt);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getBusinessCustomerOrder(
    _i1.EthereumAddress wallet_address, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[9];
    assert(checkSignature(function, '8a43dfb9'));
    final params = [wallet_address];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getDeliverymanOrder(
    _i1.EthereumAddress wallet_address, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[10];
    assert(checkSignature(function, 'f5721707'));
    final params = [wallet_address];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getMessage(
    BigInt _orderId,
    String userType, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[11];
    assert(checkSignature(function, '2e713b7b'));
    final params = [
      _orderId,
      userType,
    ];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<List<dynamic>> getPendingOrder({_i1.BlockNum? atBlock}) async {
    final function = self.abi.functions[12];
    assert(checkSignature(function, '4a41aa47'));
    final params = [];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return (response[0] as List<dynamic>).cast<dynamic>();
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Messages> messages(
    BigInt $param19, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[13];
    assert(checkSignature(function, '0d80fefd'));
    final params = [$param19];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Messages(response);
  }

  /// The optional [atBlock] parameter can be used to view historical data. When
  /// set, the function will be evaluated in the specified block. By default, the
  /// latest on-chain block will be used.
  Future<Orders> orders(
    BigInt $param20, {
    _i1.BlockNum? atBlock,
  }) async {
    final function = self.abi.functions[14];
    assert(checkSignature(function, 'a85c38ef'));
    final params = [$param20];
    final response = await read(
      function,
      params,
      atBlock,
    );
    return Orders(response);
  }

  /// Returns a live stream of all MessageSent events emitted by this contract.
  Stream<MessageSent> messageSentEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('MessageSent');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return MessageSent(decoded);
    });
  }

  /// Returns a live stream of all OrderAccepted events emitted by this contract.
  Stream<OrderAccepted> orderAcceptedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderAccepted');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderAccepted(decoded);
    });
  }

  /// Returns a live stream of all OrderCanceled events emitted by this contract.
  Stream<OrderCanceled> orderCanceledEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderCanceled');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderCanceled(decoded);
    });
  }

  /// Returns a live stream of all OrderCreated events emitted by this contract.
  Stream<OrderCreated> orderCreatedEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderCreated');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderCreated(decoded);
    });
  }

  /// Returns a live stream of all OrderDelivered events emitted by this contract.
  Stream<OrderDelivered> orderDeliveredEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderDelivered');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderDelivered(decoded);
    });
  }

  /// Returns a live stream of all OrderPaidByReceiver events emitted by this contract.
  Stream<OrderPaidByReceiver> orderPaidByReceiverEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderPaidByReceiver');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderPaidByReceiver(decoded);
    });
  }

  /// Returns a live stream of all OrderPaidBySender events emitted by this contract.
  Stream<OrderPaidBySender> orderPaidBySenderEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderPaidBySender');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderPaidBySender(decoded);
    });
  }

  /// Returns a live stream of all OrderPickedUp events emitted by this contract.
  Stream<OrderPickedUp> orderPickedUpEvents({
    _i1.BlockNum? fromBlock,
    _i1.BlockNum? toBlock,
  }) {
    final event = self.event('OrderPickedUp');
    final filter = _i1.FilterOptions.events(
      contract: self,
      event: event,
      fromBlock: fromBlock,
      toBlock: toBlock,
    );
    return client.events(filter).map((_i1.FilterEvent result) {
      final decoded = event.decodeResults(
        result.topics!,
        result.data!,
      );
      return OrderPickedUp(decoded);
    });
  }
}

class Messages {
  Messages(List<dynamic> response)
      : id = (response[0] as BigInt),
        sender = (response[1] as _i1.EthereumAddress),
        receiver = (response[2] as _i1.EthereumAddress),
        content = (response[3] as String),
        timestamp = (response[4] as BigInt);

  final BigInt id;

  final _i1.EthereumAddress sender;

  final _i1.EthereumAddress receiver;

  final String content;

  final BigInt timestamp;
}

class Orders {
  Orders(List<dynamic> response)
      : id = (response[0] as BigInt),
        walletAddress = (response[1] as dynamic),
        addressInfo = (response[2] as dynamic),
        packageInfo = (response[3] as dynamic),
        paymentInfo = (response[4] as dynamic),
        orderStatus = (response[5] as BigInt),
        timestamp = (response[6] as BigInt);

  final BigInt id;

  final dynamic walletAddress;

  final dynamic addressInfo;

  final dynamic packageInfo;

  final dynamic paymentInfo;

  final BigInt orderStatus;

  final BigInt timestamp;
}

class MessageSent {
  MessageSent(List<dynamic> response)
      : messageID = (response[0] as BigInt),
        timestamp = (response[1] as BigInt);

  final BigInt messageID;

  final BigInt timestamp;
}

class OrderAccepted {
  OrderAccepted(List<dynamic> response) : status = (response[0] as String);

  final String status;
}

class OrderCanceled {
  OrderCanceled(List<dynamic> response) : status = (response[0] as String);

  final String status;
}

class OrderCreated {
  OrderCreated(List<dynamic> response)
      : orderID = (response[0] as BigInt),
        timestamp = (response[1] as BigInt);

  final BigInt orderID;

  final BigInt timestamp;
}

class OrderDelivered {
  OrderDelivered(List<dynamic> response) : status = (response[0] as String);

  final String status;
}

class OrderPaidByReceiver {
  OrderPaidByReceiver(List<dynamic> response)
      : status = (response[0] as String);

  final String status;
}

class OrderPaidBySender {
  OrderPaidBySender(List<dynamic> response) : status = (response[0] as String);

  final String status;
}

class OrderPickedUp {
  OrderPickedUp(List<dynamic> response) : status = (response[0] as String);

  final String status;
}
