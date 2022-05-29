import 'dart:async';
import 'dart:convert';

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

  void _loadContacts() {
    widget.api
      ..stream.listen((contacts) {
        _isLoading = false;
        _socketStream.add(contacts);
      })
      ..send(json.encode({'action': 'LOAD'}));
  }

  void _addContact() {
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Contacts App"),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => ContactRestScreen(
                      api: ContactsRestApi(),
                    ),
                  ));
                },
                icon: const Icon(Icons.next_plan))
          ],
        ),
        body: StreamBuilder<List<Contact>>(
          initialData: const [],
          stream: _socketStream.stream,
          builder: (context, snapshot) {
            if (_isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return ContactsList(
                data: snapshot.data!,
                onDelete: _deleteContact,
                onAdd: _addContact);
          },
        ),
        floatingActionButton: FloatingActionButton(
          heroTag: const Text("ws-add"),
          onPressed: _addContact,
          tooltip: "Add new contact",
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }
}
