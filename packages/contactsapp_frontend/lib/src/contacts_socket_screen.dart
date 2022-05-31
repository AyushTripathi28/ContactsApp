import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'dart:async';
import 'dart:convert';
import 'package:faker/faker.dart';

// ----------------------------------------------------------------------------
// WEBSOCKET UI SCREEN
// ----------------------------------------------------------------------------

class ContactSocketScreen extends StatefulWidget {
  const ContactSocketScreen({Key? key, required this.api}) : super(key: key);

  final ContactsSocketApi api;

  @override
  State<ContactSocketScreen> createState() => _ContactSocketScreenState();
}

class _ContactSocketScreenState extends State<ContactSocketScreen> {
  final _socketStream = StreamController<List<Contact>>();
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

// ----------------------------------------------------------------------------
// WEBSOCKET API work start.
// ----------------------------------------------------------------------------

  void _loadContacts() {
    widget.api
      ..stream.listen((contacts) {
        _isLoading = false;
        _socketStream.add(contacts);
      })
      ..send(json.encode({'action': 'LOAD'}));
  }

  void _addContact() {
    // FAKER for generating random name and email for contacts details.
    final faker = Faker();
    final person = faker.person;
    final fullName = '${person.firstName()} ${person.lastName()}';
    final email = faker.internet.email();

    widget.api.send(json.encode({
      'action': 'ADD',
      'name': fullName,
      'email': email,
    }));
  }

  void _deleteContact(String id) {
    widget.api.send(json.encode({'action': 'DELETE', 'id': id}));
  }

  void _updateContact(Contact contact) {
    widget.api.send(json.encode({
      'action': 'UPDATE',
      'id': contact.id,
      'name': contact.name,
      'email': contact.email
    }));
  }

// ----------------------------------------------------------------------------
// WEBSOCKET API Work END.
// ----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Contacts App - WebSocket"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          ContactRestScreen(api: ContactsRestApi())),
                );
              },
              icon: const Icon(Icons.next_plan, color: Color(0xff08D9D6))),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<List<Contact>>(
        initialData: const [],
        stream: _socketStream.stream,
        builder: (context, snapshot) {
          if (_isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return ContactsList(
            data: snapshot.data!,
            onDelete: _deleteContact,
            onAdd: _addContact,
            onUpdate: _updateContact,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: const Text("ws-add"),
        onPressed: _addContact,
        tooltip: "Add new contact",
        backgroundColor: const Color(0xffEEEEEE),
        child: const Icon(Icons.person_add, color: Color(0xff393E46)),
      ),
      backgroundColor: const Color(0xff222831),
    );
  }
}
