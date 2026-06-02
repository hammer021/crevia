class EwalletRegisterModel {
  final String code;
  final String description;
  final String msg;

  EwalletRegisterModel({
    required this.code,
    required this.description,
    required this.msg,
  });

  factory EwalletRegisterModel.fromJson(Map<String, dynamic> json) {
    return EwalletRegisterModel(
      code: json['status'] == null
          ? (json['code']?.toString() ?? '')
          : (json['status']['code']?.toString() ?? ''),
      description: json['status'] == null
          ? (json['msg']?.toString() ?? '')
          : (json['status']['description']?.toString() ?? ''),
      msg: json['msg']?.toString() ?? '',
    );
  }
}

class EwalletTransactionModel {
  final String description;
  final double debit;
  final double credit;
  final double charge;
  final double commission;
  final String transactionDate;
  final String noRefferenceTrx;
  final String noreff;
  final String name;
  final String mode;
  final DateTime transcationDateValue;

  EwalletTransactionModel({
    required this.description,
    required this.debit,
    required this.credit,
    required this.charge,
    required this.commission,
    required this.transactionDate,
    required this.noRefferenceTrx,
    required this.noreff,
    required this.name,
    required this.mode,
    required this.transcationDateValue,
  });

  factory EwalletTransactionModel.fromJson(Map<String, dynamic> json) {
    String? trxDate = json['transactionDate']?['_text'];
    DateTime trxDateValue = DateTime.now();
    if (trxDate != null && trxDate.length >= 14) {
      trxDateValue = DateTime.parse(
        trxDate.substring(0, 8) + 'T' + trxDate.substring(8),
      );
    }

    return EwalletTransactionModel(
      description: json['description']?['_text']?.toString() ?? '',
      mode: json['debit'] != null
          ? "DEBIT"
          : json['credit'] != null
              ? "CREDIT"
              : '',
      debit: double.tryParse(json['debit']?['_text']?.toString() ?? '0') ?? 0,
      credit: double.tryParse(json['credit']?['_text']?.toString() ?? '0') ?? 0,
      charge: double.tryParse(json['charge']?['_text']?.toString() ?? '0') ?? 0,
      commission:
          double.tryParse(json['commission']?['_text']?.toString() ?? '0') ?? 0,
      transactionDate: json['transactionDate']?['_text']?.toString() ?? '',
      transcationDateValue: trxDateValue,
      noRefferenceTrx: json['noRefferenceTrx']?['_text']?.toString() ?? '',
      noreff: json['noreff']?['_text']?.toString() ?? '',
      name: json['name']?['_text']?.toString() ?? '',
    );
  }
}

class EwalletPaymentReserved {
  final String reserved1;
  final String reserved4;
  final String reserved6;
  final String reserved7;
  final String reserved8;
  final String reserved9;
  final String reserved11;
  final String reserved12;
  final String reserved14;
  final String reserved15;
  final String reserved16;
  final String reserved17;
  final String reserved18;
  final String reserved19;
  final String reserved21;
  final String reserved22;
  final String reference;
  final String amountPay;

  EwalletPaymentReserved({
    required this.reserved1,
    required this.amountPay,
    required this.reserved4,
    required this.reserved6,
    required this.reserved7,
    required this.reserved8,
    required this.reserved9,
    required this.reserved11,
    required this.reserved12,
    required this.reserved14,
    required this.reserved15,
    required this.reserved16,
    required this.reserved17,
    required this.reserved18,
    required this.reserved19,
    required this.reserved21,
    required this.reserved22,
    required this.reference,
  });
}
