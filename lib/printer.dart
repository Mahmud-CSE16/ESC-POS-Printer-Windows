import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:image/image.dart';

Future<void> testReceipt(
    NetworkPrinter printer,  Uint8List theimageThatC) async {


  printer.drawer();
  // printer.text("www.zatiq.com");
  // printer.cut();
  final Image? image = decodeImage(theimageThatC);
  printer.image(image! , align: PosAlign.center);


  printer.cut();

}


