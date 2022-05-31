import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:flutter/gestures.dart';

class ContactsList extends StatefulWidget {
  const ContactsList(
      {Key? key,
      required this.data,
      required this.onDelete,
      required this.onAdd,
      required this.onUpdate})
      : super(key: key);

  final List<Contact> data;
  final ValueChanged<String> onDelete;
  final ValueChanged<Contact> onUpdate;
  final VoidCallback onAdd;

  @override
  State<ContactsList> createState() => _ContactsListState();
}

class _ContactsListState extends State<ContactsList> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return widget.data.isEmpty
        ? _NoContact(
            onAdd: widget.onAdd,
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
                ...widget.data.map(
                  (contact) => Padding(
                    key: ValueKey(contact.id),
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: const Color(0xff393E46),
                          borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        onTap: () => _showAlertDialog(contact),
                        contentPadding: const EdgeInsets.only(left: 5),
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xff00ADB5),
                          radius: 25,
                          child: Text(
                            contact.initials,
                            style: const TextStyle(
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
                            widget.onDelete(contact.id);
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

  Future<void> _showAlertDialog(Contact contact) async {
    nameController.text = contact.name;
    emailController.text = contact.email;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: const EdgeInsets.all(15),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            title: const Text(
              "Update Data",
              style: TextStyle(
                color: Color(0xff222831),
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  String name = nameController.text;
                  String email = emailController.text;
                  var con = Contact(contact.id, name, email, "");

                  widget.onUpdate(con);
                  Navigator.pop(context);
                },
                child: const Text(
                  "Update",
                  style: TextStyle(
                    color: Color(0xff222831),
                    fontWeight: FontWeight.w500,
                    fontSize: 17,
                  ),
                ),
              ),
            ],
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Full Name",
                    style: TextStyle(
                      color: Color(0xff222831),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: nameController,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff00ADB5),
                      hintText: "Full Name",
                      hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  const Text(
                    "Email",
                    style: TextStyle(
                      color: Color(0xff222831),
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextField(
                    controller: emailController,
                    style: const TextStyle(),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xff00ADB5),
                      hintText: "Email",
                      hintStyle: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w400,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: const Color(0xffF1EEE9),
            scrollable: true,
          );
        });
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
