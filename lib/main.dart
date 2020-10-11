import 'dart:io';
import 'package:flutter/material.dart';

import 'dart:async';

import 'package:flutter_email_sender/flutter_email_sender.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/PropertyForm.dart' as v;

import 'package:flutter_tests/GeneratePdf.dart';
import 'package:flutter_tests/widgets/StateOfPlays.dart';
import 'package:flutter_tests/widgets/NewStateOfPlay.dart';

import 'package:graphql_flutter/graphql_flutter.dart';


// import 'package:http/http.dart' as http;

String get host {
  if (Platform.isAndroid) {
    return 'localhost';
  } else {
    return 'localhost';
  }
}

void main() {
  runApp(MyApp());
}

final HttpLink httpLink = HttpLink(
  uri: 'http://$host:9002/graphql',
);

// final AuthLink authLink = AuthLink(
//   getToken: () async => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
//   // OR
//   // getToken: () => 'Bearer <YOUR_PERSONAL_ACCESS_TOKEN>',
// );

// final Link link = authLink.concat(httpLink);

ValueNotifier<GraphQLClient> client = ValueNotifier(
  GraphQLClient(
    cache: InMemoryCache(),
    link: httpLink,
  ),
);

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return
      GraphQLProvider(
        client: client,
        child:
          MaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: '/',
            routes: {
              '/': (context) => MyHomePage(title: 'Flutter Demo Home Page'),
              '/state-of-plays': (context) => StateOfPlays(),
              '/new': (context) => NewStateOfPlay(),
            },
          )
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
// STATE_OF_PLAY MODEL

sop.StateOfPlay stateOfPlay = sop.StateOfPlay(
  owner: sop.Owner(
    firstname: 'Robert',
    lastname: 'Dupont',
    company: "SCI d'Investisseurs",
    address: '3 rue des Mésanges',
    postalCode: '75001',
    city: 'Paris'
  ),
  representative: sop.Representative(
    firstname: 'Elise',
    lastname: 'Lenotre',
    company: 'Marketin Immobilier',
    address: '3 rue des Mésanges',
    postalCode: '75001',
    city: 'Paris'
  ),
  tenants: [
    sop.Tenant(
      firstname: 'Emilie',
      lastname: 'Dupond',
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris'
    ),
    sop.Tenant(
      firstname: 'Schmitt',
      lastname: 'Albert',
      address: '3 rue des Mésanges',
      postalCode: '75001',
      city: 'Paris'
    )
  ],
  entryDate: DateTime.now(),// To be changed
  property: sop.Property(
    address: '3 rue des Mésanges',
    postalCode: '75001',
    city: 'Paris',
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
  rooms: [
    sop.Room(
      name: 'Cuisine',
      decorations: [
        sop.Decoration(
          type: 'Porte',
          nature: 'Pas de porte',
          state: sop.States.good,
          comment: 'Il manque la porte',
          photo: 0
        ),
        sop.Decoration(
          type: 'Porte',
          nature: 'Pas de porte',
          state: sop.States.good,
          comment: 'Il manque la porte',
          photo: 0
        )
      ],
      electricsAndHeatings: [
        sop.ElectricAndHeating(
          type: 'Interrupteur',
          quantity: 1,
          state: sop.States.neww,
          comment: '',
          photo: 0
        ),
        sop.ElectricAndHeating(
          type: 'Prise électrique',
          quantity: 3,
          state: sop.States.neww,
          comment: '',
          photo: 0
        ),
      ],
      equipments: [
        sop.Equipment(
          type: 'Interrupteur',
          brandOrObject: 'Brandt',
          stateOrQuantity: sop.States.good,
          comment: '',
          photo: 0
        ),
        sop.Equipment(
          type: 'Interrupteur',
          brandOrObject: 'Brandt',
          stateOrQuantity: sop.States.good,
          comment: '',
          photo: 0
        ),
      ],
      generalAspect: sop.GeneralAspect(
        comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
        photo: 0
      )
    ),
    sop.Room(
      name: 'Séjour / Salon',
      decorations: [
        sop.Decoration(
          type: 'Porte',
          nature: 'Pas de porte',
          state: sop.States.good,
          comment: 'Il manque la porte',
          photo: 0
        ),
        sop.Decoration(
          type: 'Porte',
          nature: 'Pas de porte',
          state: sop.States.good,
          comment: 'Il manque la porte',
          photo: 0
        )
      ],
      electricsAndHeatings: [
        sop.ElectricAndHeating(
          type: 'Interrupteur',
          quantity: 1,
          state: sop.States.neww,
          comment: '',
          photo: 0
        ),
        sop.ElectricAndHeating(
          type: 'Prise électrique',
          quantity: 3,
          state: sop.States.neww,
          comment: '',
          photo: 0
        ),
      ],
      equipments: [
        sop.Equipment(
          type: 'Interrupteur',
          brandOrObject: 'Brandt',
          stateOrQuantity: sop.States.good,
          comment: '',
          photo: 0
        ),
        sop.Equipment(
          type: 'Interrupteur',
          brandOrObject: 'Brandt',
          stateOrQuantity: sop.States.good,
          comment: '',
          photo: 0
        ),
      ],
      generalAspect: sop.GeneralAspect(
        comment: 'Cuisine La cuisine équipée est en très bon état et complète Photo n°12',
        photo: 0
      ),
    )
  ],
  meters: [
    sop.Meter(
      type: 'Eau froide',
      location: 'Cuisine',
      dateOfSuccession: DateTime.now(),
      index: 4567,
      photo: 0
    )
  ],
  keys: [
    sop.Key(
      type: 'Clé ascenceur',
      count: 1,
      comments: '',
      photo: 0
    )
  ],
  insurance: sop.Insurance(
    company: 'Homestar',
    number: '123465468',
    dateStart: DateTime.now(),
    dateEnd: DateTime.now(),
  ),
  comment: "L'appartement vient d'être repeint",
  reserve: 'Le propritaire doit remettre une cuvette dans les toilettes',
  city: 'Mulhouse',
  date: DateTime.now()
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
            v.PropertyForm(
              property: stateOfPlay.property
            ),
            Image(image: AssetImage('assets/images/logo.png')),
            RaisedButton(
              onPressed: () => generatePdf(stateOfPlay),
              child: Text(
                'Generate PDF'
              )
            ),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, '/state-of-plays'),
              child: Text(
                'State of play list'
              )
            ),
            RaisedButton(
              onPressed: () => Navigator.pushNamed(context, '/new'),
              child: Text(
                'New state of play'
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
