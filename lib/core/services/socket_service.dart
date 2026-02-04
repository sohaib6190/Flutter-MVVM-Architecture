part of 'helpers.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  Function(Map<String, dynamic>)? onOperatorLocationUpdate;
  Function(Map<String, dynamic>)? onUserLocationUpdate;
  String? _currentChatId;
  bool _hasJoinedChatRoom = false;
  void Function(Map<String, dynamic> data)? onOrderStatusUpdate;
  Timer? _reconnectTimer;

  factory SocketService() => _instance;
  SocketService._internal();
  bool _isInitialized = false;
  IO.Socket? _socket;
  BuildContext? _context;
  bool _socketConnected = false; // ✅ Socket connection state

  bool get socketConnected => _socketConnected;
  bool get isConnected => _socket?.connected ?? false;

  void initSocket(String url) {
    if (_isInitialized) return;
    _isInitialized = true;

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket?.connect();
  }

  void connect({
    required BuildContext context,
    required String url,
    String? chatId,
    int? userId,
    required bool isUser,
  }) {
    _context = context;

    log("🔌 Connecting to socket with chatId: $chatId, userId: $userId");

    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;

    _currentChatId = chatId; // ✅ Save the intended chat ID for later use
    _hasJoinedChatRoom = false;

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _socket!.onConnect((_) {
      log('✅ Socket connected: ${_socket!.id}');
      _socketConnected = true;

      // ✅ Emit join only once
      if (_currentChatId != null && !_hasJoinedChatRoom) {
        _socket!.emit('joinChat', _currentChatId);
        log("💬 Joined chat room: $_currentChatId");
        _hasJoinedChatRoom = true;
      } else if (_currentChatId == null && userId != null) {
        _socket!.emit('joinOrderRoom', {
          'userId': userId,
        });
      }
    });

    // Remove existing listeners
    _socket!.off('newMessage');
    _socket!.off('operatorLocationUpdate');
    _socket!.off('userLocationUpdate');
    _socket!.off('orderStatusUpdate');

    // Attach listeners
    _socket!.on('newMessage', _handleIncomingMessage);
  

    _socket!.onConnectError((err) => log('❌ Connect error: $err'));

    _socket!.onDisconnect((reason) {
      log('🔌 Disconnected: $reason');
      _socketConnected = false;

      // ⚠️ Don't reset _currentChatId here
      _hasJoinedChatRoom = false; // Let it rejoin on reconnect

      if (reason == 'io server disconnect') {
        _socket!.connect();
      }
    });
  }

  void _handleIncomingMessage(dynamic data) {

    final parsed = data is String ? jsonDecode(data) : data;
    final messageJson = parsed["message"];
    // final message = Message.fromJson(messageJson);
    // log("✅Message: ${message.toJson()}");

    // _context?.read<MessageCubit>().addMessageFromSocket(message);
  }





  void sendMessage(Map<String, dynamic> message) {
    if (!isConnected) {
      log("⚠️ Socket not connected. Message not sent.");
      return;
    }
    log("📤 Sending message: $message");
    _socket!.emit('newMessage', message);
  }

  void sendLocation({
    required int orderId,
    required int id,
    required double lat,
    required double long,
  }) {
    if (!isConnected) {
      log("⚠️ Socket not connected. Operator location not sent.");
      return;
    }

    final data = {
      'orderId': orderId,
      'id': id,
      'lat': lat,
      'long': long,
    };

    _socket!.emit('LiveLocation', data);
    // _socket!.emit('userLiveLocation', data);
    log("📤  location: $data");
  }

  void sendUserLocation({
    required int orderId,
    required int id,
    required double lat,
    required double long,
  }) {
    if (!isConnected) {
      log("⚠️ Socket not connected. user location not sent.");
      return;
    }

    final data = {
      'orderId': orderId,
      'id': id,
      'lat': lat,
      'long': long,
    };

    _socket!.emit('userLiveLocation', data);
    log("📤 Sent User location: $data");
  }

  void connectForOperatorLocations({
    required BuildContext context,
    required String url,
  }) {
    _context = context;

    _socket?.disconnect();
    _socket?.destroy();
    _socket = null;

    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableReconnection()
          .setReconnectionAttempts(500)
          .setReconnectionDelay(500)
          .build(),
    );

    _socket!.onConnect((_) {
      log('✅ Connected for operator location tracking.');
    });

    _socket!.on('allOperatorsLocationUpdate', (data) {
      log("🌍 All operators location update: $data");
      // Optional: Dispatch to Cubit
    });

    _socket!.onConnectError((err) => log('❌ Connect error: $err'));
    _socket!.onDisconnect((reason) {
      log('🔌 Disconnected: $reason');
      _socketConnected = false; // Update connection state
      if (reason == 'io server disconnect') {
        _socket!.connect();
      }
    });
  }



  void disconnect() {
    if (_socket != null) {
      // _socket!.emit("disconnect");
      log("🔌 Disconnecting socket...");
      _socketConnected = false;
      _socket?.off('newMessage');
      _reconnectTimer?.cancel(); // ✅ Stop reconnection loop
      _socket!.disconnect(); // Gracefully disconnect
      _socket!.destroy(); // Destroy socket instance
      _socket = null;
      log("✅ Socket fully disconnected");
    }
  }

  // void disconnect() {
  //   if (_socket != null) {
  //     log("🔌 Disconnecting socket...");
  //     // _socket!.off('newMessage');
  //     _socketConnected = false;
  //     _socket!.destroy();
  //     _socket = null;
  //     _tryReconnect();
  //   }
  // }

  void off() {
    if (_socket != null) {
      log("🔌 Disconnecting socket...");
      _socketConnected = false;
      _socket?.off('newMessage');
      _socketConnected = false;
      _isInitialized = false;
      // _socket!.off('newMessage');
    }
  }
}









