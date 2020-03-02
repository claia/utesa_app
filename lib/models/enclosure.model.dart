// To parse this JSON data, do
//
class EnclosureModel {
  int addressesId;
  String name;

  EnclosureModel({
    this.addressesId,
    this.name,
  });

  factory EnclosureModel.fromJson(Map<String, dynamic> json) => EnclosureModel(
        addressesId: json["addressesId"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "addressesId": addressesId,
        "name": name,
      };
}
