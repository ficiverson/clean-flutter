import 'dart:async';

class BroadcastServer {
  StreamController<bool> _controller = new StreamController.broadcast();
  void sendMessage(bool status) {
    _controller.add(status);
  }
  Stream get messages => _controller.stream;
}