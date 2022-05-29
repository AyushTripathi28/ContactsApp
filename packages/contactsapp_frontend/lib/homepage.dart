import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.api}) : super(key: key);

  final ContactsRestApi api;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App'),
      ),
      body: Container(),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () {},
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
            onPressed: () {},
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
