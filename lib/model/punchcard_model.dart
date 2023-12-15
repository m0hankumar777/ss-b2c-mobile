
import 'dart:convert';

List<PunchCardModel> punchCardModelFromJson(String str) => List<PunchCardModel>.from(json.decode(str).map((x) => PunchCardModel.fromJson(x)));

String punchCardModelToJson(List<PunchCardModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class PunchCardModel {
    String name;
    String imageUrl;
    String address;
    String mobileNo;
    int totalPunchCardSum;
    int totalPunchCardDoneSum;
    int businessId;
    List<PunchCard> punchCards;

    PunchCardModel({
        required this.name,
        required this.imageUrl,
        required this.address,
        required this.mobileNo,
        required this.totalPunchCardSum,
        required this.totalPunchCardDoneSum,
        required this.businessId,
        required this.punchCards,
    });

    factory PunchCardModel.fromJson(Map<String, dynamic> json) => PunchCardModel(
        name: json["Name"],
        imageUrl: json["ImageUrl"],
        address: json["Address"],
        mobileNo: json["MobileNo"],
        totalPunchCardSum: json["TotalPunchCardSum"],
        totalPunchCardDoneSum: json["TotalPunchCardDoneSum"],
        businessId: json["BusinessId"],
        punchCards: List<PunchCard>.from(json["punchCards"].map((x) => PunchCard.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "Name": name,
        "ImageUrl": imageUrl,
        "Address": address,
        "MobileNo": mobileNo,
        "TotalPunchCardSum": totalPunchCardSum,
        "TotalPunchCardDoneSum": totalPunchCardDoneSum,
        "BusinessId": businessId,
        "punchCards": List<dynamic>.from(punchCards.map((x) => x.toJson())),
    };
}

class PunchCard {
    int id;
    int totalPunchCard;
    int totalPunchCardDone;
    DateTime expiryDate;
    String serviceName;
    String serviceNameH;
    dynamic price;
    CustomProperties customProperties;

    PunchCard({
        required this.id,
        required this.totalPunchCard,
        required this.totalPunchCardDone,
        required this.expiryDate,
        required this.serviceName,
        required this.serviceNameH,
        required this.price,
        required this.customProperties,
    });

    factory PunchCard.fromJson(Map<String, dynamic> json) => PunchCard(
        id: json["Id"],
        totalPunchCard: json["TotalPunchCard"],
        totalPunchCardDone: json["TotalPunchCardDone"],
        expiryDate: DateTime.parse(json["ExpiryDate"]),
        serviceName: json["ServiceName"],
        serviceNameH: json["ServiceNameH"],
        price: json["Price"],
        customProperties: CustomProperties.fromJson(json["CustomProperties"]),
    );

    Map<String, dynamic> toJson() => {
        "Id": id,
        "TotalPunchCard": totalPunchCard,
        "TotalPunchCardDone": totalPunchCardDone,
        "ExpiryDate": expiryDate.toIso8601String(),
        "ServiceName": serviceName,
        "ServiceNameH": serviceNameH,
        "Price": price,
        "CustomProperties": customProperties.toJson(),
    };
}

class CustomProperties {
    CustomProperties();

    factory CustomProperties.fromJson(Map<String, dynamic> json) => CustomProperties(
    );

    Map<String, dynamic> toJson() => {
    };
}
