class Contact {
  Contact._(this.id, this.name, this.initials);

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
