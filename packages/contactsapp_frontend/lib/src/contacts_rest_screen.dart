import 'package:contactsapp_frontend/contactsapp_frontend.dart';
import 'package:faker/faker.dart';

// ----------------------------------------------------------------------------
// REST API UI SCREEN.
// ----------------------------------------------------------------------------

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

// ----------------------------------------------------------------------------
// REST API work start.
// ----------------------------------------------------------------------------
  void _loadContacts() async {
    final contacts = await widget.api.getContacts();
    setState(() {
      _contacts = contacts;
      _isLoading = false;
    });
  }

  void _addContact() async {
    // FAKER for generating random name and email for contacts details.
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

  void _updateContact(Contact contact) async {
    final createContact =
        await widget.api.updateContact(contact.id, contact.name, contact.email);
    setState(() {
      _contacts.removeWhere((c) => c.id == contact.id);
      _contacts.add(createContact);
    });
  }

// ----------------------------------------------------------------------------
//  REST API work END.
// ----------------------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts App - Rest API'),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) =>
                          ContactSocketScreen(api: ContactsSocketApi())),
                );
              },
              icon: const Icon(Icons.next_plan, color: Color(0xff08D9D6))),
        ],
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ContactsList(
              data: _contacts,
              onDelete: _deleteContact,
              onAdd: _addContact,
              onUpdate: _updateContact,
            ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: const Text("refresh"),
            onPressed: _loadContacts,
            tooltip: "Refresh List",
            backgroundColor: const Color(0xffEEEEEE),
            child: const Icon(Icons.refresh, color: Color(0xff393E46)),
          ),
          const SizedBox(width: 10),
          FloatingActionButton(
            heroTag: const Text("rest-add"),
            backgroundColor: const Color(0xffEEEEEE),
            onPressed: _addContact,
            tooltip: "Add new contacts",
            child: const Icon(Icons.person_add, color: Color(0xff393E46)),
          ),
        ],
      ),
      backgroundColor: const Color(0xff222831),
    );
    // );
  }
}
