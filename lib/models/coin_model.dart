import 'package:equatable/equatable.dart';

class Coin extends Equatable {
  final String name;
  final String fullName;
  final double price;

  Coin({required this.name, required this.fullName, required this.price});

  @override
  // TODO: implement props
  List<Object?> get props => [name, fullName, price];

  factory Coin.fromMap(Map<String, dynamic> map) {
    return Coin(
        name: map['CoinInfo']?['Name'] ?? '' as String,
        fullName: map['CoinInfo']?['FullName'] ?? '' as String,
        price: (map['RAW']?['USD']?['PRICE'] ?? 0 as num).toDouble());
  }
}
