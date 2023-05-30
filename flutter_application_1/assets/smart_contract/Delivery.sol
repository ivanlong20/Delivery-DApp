// SPDX-License-Identifier: MIT 
pragma solidity ^0.8.0;

contract Delivery{
    uint private currentOrderId = 100000;
    uint private currentMessageId = 10;
    uint[] orderId;
    mapping (uint => Order) public orders;
    mapping (uint => Message) public messages;
    //Holding balance
    mapping (address => uint) public balances;

    enum State{Submitted, Pending, Picking_Up, Delivering, Delivered, Canceled}

    struct Order {
    // Wallet Address
    uint id;
    Address walletAddress;
    DeliveryAddressInfo addressInfo;
    Package packageInfo;
    Payment paymentInfo;
    State orderStatus;
    // Timestamp
    uint256 timestamp;
    // Message ID belongs to this order
    uint[] messageID;
}

struct Message{
    uint id;
    address sender;
    address receiver;
    string content;
    uint256 timestamp;
}

struct Address{
    address payable sender;
    address payable receiver;
    address payable deliveryman;
}

struct DeliveryAddressInfo{
    string senderAddress;
    string senderDistrict;
    string receiverAddress;
    string receiverDistrict;
}

struct Package {
    string packageDescription;
    uint packageHeight;
    uint packageWidth;
    uint packageDepth;
    uint packageWeight;
}

struct Payment {
    bool payBySender;
    uint deliveryFee;
    uint productAmount;
    uint totalAmount;
}

    error OnlySender();
    error OnlyReceiver();
    error OnlyDeliveryman();
    error InvalidState();

    modifier condition(bool condition_) {
        if (!condition_)
            revert InvalidState();
        _;
    }

    modifier onlySender(uint _orderId) {
       require(msg.sender == orders[_orderId].walletAddress.sender,"Only sender can call this function");
       _;
    }

    modifier onlyRecipient(uint _orderId) {
        require(msg.sender == orders[_orderId].walletAddress.receiver,"Only receiver can call this function");
       _;
    }

    modifier onlyDeliveryman(uint _orderId) {
        require(msg.sender == orders[_orderId].walletAddress.deliveryman,"Only deliveryman can call this function");
       _;
    }

    // modifier onlySubmitted(uint _orderId) {
    //     require(orders[_orderId].orderStatus == State.Submitted,"Only the order in submitted state can call this function");
    //    _;
    // }

    // modifier onlyPending(uint _orderId) {
    //     require(orders[_orderId].orderStatus == State.Pending,"Only the order in pending state can call this function");
    //    _;
    // }

    // modifier onlyPickingUp(uint _orderId) {
    //     require(orders[_orderId].orderStatus == State.Picking_Up,"Only the order in picking up state can call this function");
    //    _;
    // }

    // modifier onlyDelivering(uint _orderId) {
    //     require(orders[_orderId].orderStatus == State.Delivering,"Only the order in delivering state can call this function");
    //    _;
    // }

    event OrderCreated(uint orderID, uint256 timestamp);
    event OrderCanceled(string status);
    event OrderPaidBySender(string status);
    event OrderPaidByReceiver(string status);
    event OrderAccepted(string status);
    event OrderPickedUp(string status);
    event OrderDelivered(string status);
    event MessageSent(uint messageID, uint256 timestamp);


    //1. Create Order and Receive Payment
    function createDeliveryOrder(address payable sender, address payable receiver, DeliveryAddressInfo calldata _addressInfo,
    Package calldata _packageInfo, Payment calldata _paymentInfo)
        external
        payable
    {
        uint totalAmount = _paymentInfo.deliveryFee + _paymentInfo.productAmount;
        uint256 orderID = generateOrderId();
        Order memory newOrder;
        newOrder.id = orderID;
        newOrder.walletAddress.sender = sender;
        newOrder.walletAddress.receiver = receiver;
        newOrder.addressInfo.senderAddress = _addressInfo.senderAddress;
        newOrder.addressInfo.senderDistrict = _addressInfo.senderDistrict;
        newOrder.addressInfo.receiverAddress = _addressInfo.receiverAddress;
        newOrder.addressInfo.receiverDistrict = _addressInfo.receiverDistrict;
        newOrder.packageInfo.packageDescription = _packageInfo.packageDescription;
        newOrder.packageInfo.packageHeight = _packageInfo.packageHeight;
        newOrder.packageInfo.packageWidth = _packageInfo.packageWidth;
        newOrder.packageInfo.packageDepth = _packageInfo.packageDepth;
        newOrder.packageInfo.packageWeight = _packageInfo.packageWeight;
        newOrder.paymentInfo.payBySender = _paymentInfo.payBySender;
        newOrder.paymentInfo.deliveryFee = _paymentInfo.deliveryFee;
        newOrder.paymentInfo.productAmount = _paymentInfo.productAmount;
        newOrder.paymentInfo.totalAmount = totalAmount;
        newOrder.timestamp = block.timestamp;
        newOrder.orderStatus = State.Submitted;
    
        orders[orderID] = newOrder;
        orderId.push(orderID);
        emit OrderCreated(orderID, block.timestamp);
    }

    // Cancel Order
    function cancelOrder(uint _orderId) external payable {
        if(orders[_orderId].paymentInfo.payBySender == true) {
            balances[orders[_orderId].walletAddress.sender] -= orders[_orderId].paymentInfo.totalAmount;
            orders[_orderId].walletAddress.sender.transfer(orders[_orderId].paymentInfo.totalAmount);
        }
        else{
            balances[orders[_orderId].walletAddress.receiver] -= orders[_orderId].paymentInfo.totalAmount;
            orders[_orderId].walletAddress.receiver.transfer(balances[orders[_orderId].walletAddress.receiver]);
        }
        orders[_orderId].orderStatus = State.Canceled;
        emit OrderCanceled("Canceled");
    }

    //2. Payment
    function payBySender(uint _orderId) public payable{
        require(msg.value == orders[_orderId].paymentInfo.totalAmount, "Amount not equal to total amount");
        balances[msg.sender] += msg.value;
        orders[_orderId].orderStatus = State.Pending;
        emit OrderPaidBySender("Payment Success by Sender");
    }

    //2. Payment
    function payByReceipient (uint _orderId) public payable {
        require(msg.value == orders[_orderId].paymentInfo.totalAmount, "Amount not equal to total amount");
        balances[msg.sender] += msg.value;
        orders[_orderId].orderStatus = State.Pending;
        emit OrderPaidByReceiver("Payment Success by Receiver");
    }

    //3. Deliverymen Accept Order
    function acceptOrder(uint _orderId) external {
        orders[_orderId].walletAddress.deliveryman = payable(msg.sender);
        orders[_orderId].orderStatus = State.Picking_Up;
        emit OrderAccepted("Order Accepted");
    }

    //4. Deliverymen Pick Up Order
    function orderPickedUp (uint _orderId) external  onlyDeliveryman(_orderId){
        orders[_orderId].orderStatus = State.Delivering;
        emit OrderPickedUp("Order Picked Up");
    }

    //5. Recipient confirm order received
    function deliveryCompleted (uint _orderId) public payable onlyRecipient(_orderId){
        if(orders[_orderId].paymentInfo.payBySender){
            // Pay the delivery fee to deliveryman
            balances[orders[_orderId].walletAddress.sender] -= orders[_orderId].paymentInfo.deliveryFee;
            orders[_orderId].walletAddress.deliveryman.transfer(orders[_orderId].paymentInfo.deliveryFee);
        }
        else{
            // Pay the delivery fee to deliveryman
            balances[orders[_orderId].walletAddress.receiver] -= orders[_orderId].paymentInfo.deliveryFee;
            orders[_orderId].walletAddress.deliveryman.transfer(orders[_orderId].paymentInfo.deliveryFee);
            // Pay the product amount to sender
            balances[orders[_orderId].walletAddress.receiver] -= orders[_orderId].paymentInfo.productAmount;
            orders[_orderId].walletAddress.sender.transfer(orders[_orderId].paymentInfo.productAmount);
        }
        orders[_orderId].orderStatus = State.Delivered;
        emit OrderDelivered("Order Delivered");
    }

    // Generate Order ID
    function generateOrderId() internal returns (uint256) {
        currentOrderId += 1;
        return currentOrderId;
    }

     // Generate Message ID
    function generateMessageId() internal returns (uint256) {
        currentOrderId += 1;
        return currentOrderId;
    }

    //Sending Message
    function sendMessage(uint _orderId, address receiver, string calldata content) external {
        uint messageId = generateMessageId();

        Message memory newMessage;
        newMessage.id = messageId;
        newMessage.sender = msg.sender;
        newMessage.receiver = receiver;
        newMessage.content = content;
        newMessage.timestamp = block.timestamp;
        messages[messageId] = newMessage;
        orders[_orderId].messageID.push(messageId);
        emit MessageSent(messageId,block.timestamp);
    }

    //Getting Message
    function getMessage(uint _orderId, string calldata userType) external view returns(Message[] memory){
        Order memory order = orders[_orderId];
        Message[] memory messagesTemp = new Message[](order.messageID.length);
        uint count = 0;
        //If user type is deliverymen, only fetch messages from/to deliverymen
        if(keccak256(bytes(userType)) == keccak256(bytes("Deliverymen"))){
            for(uint i=0;i<order.messageID.length;i++){
            if(messages[order.messageID[i]].sender == order.walletAddress.deliveryman || messages[order.messageID[i]].receiver == order.walletAddress.deliveryman){
                messagesTemp[count] = messages[order.messageID[i]];
                count++;
            }
        }

        Message[] memory filteredMessages = new Message[](count);
        if(count>0){
            for(uint i=0;i<count;i++){
                filteredMessages[i]=messagesTemp[i];
            }
               
        return filteredMessages;
        }
        else{
            revert("Not found");
        }
        }

        //If user type is any except deliverymen, only fetch messages from/to Businesses/Customers
        else{
            for(uint i=0;i<order.messageID.length;i++){
            if(messages[order.messageID[i]].sender == order.walletAddress.deliveryman || messages[order.messageID[i]].receiver == order.walletAddress.deliveryman){
                messagesTemp[count] = messages[order.messageID[i]];
                count++;
            }
        }

        Message[] memory filteredMessages = new Message[](count);
        if(count>0){
            for(uint i=0;i<count;i++){
                filteredMessages[i]=messagesTemp[i];
            }
   
        return filteredMessages;
        }
        else{
            revert("Not found");
        }
        }
     
    }

    // For Deliverymen App
    function getPendingOrder () external view returns (Order[] memory) {
        require (orderId.length > 0, "No orders found.");
        Order[] memory ordersTemp = new Order[](orderId.length+1);
        uint count = 0;
        for (uint i = 0; i < orderId.length; i++) {
            if (orders[orderId[i]].orderStatus == State.Pending) {
                ordersTemp[count] = orders[orderId[i]];
                count++;
            }
        }
        Order[] memory filteredOrders = new Order[](count);
        if(count>0){
            for(uint i=0;i<count;i++){
                filteredOrders[i]=ordersTemp[i];
            }
        }
        else{
            revert('Not found');
        }
        return filteredOrders;
    }

    // For Business and Customer App
    function getBusinessCustomerOrder(address wallet_address) external view returns (Order[] memory) {
        require (orderId.length > 0, "No orders found.");
        Order[] memory ordersTemp = new Order[](orderId.length+1);
        uint count = 0;
        for (uint i = 0; i < orderId.length; i++) {
            if ((orders[orderId[i]].walletAddress.sender == wallet_address) || (orders[orderId[i]].walletAddress.receiver == wallet_address))  {
                ordersTemp[count] = orders[orderId[i]];
                count++;
            }
        }

        Order[] memory filteredOrders = new Order[](count);

        if(count>0){
            for(uint i=0;i<count;i++){
                filteredOrders[i]=ordersTemp[i];
            }
        }
        else{
            revert('Not found');
        }

        return filteredOrders;
    }

    // For Deliverymen App
    function getDeliverymanOrder (address wallet_address) external view returns (Order[] memory) {
        require (orderId.length > 0, "No orders found.");
        Order[] memory ordersTemp = new Order[](orderId.length+1);
        uint count = 0;
        for (uint i = 0; i < orderId.length; i++) {
            if ((orders[orderId[i]].walletAddress.deliveryman == wallet_address))  {
                ordersTemp[count] = orders[orderId[i]];
                count += 1;
            }
        }

        Order[] memory filteredOrders = new Order[](count);

        if(count>0){
            for(uint i=0;i<count;i++){
                filteredOrders[i]=ordersTemp[i];
            }
        }
        else{
            revert('Not found');
        }

        return filteredOrders;
    }
    

    // function getOrderStatus(uint _orderId) external view returns (string memory) {
    //     string memory result;
    //     State status = orders[_orderId].orderStatus;
    //     if (status == State.Submitted) {
    //         result = "Submitted";
    //     } else if (status == State.Pending) {
    //         result = "Pending";
    //     } else if (status == State.Picking_Up) {
    //         result = "Picking Up";
    //     } else if (status == State.Delivering) {
    //         result = "Delivering";
    //     } else if (status == State.Delivered) {
    //         result = "Delivered";
    //     } else if (status == State.Canceled) {
    //         result = "Canceled";
    //     } else {
    //         result = "Invalid";
    //     }
    //     return result;
    // }

}