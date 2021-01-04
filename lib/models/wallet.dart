class Wallet {
  final String public;
  final String private;
  final String currency;
  final String balance;
  String create_date;
  double sent;
  double received;
  String link;

  Wallet({this.public, this.private, this.currency, this.balance});

  factory Wallet.fromJson(Map<String, dynamic> parsedJson) {
    DateTime created;
    if (parsedJson['created'] != null) {
      created = DateTime.parse(parsedJson['created']).toLocal();
    }

    return Wallet();
  }

  Map<String, dynamic> toJson() {
    return {
      'public': this.public,
      'private': this.private,
      'balance': this.balance
    };
  }
}
