class Reader {
  Reader(
    this.id,
    this.fullname,
    this.address,
    this.dob,
    this.phoneNumber,
    this.creationDate,
    this.expirationDate,
  );

  String id;
  String fullname;
  String dob;
  String address;
  String phoneNumber;
  DateTime creationDate;
  DateTime expirationDate;
}
