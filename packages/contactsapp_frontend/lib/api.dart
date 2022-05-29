import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:equatable/equatable.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class Contact extends Equatable {
  const Contact._(this.id, this.name, this.initials);

  final String id;
  final String name;
  final String initials;

  factory Contact.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final names = name.split(' ');
    final initials = names[0].substring(0, 1) + names[1].substring(0, 1);

    return Contact._(json['_id'], name, initials);
  }

  @override
  List<String> get props => [id, name, initials];
}

class ContactsRestApi {
  final _api = Dio(BaseOptions(
    baseUrl: 'http://192.168.1.106:8001/contacts/',
    headers: {
      'Content-Type': ContentType.json.mimeType,
    },
  ));

  Future<List<Contact>> getContacts() async {
    final res = await _api.get('');
    return (res.data['contacts'] as List)
        .map<Contact>((json) => Contact.fromJson(json))
        .toList();
  }

  Future<Contact> addContact(String name) async {
    final res = await _api.post('', data: {'name': name});
    return Contact.fromJson(res.data);
  }

  Future deleteContact(String id) => _api.delete(id);
}

class ContactsSocketApi {
  ContactsSocketApi()
      : _api = WebSocketChannel.connect(
            Uri.parse('ws://192.168.1.106:8001/contacts-ws/'));

  final WebSocketChannel _api;

  Stream<List<Contact>> get stream => _api.stream.map<List<Contact>>((data) {
        final decoded = json.decode(data);
        return (decoded as List).map((json) => Contact.fromJson(json)).toList();
      });
}
