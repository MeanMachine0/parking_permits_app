import 'dart:convert';

PermitModel permitModelFromJson(String str) =>
    PermitModel.fromJson(json.decode(str));

String permitModelToJson(PermitModel data) => json.encode(data.toJson());

class PermitModel {
  String type;
  int id;
  String status;
  DateTime statusDate;
  String previousPermitNumber;
  String renewedPermitNumber;
  String applicationNumber;
  String permitTypeName;
  DateTime issueDate;
  DateTime startDate;
  DateTime expiryDate;
  bool isCancelled;
  bool isExpired;
  bool isSuspended;
  dynamic cancellationDate;
  dynamic cancellationReason;
  double cost;
  double amountOwing;
  double amountPaid;
  double amountOverpaid;
  double amountCancelled;
  double amountWrittenOff;
  double amountRefunded;
  dynamic paymentOrigin;
  double income;
  bool canCancel;
  bool canCancelOnPublicSite;
  bool canRenew;
  bool canSuspend;
  bool canReinstate;
  List<dynamic> questionResponses;
  List<dynamic> answers;
  Applicant applicant;
  List<Vehicle> vehicles;
  dynamic applicationPin;
  dynamic permitPin;
  bool showOnPublicSite;
  bool vehicleEditable;
  bool vehicleVrmEditOnly;
  bool personalDetailsEditable;
  bool personalReferenceRequired;
  bool addressDetailsEditable;
  Ops options;
  dynamic voucherSmartiPin;
  dynamic transactions;
  dynamic refundOrigin;
  dynamic refundMaxAmount;
  dynamic issueFeeMessage;
  dynamic vehicleChangeDate;
  dynamic vehicleChangeRestrictedUntilDate;
  dynamic vehicleChangedFromVrm;
  double additionalCharge;
  dynamic refund;
  bool legacyPermitType;
  dynamic legacyPermitNumber;
  bool allowsExternalReferences;
  int maxReferenceBooks;
  int noReferencesPerBook;
  dynamic originalExpiryDate;
  bool hasCoupons;
  String permitNumber;
  bool changeProofRequired;
  String vehicleSummaryHelpText;
  String vehicleSummaryHelpUrl;
  dynamic vehicleKeeperNameHelpText;
  dynamic vehicleKeeperNameHelpUrl;
  bool reissueAllowed;
  dynamic suspendFromDate;
  dynamic suspendToDate;
  bool applicationProofRequired;
  bool renewalProofRequired;
  int issueNumber;
  bool doNotSendReminder;
  bool doNotSendExportToHh;
  dynamic maxExtensionDays;
  String parkingZoneCategoryName;
  dynamic paymentScheduleMessage;
  dynamic paymentScheduleCancellationMessage;
  double instalmentPaymentsOverdue;
  dynamic balanceLeftToPay;
  bool directDebit;
  dynamic ddiMandateReference;
  bool cardPaymentsAllowed;
  bool vouchersEnabled;
  bool recurringPaymentRequired;
  bool pointScoreProofRequired;
  bool dateOfBirthRequired;
  bool blueBadgeRequired;
  PermitModelAddress address;
  bool addressDetailsCaptured;
  bool applicantDetailsCaptured;
  dynamic business;
  bool businessDetailsCaptured;
  List<dynamic> documents;
  List<PermitTypeProofDocumentCategory> permitTypeProofDocumentCategories;
  String periodName;
  dynamic calendarItemName;
  bool questionResponsesCaptured;
  bool proofDocumentsCaptured;
  bool vehicleColourCaptured;
  bool vehicleCylinderCapacityCaptured;
  bool vehicleDetailsCaptured;
  bool vehicleEmissionsCaptured;
  bool vehicleEmissionsRequired;
  bool vehicleFirstRegisteredCaptured;
  bool vehicleFuelTypeCaptured;
  bool vehicleHeightCaptured;
  bool vehicleLengthCaptured;
  bool vehicleMakeCaptured;
  bool vehicleModelCaptured;
  bool vehicleNumberOfSeatsCaptured;
  bool vehicleGrossWeightCaptured;
  bool vehicleKerbWeightCaptured;
  bool vehicleUnladenWeightCaptured;
  bool vehicleWidthCaptured;
  bool vehicleGrossWeightRequired;
  bool vehicleKerbWeightRequired;
  bool vehicleUnladenWeightRequired;
  bool vehicleWidthRequired;
  bool vehicleKeeperFullNameCaptured;
  bool vehicleKnownAsCaptured;
  bool vehicleEuroStatusCaptured;
  bool vehicleCategoryCaptured;
  dynamic eventLogs;
  List<Payment> payments;
  List<String> parkingZones;
  dynamic memos;
  dynamic orgHigherLevelLabel;
  dynamic orgDepartmentLevelLabel;
  dynamic orgHigherLevelName;
  dynamic orgDepartmentLevelName;
  bool organisationDetailsCaptured;
  bool allowsAppeal;
  Account account;
  bool salaryDeduction;
  dynamic salaryPercentageApplied;
  dynamic correspondence;
  dynamic licencePermitId;
  dynamic licencePermitNumber;
  bool hasPaymentSchedule;

  PermitModel({
    required this.type,
    required this.id,
    required this.status,
    required this.statusDate,
    required this.previousPermitNumber,
    required this.renewedPermitNumber,
    required this.applicationNumber,
    required this.permitTypeName,
    required this.issueDate,
    required this.startDate,
    required this.expiryDate,
    required this.isCancelled,
    required this.isExpired,
    required this.isSuspended,
    this.cancellationDate,
    this.cancellationReason,
    required this.cost,
    required this.amountOwing,
    required this.amountPaid,
    required this.amountOverpaid,
    required this.amountCancelled,
    required this.amountWrittenOff,
    required this.amountRefunded,
    this.paymentOrigin,
    required this.income,
    required this.canCancel,
    required this.canCancelOnPublicSite,
    required this.canRenew,
    required this.canSuspend,
    required this.canReinstate,
    required this.questionResponses,
    required this.answers,
    required this.applicant,
    required this.vehicles,
    this.applicationPin,
    this.permitPin,
    required this.showOnPublicSite,
    required this.vehicleEditable,
    required this.vehicleVrmEditOnly,
    required this.personalDetailsEditable,
    required this.personalReferenceRequired,
    required this.addressDetailsEditable,
    required this.options,
    this.voucherSmartiPin,
    this.transactions,
    this.refundOrigin,
    this.refundMaxAmount,
    this.issueFeeMessage,
    this.vehicleChangeDate,
    this.vehicleChangeRestrictedUntilDate,
    this.vehicleChangedFromVrm,
    required this.additionalCharge,
    this.refund,
    required this.legacyPermitType,
    this.legacyPermitNumber,
    required this.allowsExternalReferences,
    required this.maxReferenceBooks,
    required this.noReferencesPerBook,
    this.originalExpiryDate,
    required this.hasCoupons,
    required this.permitNumber,
    required this.changeProofRequired,
    required this.vehicleSummaryHelpText,
    required this.vehicleSummaryHelpUrl,
    this.vehicleKeeperNameHelpText,
    this.vehicleKeeperNameHelpUrl,
    required this.reissueAllowed,
    this.suspendFromDate,
    this.suspendToDate,
    required this.applicationProofRequired,
    required this.renewalProofRequired,
    required this.issueNumber,
    required this.doNotSendReminder,
    required this.doNotSendExportToHh,
    this.maxExtensionDays,
    required this.parkingZoneCategoryName,
    this.paymentScheduleMessage,
    this.paymentScheduleCancellationMessage,
    required this.instalmentPaymentsOverdue,
    this.balanceLeftToPay,
    required this.directDebit,
    this.ddiMandateReference,
    required this.cardPaymentsAllowed,
    required this.vouchersEnabled,
    required this.recurringPaymentRequired,
    required this.pointScoreProofRequired,
    required this.dateOfBirthRequired,
    required this.blueBadgeRequired,
    required this.address,
    required this.addressDetailsCaptured,
    required this.applicantDetailsCaptured,
    this.business,
    required this.businessDetailsCaptured,
    required this.documents,
    required this.permitTypeProofDocumentCategories,
    required this.periodName,
    this.calendarItemName,
    required this.questionResponsesCaptured,
    required this.proofDocumentsCaptured,
    required this.vehicleColourCaptured,
    required this.vehicleCylinderCapacityCaptured,
    required this.vehicleDetailsCaptured,
    required this.vehicleEmissionsCaptured,
    required this.vehicleEmissionsRequired,
    required this.vehicleFirstRegisteredCaptured,
    required this.vehicleFuelTypeCaptured,
    required this.vehicleHeightCaptured,
    required this.vehicleLengthCaptured,
    required this.vehicleMakeCaptured,
    required this.vehicleModelCaptured,
    required this.vehicleNumberOfSeatsCaptured,
    required this.vehicleGrossWeightCaptured,
    required this.vehicleKerbWeightCaptured,
    required this.vehicleUnladenWeightCaptured,
    required this.vehicleWidthCaptured,
    required this.vehicleGrossWeightRequired,
    required this.vehicleKerbWeightRequired,
    required this.vehicleUnladenWeightRequired,
    required this.vehicleWidthRequired,
    required this.vehicleKeeperFullNameCaptured,
    required this.vehicleKnownAsCaptured,
    required this.vehicleEuroStatusCaptured,
    required this.vehicleCategoryCaptured,
    this.eventLogs,
    required this.payments,
    required this.parkingZones,
    this.memos,
    this.orgHigherLevelLabel,
    this.orgDepartmentLevelLabel,
    this.orgHigherLevelName,
    this.orgDepartmentLevelName,
    required this.organisationDetailsCaptured,
    required this.allowsAppeal,
    required this.account,
    required this.salaryDeduction,
    this.salaryPercentageApplied,
    this.correspondence,
    this.licencePermitId,
    this.licencePermitNumber,
    required this.hasPaymentSchedule,
  });

  factory PermitModel.fromJson(Map<String, dynamic> json) => PermitModel(
        type: json["\u0024type"],
        id: json["id"],
        status: json["status"],
        statusDate: DateTime.parse(json["statusDate"]),
        previousPermitNumber: json["previousPermitNumber"],
        renewedPermitNumber: json["renewedPermitNumber"],
        applicationNumber: json["applicationNumber"],
        permitTypeName: json["permitTypeName"],
        issueDate: DateTime.parse(json["issueDate"]),
        startDate: DateTime.parse(json["startDate"]),
        expiryDate: DateTime.parse(json["expiryDate"]),
        isCancelled: json["isCancelled"],
        isExpired: json["isExpired"],
        isSuspended: json["isSuspended"],
        cancellationDate: json["cancellationDate"],
        cancellationReason: json["cancellationReason"],
        cost: json["cost"],
        amountOwing: json["amountOwing"],
        amountPaid: json["amountPaid"],
        amountOverpaid: json["amountOverpaid"],
        amountCancelled: json["amountCancelled"],
        amountWrittenOff: json["amountWrittenOff"],
        amountRefunded: json["amountRefunded"],
        paymentOrigin: json["paymentOrigin"],
        income: json["income"],
        canCancel: json["canCancel"],
        canCancelOnPublicSite: json["canCancelOnPublicSite"],
        canRenew: json["canRenew"],
        canSuspend: json["canSuspend"],
        canReinstate: json["canReinstate"],
        questionResponses:
            List<dynamic>.from(json["questionResponses"].map((x) => x)),
        answers: List<dynamic>.from(json["answers"].map((x) => x)),
        applicant: Applicant.fromJson(json["applicant"]),
        vehicles: List<Vehicle>.from(
            json["vehicles"].map((x) => Vehicle.fromJson(x))),
        applicationPin: json["applicationPin"],
        permitPin: json["permitPin"],
        showOnPublicSite: json["showOnPublicSite"],
        vehicleEditable: json["vehicleEditable"],
        vehicleVrmEditOnly: json["vehicleVrmEditOnly"],
        personalDetailsEditable: json["personalDetailsEditable"],
        personalReferenceRequired: json["personalReferenceRequired"],
        addressDetailsEditable: json["addressDetailsEditable"],
        options: Ops.fromJson(json["options"]),
        voucherSmartiPin: json["voucherSmartiPin"],
        transactions: json["transactions"],
        refundOrigin: json["refundOrigin"],
        refundMaxAmount: json["refundMaxAmount"],
        issueFeeMessage: json["issueFeeMessage"],
        vehicleChangeDate: json["vehicleChangeDate"],
        vehicleChangeRestrictedUntilDate:
            json["vehicleChangeRestrictedUntilDate"],
        vehicleChangedFromVrm: json["vehicleChangedFromVRM"],
        additionalCharge: json["additionalCharge"],
        refund: json["refund"],
        legacyPermitType: json["legacyPermitType"],
        legacyPermitNumber: json["legacyPermitNumber"],
        allowsExternalReferences: json["allowsExternalReferences"],
        maxReferenceBooks: json["maxReferenceBooks"],
        noReferencesPerBook: json["noReferencesPerBook"],
        originalExpiryDate: json["originalExpiryDate"],
        hasCoupons: json["hasCoupons"],
        permitNumber: json["permitNumber"],
        changeProofRequired: json["changeProofRequired"],
        vehicleSummaryHelpText: json["vehicleSummaryHelpText"],
        vehicleSummaryHelpUrl: json["vehicleSummaryHelpUrl"],
        vehicleKeeperNameHelpText: json["vehicleKeeperNameHelpText"],
        vehicleKeeperNameHelpUrl: json["vehicleKeeperNameHelpUrl"],
        reissueAllowed: json["reissueAllowed"],
        suspendFromDate: json["suspendFromDate"],
        suspendToDate: json["suspendToDate"],
        applicationProofRequired: json["applicationProofRequired"],
        renewalProofRequired: json["renewalProofRequired"],
        issueNumber: json["issueNumber"],
        doNotSendReminder: json["doNotSendReminder"],
        doNotSendExportToHh: json["doNotSendExportToHH"],
        maxExtensionDays: json["maxExtensionDays"],
        parkingZoneCategoryName: json["parkingZoneCategoryName"],
        paymentScheduleMessage: json["paymentScheduleMessage"],
        paymentScheduleCancellationMessage:
            json["paymentScheduleCancellationMessage"],
        instalmentPaymentsOverdue: json["instalmentPaymentsOverdue"],
        balanceLeftToPay: json["balanceLeftToPay"],
        directDebit: json["directDebit"],
        ddiMandateReference: json["ddiMandateReference"],
        cardPaymentsAllowed: json["cardPaymentsAllowed"],
        vouchersEnabled: json["vouchersEnabled"],
        recurringPaymentRequired: json["recurringPaymentRequired"],
        pointScoreProofRequired: json["pointScoreProofRequired"],
        dateOfBirthRequired: json["dateOfBirthRequired"],
        blueBadgeRequired: json["blueBadgeRequired"],
        address: PermitModelAddress.fromJson(json["address"]),
        addressDetailsCaptured: json["addressDetailsCaptured"],
        applicantDetailsCaptured: json["applicantDetailsCaptured"],
        business: json["business"],
        businessDetailsCaptured: json["businessDetailsCaptured"],
        documents: List<dynamic>.from(json["documents"].map((x) => x)),
        permitTypeProofDocumentCategories:
            List<PermitTypeProofDocumentCategory>.from(
                json["permitTypeProofDocumentCategories"]
                    .map((x) => PermitTypeProofDocumentCategory.fromJson(x))),
        periodName: json["periodName"],
        calendarItemName: json["calendarItemName"],
        questionResponsesCaptured: json["questionResponsesCaptured"],
        proofDocumentsCaptured: json["proofDocumentsCaptured"],
        vehicleColourCaptured: json["vehicleColourCaptured"],
        vehicleCylinderCapacityCaptured:
            json["vehicleCylinderCapacityCaptured"],
        vehicleDetailsCaptured: json["vehicleDetailsCaptured"],
        vehicleEmissionsCaptured: json["vehicleEmissionsCaptured"],
        vehicleEmissionsRequired: json["vehicleEmissionsRequired"],
        vehicleFirstRegisteredCaptured: json["vehicleFirstRegisteredCaptured"],
        vehicleFuelTypeCaptured: json["vehicleFuelTypeCaptured"],
        vehicleHeightCaptured: json["vehicleHeightCaptured"],
        vehicleLengthCaptured: json["vehicleLengthCaptured"],
        vehicleMakeCaptured: json["vehicleMakeCaptured"],
        vehicleModelCaptured: json["vehicleModelCaptured"],
        vehicleNumberOfSeatsCaptured: json["vehicleNumberOfSeatsCaptured"],
        vehicleGrossWeightCaptured: json["vehicleGrossWeightCaptured"],
        vehicleKerbWeightCaptured: json["vehicleKerbWeightCaptured"],
        vehicleUnladenWeightCaptured: json["vehicleUnladenWeightCaptured"],
        vehicleWidthCaptured: json["vehicleWidthCaptured"],
        vehicleGrossWeightRequired: json["vehicleGrossWeightRequired"],
        vehicleKerbWeightRequired: json["vehicleKerbWeightRequired"],
        vehicleUnladenWeightRequired: json["vehicleUnladenWeightRequired"],
        vehicleWidthRequired: json["vehicleWidthRequired"],
        vehicleKeeperFullNameCaptured: json["vehicleKeeperFullNameCaptured"],
        vehicleKnownAsCaptured: json["vehicleKnownAsCaptured"],
        vehicleEuroStatusCaptured: json["vehicleEuroStatusCaptured"],
        vehicleCategoryCaptured: json["vehicleCategoryCaptured"],
        eventLogs: json["eventLogs"],
        payments: List<Payment>.from(
            json["payments"].map((x) => Payment.fromJson(x))),
        parkingZones: List<String>.from(json["parkingZones"].map((x) => x)),
        memos: json["memos"],
        orgHigherLevelLabel: json["orgHigherLevelLabel"],
        orgDepartmentLevelLabel: json["orgDepartmentLevelLabel"],
        orgHigherLevelName: json["orgHigherLevelName"],
        orgDepartmentLevelName: json["orgDepartmentLevelName"],
        organisationDetailsCaptured: json["organisationDetailsCaptured"],
        allowsAppeal: json["allowsAppeal"],
        account: Account.fromJson(json["account"]),
        salaryDeduction: json["salaryDeduction"],
        salaryPercentageApplied: json["salaryPercentageApplied"],
        correspondence: json["correspondence"],
        licencePermitId: json["licencePermitId"],
        licencePermitNumber: json["licencePermitNumber"],
        hasPaymentSchedule: json["hasPaymentSchedule"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "status": status,
        "statusDate": statusDate.toIso8601String(),
        "previousPermitNumber": previousPermitNumber,
        "renewedPermitNumber": renewedPermitNumber,
        "applicationNumber": applicationNumber,
        "permitTypeName": permitTypeName,
        "issueDate": issueDate.toIso8601String(),
        "startDate": startDate.toIso8601String(),
        "expiryDate": expiryDate.toIso8601String(),
        "isCancelled": isCancelled,
        "isExpired": isExpired,
        "isSuspended": isSuspended,
        "cancellationDate": cancellationDate,
        "cancellationReason": cancellationReason,
        "cost": cost,
        "amountOwing": amountOwing,
        "amountPaid": amountPaid,
        "amountOverpaid": amountOverpaid,
        "amountCancelled": amountCancelled,
        "amountWrittenOff": amountWrittenOff,
        "amountRefunded": amountRefunded,
        "paymentOrigin": paymentOrigin,
        "income": income,
        "canCancel": canCancel,
        "canCancelOnPublicSite": canCancelOnPublicSite,
        "canRenew": canRenew,
        "canSuspend": canSuspend,
        "canReinstate": canReinstate,
        "questionResponses":
            List<dynamic>.from(questionResponses.map((x) => x)),
        "answers": List<dynamic>.from(answers.map((x) => x)),
        "applicant": applicant.toJson(),
        "vehicles": List<dynamic>.from(vehicles.map((x) => x.toJson())),
        "applicationPin": applicationPin,
        "permitPin": permitPin,
        "showOnPublicSite": showOnPublicSite,
        "vehicleEditable": vehicleEditable,
        "vehicleVrmEditOnly": vehicleVrmEditOnly,
        "personalDetailsEditable": personalDetailsEditable,
        "personalReferenceRequired": personalReferenceRequired,
        "addressDetailsEditable": addressDetailsEditable,
        "options": options.toJson(),
        "voucherSmartiPin": voucherSmartiPin,
        "transactions": transactions,
        "refundOrigin": refundOrigin,
        "refundMaxAmount": refundMaxAmount,
        "issueFeeMessage": issueFeeMessage,
        "vehicleChangeDate": vehicleChangeDate,
        "vehicleChangeRestrictedUntilDate": vehicleChangeRestrictedUntilDate,
        "vehicleChangedFromVRM": vehicleChangedFromVrm,
        "additionalCharge": additionalCharge,
        "refund": refund,
        "legacyPermitType": legacyPermitType,
        "legacyPermitNumber": legacyPermitNumber,
        "allowsExternalReferences": allowsExternalReferences,
        "maxReferenceBooks": maxReferenceBooks,
        "noReferencesPerBook": noReferencesPerBook,
        "originalExpiryDate": originalExpiryDate,
        "hasCoupons": hasCoupons,
        "permitNumber": permitNumber,
        "changeProofRequired": changeProofRequired,
        "vehicleSummaryHelpText": vehicleSummaryHelpText,
        "vehicleSummaryHelpUrl": vehicleSummaryHelpUrl,
        "vehicleKeeperNameHelpText": vehicleKeeperNameHelpText,
        "vehicleKeeperNameHelpUrl": vehicleKeeperNameHelpUrl,
        "reissueAllowed": reissueAllowed,
        "suspendFromDate": suspendFromDate,
        "suspendToDate": suspendToDate,
        "applicationProofRequired": applicationProofRequired,
        "renewalProofRequired": renewalProofRequired,
        "issueNumber": issueNumber,
        "doNotSendReminder": doNotSendReminder,
        "doNotSendExportToHH": doNotSendExportToHh,
        "maxExtensionDays": maxExtensionDays,
        "parkingZoneCategoryName": parkingZoneCategoryName,
        "paymentScheduleMessage": paymentScheduleMessage,
        "paymentScheduleCancellationMessage":
            paymentScheduleCancellationMessage,
        "instalmentPaymentsOverdue": instalmentPaymentsOverdue,
        "balanceLeftToPay": balanceLeftToPay,
        "directDebit": directDebit,
        "ddiMandateReference": ddiMandateReference,
        "cardPaymentsAllowed": cardPaymentsAllowed,
        "vouchersEnabled": vouchersEnabled,
        "recurringPaymentRequired": recurringPaymentRequired,
        "pointScoreProofRequired": pointScoreProofRequired,
        "dateOfBirthRequired": dateOfBirthRequired,
        "blueBadgeRequired": blueBadgeRequired,
        "address": address.toJson(),
        "addressDetailsCaptured": addressDetailsCaptured,
        "applicantDetailsCaptured": applicantDetailsCaptured,
        "business": business,
        "businessDetailsCaptured": businessDetailsCaptured,
        "documents": List<dynamic>.from(documents.map((x) => x)),
        "permitTypeProofDocumentCategories": List<dynamic>.from(
            permitTypeProofDocumentCategories.map((x) => x.toJson())),
        "periodName": periodName,
        "calendarItemName": calendarItemName,
        "questionResponsesCaptured": questionResponsesCaptured,
        "proofDocumentsCaptured": proofDocumentsCaptured,
        "vehicleColourCaptured": vehicleColourCaptured,
        "vehicleCylinderCapacityCaptured": vehicleCylinderCapacityCaptured,
        "vehicleDetailsCaptured": vehicleDetailsCaptured,
        "vehicleEmissionsCaptured": vehicleEmissionsCaptured,
        "vehicleEmissionsRequired": vehicleEmissionsRequired,
        "vehicleFirstRegisteredCaptured": vehicleFirstRegisteredCaptured,
        "vehicleFuelTypeCaptured": vehicleFuelTypeCaptured,
        "vehicleHeightCaptured": vehicleHeightCaptured,
        "vehicleLengthCaptured": vehicleLengthCaptured,
        "vehicleMakeCaptured": vehicleMakeCaptured,
        "vehicleModelCaptured": vehicleModelCaptured,
        "vehicleNumberOfSeatsCaptured": vehicleNumberOfSeatsCaptured,
        "vehicleGrossWeightCaptured": vehicleGrossWeightCaptured,
        "vehicleKerbWeightCaptured": vehicleKerbWeightCaptured,
        "vehicleUnladenWeightCaptured": vehicleUnladenWeightCaptured,
        "vehicleWidthCaptured": vehicleWidthCaptured,
        "vehicleGrossWeightRequired": vehicleGrossWeightRequired,
        "vehicleKerbWeightRequired": vehicleKerbWeightRequired,
        "vehicleUnladenWeightRequired": vehicleUnladenWeightRequired,
        "vehicleWidthRequired": vehicleWidthRequired,
        "vehicleKeeperFullNameCaptured": vehicleKeeperFullNameCaptured,
        "vehicleKnownAsCaptured": vehicleKnownAsCaptured,
        "vehicleEuroStatusCaptured": vehicleEuroStatusCaptured,
        "vehicleCategoryCaptured": vehicleCategoryCaptured,
        "eventLogs": eventLogs,
        "payments": List<dynamic>.from(payments.map((x) => x.toJson())),
        "parkingZones": List<dynamic>.from(parkingZones.map((x) => x)),
        "memos": memos,
        "orgHigherLevelLabel": orgHigherLevelLabel,
        "orgDepartmentLevelLabel": orgDepartmentLevelLabel,
        "orgHigherLevelName": orgHigherLevelName,
        "orgDepartmentLevelName": orgDepartmentLevelName,
        "organisationDetailsCaptured": organisationDetailsCaptured,
        "allowsAppeal": allowsAppeal,
        "account": account.toJson(),
        "salaryDeduction": salaryDeduction,
        "salaryPercentageApplied": salaryPercentageApplied,
        "correspondence": correspondence,
        "licencePermitId": licencePermitId,
        "licencePermitNumber": licencePermitNumber,
        "hasPaymentSchedule": hasPaymentSchedule,
      };
}

class Account {
  String type;
  int id;
  String title;
  String forename;
  String initials;
  String surname;
  List<ContactMethod> contactMethods;
  int operatorAccountTypeId;
  dynamic businessName;
  dynamic departmentName;
  OperatorAccountType operatorAccountType;
  dynamic orgDepartmentLevelId;
  dynamic orgHigherLevelId;
  String personReference;
  dynamic dateOfBirth;
  dynamic blueBadges;
  List<AddressElement> addresses;
  bool customReminder;
  int customReminderDaysBefore;
  List<Member> members;
  dynamic externalAccountReference;
  List<dynamic> permitAccountBankDetails;
  dynamic publicLoginLockedUntil;

  Account({
    required this.type,
    required this.id,
    required this.title,
    required this.forename,
    required this.initials,
    required this.surname,
    required this.contactMethods,
    required this.operatorAccountTypeId,
    this.businessName,
    this.departmentName,
    required this.operatorAccountType,
    this.orgDepartmentLevelId,
    this.orgHigherLevelId,
    required this.personReference,
    this.dateOfBirth,
    this.blueBadges,
    required this.addresses,
    required this.customReminder,
    required this.customReminderDaysBefore,
    required this.members,
    this.externalAccountReference,
    required this.permitAccountBankDetails,
    this.publicLoginLockedUntil,
  });

  factory Account.fromJson(Map<String, dynamic> json) => Account(
        type: json["\u0024type"],
        id: json["id"],
        title: json["title"],
        forename: json["forename"],
        initials: json["initials"],
        surname: json["surname"],
        contactMethods: List<ContactMethod>.from(
            json["contactMethods"].map((x) => ContactMethod.fromJson(x))),
        operatorAccountTypeId: json["operatorAccountTypeId"],
        businessName: json["businessName"],
        departmentName: json["departmentName"],
        operatorAccountType:
            OperatorAccountType.fromJson(json["operatorAccountType"]),
        orgDepartmentLevelId: json["orgDepartmentLevelId"],
        orgHigherLevelId: json["orgHigherLevelId"],
        personReference: json["personReference"],
        dateOfBirth: json["dateOfBirth"],
        blueBadges: json["blueBadges"],
        addresses: List<AddressElement>.from(
            json["addresses"].map((x) => AddressElement.fromJson(x))),
        customReminder: json["customReminder"],
        customReminderDaysBefore: json["customReminderDaysBefore"],
        members:
            List<Member>.from(json["members"].map((x) => Member.fromJson(x))),
        externalAccountReference: json["externalAccountReference"],
        permitAccountBankDetails:
            List<dynamic>.from(json["permitAccountBankDetails"].map((x) => x)),
        publicLoginLockedUntil: json["publicLoginLockedUntil"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "title": title,
        "forename": forename,
        "initials": initials,
        "surname": surname,
        "contactMethods":
            List<dynamic>.from(contactMethods.map((x) => x.toJson())),
        "operatorAccountTypeId": operatorAccountTypeId,
        "businessName": businessName,
        "departmentName": departmentName,
        "operatorAccountType": operatorAccountType.toJson(),
        "orgDepartmentLevelId": orgDepartmentLevelId,
        "orgHigherLevelId": orgHigherLevelId,
        "personReference": personReference,
        "dateOfBirth": dateOfBirth,
        "blueBadges": blueBadges,
        "addresses": List<dynamic>.from(addresses.map((x) => x.toJson())),
        "customReminder": customReminder,
        "customReminderDaysBefore": customReminderDaysBefore,
        "members": List<dynamic>.from(members.map((x) => x.toJson())),
        "externalAccountReference": externalAccountReference,
        "permitAccountBankDetails":
            List<dynamic>.from(permitAccountBankDetails.map((x) => x)),
        "publicLoginLockedUntil": publicLoginLockedUntil,
      };
}

class AddressElement {
  String type;
  int id;
  String line1;
  String line2;
  String line3;
  String line4;
  String postcode;
  PafAddress pafAddress;
  int addressTypeId;
  bool isPrimary;
  bool isForCorresp;
  int operatorAccountAddressTypeId;

  AddressElement({
    required this.type,
    required this.id,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.line4,
    required this.postcode,
    required this.pafAddress,
    required this.addressTypeId,
    required this.isPrimary,
    required this.isForCorresp,
    required this.operatorAccountAddressTypeId,
  });

  factory AddressElement.fromJson(Map<String, dynamic> json) => AddressElement(
        type: json["\u0024type"],
        id: json["id"],
        line1: json["line1"],
        line2: json["line2"],
        line3: json["line3"],
        line4: json["line4"],
        postcode: json["postcode"],
        pafAddress: PafAddress.fromJson(json["pafAddress"]),
        addressTypeId: json["addressTypeId"],
        isPrimary: json["isPrimary"],
        isForCorresp: json["isForCorresp"],
        operatorAccountAddressTypeId: json["operatorAccountAddressTypeId"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "line1": line1,
        "line2": line2,
        "line3": line3,
        "line4": line4,
        "postcode": postcode,
        "pafAddress": pafAddress.toJson(),
        "addressTypeId": addressTypeId,
        "isPrimary": isPrimary,
        "isForCorresp": isForCorresp,
        "operatorAccountAddressTypeId": operatorAccountAddressTypeId,
      };
}

class PafAddress {
  String type;
  int id;
  String udprn;
  String subBuildingName;
  String buildingName;
  String buildingNumber;
  String departmentName;
  String organisationName;
  String poBoxNumber;
  String dependentThoroughfareName;
  dynamic dependentThoroughfareDescriptor;
  String thoroughfareName;
  dynamic thoroughfareDescriptor;
  String doubleDependentLocality;
  String dependentLocality;
  String postTown;
  dynamic county;
  String postcode;
  String uprn;
  String usrn;
  String origin;
  bool isActive;
  dynamic notes;
  dynamic lpi;
  dynamic blpuClass;
  dynamic businessOrResidentPermitsAllowed;

  PafAddress({
    required this.type,
    required this.id,
    required this.udprn,
    required this.subBuildingName,
    required this.buildingName,
    required this.buildingNumber,
    required this.departmentName,
    required this.organisationName,
    required this.poBoxNumber,
    required this.dependentThoroughfareName,
    this.dependentThoroughfareDescriptor,
    required this.thoroughfareName,
    this.thoroughfareDescriptor,
    required this.doubleDependentLocality,
    required this.dependentLocality,
    required this.postTown,
    this.county,
    required this.postcode,
    required this.uprn,
    required this.usrn,
    required this.origin,
    required this.isActive,
    this.notes,
    this.lpi,
    this.blpuClass,
    this.businessOrResidentPermitsAllowed,
  });

  factory PafAddress.fromJson(Map<String, dynamic> json) => PafAddress(
        type: json["\u0024type"],
        id: json["id"],
        udprn: json["udprn"],
        subBuildingName: json["subBuildingName"],
        buildingName: json["buildingName"],
        buildingNumber: json["buildingNumber"],
        departmentName: json["departmentName"],
        organisationName: json["organisationName"],
        poBoxNumber: json["poBoxNumber"],
        dependentThoroughfareName: json["dependentThoroughfareName"],
        dependentThoroughfareDescriptor:
            json["dependentThoroughfareDescriptor"],
        thoroughfareName: json["thoroughfareName"],
        thoroughfareDescriptor: json["thoroughfareDescriptor"],
        doubleDependentLocality: json["doubleDependentLocality"],
        dependentLocality: json["dependentLocality"],
        postTown: json["postTown"],
        county: json["county"],
        postcode: json["postcode"],
        uprn: json["uprn"],
        usrn: json["usrn"],
        origin: json["origin"],
        isActive: json["isActive"],
        notes: json["notes"],
        lpi: json["lpi"],
        blpuClass: json["blpuClass"],
        businessOrResidentPermitsAllowed:
            json["businessOrResidentPermitsAllowed"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "udprn": udprn,
        "subBuildingName": subBuildingName,
        "buildingName": buildingName,
        "buildingNumber": buildingNumber,
        "departmentName": departmentName,
        "organisationName": organisationName,
        "poBoxNumber": poBoxNumber,
        "dependentThoroughfareName": dependentThoroughfareName,
        "dependentThoroughfareDescriptor": dependentThoroughfareDescriptor,
        "thoroughfareName": thoroughfareName,
        "thoroughfareDescriptor": thoroughfareDescriptor,
        "doubleDependentLocality": doubleDependentLocality,
        "dependentLocality": dependentLocality,
        "postTown": postTown,
        "county": county,
        "postcode": postcode,
        "uprn": uprn,
        "usrn": usrn,
        "origin": origin,
        "isActive": isActive,
        "notes": notes,
        "lpi": lpi,
        "blpuClass": blpuClass,
        "businessOrResidentPermitsAllowed": businessOrResidentPermitsAllowed,
      };
}

class ContactMethod {
  String type;
  int contactMethodId;
  String details;
  bool isPrimary;
  String code;
  dynamic labelText;

  ContactMethod({
    required this.type,
    required this.contactMethodId,
    required this.details,
    required this.isPrimary,
    required this.code,
    this.labelText,
  });

  factory ContactMethod.fromJson(Map<String, dynamic> json) => ContactMethod(
        type: json["\u0024type"],
        contactMethodId: json["contactMethodId"],
        details: json["details"],
        isPrimary: json["isPrimary"],
        code: json["code"],
        labelText: json["labelText"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "contactMethodId": contactMethodId,
        "details": details,
        "isPrimary": isPrimary,
        "code": code,
        "labelText": labelText,
      };
}

class Member {
  String type;
  int id;
  bool accountHolder;
  bool active;
  String title;
  String forename;
  String surname;
  String initials;
  String personReference;
  dynamic dateOfBirth;

  Member({
    required this.type,
    required this.id,
    required this.accountHolder,
    required this.active,
    required this.title,
    required this.forename,
    required this.surname,
    required this.initials,
    required this.personReference,
    this.dateOfBirth,
  });

  factory Member.fromJson(Map<String, dynamic> json) => Member(
        type: json["\u0024type"],
        id: json["id"],
        accountHolder: json["accountHolder"],
        active: json["active"],
        title: json["title"],
        forename: json["forename"],
        surname: json["surname"],
        initials: json["initials"],
        personReference: json["personReference"],
        dateOfBirth: json["dateOfBirth"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "accountHolder": accountHolder,
        "active": active,
        "title": title,
        "forename": forename,
        "surname": surname,
        "initials": initials,
        "personReference": personReference,
        "dateOfBirth": dateOfBirth,
      };
}

class OperatorAccountType {
  String type;
  int id;
  int defaultAccountTypeId;
  int sequence;
  String defaultAccountTypeName;
  bool active;
  bool businessNameRequired;
  bool orgDepartmentRequired;
  dynamic orgHigherLevelLabel;
  dynamic orgDepartmentLabel;
  bool personRefRequired;
  String personRefLabel;
  bool internalEmailRequired;
  dynamic internalEmailDomain;
  String name;
  String helpCode;
  bool customExpiryReminderAllowed;
  int customExpiryReminderEmailTemplateId;
  int memberListMaxNumber;
  String memberListLabel;
  dynamic memberListHelpCode;
  dynamic memberListHelpText;
  dynamic memberListHelpUrl;
  bool myAccountAccessRestricted;
  bool myNameAddressRestricted;
  bool unitPriceRequired;
  List<AccountAddressType> accountAddressTypes;
  List<AccountContactMethodType> accountContactMethodTypes;
  bool bankDetailsRequired;
  dynamic bankDetailsHelpCode;
  dynamic bankDetailsHelpText;
  bool dateOfBirthRequired;
  bool blueBadgeValidationRequired;

  OperatorAccountType({
    required this.type,
    required this.id,
    required this.defaultAccountTypeId,
    required this.sequence,
    required this.defaultAccountTypeName,
    required this.active,
    required this.businessNameRequired,
    required this.orgDepartmentRequired,
    this.orgHigherLevelLabel,
    this.orgDepartmentLabel,
    required this.personRefRequired,
    required this.personRefLabel,
    required this.internalEmailRequired,
    this.internalEmailDomain,
    required this.name,
    required this.helpCode,
    required this.customExpiryReminderAllowed,
    required this.customExpiryReminderEmailTemplateId,
    required this.memberListMaxNumber,
    required this.memberListLabel,
    this.memberListHelpCode,
    this.memberListHelpText,
    this.memberListHelpUrl,
    required this.myAccountAccessRestricted,
    required this.myNameAddressRestricted,
    required this.unitPriceRequired,
    required this.accountAddressTypes,
    required this.accountContactMethodTypes,
    required this.bankDetailsRequired,
    this.bankDetailsHelpCode,
    this.bankDetailsHelpText,
    required this.dateOfBirthRequired,
    required this.blueBadgeValidationRequired,
  });

  factory OperatorAccountType.fromJson(Map<String, dynamic> json) =>
      OperatorAccountType(
        type: json["\u0024type"],
        id: json["id"],
        defaultAccountTypeId: json["defaultAccountTypeId"],
        sequence: json["sequence"],
        defaultAccountTypeName: json["defaultAccountTypeName"],
        active: json["active"],
        businessNameRequired: json["businessNameRequired"],
        orgDepartmentRequired: json["orgDepartmentRequired"],
        orgHigherLevelLabel: json["orgHigherLevelLabel"],
        orgDepartmentLabel: json["orgDepartmentLabel"],
        personRefRequired: json["personRefRequired"],
        personRefLabel: json["personRefLabel"],
        internalEmailRequired: json["internalEmailRequired"],
        internalEmailDomain: json["internalEmailDomain"],
        name: json["name"],
        helpCode: json["helpCode"],
        customExpiryReminderAllowed: json["customExpiryReminderAllowed"],
        customExpiryReminderEmailTemplateId:
            json["customExpiryReminderEmailTemplateId"],
        memberListMaxNumber: json["memberListMaxNumber"],
        memberListLabel: json["memberListLabel"],
        memberListHelpCode: json["memberListHelpCode"],
        memberListHelpText: json["memberListHelpText"],
        memberListHelpUrl: json["memberListHelpUrl"],
        myAccountAccessRestricted: json["myAccountAccessRestricted"],
        myNameAddressRestricted: json["myNameAddressRestricted"],
        unitPriceRequired: json["unitPriceRequired"],
        accountAddressTypes: List<AccountAddressType>.from(
            json["accountAddressTypes"]
                .map((x) => AccountAddressType.fromJson(x))),
        accountContactMethodTypes: List<AccountContactMethodType>.from(
            json["accountContactMethodTypes"]
                .map((x) => AccountContactMethodType.fromJson(x))),
        bankDetailsRequired: json["bankDetailsRequired"],
        bankDetailsHelpCode: json["bankDetailsHelpCode"],
        bankDetailsHelpText: json["bankDetailsHelpText"],
        dateOfBirthRequired: json["dateOfBirthRequired"],
        blueBadgeValidationRequired: json["blueBadgeValidationRequired"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "defaultAccountTypeId": defaultAccountTypeId,
        "sequence": sequence,
        "defaultAccountTypeName": defaultAccountTypeName,
        "active": active,
        "businessNameRequired": businessNameRequired,
        "orgDepartmentRequired": orgDepartmentRequired,
        "orgHigherLevelLabel": orgHigherLevelLabel,
        "orgDepartmentLabel": orgDepartmentLabel,
        "personRefRequired": personRefRequired,
        "personRefLabel": personRefLabel,
        "internalEmailRequired": internalEmailRequired,
        "internalEmailDomain": internalEmailDomain,
        "name": name,
        "helpCode": helpCode,
        "customExpiryReminderAllowed": customExpiryReminderAllowed,
        "customExpiryReminderEmailTemplateId":
            customExpiryReminderEmailTemplateId,
        "memberListMaxNumber": memberListMaxNumber,
        "memberListLabel": memberListLabel,
        "memberListHelpCode": memberListHelpCode,
        "memberListHelpText": memberListHelpText,
        "memberListHelpUrl": memberListHelpUrl,
        "myAccountAccessRestricted": myAccountAccessRestricted,
        "myNameAddressRestricted": myNameAddressRestricted,
        "unitPriceRequired": unitPriceRequired,
        "accountAddressTypes":
            List<dynamic>.from(accountAddressTypes.map((x) => x.toJson())),
        "accountContactMethodTypes": List<dynamic>.from(
            accountContactMethodTypes.map((x) => x.toJson())),
        "bankDetailsRequired": bankDetailsRequired,
        "bankDetailsHelpCode": bankDetailsHelpCode,
        "bankDetailsHelpText": bankDetailsHelpText,
        "dateOfBirthRequired": dateOfBirthRequired,
        "blueBadgeValidationRequired": blueBadgeValidationRequired,
      };
}

class AccountAddressType {
  String type;
  int id;
  int addressTypeId;
  String addressLabel;
  bool isPrimary;
  bool useLocalAddressBase;
  bool useDepartmentAddress;
  bool isCorrespondence;

  AccountAddressType({
    required this.type,
    required this.id,
    required this.addressTypeId,
    required this.addressLabel,
    required this.isPrimary,
    required this.useLocalAddressBase,
    required this.useDepartmentAddress,
    required this.isCorrespondence,
  });

  factory AccountAddressType.fromJson(Map<String, dynamic> json) =>
      AccountAddressType(
        type: json["\u0024type"],
        id: json["id"],
        addressTypeId: json["addressTypeId"],
        addressLabel: json["addressLabel"],
        isPrimary: json["isPrimary"],
        useLocalAddressBase: json["useLocalAddressBase"],
        useDepartmentAddress: json["useDepartmentAddress"],
        isCorrespondence: json["isCorrespondence"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "addressTypeId": addressTypeId,
        "addressLabel": addressLabel,
        "isPrimary": isPrimary,
        "useLocalAddressBase": useLocalAddressBase,
        "useDepartmentAddress": useDepartmentAddress,
        "isCorrespondence": isCorrespondence,
      };
}

class AccountContactMethodType {
  String type;
  int id;
  int operatorAccountTypeId;
  int contactMethodId;
  String contactMethodName;
  bool required;

  AccountContactMethodType({
    required this.type,
    required this.id,
    required this.operatorAccountTypeId,
    required this.contactMethodId,
    required this.contactMethodName,
    required this.required,
  });

  factory AccountContactMethodType.fromJson(Map<String, dynamic> json) =>
      AccountContactMethodType(
        type: json["\u0024type"],
        id: json["id"],
        operatorAccountTypeId: json["operatorAccountTypeId"],
        contactMethodId: json["contactMethodId"],
        contactMethodName: json["contactMethodName"],
        required: json["required"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "operatorAccountTypeId": operatorAccountTypeId,
        "contactMethodId": contactMethodId,
        "contactMethodName": contactMethodName,
        "required": required,
      };
}

class PermitModelAddress {
  String type;
  String subAddress;
  String name;
  String number;
  String street;
  int streetId;
  String addressLine;
  String town;
  String county;
  String postcode;
  int addressBaseId;
  PafAddress pafAddress;

  PermitModelAddress({
    required this.type,
    required this.subAddress,
    required this.name,
    required this.number,
    required this.street,
    required this.streetId,
    required this.addressLine,
    required this.town,
    required this.county,
    required this.postcode,
    required this.addressBaseId,
    required this.pafAddress,
  });

  factory PermitModelAddress.fromJson(Map<String, dynamic> json) =>
      PermitModelAddress(
        type: json["\u0024type"],
        subAddress: json["subAddress"],
        name: json["name"],
        number: json["number"],
        street: json["street"],
        streetId: json["streetId"],
        addressLine: json["addressLine"],
        town: json["town"],
        county: json["county"],
        postcode: json["postcode"],
        addressBaseId: json["addressBaseId"],
        pafAddress: PafAddress.fromJson(json["pafAddress"]),
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "subAddress": subAddress,
        "name": name,
        "number": number,
        "street": street,
        "streetId": streetId,
        "addressLine": addressLine,
        "town": town,
        "county": county,
        "postcode": postcode,
        "addressBaseId": addressBaseId,
        "pafAddress": pafAddress.toJson(),
      };
}

class Applicant {
  String type;
  String email;
  String daytimePhone;
  String mobilePhone;
  dynamic homePhone;
  dynamic workPhone;
  String personalReference;
  String personalReferenceLabel;
  int daytimePhoneRequiredCriteria;
  int mobilePhoneRequiredCriteria;
  int homePhoneRequiredCriteria;
  int workPhoneRequiredCriteria;
  dynamic dateOfBirth;
  String title;
  String forename;
  String initials;
  String surname;

  Applicant({
    required this.type,
    required this.email,
    required this.daytimePhone,
    required this.mobilePhone,
    this.homePhone,
    this.workPhone,
    required this.personalReference,
    required this.personalReferenceLabel,
    required this.daytimePhoneRequiredCriteria,
    required this.mobilePhoneRequiredCriteria,
    required this.homePhoneRequiredCriteria,
    required this.workPhoneRequiredCriteria,
    this.dateOfBirth,
    required this.title,
    required this.forename,
    required this.initials,
    required this.surname,
  });

  factory Applicant.fromJson(Map<String, dynamic> json) => Applicant(
        type: json["\u0024type"],
        email: json["email"],
        daytimePhone: json["daytimePhone"],
        mobilePhone: json["mobilePhone"],
        homePhone: json["homePhone"],
        workPhone: json["workPhone"],
        personalReference: json["personalReference"],
        personalReferenceLabel: json["personalReferenceLabel"],
        daytimePhoneRequiredCriteria: json["daytimePhoneRequiredCriteria"],
        mobilePhoneRequiredCriteria: json["mobilePhoneRequiredCriteria"],
        homePhoneRequiredCriteria: json["homePhoneRequiredCriteria"],
        workPhoneRequiredCriteria: json["workPhoneRequiredCriteria"],
        dateOfBirth: json["dateOfBirth"],
        title: json["title"],
        forename: json["forename"],
        initials: json["initials"],
        surname: json["surname"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "email": email,
        "daytimePhone": daytimePhone,
        "mobilePhone": mobilePhone,
        "homePhone": homePhone,
        "workPhone": workPhone,
        "personalReference": personalReference,
        "personalReferenceLabel": personalReferenceLabel,
        "daytimePhoneRequiredCriteria": daytimePhoneRequiredCriteria,
        "mobilePhoneRequiredCriteria": mobilePhoneRequiredCriteria,
        "homePhoneRequiredCriteria": homePhoneRequiredCriteria,
        "workPhoneRequiredCriteria": workPhoneRequiredCriteria,
        "dateOfBirth": dateOfBirth,
        "title": title,
        "forename": forename,
        "initials": initials,
        "surname": surname,
      };
}

class Ops {
  String type;
  dynamic permitTypeGroups;
  dynamic permitTypes;
  dynamic periods;
  dynamic colours;
  dynamic makes;
  dynamic titles;
  dynamic fuelTypes;
  dynamic streets;
  int usePaf;
  dynamic pafToken;
  dynamic frontOfficePafToken;
  dynamic externalPafUrl;
  bool verifyEmail;
  bool generatedFromExistingApp;
  bool useLocalPafWithPropertyClusterCoding;
  dynamic groupSelectionHelpText;
  dynamic groupSelectionHelpUrl;
  dynamic emailHelpText;
  bool permitCanBeCancelled;
  dynamic calendarItems;
  dynamic accountTypeOptions;
  int minVehicles;
  int maxVehicles;
  bool vehicleChangeRestricted;
  dynamic vehicleChangeRestrictedDays;
  bool sessionVehicleRestricted;
  bool onlyOneActiveVehicleAllowed;
  bool reasonRequired;
  bool calculateRefundValue;
  dynamic paymentScheduleRules;
  dynamic permitAccountBankDetails;
  dynamic categories;
  dynamic blueBadges;

  Ops({
    required this.type,
    this.permitTypeGroups,
    this.permitTypes,
    this.periods,
    this.colours,
    this.makes,
    this.titles,
    this.fuelTypes,
    this.streets,
    required this.usePaf,
    this.pafToken,
    this.frontOfficePafToken,
    this.externalPafUrl,
    required this.verifyEmail,
    required this.generatedFromExistingApp,
    required this.useLocalPafWithPropertyClusterCoding,
    this.groupSelectionHelpText,
    this.groupSelectionHelpUrl,
    this.emailHelpText,
    required this.permitCanBeCancelled,
    this.calendarItems,
    this.accountTypeOptions,
    required this.minVehicles,
    required this.maxVehicles,
    required this.vehicleChangeRestricted,
    this.vehicleChangeRestrictedDays,
    required this.sessionVehicleRestricted,
    required this.onlyOneActiveVehicleAllowed,
    required this.reasonRequired,
    required this.calculateRefundValue,
    this.paymentScheduleRules,
    this.permitAccountBankDetails,
    this.categories,
    this.blueBadges,
  });

  factory Ops.fromJson(Map<String, dynamic> json) => Ops(
        type: json["\u0024type"],
        permitTypeGroups: json["permitTypeGroups"],
        permitTypes: json["permitTypes"],
        periods: json["periods"],
        colours: json["colours"],
        makes: json["makes"],
        titles: json["titles"],
        fuelTypes: json["fuelTypes"],
        streets: json["streets"],
        usePaf: json["usePaf"],
        pafToken: json["pafToken"],
        frontOfficePafToken: json["frontOfficePafToken"],
        externalPafUrl: json["externalPafUrl"],
        verifyEmail: json["verifyEmail"],
        generatedFromExistingApp: json["generatedFromExistingApp"],
        useLocalPafWithPropertyClusterCoding:
            json["useLocalPafWithPropertyClusterCoding"],
        groupSelectionHelpText: json["groupSelectionHelpText"],
        groupSelectionHelpUrl: json["groupSelectionHelpUrl"],
        emailHelpText: json["emailHelpText"],
        permitCanBeCancelled: json["permitCanBeCancelled"],
        calendarItems: json["calendarItems"],
        accountTypeOptions: json["accountTypeOptions"],
        minVehicles: json["minVehicles"],
        maxVehicles: json["maxVehicles"],
        vehicleChangeRestricted: json["vehicleChangeRestricted"],
        vehicleChangeRestrictedDays: json["vehicleChangeRestrictedDays"],
        sessionVehicleRestricted: json["sessionVehicleRestricted"],
        onlyOneActiveVehicleAllowed: json["onlyOneActiveVehicleAllowed"],
        reasonRequired: json["reasonRequired"],
        calculateRefundValue: json["calculateRefundValue"],
        paymentScheduleRules: json["paymentScheduleRules"],
        permitAccountBankDetails: json["permitAccountBankDetails"],
        categories: json["categories"],
        blueBadges: json["blueBadges"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "permitTypeGroups": permitTypeGroups,
        "permitTypes": permitTypes,
        "periods": periods,
        "colours": colours,
        "makes": makes,
        "titles": titles,
        "fuelTypes": fuelTypes,
        "streets": streets,
        "usePaf": usePaf,
        "pafToken": pafToken,
        "frontOfficePafToken": frontOfficePafToken,
        "externalPafUrl": externalPafUrl,
        "verifyEmail": verifyEmail,
        "generatedFromExistingApp": generatedFromExistingApp,
        "useLocalPafWithPropertyClusterCoding":
            useLocalPafWithPropertyClusterCoding,
        "groupSelectionHelpText": groupSelectionHelpText,
        "groupSelectionHelpUrl": groupSelectionHelpUrl,
        "emailHelpText": emailHelpText,
        "permitCanBeCancelled": permitCanBeCancelled,
        "calendarItems": calendarItems,
        "accountTypeOptions": accountTypeOptions,
        "minVehicles": minVehicles,
        "maxVehicles": maxVehicles,
        "vehicleChangeRestricted": vehicleChangeRestricted,
        "vehicleChangeRestrictedDays": vehicleChangeRestrictedDays,
        "sessionVehicleRestricted": sessionVehicleRestricted,
        "onlyOneActiveVehicleAllowed": onlyOneActiveVehicleAllowed,
        "reasonRequired": reasonRequired,
        "calculateRefundValue": calculateRefundValue,
        "paymentScheduleRules": paymentScheduleRules,
        "permitAccountBankDetails": permitAccountBankDetails,
        "categories": categories,
        "blueBadges": blueBadges,
      };
}

class Payment {
  String type;
  int id;
  int paymentId;
  double totalAmount;
  DateTime dateReceived;
  DateTime dateLogged;
  String note;
  String paymentMethod;
  dynamic paymentOffice;
  String authorisationCode;
  String merchantReference;
  String fulfilDataCashReference;
  String maskedCardNumber;
  String origin;
  String originDescription;
  String transactionTitle;
  bool showCardDetails;
  int paymentVoid;
  bool refund;
  String sortCode;
  String accountNumber;
  String accountName;
  String chequeNumber;
  bool captureBankAccount;
  bool chequePayment;
  String receiptNumber;

  Payment({
    required this.type,
    required this.id,
    required this.paymentId,
    required this.totalAmount,
    required this.dateReceived,
    required this.dateLogged,
    required this.note,
    required this.paymentMethod,
    this.paymentOffice,
    required this.authorisationCode,
    required this.merchantReference,
    required this.fulfilDataCashReference,
    required this.maskedCardNumber,
    required this.origin,
    required this.originDescription,
    required this.transactionTitle,
    required this.showCardDetails,
    required this.paymentVoid,
    required this.refund,
    required this.sortCode,
    required this.accountNumber,
    required this.accountName,
    required this.chequeNumber,
    required this.captureBankAccount,
    required this.chequePayment,
    required this.receiptNumber,
  });

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
        type: json["\u0024type"],
        id: json["id"],
        paymentId: json["paymentId"],
        totalAmount: json["totalAmount"],
        dateReceived: DateTime.parse(json["dateReceived"]),
        dateLogged: DateTime.parse(json["dateLogged"]),
        note: json["note"],
        paymentMethod: json["paymentMethod"],
        paymentOffice: json["paymentOffice"],
        authorisationCode: json["authorisationCode"],
        merchantReference: json["merchantReference"],
        fulfilDataCashReference: json["fulfilDataCashReference"],
        maskedCardNumber: json["maskedCardNumber"],
        origin: json["origin"],
        originDescription: json["originDescription"],
        transactionTitle: json["transactionTitle"],
        showCardDetails: json["showCardDetails"],
        paymentVoid: json["void"],
        refund: json["refund"],
        sortCode: json["sortCode"],
        accountNumber: json["accountNumber"],
        accountName: json["accountName"],
        chequeNumber: json["chequeNumber"],
        captureBankAccount: json["captureBankAccount"],
        chequePayment: json["chequePayment"],
        receiptNumber: json["receiptNumber"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "paymentId": paymentId,
        "totalAmount": totalAmount,
        "dateReceived": dateReceived.toIso8601String(),
        "dateLogged": dateLogged.toIso8601String(),
        "note": note,
        "paymentMethod": paymentMethod,
        "paymentOffice": paymentOffice,
        "authorisationCode": authorisationCode,
        "merchantReference": merchantReference,
        "fulfilDataCashReference": fulfilDataCashReference,
        "maskedCardNumber": maskedCardNumber,
        "origin": origin,
        "originDescription": originDescription,
        "transactionTitle": transactionTitle,
        "showCardDetails": showCardDetails,
        "void": paymentVoid,
        "refund": refund,
        "sortCode": sortCode,
        "accountNumber": accountNumber,
        "accountName": accountName,
        "chequeNumber": chequeNumber,
        "captureBankAccount": captureBankAccount,
        "chequePayment": chequePayment,
        "receiptNumber": receiptNumber,
      };
}

class PermitTypeProofDocumentCategory {
  String type;
  int minNumberRequired;
  int id;
  String name;

  PermitTypeProofDocumentCategory({
    required this.type,
    required this.minNumberRequired,
    required this.id,
    required this.name,
  });

  factory PermitTypeProofDocumentCategory.fromJson(Map<String, dynamic> json) =>
      PermitTypeProofDocumentCategory(
        type: json["\u0024type"],
        minNumberRequired: json["minNumberRequired"],
        id: json["id"],
        name: json["name"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "minNumberRequired": minNumberRequired,
        "id": id,
        "name": name,
      };
}

class Vehicle {
  String note;
  bool isFavourite;
  String type;
  int id;
  String vrm;
  dynamic make;
  dynamic model;
  dynamic colour;
  dynamic co2Emissions;
  dynamic fuelType;
  dynamic cylinderCapacity;
  dynamic height;
  dynamic length;
  dynamic firstRegistered;
  dynamic numberOfSeats;
  dynamic grossWeight;
  dynamic kerbWeight;
  dynamic unladenWeight;
  dynamic width;
  String? keeperFullName;
  dynamic knownAs;
  dynamic euroStatus;
  dynamic validPermits;
  bool isActive;
  bool isPermitVehicle;
  dynamic category;

  Vehicle({
    required this.note,
    required this.isFavourite,
    required this.type,
    required this.id,
    required this.vrm,
    this.make,
    this.model,
    this.colour,
    this.co2Emissions,
    this.fuelType,
    this.cylinderCapacity,
    this.height,
    this.length,
    this.firstRegistered,
    this.numberOfSeats,
    this.grossWeight,
    this.kerbWeight,
    this.unladenWeight,
    this.width,
    this.keeperFullName,
    this.knownAs,
    this.euroStatus,
    this.validPermits,
    required this.isActive,
    required this.isPermitVehicle,
    this.category,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) => Vehicle(
        note: '',
        isFavourite: false,
        type: json["\u0024type"],
        id: json["id"],
        vrm: json["vrm"],
        make: json["make"],
        model: json["model"],
        colour: json["colour"],
        co2Emissions: json["co2Emissions"],
        fuelType: json["fuelType"],
        cylinderCapacity: json["cylinderCapacity"],
        height: json["height"],
        length: json["length"],
        firstRegistered: json["firstRegistered"],
        numberOfSeats: json["numberOfSeats"],
        grossWeight: json["grossWeight"],
        kerbWeight: json["kerbWeight"],
        unladenWeight: json["unladenWeight"],
        width: json["width"],
        keeperFullName: json["keeperFullName"],
        knownAs: json["knownAs"],
        euroStatus: json["euroStatus"],
        validPermits: json["validPermits"],
        isActive: json["isActive"],
        isPermitVehicle: json["isPermitVehicle"],
        category: json["category"],
      );

  Map<String, dynamic> toJson() => {
        "\u0024type": type,
        "id": id,
        "vrm": vrm,
        "make": make,
        "model": model,
        "colour": colour,
        "co2Emissions": co2Emissions,
        "fuelType": fuelType,
        "cylinderCapacity": cylinderCapacity,
        "height": height,
        "length": length,
        "firstRegistered": firstRegistered,
        "numberOfSeats": numberOfSeats,
        "grossWeight": grossWeight,
        "kerbWeight": kerbWeight,
        "unladenWeight": unladenWeight,
        "width": width,
        "keeperFullName": keeperFullName,
        "knownAs": knownAs,
        "euroStatus": euroStatus,
        "validPermits": validPermits,
        "isActive": isActive,
        "isPermitVehicle": isPermitVehicle,
        "category": category,
      };
}
