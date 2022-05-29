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
    print(contacts);
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  void _addContact() async {
    final faker = Faker();
    final person = faker.person;
    final fullName = '${person.firstName()} ${person.lastName()}';

    final createContact = await widget.api.addContact(fullName);
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
        title: const Text('Contacts App'),
      ),
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
            onPressed: _loadContacts,
            tooltip: "Refresh List",
            backgroundColor: Colors.purpleAccent,
            child: const Icon(
              Icons.refresh,
            ),
          ),
          const SizedBox(
            width: 10,
          ),
          FloatingActionButton(
            onPressed: _addContact,
            tooltip: "Add new contacts",
            child: const Icon(
              Icons.person_add,
            ),
          ),
        ],
      ),
    );
  }
}
