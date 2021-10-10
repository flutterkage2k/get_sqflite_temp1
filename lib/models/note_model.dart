class Note {
  int? id;
  String? title;
  String? dec;
  DateTime? date;
  int? status;

  Note({this.title, this.dec, this.date, this.status});
  Note.withId({this.id, this.title, this.dec, this.date, this.status});

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();

    if (id != null) {
      map['id'] = id;
    }

    map['title'] = title;
    map['dec'] = dec;
    map['date'] = date!.toIso8601String();
    map['status'] = status;
    return map;
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note.withId(
      id: map['id'],
      title: map['title'],
      dec: map['dec'],
      date: DateTime.parse(map['date']),
      status: map['status'],
    );
  }
}
