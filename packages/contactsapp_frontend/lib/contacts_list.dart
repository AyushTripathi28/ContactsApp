import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:flutter/gestures.dart';
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
        : ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              dragDevices: {
                PointerDeviceKind.touch,
                PointerDeviceKind.mouse,
              },
            ),
            child: ListView(
              children: [
                ...data.map(
                  (contact) => Padding(
                    key: ValueKey(contact.id),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Color(0xff393E46),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: const EdgeInsets.only(left: 5),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xff00ADB5),
                          radius: 25,
                          child: Text(
                            contact.initials,
                            style: TextStyle(
                                color: Color(0xff222831),
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(
                          contact.name,
                          style: const TextStyle(
                              fontSize: 20, color: Color(0xffEEEEEE)),
                        ),
                        subtitle: Text(
                          contact.email,
                          style: const TextStyle(
                              fontSize: 12, color: Color(0xffEEEEEE)),
                        ),
                        trailing: MaterialButton(
                          onPressed: (() {
                            onDelete(contact.id);
                          }),
                          child: const Icon(
                            Icons.delete,
                            color: Color(0xff00ADB5),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
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
            style: TextStyle(fontSize: 20),
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
