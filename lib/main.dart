import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_email_sender/flutter_email_sender.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class Owner {
  const Owner(
    this.firstname,
    this.lastname,
    this.company,
    this.address
  );

  final String firstname;
  final String lastname;
  final String company;
  final String address;
}

class Representative {
  const Representative(
    this.firstname,
    this.lastname,
    this.company,
    this.address
  );

  final String firstname;
  final String lastname;
  final String company;
  final String address;
}

class Tenant {
  const Tenant(
    this.firstname,
    this.lastname,
    this.address
  );

  final String firstname;
  final String lastname;
  final String address;
}

class Void {}// To be replaced

class Property {
  const Property(
    this.address,
    this.type,
    this.reference,
    this.lot,
    this.floor,
    this.roomCount,
    this.area,
    this.annexe,
    this.heatingType,
    this.hotWater
  );

  final String address;
  final Void type;
  final String reference;
  final String lot;
  final int floor;
  final int roomCount;
  final int area;
  final Void annexe;
  final Void heatingType;
  final Void hotWater;
}

class StateOfPlay {
  const StateOfPlay(
    this.owner,
    this.representative,
    this.tenants,
    this.entryDate,
    this.property
  );

  final Owner owner;
  final Representative representative;
  final List<Tenant> tenants;

  final String entryDate;// To be changed

  final Property property;
}

const StateOfPlay stateOfPlay = StateOfPlay(
  Owner(
    'Robert',
    'Dupont',
    "SCI d'Investisseurs",
    '3 rue des Mésanges, 75001 Paris'
  ),
  Representative(
    'Elise',
    'Lenotre',
    'Marketin Immobilier',
    '36 rue Paul Cézanne, 68200 Mulhouse'
  ),
  [Tenant(
    'Emilie',
    'Dupond',
    '36 rue des Vosges, 68000 Colmar',
  ),
  Tenant(
    'Schmitt',
    'Albert',
    '84 boulevard Kenedy, 68100 Mulhouse'
  )],
  'new DateTime(2020, 5, 2)',// To be changed
  Property(
    '2 avenue de la Liberté, 68200 Mulhouse',
    null,
    '3465',
    '34',
    5,
    5,
    108,
    null,
    null,
    null)
);

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _pdfPath;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  Future<void> _saveAsFile(pdf) async {
    final Uint8List bytes = pdf.save();

    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String appDocPath = appDocDir.path;
    final File file = File(appDocPath + '/' + 'document.pdf');
    print('Save as file ${file.path} ...');
    await file.writeAsBytes(bytes);
    setState(() {
      _pdfPath = file.path;
    });
    OpenFile.open(file.path);
  }

  Future<void> _generatePdf() async {
    final pw.Document pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Text("Hello World 3"),
          ); // Center
      })
    ); // Page

    // final file = File("example.pdf");
    // await file.writeAsBytes(pdf.save());

    _saveAsFile(pdf);
  
  }
  
  Future<void> _sendPdf() async {
    final Email email = Email(
      body: 'Email body',
      subject: 'Email subject',
      recipients: ['l.szabatura@gmail.com'],
      cc: ['cc@example.com'],
      bcc: ['bcc@example.com'],
      // attachmentPaths: [_pdfPath],
      isHTML: false,
    );

    await FlutterEmailSender.send(email);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.



    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(
              onPressed: _generatePdf,
              child: Text(
                'Generate PDF'
              )
            ),
            _pdfPath != null ? RaisedButton(
              onPressed: _sendPdf,
              child: Text(
                'Send PDF'
              )
            ) : Container(),
            Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Generate PDF',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
