import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:flutter/material.dart';

class ContactsList extends StatelessWidget {
  const ContactsList(
      {Key? key,
      required this.data,
      required this.onDelete,
      required this.onAdd})
      : super(key: key);

  final List<Contact> data;
  final ValueChanged<String> onDelete;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return data.isEmpty
        ? _NoContact(
            onAdd: onAdd,
          )
        : ListView(
            children: [
              ...data.map(
                (contact) => Padding(
                  key: ValueKey(contact.id),
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      child: Text(contact.initials),
                    ),
                    title: Text(
                      contact.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: MaterialButton(
                      onPressed: (() {
                        onDelete(contact.id);
                      }),
                      child: Icon(Icons.delete),
                    ),
                  ),
                ),
              ),
            ],
          );
  }
}

class _NoContact extends StatelessWidget {
  const _NoContact({Key? key, required this.onAdd}) : super(key: key);

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.person_outline,
            size: 80,
            color: Colors.black,
          ),
          const Text(
            "No Contacts Listed",
            style: const TextStyle(fontSize: 20),
          ),
          const SizedBox(
            height: 30,
          ),
          MaterialButton(
            onPressed: onAdd,
            color: Colors.amberAccent,
            child: const Text(
              "Add your first",
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
    );
  }
}
