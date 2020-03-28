class User {
  String name;
  String email;
  String phone;
  double lat;
  double lng;
  String fcmKey;
  int quarantineDate;

  User(this.name,this.email, this.fcmKey, this.lat,
      this.lng, this.phone, this.quarantineDate);

  User.fromJson(Map<String, dynamic> data) {
    this.name = data['name'];
    this.email = data['email'];
    this.phone = data['phone'];
    this.lat = data['lat'];
    this.lng = data['lng'];
    this.fcmKey = data['fcm_key'];
    this.quarantineDate = data['quaranthine_date'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'email': this.email,
      'phone': this.phone,
      'lat': this.lat,
      'lng': this.lng,
      'fcm_key': this.fcmKey,
      'quaranthine_date': this.quarantineDate,
    };
  }
}
