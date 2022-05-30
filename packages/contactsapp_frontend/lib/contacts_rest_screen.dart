import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

class ContactRestScreen extends StatefulWidget {
  const ContactRestScreen({Key? key, required this.api}) : super(key: key);

  final ContactsRestApi api;

  @override
  State<ContactRestScreen> createState() => _ContactRestScreenState();
}

class _ContactRestScreenState extends State<ContactRestScreen> {
  List<Contact> _contacts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadContacts();
  }

  void _loadContacts() async {
    final contacts = await widget.api.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  void _addContact() async {
    final faker = Faker();
    final person = faker.person;

    final fullName = '${person.firstName()} ${person.lastName()}';
    final email = faker.internet.email();

    final createContact = await widget.api.addContact(fullName, email);
    setState(() {
      _contacts.add(createContact);
    });
  }

  void _deleteContact(String id) async {
    await widget.api.deleteContact(id);
    setState(() {
      _contacts.removeWhere((contact) => contact.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // systemOverlayStyle: SystemUiOverlayStyle(
        //   systemNavigationBarColor: Colors.blue,
        //   systemNavigationBarDividerColor: Colors.black,
        //   // Navigation bar
        //   // statusBarColor: Colors.pink, // Status bar
        // ),
        title: const Text(
          'Contacts App - Rest API',
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => ContactSocketScreen(
                    api: ContactsSocketApi(),
                  ),
                ));
              },
              icon: const Icon(
                Icons.next_plan,
                color: Color(0xff08D9D6),
              ))
        ],
      ),
      backgroundColor: Color(0xff222831),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ContactsList(
              data: _contacts,
              onDelete: _deleteContact,
              onAdd: _addContact,
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: const Text("refresh"),
            onPressed: _loadContacts,
            tooltip: "Refresh List",
            backgroundColor: Color(0xffEEEEEE),
            child: const Icon(
              Icons.refresh,
              color: Color(0xff393E46),
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            heroTag: const Text("rest-add"),
            backgroundColor: Color(0xffEEEEEE),
            onPressed: _addContact,
            tooltip: "Add new contacts",
            child: const Icon(
              Icons.person_add,
              color: Color(0xff393E46),
            ),
          ),
        ],
      ),
    );
    // );
  }
}
