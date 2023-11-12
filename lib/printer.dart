import 'dart:typed_data';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

Future<void> testReceipt(
    NetworkPrinter printer,  Uint8List theimageThatC) async {


  // printer.drawer();
  // printer.text("www.zatiq.com");
  // // printer.cut();
  // final Image? image = decodeImage(theimageThatC);
  // printer.image(image!);


  List<int> bytes = [];

  // Xprinter XP-N160I
  final profile = await CapabilityProfile.load(name: 'XP-N160I');
  // PaperSize.mm80 or PaperSize.mm58
  final generator = Generator(PaperSize.mm58, profile);
  bytes += generator.setGlobalCodeTable('CP1252');

  bytes += generator.drawer();

  final ByteData data = await rootBundle.load('images/zatiq-black.webp');
  if (data.lengthInBytes > 0) {
    final Uint8List imageBytes = data.buffer.asUint8List();
    // decode the bytes into an image
    final decodedImage = img.decodeImage(imageBytes)!;
    // Create a black bottom layer
    // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
    img.Image thumbnail = img.copyResize(decodedImage, height: 80);
    // creates a copy of the original image with set dimensions
    img.Image originalImg = img.copyResize(decodedImage, width: 300, height: decodedImage.height);
    // fills the original image with a white background
    img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));
    var padding = (originalImg.width - thumbnail.width) / 2;

    //insert the image inside the frame and center it
    img.compositeImage(originalImg, thumbnail, dstX: padding.toInt());

    // convert image to grayscale
    var grayscaleImage = img.grayscale(originalImg);

    bytes += generator.feed(1);
    // bytes += generator.imageRaster(img.decodeImage(imageBytes)!, align: PosAlign.center);
    bytes += generator.imageRaster(grayscaleImage, align: PosAlign.left);
    bytes += generator.feed(1);
    bytes += generator.feed(1);

  }
  // bytes += generator.row([
  //   PosColumn(text: "Mahmudul",width: 8),
  //   PosColumn(text: "Islam",width: 4)
  // ]);
  bytes += generator.text('Zatiq - Digitalise your business',
      styles: const PosStyles(align: PosAlign.center));
  bytes += generator.feed(1);

  bytes += generator.text('Product 1: 100 tk');
  bytes += generator.text('Product 2 : 200 tk');
  bytes += generator.text('---------------------------');
  bytes += generator.text('Total : 300 tk');

  bytes += generator.feed(1);

  bytes += generator.qrcode("https://www.zatiq.com/", size: QRSize.Size8, align: PosAlign.center);



  // printEscPos(bytes, generator);


  printer.rawBytes(bytes);

  printer.cut();

}


