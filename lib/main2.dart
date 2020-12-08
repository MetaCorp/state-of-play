// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import 'dart:async';

// import 'package:flutter_email_sender/flutter_email_sender.dart';

// import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

// import 'package:flutter_tests/widgets2/PropertyForm.dart' as v;

// import 'package:flutter_tests/GeneratePdf.dart';

// import 'package:flutter_tests/widgets/property/Properties.dart';
// import 'package:flutter_tests/widgets/stateOfPlay/StateOfPlays.dart';

// import 'package:flutter_tests/widgets2/NewStateOfPlay.dart';

// import 'package:graphql_flutter/graphql_flutter.dart';


// // import 'package:http/http.dart' as http;

// String get host {
//   if (Platform.isAndroid) {
//     return 'localhost';
//   } else {
//     return 'localhost';
//   }
// }

// void main() {
//   runApp(MyApp());
// }

// final HttpLink httpLink = HttpLink(
//   uri: 'http://$host:4000/graphql',
// );

// // final AuthLink authLink = AuthLink(
// //   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
// //   // OR
// //   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
// // );

// // final Link link = authLink.concat(httpLink);

// ValueNotifier<GraphQLClient> client = ValueNotifier(
//   GraphQLClient(
//     cache: InMemoryCache(),
//     link: httpLink,
//   ),
// );

// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.

//   @override
//   Widget build(BuildContext context) {
//     //Force Device Orientation 
//     //https://stackoverflow.com/questions/49418332/flutter-how-to-prevent-device-orientation-changes-and-force-portrait
//     SystemChrome.setPreferredOrientations([
//       DeviceOrientation.landscapeLeft,
//       DeviceOrientation.landscapeRight,
//     ]);
//     return
//       GraphQLProvider(
//         client: client,
//         child:
//           MaterialApp(
//             title: 'State Of Play',
//             theme: ThemeData(
//               primarySwatch: Colors.blue,
//               visualDensity: VisualDensity.adaptivePlatformDensity,
//             ),
//             initialRoute: '/',
//             routes: {
//               '/': (context) => MyHomePage(title: 'Home Page'),
//               '/state-of-plays': (context) => StateOfPlays(),
//               '/properties': (context) => Properties(),
//              '/new': (context) => NewStateOfPlayRouter(),
//             },
//           )
//       );
//   }
// }

// class MyHomePage extends StatefulWidget {
//   MyHomePage({Key key, this.title}) : super(key: key);

//   final String title;

//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
// // STATE_OF_PLAY MODEL

// sop.StateOfPlay stateOfPlay = sop.StateOfPlay(
//   owner: sop.Owner(
//     firstname: 'Robert',
//     lastname: 'Dupont',
//     company: "SCI d'Investisseurs",
//     address: '3 rue des Mésanges',
//     postalCode: '75001',
//     city: 'Paris'
//   ),
//   representative: sop.Representative(
//     firstname: 'Elise',
//     lastname: 'Lenotre',
//     company: 'Marketin Immobilier',
//     address: '3 rue des Mésanges',
//     postalCode: '75001',
//     city: 'Paris'
//   ),
//   tenants: [
//     sop.Tenant(
//       firstname: 'Emilie',
//       lastname: 'Dupond',
//       address: '3 rue des Mésanges',
//       postalCode: '75001',
//       city: 'Paris'
//     ),
//     sop.Tenant(
//       firstname: 'Schmitt',
//       lastname: 'Albert',
//       address: '3 rue des Mésanges',
//       postalCode: '75001',
//       city: 'Paris'
//     )
//   ],
//   entryDate: DateTime.now(),// To be changed
//   property: sop.Property(
//     address: '3 rue des Mésanges',
//     postalCode: '75001',
//     city: 'Paris',
//     type: 'appartement',
//     reference: '3465',
//     lot: '34',
//     floor: 5,
//     roomCount: 5,
//     area: 108,
//     annexes: 'balcon / cave / terasse',
//     heatingType: 'chauffage collectif',
//     hotWater: 'eau chaude collective'
//   ),
//   rooms: [
//     sop.Room(
//       name: 'Cuisine',
//       decorations: [
//         sop.Decoration(
//           type: 'Porte',
//           nature: 'Pas de porte',
//           state: sop.States.good,
//           comment: 'Il manque la porte',
//           photo: 0
//         ),
//         sop.Decoration(
//           type: 'Porte',
//           nature: 'Pas de porte',
//           state: sop.States.good,
//           comment: 'Il manque la porte',
//           photo: 0
//         )
//       ],
//       electricsAndHeatings: [
//         sop.ElectricAndHeating(
//           type: 'Interrupteur',
//           quantity: 1,
//           state: sop.States.neww,
//           comment: '',
//           photo: 0
//         ),
//         sop.ElectricAndHeating(
//           type: 'Prise électrique',
//           quantity: 3,
//           state: sop.States.neww,
//           comment: '',
//           photo: 0
//         ),
//       ],
//       equipments: [
//         sop.Equipment(
//           type: 'Interrupteur',
//           brandOrObject: 'Brandt',
//           stateOrQuantity: sop.States.good,
//           comment: '',
//           photo: 0
//         ),
//         sop.Equipment(
//           type: 'Interrupteur',
//           brandOrObject: 'Brandt',
//           stateOrQuantity: sop.States.good,
//           comment: '',
//           photo: 0
//         ),
//       ],
//       generalAspect: sop.GeneralAspect(
//         comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
//         photo: 0
//       )
//     ),
//     sop.Room(
//       name: 'Séjour / Salon',
//       decorations: [
//         sop.Decoration(
//           type: 'Porte',
//           nature: 'Pas de porte',
//           state: sop.States.good,
//           comment: 'Il manque la porte',
//           photo: 0
//         ),
//         sop.Decoration(
//           type: 'Porte',
//           nature: 'Pas de porte',
//           state: sop.States.good,
//           comment: 'Il manque la porte',
//           photo: 0
//         )
//       ],
//       electricsAndHeatings: [
//         sop.ElectricAndHeating(
//           type: 'Interrupteur',
//           quantity: 1,
//           state: sop.States.neww,
//           comment: '',
//           photo: 0
//         ),
//         sop.ElectricAndHeating(
//           type: 'Prise électrique',
//           quantity: 3,
//           state: sop.States.neww,
//           comment: '',
//           photo: 0
//         ),
//       ],
//       equipments: [
//         sop.Equipment(
//           type: 'Interrupteur',
//           brandOrObject: 'Brandt',
//           stateOrQuantity: sop.States.good,
//           comment: '',
//           photo: 0
//         ),
//         sop.Equipment(
//           type: 'Interrupteur',
//           brandOrObject: 'Brandt',
//           stateOrQuantity: sop.States.good,
//           comment: '',
//           photo: 0
//         ),
//       ],
//       generalAspect: sop.GeneralAspect(
//         comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
//         photo: 0
//       ),
//     )
//   ],
//   meters: [
//     sop.Meter(
//       type: 'Eau froide',
//       location: 'Cuisine',
//       dateOfSuccession: DateTime.now(),
//       index: 4567,
//       photo: 0
//     )
//   ],
//   keys: [
//     sop.Key(
//       type: 'Clé ascenceur',
//       count: 1,
//       comments: '',
//       photo: 0
//     )
//   ],
//   insurance: sop.Insurance(
//     company: 'Homestar',
//     number: '123465468',
//     dateStart: DateTime.now(),
//     dateEnd: DateTime.now(),
//   ),
//   comment: "L'appartement vient d'être repeint",
//   reserve: 'Le propritaire doit remettre une cuvette dans les toilettes',
//   city: 'Mulhouse',
//   date: DateTime.now()
// );

// // Comment convertir en data une enum ?
// // la stocker sous forme d'entier ou de string ?
// // pb si stocker sous forme de string, comment recréer l'enum cote client ?

// // solution 1. stocker en int :
// // sop.Decorations deco = sop.Decorations.values[0];
// // int enumInt = sop.Decorations.values.indexOf(sop.Decorations.ceiling)

// // MAIS pb si on ajoute un champs à l'enum, cela demandera de maj la bdd

// // solution 2 : https://medium.com/@amir.n3t/advanced-enums-in-flutter-a8f2e2702ffd

// class _MyHomePageState extends State<MyHomePage> {
//   int _counter = 0;
//   String _pdfPath;
  
//   Future<void> _sendPdf() async {
//     final Email email = Email(
//       body: 'Email body',
//       subject: 'Email subject',
//       recipients: ['l.szabatura@gmail.com'],
//       cc: ['cc@example.com'],
//       bcc: ['bcc@example.com'],
//       // attachmentPaths: [_pdfPath],
//       isHTML: false,
//     );

//     await FlutterEmailSender.send(email);
//   }

//   @override
//   Widget build(BuildContext context) {

//     return Scaffold(
//       appBar: AppBar(
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: SingleChildScrollView(
//                   child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               v.PropertyForm(
//                 property: stateOfPlay.property
//               ),
//               Image(image: AssetImage('assets/images/logo.png')),
//               RaisedButton(
//                 onPressed: () => generatePdf(stateOfPlay),
//                 child: Text(
//                   'Generate PDF'
//                 )
//               ),
//               RaisedButton(
//                 onPressed: () => Navigator.pushNamed(context, '/state-of-plays'),
//                 child: Text(
//                   'State of play list'
//                 )
//               ),
//               RaisedButton(
//                 onPressed: () => Navigator.pushNamed(context, '/properties'),
//                 child: Text(
//                   'Property list'
//                 )
//               ),
//               RaisedButton(
//                 onPressed: () => Navigator.pushNamed(context, '/new'),
//                 child: Text(
//                   'New state of play'
//                 )
//               ),
//               _pdfPath != null ? RaisedButton(
//                 onPressed: _sendPdf,
//                 child: Text(
//                   'Send PDF'
//                 )
//               ) : Container(),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () => {},
//         tooltip: 'Generate PDF',
//         child: Icon(Icons.add),
//       ), 
//     );
//   }
// }
