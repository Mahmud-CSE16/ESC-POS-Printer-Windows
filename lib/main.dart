import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:printer_test_youtube/ImagestorByte.dart';
import 'package:printer_test_youtube/printer.dart';
import 'package:screenshot/screenshot.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'dart:io';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ScreenshotController screenshotController = ScreenshotController();
  String dir = Directory.current.path;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(dir);
     // this func to cheeck if port are close or not 
    setState(() {
        Process.run('$dir/images/installerX64/install.exe', [' start '])
          .then((ProcessResult results) {
        print("port poen");
      });
    });
  }
  void testPrint(String printerIp, Uint8List theimageThatComesfr) async {
    print("im inside the test print 2");
    // TODO Don't forget to choose printer's paper size
    const PaperSize paper = PaperSize.mm58;
    final profile = await CapabilityProfile.load();
    final printer = NetworkPrinter(paper, profile);

    final PosPrintResult res = await printer.connect(printerIp, port: 9100);

    if (res == PosPrintResult.success) {
      // DEMO RECEIPT
      await testReceipt(printer, theimageThatComesfr);
      print(res.msg);
      await Future.delayed(const Duration(seconds: 3), () {
        print("prinnter desconect");
        printer.disconnect();
      });
    }
  }
  TextEditingController printer = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ESC Pos Print"),
      ),
      body: Center(
          child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: printer,
                decoration: const InputDecoration(hintText: "Printer ip"),
              ),

              SizedBox(
                height: 10,
              ),
              ElevatedButton(
                child: const Text(
                  'Print res',
                  style: TextStyle(fontSize: 40),
                ),
                onPressed: () {
                  screenshotController
                      .capture(delay: const Duration(milliseconds: 10))
                      .then((capturedImage) async {
                    theimageThatComesfromThePrinter = capturedImage!;
                    setState(() {
                      theimageThatComesfromThePrinter = capturedImage;
                      testPrint(printer.text, theimageThatComesfromThePrinter);
                    });
                  });
                },
              ),
              SizedBox(
                height: 10,
              ),
              Screenshot(
                controller: screenshotController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("Zatiq Limited",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                    SizedBox(height: 10,),
                    Text("Banana: 10tk",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                    Text("Apple: 30tk",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                    Text("Guava: 20tk",style: TextStyle(fontSize: 25,fontWeight: FontWeight.w700),),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
            ],
          ),
        ],
      )),
    );
  }
}
