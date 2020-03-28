class User {
  String name;
  String email;
  String phone;
  double lat;
  double lng;
  String fcmKey;
  int quarantineDate;
  List _quarantineEntries = [];

  List get quarantineEntries => _quarantineEntries;

  User(this.name,this.email, this.fcmKey, this.lat,
      this.lng, this.phone, this.quarantineDate);

  User.fromJson(Map<String, dynamic> data) {
    this.name = data['name'];
    this.email = data['email'];
    this.phone = data['phone'];
    this.lat = double.parse(data['lat']);
    this.lng = double.parse(data['lng']);
    this.fcmKey = data['fcm_key'];
    final parsedDate = DateTime.parse(data['quarantine_date']).millisecondsSinceEpoch / 1000;
    this.quarantineDate = parsedDate.toInt();
    data['verifications'].forEach((k, v) => this._quarantineEntries.add(v));
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'lat': this.lat,
      'lng': this.lng,
      'fcm_key': this.fcmKey,
      'quarantine_date': this.quarantineDate,
    };
  }
}
