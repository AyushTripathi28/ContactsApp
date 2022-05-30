import 'package:contactsapp_backend/contactsapp_backend.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_hotreload/shelf_hotreload.dart';

// ----------------------------------------------------------------------------
// Backend code for Contacts app using dart, DB using MONGO DB,
// Worked on both REST API and WEB SOCKET.
// ----------------------------------------------------------------------------

void main(List<String> arguments) async {
  // Connect and load collection
  final db = await Db.create(
      'mongodb+srv://admin:root@cluster0.5nwsw.mongodb.net/?retryWrites=true&w=majority');
  await db.open();
  final coll = db.collection("contacts");
  print("Database opened");

  // Create server
  const port = 8001;
  final app = Router();

  // Create routes for both REST and WEBSOCKET API
  app.mount('/contacts/', ContactRestApi(coll).router);
  app.mount('/contacts-ws/', ContactsSocketApi(coll).router);

  // Listen for incoming connections
  final handler = Pipeline()
      .addMiddleware(logRequests())
      .addMiddleware(handleCors())
      .addHandler(app);

  withHotreload(() => serve(handler, InternetAddress.anyIPv4, port));
}
