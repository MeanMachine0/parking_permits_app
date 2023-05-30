import 'dart:convert';

PermitsModel permitsModelFromJson(String str) =>
    PermitsModel.fromJson(json.decode(str));

String permitsModelToJson(PermitsModel data) => json.encode(data.toJson());

class PermitsModel {
  String type;
  int id;
  String permitNumber;
  String permitType;
  String applicantTitle;
  String applicantFirstNames;
  String applicantSurname;
  dynamic businessName;
  String personalReference;
  List<String> vehicleVrms;
  DateTime startDate;
  DateTime expiryDate;
  dynamic cancellationDate;
  bool canCancel;
  bool canCancelOnPublicSite;
  bool canRenew;
  bool isExpired;
  bool showVehicle;
  bool usesSalaryPercentage;
  String status;
  DateTime statusDate;
  String externalPermitReference;
  dynamic licencePermitNumber;
  bool hasPaymentSchedule;
  bool directDebit;
  double balanceLeftToPay;
  double instalmentPaymentsOverdue;
  bool cardPaymentsAllowed;
  bool reasonRequired;
  bool recurringPaymentRequired;

  PermitsModel({
    required this.type,
    required this.id,
    required this.permitNumber,
    required this.permitType,
    required this.applicantTitle,
    required this.applicantFirstNames,
    required this.applicantSurname,
    this.businessName,
    required this.personalReference,
    required this.vehicleVrms,
    required this.startDate,
    required this.expiryDate,
    this.cancellationDate,
    required this.canCancel,
    required this.canCancelOnPublicSite,
    required this.canRenew,
    required this.isExpired,
    required this.showVehicle,
    required this.usesSalaryPercentage,
    required this.status,
    required this.statusDate,
    required this.externalPermitReference,
    this.licencePermitNumber,
    required this.hasPaymentSchedule,
    required this.directDebit,
    required this.balanceLeftToPay,
    required this.instalmentPaymentsOverdue,
    required this.cardPaymentsAllowed,
    required this.reasonRequired,
    required this.recurringPaymentRequired,
  });

  factory PermitsModel.fromJson(Map<String, dynamic> json) => PermitsModel(
        type: json["\u0024type"],
        id: json["id"],
        permitNumber: json["permitNumber"],
        permitType: json["permitType"],
        applicantTitle: json["applicantTitle"],
        applicantFirstNames: json["applicantFirstNames"],
        applicantSurname: json["applicantSurname"],
        businessName: json["businessName"],
        personalReference: json["personalReference"],
        vehicleVrms: List<String>.from(json["vehicleVrms"].map((x) => x)),
        startDate: DateTime.parse(json["startDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        cancellationDate: json["cancellationDate"],
        canCancel: json["canCancel"],
        canCancelOnPublicSite: json["canCancelOnPublicSite"],
        canRenew: json["canRenew"],
        isExpired: json["isExpired"],
        showVehicle: json["showVehicle"],
        usesSalaryPercentage: json["usesSalaryPercentage"],
        status: json["status"],
        statusDate: DateTime.parse(json["statusDate"]),
        externalPermitReference: json["externalPermitReference"],
        licencePermitNumber: json["licencePermitNumber"],
        hasPaymentSchedule: json["hasPaymentSchedule"],
        directDebit: json["directDebit"],
        balanceLeftToPay: json["balanceLeftToPay"],
        instalmentPaymentsOverdue: json["instalmentPaymentsOverdue"],
        cardPaymentsAllowed: json["cardPaymentsAllowed"],
        reasonRequired: json["reasonRequired"],
        recurringPaymentRequired: json["recurringPaymentRequired"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "permitNumber": permitNumber,
        "permitType": permitType,
        "applicantTitle": applicantTitle,
        "applicantFirstNames": applicantFirstNames,
        "applicantSurname": applicantSurname,
        "businessName": businessName,
        "personalReference": personalReference,
        "vehicleVrms": List<dynamic>.from(vehicleVrms.map((x) => x)),
        "startDate": startDate.toIso8601String(),
        "expiryDate": expiryDate.toIso8601String(),
        "cancellationDate": cancellationDate,
        "canCancel": canCancel,
        "canCancelOnPublicSite": canCancelOnPublicSite,
        "canRenew": canRenew,
        "isExpired": isExpired,
        "showVehicle": showVehicle,
        "usesSalaryPercentage": usesSalaryPercentage,
        "status": status,
        "statusDate": statusDate.toIso8601String(),
        "externalPermitReference": externalPermitReference,
        "licencePermitNumber": licencePermitNumber,
        "hasPaymentSchedule": hasPaymentSchedule,
        "directDebit": directDebit,
        "balanceLeftToPay": balanceLeftToPay,
        "instalmentPaymentsOverdue": instalmentPaymentsOverdue,
        "cardPaymentsAllowed": cardPaymentsAllowed,
        "reasonRequired": reasonRequired,
        "recurringPaymentRequired": recurringPaymentRequired,
      };
}
