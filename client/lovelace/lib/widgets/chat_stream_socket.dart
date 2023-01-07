import 'dart:async';
import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:lovelace/resources/storage_methods.dart';
import 'package:lovelace/utils/global_variables.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

// STEP1:  Stream setup
class ChatStreamSocket {
  final _socketResponse = StreamController<String>();

  void Function(String) get addResponse => _socketResponse.sink.add;

  Stream<String> get getResponse => _socketResponse.stream;

  void dispose() {
    _socketResponse.close();
  }
}

ChatStreamSocket streamSocket = ChatStreamSocket();

//STEP2: Add this function in main function in main.dart file and add incoming data to the stream
void connectAndListen(String keyName, String senderName) async {
  dynamic cookie = await StorageMethods().read("cookie");
  String baseUrl = checkDevice();

  socket_io.Socket socket = socket_io.io(
      Uri.http(baseUrl, '/chat').toString(),
      socket_io.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.cookieHeader: cookie
      }).build());

  socket.onConnect((_) {
    socket.emit('join', {"room": keyName, "username": senderName});
  });

  //When an event recieved from server, data is added to the stream
  socket.on('sent', (data) {
    print(data);
  });

  socket.onDisconnect((_) {
    socket.emit('leave', {"room": keyName, "username": senderName});
  });
}

void sendingMessage(dynamic chatMessageMap) async {
  dynamic cookie = await StorageMethods().read("cookie");
  String baseUrl = checkDevice();

  socket_io.Socket socket = socket_io.io(
      Uri.http(baseUrl, '/chat').toString(),
      socket_io.OptionBuilder().setTransports(['websocket']).setExtraHeaders({
        HttpHeaders.contentTypeHeader: 'application/json; charset=UTF-8',
        HttpHeaders.cookieHeader: cookie
      }).build());

  socket.emit('sent', chatMessageMap);
  // print(chatMessageMap);
}

//Step3: Build widgets with streambuilder

class ChatStreamSocketBuild extends StatelessWidget {
  const ChatStreamSocketBuild({required Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: streamSocket.getResponse,
      builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
        print(snapshot.data!);
        return Text(snapshot.data!);
      },
    );
  }
}
