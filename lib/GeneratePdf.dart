import 'package:flutter/material.dart';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/services.dart';

import 'package:flutter_tests/models/StateOfPlayOptions.dart';
import 'package:flutter_tests/models/StateOfPlayTexts.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:intl/intl.dart';// DateFormat

// import 'package:http/http.dart' as http;

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
  'Eau chaude',
  'Le Bien Immobilier',
  'Compteur',
  'Clés',
  'Commentaire',
  'Réserve',
  'Signature du Propriétaire ou de son Mandataire',
  'Signature du Locatataire n°',
  'Annexes Photos'
);

// STATE_OF_PLAY OPTIONS

const StateOfPlayOptions stateOfPlayOptions = StateOfPlayOptions(
  "État des lieux d'entrée",
  "État des lieux de sortie",
  'Dressé en commun et contradicatoire entre les soussignés',
  'assets/images/logo.png'
);

final pw.Document pdf = pw.Document();

Future<void> _saveAsFile(pdf) async {
  final Uint8List bytes = pdf.save();

  final Directory appDocDir = await getApplicationDocumentsDirectory();
  final String appDocPath = appDocDir.path;
  final File file = File(appDocPath + '/' + 'document.pdf');
  print('Save as file ${file.path} ...');
  await file.writeAsBytes(bytes);
  // setState(() {
  //   _pdfPath = file.path;
  // });
  OpenFile.open(file.path);
}

pw.Widget _buildTable({ List<String> tableHeaders, List<dynamic> array, Map<int, pw.TableColumnWidth> columnWidths, PdfColor primaryColor }) {
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
      color: primaryColor,
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

pw.Widget _buildTableGeneralAspect({ List<String> tableHeaders, String roomName, sop.GeneralAspect generalAspect, Map<int, pw.TableColumnWidth> columnWidths, PdfColor primaryColor }) {
  return pw.Table.fromTextArray(
    columnWidths: columnWidths,
    border: pw.TableBorder(
      noGlobalBorder: true,
      borderColor: PdfColors.grey400
    ),
    cellAlignment: pw.Alignment.centerLeft,
    headerAlignment: pw.Alignment.centerLeft,
    headerDecoration: pw.BoxDecoration(
      color: PdfColors.grey100
    ),
    headerHeight: 25,
    headerStyle: pw.TextStyle(
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    ),
    firstHeaderStyle: pw.TextStyle(
      color: primaryColor,
      fontSize: 8,
      fontWeight: pw.FontWeight.bold,
    ),
    cellStyle: const pw.TextStyle(
      fontSize: 10,
    ),
    headers: List<String>.generate(
      tableHeaders.length,
      (col) => tableHeaders[col].toUpperCase(),
    ),
    data: List<List<String>>.generate(
      1,
      (row) => List<String>.generate(
        tableHeaders.length,
        (col) => col == 0 ? roomName : col == 1 ? generalAspect.comments : generalAspect.image.toString(),
      ),
    ),
  );
}

pw.Widget _buildRoomHeader({ String title, PdfImage logo }) {
  return
    pw.Container(
      alignment: pw.Alignment.centerLeft,
      child:
        pw.Row(
          // mainAxisAlignment: pw.MainAxisAlignment.start,
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          // verticalDirection: pw.VerticalDirection.down,
          children: [
            pw.Container(
              height: 40,
              child: pw.Image(logo)
            ),
            pw.Expanded(
              child:
                pw.Container(
                  alignment: pw.Alignment.centerLeft,
                  height: 25,
                  padding: pw.EdgeInsets.fromLTRB(10, 5, 5, 5),
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey600
                  ),
                  child:
                    pw.Text(
                      title.toUpperCase(),
                      style: pw.TextStyle(
                        color: PdfColors.white
                      )
                    )
                    
                )

            )
          ]
        )
    );
}

pw.Widget _buildRoom({ sop.Room room, PdfColor primaryColor, PdfImage logo }) {
  
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
  
  // const tableGeneralAspectsHeaders = [
  //   'Aspect Général',
  //   'Commentaires',
  //   'Photo'
  // ];

  return pw.Column(
    children: [
      _buildRoomHeader(
        title: room.name,
        logo: logo
      ),
      room.decorations != null ? _buildTable(
        tableHeaders: tableDecorationHeaders,
        array: room.decorations,
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FixedColumnWidth(120),
          1: const pw.FixedColumnWidth(100),
          2: const pw.FixedColumnWidth(80),
          3: const pw.FixedColumnWidth(120),
          4: const pw.FixedColumnWidth(60),
          // 1: const pw.FlexColumnWidth(2),
          // 2: const pw.FractionColumnWidth(.2),
        },
        primaryColor: primaryColor//PdfColors.pink400
      ) : Container(),
      room.electricities != null ? _buildTable(
        tableHeaders: tableElectricAndHeatingHeaders,
        array: room.electricities,
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FixedColumnWidth(120),
          1: const pw.FixedColumnWidth(100),
          2: const pw.FixedColumnWidth(80),
          3: const pw.FixedColumnWidth(120),
          4: const pw.FixedColumnWidth(60),
        },
        primaryColor: primaryColor
      ) : Container(),
      room.equipments != null ? _buildTable(
        tableHeaders: tableEquipmentsHeaders,
        array: room.equipments,
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FixedColumnWidth(120),
          1: const pw.FixedColumnWidth(100),
          2: const pw.FixedColumnWidth(80),
          3: const pw.FixedColumnWidth(120),
          4: const pw.FixedColumnWidth(60),
        },
        primaryColor: primaryColor
      ) : Container(),
      // room.generalAspect != null ? _buildTableGeneralAspect(
      //   tableHeaders: tableGeneralAspectsHeaders,
      //   roomName: room.name,
      //   generalAspect: room.generalAspect,
      //   columnWidths: <int, pw.TableColumnWidth>{
      //     0: const pw.FixedColumnWidth(120),
      //     1: const pw.FixedColumnWidth(300),
      //     2: const pw.FixedColumnWidth(60),
      //   },
      //   primaryColor: primaryColor
      // ) : Container(),
    ]
  );
}

pw.Widget _buildMeters({ List<sop.Meter> meters, PdfImage logo }) {
  
  const tableMeterHeaders = [
    'Type de compteur',
    'Emplacement',
    'Date du relevé',
    'Index',
    'Photo'
  ];

  return pw.Column(
    children: [
      _buildRoomHeader(
        title: stateOfPlayTexts.meter,
        logo: logo
      ),
      meters != null ? _buildTable(
        tableHeaders: tableMeterHeaders,
        array: meters,
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FixedColumnWidth(120),
          1: const pw.FixedColumnWidth(100),
          2: const pw.FixedColumnWidth(100),
          3: const pw.FixedColumnWidth(100),
          4: const pw.FixedColumnWidth(60),
        },
      ) : Container(),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 25)
      )
    ]
  );
}

pw.Widget _buildKeys({ List<sop.Key> keys, PdfImage logo }) {
  
  const tableMeterHeaders = [
    'Type de clé',
    'Nnombre',
    'Commentaires',
    'Photo'
  ];

  return pw.Column(
    children: [
      _buildRoomHeader(
        title: stateOfPlayTexts.key,
        logo: logo
      ),
      keys != null ? _buildTable(
        tableHeaders: tableMeterHeaders,
        array: keys,
        columnWidths: <int, pw.TableColumnWidth>{
          0: const pw.FixedColumnWidth(120),
          1: const pw.FixedColumnWidth(100),
          2: const pw.FixedColumnWidth(200),
          4: const pw.FixedColumnWidth(60),
        },
      ) : Container(),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 25)
      )
    ]
  );
}

pw.Widget _buildPhotos({ List<dynamic> imagesType, PdfImage logo }) {

  return pw.Column(
    children: [
      _buildRoomHeader(
        title: stateOfPlayTexts.photoAnnexe,
        logo: logo
      ),
      pw.Padding(
        padding: pw.EdgeInsets.only(bottom: 25)
      ),
      pw.Wrap(
        alignment: pw.WrapAlignment.start,
        runAlignment: pw.WrapAlignment.start,
        crossAxisAlignment: pw.WrapCrossAlignment.start,
        spacing: 20,
        runSpacing: 20,
        children: imagesType.map((imageType) => pw.Container(
          // TODO: width: ???
          alignment: pw.Alignment.bottomLeft,
          child: pw.Column(
            // mainAxisAlignment: pw.MainAxisAlignment.start,
            children: [
              pw.Container(
                padding: pw.EdgeInsets.only(bottom: 4),
                height: 200,
                child: pw.Image(
                  imageType["type"] == "file" ? PdfImage.file(
                    pdf.document,
                    bytes: imageType["image"].readAsBytesSync()
                  ) : pw.Text(imageType["image"])
                )
              ),
              pw.Container(
                alignment: pw.Alignment.bottomLeft,
                child: pw.Text(
                  "Photo n°" + (imagesType.indexOf(imageType) + 1).toString(),
                  textAlign: pw.TextAlign.left
                )
              )
            ]
          )
        )).toList()
      )
    ]
  );
}

Future<void> generatePdf(sop.StateOfPlay stateOfPlay) async {

  // TODO: Load Image From Internet
  // http.Response response = await http.get(
  //   'https://flutter.io/images/flutter-mark-square-100.png',
  // );   
  // response.bodyBytes //Uint8List

  PdfImage logo = PdfImage.file(
    pdf.document,
    bytes: (await rootBundle.load(stateOfPlayOptions.logo)).buffer.asUint8List(),
  );

  PdfImage logoKitchen = PdfImage.file(
    pdf.document,
    bytes: (await rootBundle.load(stateOfPlayOptions.logo)).buffer.asUint8List(),
  );

  List tenants = stateOfPlay.tenants.map((tenant) => pw.Column(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        stateOfPlay.representative.lastName.toUpperCase() + ' ' + tenant.firstName,
        style: pw.TextStyle(
          color: PdfColors.black,
          fontWeight: pw.FontWeight.bold,
          fontSize: 9,
        ),
      ),
      pw.Text(
        tenant.address,
        style: pw.TextStyle(
          color: PdfColors.black,
          fontSize: 9,
        ),
      ),
      pw.Text(
        tenant.postalCode + ' ' + tenant.city,
        style: pw.TextStyle(
          color: PdfColors.black,
          fontSize: 9,
        ),
      ),
      pw.Padding(padding: const pw.EdgeInsets.only(bottom: 10)),
    ]
  )).toList();

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
                              stateOfPlay.out ? stateOfPlayOptions.titleExit.toUpperCase() : stateOfPlayOptions.titleEntry.toUpperCase(),
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
                                  stateOfPlay.owner.lastName.toUpperCase() + ' ' + stateOfPlay.owner.firstName,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.Text(
                                  stateOfPlay.owner.address,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.Text(
                                  stateOfPlay.owner.postalCode + ' ' + stateOfPlay.owner.city,
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
                                  stateOfPlay.representative.lastName.toUpperCase() + ' ' + stateOfPlay.representative.firstName,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.Text(
                                  stateOfPlay.representative.address,
                                  style: pw.TextStyle(
                                    color: PdfColors.black,
                                    fontSize: 9,
                                  ),
                                ),
                                pw.Text(
                                  stateOfPlay.representative.postalCode + ' ' + stateOfPlay.representative.city,
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
                              children: [
                                pw.Column(
                                  children: tenants
                                ),
                                pw.Expanded(
                                  child:
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
                                )
                                    
                              ]
                            )
                          )
                        ),
                        pw.Container(
                            decoration: pw.BoxDecoration(
                              color: PdfColors.grey600,
                              borderRadius: 2
                            ),
                            height: 20,
                            padding: const pw.EdgeInsets.only(left: 20, top: 5, right: 20, bottom: 15),
                            alignment: pw.Alignment.centerLeft,
                            child: pw.Text(
                              stateOfPlayTexts.entryDate + ' : ' + DateFormat('dd/MM/yyyy').format(stateOfPlay.entryExitDate),
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
              _buildRoomHeader(
                title: stateOfPlayTexts.property,
                logo: logo
              ),
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
                          stateOfPlay.property.address + ', ' + stateOfPlay.property.postalCode + ' ' + stateOfPlay.property.city
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
                  
                  // <pw.Widget>[ // TODO : Add annexes
                  //   pw.Row(
                  //     children: [
                  //       pw.Text(
                  //         stateOfPlayTexts.annexe + ':   ',
                  //         style: pw.TextStyle(
                  //           fontWeight: pw.FontWeight.bold,
                  //         )
                  //       ),
                  //       pw.Text(
                  //         stateOfPlay.property.annexes
                  //       )
                  //   ])
                  // ],

                  
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

              // ROOMS
              ...stateOfPlay.rooms.map((room) =>
                pw.Column(
                  children: [
                    _buildRoom(
                      room: room,
                      primaryColor: stateOfPlay.rooms.indexOf(room) % 2 == 0 ? PdfColors.blue : PdfColors.pink,
                      logo: logoKitchen
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.only(bottom: 25)
                    ),
                  ]
                )
              ).toList(),

              // METER
              _buildMeters(
                meters: stateOfPlay.meters,
                logo: logoKitchen
              ),

              // KEY
              _buildKeys(
                keys: stateOfPlay.keys,
                logo: logoKitchen
              ),
              

            ])
        ];
    })
  ); // Page

  pdf.addPage(pw.MultiPage(
    build: (pw.Context context) => [

              pw.RichText(
                text:
                  pw.TextSpan(
                    text: "Le Locataire a assuré le bien immobilier auprès de la compagnie d'assurance ",
                    style: pw.TextStyle(
                      fontSize: 11
                    ),
                    children: [
                      pw.TextSpan(
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11
                        ),
                        text: stateOfPlay.insurance.company
                      ),
                      pw.TextSpan(
                        text: "sous le numéro de police " + stateOfPlay.insurance.number + " à compter du " + DateFormat('dd/MM/yyyy').format(stateOfPlay.insurance.dateStart) + " jusqu'au " + DateFormat('dd/MM/yyyy').format(stateOfPlay.insurance.dateEnd),
                        style: pw.TextStyle(
                          fontSize: 11
                        ),
                      )
                    ]
                  )
              ),
              pw.Padding(padding: pw.EdgeInsets.only(bottom: 15)),

              // COMMENT
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                height: 100,
                padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                alignment: pw.Alignment.centerLeft,
                child:
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:
                      [
                        pw.Text(
                          stateOfPlayTexts.comment + ' :',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold
                          ),
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),
                        pw.Text(stateOfPlay.comments)
                      ]
                  )
              ),
              pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),

              // RESERVE
              pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                height: 100,
                padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                alignment: pw.Alignment.centerLeft,
                child:
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children:
                      [
                        pw.Text(
                          stateOfPlayTexts.reserve + ' :',
                          style: pw.TextStyle(
                            fontWeight: pw.FontWeight.bold
                          )
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),
                        pw.Text(stateOfPlay.reserve)
                      ]
                  )
              ),
              pw.Padding(padding: pw.EdgeInsets.only(bottom: 15)),

              // TEXTE
              pw.Column(
                children: [
                  pw.Text(
                    "Les soussignés reconnaissent exactes les constatations sur l'état du logement, sous réserve du bon fonctionnement des canalisations, appareils et installations sanitaires, électriques et du chauffage qui n'a pu être vérifié ce jour, toute défectuosité dans le fonctionnement de ceux-ci devant être signalée dans le délai maximum de huit jours, et pendant le premier mois de la période de chauffe en ce qui concerne les éléments de chauffage.",
                    style: pw.TextStyle(
                      fontSize: 11
                    )
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),
                  pw.Text(
                    "Les cosignataires aux présentes ont convenu du caractère probant et indiscutable des signatures y figurant pour être recueillies selon procédé informatique sécurisé au contradictoire des partie, ils s'accordent pour y faire référence lors du départ du locataire.",
                    style: pw.TextStyle(
                      fontSize: 11
                    )
                  ),
                  pw.Padding(padding: pw.EdgeInsets.only(bottom: 5)),
                  pw.Text(
                    "Le présent état des lieux établi contradictoirement entre les parties qui le reconnaissent exact, fait partie intégrante du contrat de location dont il ne peut être dissocié.",
                    style: pw.TextStyle(
                      fontSize: 11
                    )
                  )
                ]
              ),
              pw.Padding(padding: pw.EdgeInsets.only(bottom: 25)),

              // Signatures
              pw.Container(
                alignment: pw.Alignment.topLeft,
                child: 
                  pw.RichText(
                    text: pw.TextSpan(
                      text: 'Fait à ' + stateOfPlay.city + ' ',
                        style: pw.TextStyle(
                        fontSize: 11
                      ),
                      children: [pw.TextSpan(
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 11
                        ),
                        text: 'le ' + DateFormat('dd/MM/yyy').format(stateOfPlay.date),
                      )]
                    )
                  )
              ),
              pw.Padding(padding: pw.EdgeInsets.only(bottom: 15)),

              pw.Wrap(
                spacing: 15,
                children: [
                  pw.Container(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                    ),
                    height: 120,
                    width: 230,
                    padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Container(
                          height: 40,
                          child: stateOfPlay.signatureOwner != null ? pw.Image(PdfImage.file(
                            pdf.document,
                            bytes: stateOfPlay.signatureOwner,
                          )) : pw.Container()
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 20)),
                        pw.Text(
                          stateOfPlayTexts.signatureOwnerOrRepresentative,
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontStyle: pw.FontStyle.italic 
                          )  
                        )
                      ]
                    )
                  ),
                  ...stateOfPlay.signatureTenants.map((signatureTenant) => pw.Container(
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                    ),
                    height: 120,
                    width: 230,
                    padding: const pw.EdgeInsets.only(left: 20, top: 15, right: 20, bottom: 15),
                    margin: const pw.EdgeInsets.only(bottom: 15),
                    alignment: pw.Alignment.bottomCenter,
                    child: pw.Column(
                      mainAxisAlignment: pw.MainAxisAlignment.end,
                      children: [
                        pw.Container(
                          height: 40,
                          child: signatureTenant != null ? pw.Image(PdfImage.file(
                            pdf.document,
                            bytes: signatureTenant,
                          )) : pw.Container()
                        ),
                        pw.Padding(padding: pw.EdgeInsets.only(bottom: 20)),
                        pw.Text(
                          stateOfPlayTexts.signatureTenant + (stateOfPlay.signatureTenants.indexOf(signatureTenant) + 1).toString(),
                          style: pw.TextStyle(
                            fontSize: 9,
                            fontStyle: pw.FontStyle.italic 
                          )    
                        )
                      ]
                    )
                  ))
                ]
              ),

              _buildPhotos(imagesType: stateOfPlay.images, logo: logo)
    ]
  ));

  // final file = File("example.pdf");
  // await file.writeAsBytes(pdf.save());

  _saveAsFile(pdf);

}