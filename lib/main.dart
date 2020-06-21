import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:flutter/services.dart';

import 'package:flutter_tests/models/StateOfPlayOptions.dart';
import 'package:flutter_tests/models/StateOfPlayTexts.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

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

// STATE_OF_PLAY TEXTS

const StateOfPlayTexts stateOfPlayTexts = StateOfPlayTexts(
  'Ci-après le Propriétaire',
  'Ci-après le Mandataire',
  'Ci-après le(s) Locataire(s)',
  "Date d'entrée",
  'Adresse des lieux loués',
  'Type de bien',
  'Référence',
  'Lot',
  'Étage',
  'Nombre de pièces',
  'Surface',
  'Annexes louées avec',
  'Type de chauffage',
  'Eau chaude'
);

// STATE_OF_PLAY OPTIONS

const StateOfPlayOptions stateOfPlayOptions = StateOfPlayOptions(
  "État des lieux d'entrée",
  'Dressé en commun et contradicatoire entre les soussignés',
  'assets/images/logo.png'
);

// STATE_OF_PLAY MODEL

sop.StateOfPlay stateOfPlay = sop.StateOfPlay(
  owner: sop.Owner(
    firstname: 'Robert',
    lastname: 'Dupont',
    company: "SCI d'Investisseurs",
    address: '3 rue des Mésanges, 75001 Paris'
  ),
  representative: sop.Representative(
    firstname: 'Elise',
    lastname: 'Lenotre',
    company: 'Marketin Immobilier',
    address: '36 rue Paul Cézanne, 68200 Mulhouse'
  ),
  tenants: [
    sop.Tenant(
      firstname: 'Emilie',
      lastname: 'Dupond',
      address: '36 rue des Vosges, 68000 Colmar',
    ),
    sop.Tenant(
      firstname: 'Schmitt',
      lastname: 'Albert',
      address: '84 boulevard Kenedy, 68100 Mulhouse'
    )
  ],
  entryDate: DateTime(2020, 5, 2),// To be changed
  property: sop.Property(
    address: '2 avenue de la Liberté, 68200 Mulhouse',
    type: 'appartement',
    reference: '3465',
    lot: '34',
    floor: 5,
    roomCount: 5,
    area: 108,
    annexes: 'balcon / cave / terasse',
    heatingType: 'chauffage collectif',
    hotWater: 'eau chaude collective'
  ),
  kitchen: sop.Kitchen(
    decorations: [
      sop.Decoration(
        type: 'Porte',
        nature: 'Pas de porte',
        state: sop.States.good,
        comment: 'Il manque la porte',
        photo: ''
      ),
      sop.Decoration(
        type: 'Porte',
        nature: 'Pas de porte',
        state: sop.States.good,
        comment: 'Il manque la porte',
        photo: ''
      )
    ],
    electricsAndHeatings: [
      sop.ElectricAndHeating(
        type: 'Interrupteur',
        quantity: 1,
        state: sop.States.neww,
        comment: '',
        photo: ''
      ),
      sop.ElectricAndHeating(
        type: 'Prise électrique',
        quantity: 3,
        state: sop.States.neww,
        comment: '',
        photo: ''
      ),
    ],
    equipments: [
      sop.Equipment(
        type: 'Interrupteur',
        brandOrObject: 'Brandt',
        stateOrQuantity: sop.States.good,
        comment: '',
        photo: ''
      ),
      sop.Equipment(
        type: 'Interrupteur',
        brandOrObject: 'Brandt',
        stateOrQuantity: sop.States.good,
        comment: '',
        photo: ''
      ),
    ],
    generalAspects: [
      sop.GeneralAspect(
        type: 'Cuisine',
        comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
        photo: ''
      )
    ]
  )
);

// Comment convertir en data une enum ?
// la stocker sous forme d'entier ou de string ?
// pb si stocker sous forme de string, comment recréer l'enum cote client ?

// solution 1. stocker en int :
// sop.Decorations deco = sop.Decorations.values[0];
// int enumInt = sop.Decorations.values.indexOf(sop.Decorations.ceiling)

// MAIS pb si on ajoute un champs à l'enum, cela demandera de maj la bdd

// solution 2 : https://medium.com/@amir.n3t/advanced-enums-in-flutter-a8f2e2702ffd

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

  pw.Widget _buildTable({ List<String> tableHeaders, List<dynamic> array, columnWidths }) {
    print(array.length);

    return pw.Table.fromTextArray(
      columnWidths: columnWidths,
      border: pw.TableBorder(
        noGlobalBorder: true,
        borderColor: PdfColors.grey400
      ),
      cellAlignment: pw.Alignment.centerLeft,
      headerAlignment: pw.Alignment.centerLeft,
      headerDecoration: pw.BoxDecoration(
        // borderRadius: 2,
        color: PdfColors.grey100
      ),
      headerHeight: 25,
      // cellHeight: 40,
      headerStyle: pw.TextStyle(
        // color: _baseTextColor,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      firstHeaderStyle: pw.TextStyle(
        color: PdfColors.blue600,
        fontSize: 8,
        fontWeight: pw.FontWeight.bold,
      ),
      cellStyle: const pw.TextStyle(
        // color: _darkColor,
        fontSize: 10,
      ),
      // rowDecoration: pw.BoxDecoration(
      //   border: pw.BoxBorder(
      //     bottom: true,
      //     // color: accentColor,
      //     width: .5,
      //   ),
      // ),
      headers: List<String>.generate(
        tableHeaders.length,
        (col) => tableHeaders[col].toUpperCase(),
      ),
      data: List<List<String>>.generate(
        array.length,
        (row) => List<String>.generate(
          tableHeaders.length,
          (col) => array[row].getIndex(col),
        ),
      ),
    );
  }

  pw.Widget _buildSectionHeader({ String title }) {
    return pw.Container(
      child: pw.Row(
        children: [
          // TODO Image Header
          pw.Row(
            children: [
              pw.Text(
                title
              )
            ]
          )
        ]
      )
    );
  }

  pw.Widget _buildKitchenTables() {
    
    const tableDecorationHeaders = [
      'Decoration',
      'Nature',
      'État',
      'Commentaires',
      'Photo'
    ];
    
    const tableElectricAndHeatingHeaders = [
      'Électrique/Chauffage',
      'Quantité',
      'État',
      'Commentaires',
      'Photo'
    ];

    const tableEquipmentsHeaders = [
      'Équipement',
      'Marque/Objet',
      'État/Qte',
      'Commentaires',
      'Photo'
    ];
    
    const tableGeneralAspectsHeaders = [
      'Aspect Général',
      'Commentaires',
      'Photo'
    ];

    return pw.Column(
      children: [
        _buildSectionHeader(
          title: 'Cuisine'
        ),
        _buildTable(
          tableHeaders: tableDecorationHeaders,
          array: stateOfPlay.kitchen.decorations,
          columnWidths: <int, pw.TableColumnWidth>{
            0: const pw.FixedColumnWidth(120),
            1: const pw.FixedColumnWidth(100),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(120),
            4: const pw.FixedColumnWidth(60),
            // 1: const pw.FlexColumnWidth(2),
            // 2: const pw.FractionColumnWidth(.2),
          }
        ),
        _buildTable(
          tableHeaders: tableElectricAndHeatingHeaders,
          array: stateOfPlay.kitchen.electricsAndHeatings,
          columnWidths: <int, pw.TableColumnWidth>{
            0: const pw.FixedColumnWidth(120),
            1: const pw.FixedColumnWidth(100),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(120),
            4: const pw.FixedColumnWidth(60),
          }
        ),
        _buildTable(
          tableHeaders: tableEquipmentsHeaders,
          array: stateOfPlay.kitchen.equipments,
          columnWidths: <int, pw.TableColumnWidth>{
            0: const pw.FixedColumnWidth(120),
            1: const pw.FixedColumnWidth(100),
            2: const pw.FixedColumnWidth(80),
            3: const pw.FixedColumnWidth(120),
            4: const pw.FixedColumnWidth(60),
          }
        ),
        _buildTable(
          tableHeaders: tableGeneralAspectsHeaders,
          array: stateOfPlay.kitchen.generalAspects,
          columnWidths: <int, pw.TableColumnWidth>{
            0: const pw.FixedColumnWidth(120),
            1: const pw.FixedColumnWidth(300),
            2: const pw.FixedColumnWidth(60),
          }
        ),
      ]
    );
  }

  Future<void> _generatePdf() async {
    final pw.Document pdf = pw.Document();

    PdfImage logo = PdfImage.file(
      pdf.document,
      bytes: (await rootBundle.load(stateOfPlayOptions.logo)).buffer.asUint8List(),
    );

    List tenants = stateOfPlay.tenants.map((tenant) => pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          stateOfPlay.representative.lastname.toUpperCase() + ' ' + tenant.firstname,
          style: pw.TextStyle(
            color: PdfColors.black,
            fontWeight: pw.FontWeight.bold,
            fontSize: 9,
          ),
        ),
        pw.Text(
          tenant.address.split(', ')[0],
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 9,
          ),
        ),
        pw.Text(
          tenant.address.split(', ')[1],
          style: pw.TextStyle(
            color: PdfColors.black,
            fontSize: 9,
          ),
        ),
        pw.Padding(padding: const pw.EdgeInsets.only(bottom: 10)),
      ]
    )).toList();

    tenants.add(pw.Column(
      children: [
        // pw.Expanded(
        //   child:
          pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.end,
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [pw.Text(
              stateOfPlayTexts.tenantsAux,
              style: pw.TextStyle(
                color: PdfColors.black,
                fontStyle: pw.FontStyle.italic,
                fontSize: 7,
              ),
            )
          ])
        // )
      ])
    );

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Column(
              children: [

                // HEADER
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 20),
                  child: pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          children: [
                            pw.Container(
                              height: 30,
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                stateOfPlayOptions.title.toUpperCase(),
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 22,
                                ),
                              ),
                            ),
                            pw.Container(
                              height: 30,
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                stateOfPlayOptions.description,
                                style: pw.TextStyle(
                                  color: PdfColors.black,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ])
                      ),
                      pw.Column(
                        children: [
                          pw.Container(
                            height: 90,
                            child: pw.Image(logo)
                          ),
                      ])
                  ]),
                ),
                
                pw.Container(
                  margin: const pw.EdgeInsets.only(bottom: 30),
                  child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [

                    // Box Owner
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                              ),
                              height: 120,
                              padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                              margin: const pw.EdgeInsets.only(right: 10),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    stateOfPlay.owner.company,
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.owner.lastname.toUpperCase() + ' ' + stateOfPlay.owner.firstname,
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.owner.address.split(', ')[0],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.owner.address.split(', ')[1],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Row(
                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                      mainAxisAlignment: pw.MainAxisAlignment.end,
                                      children: [pw.Text(
                                        stateOfPlayTexts.ownerAux,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontStyle: pw.FontStyle.italic,
                                          fontSize: 7,
                                        ),
                                      )
                                    ])
                                  )
                                ]),
                            )
                          ),
                        ])
                    ),

                    // Box Representative
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                              ),
                              height: 120,
                              padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                              margin: const pw.EdgeInsets.only(right: 10),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(
                                    stateOfPlay.representative.company,
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontWeight: pw.FontWeight.bold,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.representative.lastname.toUpperCase() + ' ' + stateOfPlay.representative.firstname,
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.representative.address.split(', ')[0],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Text(
                                    stateOfPlay.representative.address.split(', ')[1],
                                    style: pw.TextStyle(
                                      color: PdfColors.black,
                                      fontSize: 9,
                                    ),
                                  ),
                                  pw.Expanded(
                                    child: pw.Row(
                                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                                      mainAxisAlignment: pw.MainAxisAlignment.end,
                                      children: [pw.Text(
                                        stateOfPlayTexts.representativeAux,
                                        style: pw.TextStyle(
                                          color: PdfColors.black,
                                          fontStyle: pw.FontStyle.italic,
                                          fontSize: 7,
                                        ),
                                      )
                                    ])
                                  )
                                ]),
                            )
                          ),
                        ])
                    ),

                    // Box Tenants
                    pw.Expanded(
                      child: pw.Column(
                        children: [
                          pw.Container(
                            child: pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey100,
                              ),
                              height: 120,
                              padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: tenants
                              )
                            )
                          ),
                          pw.Container(
                              decoration: pw.BoxDecoration(
                                color: PdfColors.grey500,
                              ),
                              height: 25,
                              padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                              alignment: pw.Alignment.centerLeft,
                              child: pw.Text(
                                stateOfPlayTexts.entryDate + ' : ' + stateOfPlay.entryDate.toString(),
                                style: pw.TextStyle(
                                  color: PdfColors.white,
                                  fontSize: 9
                                )
                              )
                            )
                        ])
                    ),
                  ]),
                ),

                // Property Array
                pw.Table.fromTextArray(
                  context: context,
                  border: pw.TableBorder(
                    color: PdfColors.grey400,
                    borderColor: PdfColors.grey400
                  ),
                  cellAlignment: pw.Alignment.centerLeft,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                  },
                  data: <List<pw.Widget>>[

                    <pw.Widget>[
                      pw.Row(
                        children: [
                          pw.Text(
                            stateOfPlayTexts.address + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.address
                          )
                      ])
                    ],

                    <pw.Widget>[
                      pw.Row(
                        children: [
                          pw.Text(
                            stateOfPlayTexts.type + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.type + '           '
                          ),
                          pw.Text(
                            stateOfPlayTexts.reference + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.reference + '           '
                          ),
                          pw.Text(
                            stateOfPlayTexts.lot + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.lot
                          )
                      ])
                    ],
                    
                    <pw.Widget>[
                      pw.Row(
                        children: [
                          pw.Text(
                            stateOfPlayTexts.floor + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.floor.toString() + '           '
                          ),
                          pw.Text(
                            stateOfPlayTexts.roomCount + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.roomCount.toString() + '           '
                          ),
                          pw.Text(
                            stateOfPlayTexts.area + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.area.toString() + 'm²'
                          )
                      ])
                    ],
                    
                    <pw.Widget>[
                      pw.Row(
                        children: [
                          pw.Text(
                            stateOfPlayTexts.annexe + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.annexes
                          )
                      ])
                    ],

                    
                    <pw.Widget>[
                      pw.Row(
                        children: [
                          pw.Text(
                            stateOfPlayTexts.heatingType + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.heatingType + '           '
                          ),
                          pw.Text(
                            stateOfPlayTexts.hotWater + ':   ',
                            style: pw.TextStyle(
                              fontWeight: pw.FontWeight.bold,
                            )
                          ),
                          pw.Text(
                            stateOfPlay.property.hotWater
                          )
                      ])
                    ],
                  ]
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 25)
                ),

                _buildKitchenTables(),
                pw.Padding(
                  padding: pw.EdgeInsets.only(bottom: 25)
                ),
                
                _buildKitchenTables(),

              ])
          ];
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
            Image(image: AssetImage('assets/images/logo.png')),
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
