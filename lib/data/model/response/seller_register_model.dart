class SellerRegisterModel {
  String email;
  String password;
  String fName;
  String lName;
  String phone;
  String shopName;
  String shopAddress;
  String paymentMethodId;
  String bankName;
  String holderName;
  String accountNo;
  String idCard;
  String logo;
  String banner;
  String profileImage;

  SellerRegisterModel({
    this.email,
    this.password,
    this.fName,
    this.lName,
    this.phone,
    this.shopName,
    this.paymentMethodId,
    this.shopAddress,
    this.holderName,
    this.bankName,
    this.accountNo,
    this.idCard,
    this.logo,
    this.banner,
    this.profileImage,
  });

  SellerRegisterModel.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    password = json['password'];
    fName = json['f_name'];
    lName = json['l_name'];
    phone = json['phone'];
    shopName = json['shop_name'];
    shopAddress = json['shop_address'];
    bankName = json['bank_name'];
    holderName = json['holder_name'];
    paymentMethodId = json['payment_method_id'];
    accountNo = json['account_no'];
    idCard = json['passport_image'];
    logo = json['logo'];
    banner = json['banner'];
    profileImage = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['password'] = this.password;
    data['f_name'] = this.fName;
    data['l_name'] = this.lName;
    data['shop_name'] = this.shopName;
    data['phone'] = this.phone;
    data['shop_address'] = this.shopAddress;
    data['payment_method_id'] = this.paymentMethodId;
    data['holder_name'] = this.holderName;
    data['bank_name'] = this.bankName;
    data['account_no'] = this.accountNo;
    data['passport_image'] = this.idCard;
    data['logo'] = this.logo;
    data['banner'] = this.banner;
    data['image'] = this.profileImage;
    return data;
  }
}
