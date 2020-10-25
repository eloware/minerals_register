import 'package:intl/intl.dart';

class Formats{
  static DateFormat dateFormat = DateFormat('dd.MM.yyyy');
  static NumberFormat currencyFormat = NumberFormat.currency(locale: 'de_DE');
  static NumberFormat doubleFormat = NumberFormat('0.00', 'de_DE');

}
