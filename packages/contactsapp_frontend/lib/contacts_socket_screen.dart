import 'dart:async';

import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

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

  void _loadContacts() {}

  void _addContact() {
    final faker = Faker();
    final person = faker.person;
    final fullName = '${person.firstName()} ${person.lastName()}';
  }

  void _deleteContact(String id) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Contacts App")),
      body: StreamBuilder<List<Contact>>(
        initialData: [],
        stream: _socketStream.stream,
        builder: (context, snapshot) {
          return ContactsList(
              data: snapshot.data!,
              onDelete: _deleteContact,
              onAdd: _addContact);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addContact,
        tooltip: "Add new contact",
        child: Icon(Icons.person_add),
      ),
    );
  }
}
