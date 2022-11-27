class PaymentMethodModel {
  int id;
  String name;
  String accountName;
  String accountNumber;
  String image;
  PaymentMethodModel({
    this.id,
    this.name,
    this.accountName,
    this.accountNumber,
  });

  PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['account_name'] = this.accountName;
    data['account_number'] = this.accountNumber;
    data['image'] = this.image;

    return data;
  }
}
