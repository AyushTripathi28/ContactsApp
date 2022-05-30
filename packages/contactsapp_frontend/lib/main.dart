import 'package:contactsapp_frontend/contactsapp_frontend.dart';

void main() {
  runApp(const MyApp());
}

// ----------------------------------------------------------------------------
// Flutter project to showcase RestAPI and WebSocket integration in Frontend
// Backend is also created using dart with both Rest API and WebSocket.
// ----------------------------------------------------------------------------

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Contacts App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // This is for Rest API page for directly going to Websocket part
      // replace this comment for home. or go from homescreeen icon btn.
      // home: ContactSocketScreen(
      //   api: ContactsSocketApi(),
      // ),
      home: ContactRestScreen(
        api: ContactsRestApi(),
      ),
    );
  }
}
