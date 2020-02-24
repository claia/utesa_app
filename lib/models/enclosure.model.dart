// To parse this JSON data, do
//
class Enclosure {
  int addressesId;
  String name;

  Enclosure({
    this.addressesId,
    this.name,
  });

  factory Enclosure.fromJson(Map<String, dynamic> json) => Enclosure(
        addressesId: json["addressesId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "addressesId": addressesId,
        "name": name,
      };
}
