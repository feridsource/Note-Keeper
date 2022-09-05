class MyNote {
  String key;
  String email;
  String anote;
  String time;

  MyNote(this.key, this.email, this.anote, this.time);

  factory MyNote.fromJson(String key, Map<dynamic, dynamic> json) {
    return MyNote(key, json["email"] as String,
        json["anote"] as String, json["time"] as String);
  }
}