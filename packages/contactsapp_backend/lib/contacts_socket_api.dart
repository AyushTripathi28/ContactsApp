import 'package:contactsapp_backend/contactsapp_backend.dart';
import 'package:shelf_web_socket/shelf_web_socket.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

// ----------------------------------------------------------------------------
// BACKEND PART FOR WEBSOCKET API
// Created ends point STREAM for LOAD(get), ADD(post) and DELETE(delete).
// ----------------------------------------------------------------------------

class ContactsSocketApi {
  ContactsSocketApi(this.store);

  final List<WebSocketChannel> _sockets = [];
  final DbCollection store;

  Handler get router {
    return webSocketHandler((WebSocketChannel socket) {
      socket.stream.listen((message) async {
        final data = json.decode(message);
        print(data);

        if (data['action'] == 'ADD') {
          await store.insert({'name': data['name'], 'email': data['email']});
        }

        if (data['action'] == 'DELETE') {
          await store.deleteOne({
            '_id': ObjectId.fromHexString(data['id']),
          });
        }

        final contacts = await store.find().toList();
        for (final ws in _sockets) {
          ws.sink.add(json.encode(contacts));
        }
      });
      _sockets.add(socket);
    });
  }
}
