import 'dart:io';
// import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/shop/ListTileShop.dart';
import 'package:flutter_tests/widgets/utilities/MyScaffold.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:stripe_payment/stripe_payment.dart';

class ShowDialogToDismiss extends StatelessWidget {
  final String content;
  final String title;
  final String buttonText;
  ShowDialogToDismiss({this.title, this.buttonText, this.content});
  @override
  Widget build(BuildContext context) {
    // if (!Platform.isIOS) {
      return AlertDialog(
        title: new Text(
          title,
        ),
        content: new Text(
          this.content,
        ),
        actions: <Widget>[
          new FlatButton(
            child: new Text(
              buttonText,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    // } else {
    //   return CupertinoAlertDialog(
    //       title: Text(
    //         title,
    //       ),
    //       content: new Text(
    //         this.content,
    //       ),
    //       actions: <Widget>[
    //         CupertinoDialogAction(
    //           isDefaultAction: true,
    //           child: new Text(
    //             buttonText[0].toUpperCase() +
    //                 buttonText.substring(1).toLowerCase(),
    //           ),
    //           onPressed: () {
    //             Navigator.of(context).pop();
    //           },
    //         )
    //       ]);
    // }
  }
}

class Shop extends StatefulWidget {
  Shop({ Key key, this.isPopup = false }) : super(key: key);

  final bool isPopup;

  @override
  _ShopState createState() => _ShopState();
}

class _ShopState extends State<Shop> {
  List<bool> loadings = List(3);

  @override
  void initState() {
    super.initState();

    loadings = loadings.map((value) => false).toList();
  }

  _onWillPop(sop.User user) {
    if (user == null)
      Navigator.pop(context, false);

    Navigator.pop(context, user.credits > 0);

    return false;
  }

  void checkIfNativePayReady(runMutation) async {
    print('started to check if native pay ready');
    // bool deviceSupportNativePay = await StripePayment.deviceSupportsNativePay();
    // bool isNativeReady = await StripePayment.canMakeNativePayPayments(['american_express', 'visa', 'maestro', 'master_card']);
    /*deviceSupportNativePay && isNativeReady*/ false ? createPaymentMethodNative(4.99) : createPaymentMethod(4.99);
  }

  Future<void> createPaymentMethodNative(double totalCost) async {
    print('started NATIVE payment...');
    StripePayment.setStripeAccount(null);
    List<ApplePayItem> items = [];
    items.add(ApplePayItem(
      label: 'Demo Order',
      amount: totalCost.toString(),
    ));
    // if (tip != 0.0)
    //   items.add(ApplePayItem(
    //     label: 'Tip',
    //     amount: tip.toString(),
    //   ));
    // if (taxPercent != 0.0) {
    //   tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    //   items.add(ApplePayItem(
    //     label: 'Tax',
    //     amount: tax.toString(),
    //   ));
    // }
    items.add(ApplePayItem(
      label: 'Vendor A',
      amount: (totalCost/* + tip + tax*/).toString(),
    ));
    int amount = ((totalCost/* + tip + tax*/) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');

    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    Token token = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        totalPrice: (totalCost/* + tax + tip*/).toStringAsFixed(2),
        currencyCode: 'EUR',
      ),
      applePayOptions: ApplePayPaymentOptions(
        countryCode: 'FR',
        currencyCode: 'EUR',
        items: items,
      ),
    );

    paymentMethod = await StripePayment.createPaymentMethod(
      PaymentMethodRequest(
        card: CreditCard(
          token: token.tokenId,
        ),
      ),
    );

    // paymentMethod != null
    //     ? processPaymentAsDirectCharge(paymentMethod)
    //     : showDialog(
    //         context: context,
    //         builder: (BuildContext context) => ShowDialogToDismiss(
    //             title: 'Error',
    //             content:
    //                 'It is not possible to pay with this card. Please try again with a different card',
    //             buttonText: 'CLOSE'));
  }

  Future<void> createPaymentMethod(double totalCost) async {
    StripePayment.setStripeAccount(null);

    // double tax = ((totalCost * taxPercent) * 100).ceil() / 100;
    int amount = ((totalCost/* + tip + tax*/) * 100).toInt();
    print('amount in pence/cent which will be charged = $amount');

    //step 1: add card
    PaymentMethod paymentMethod = PaymentMethod();
    paymentMethod = await StripePayment.paymentRequestWithCardForm(
      CardFormPaymentRequest(),
    ).then((PaymentMethod paymentMethod) {
      return paymentMethod;
    }).catchError((e) {
      print('Errore Card: ${e.toString()}');
    });
    // paymentMethod != null
    //     ? processPaymentAsDirectCharge(paymentMethod)
    //     : showDialog(
    //         context: context,
    //         builder: (BuildContext context) => ShowDialogToDismiss(
    //             title: 'Error',
    //             content:
    //                 'It is not possible to pay with this card. Please try again with a different card',
    //             buttonText: 'CLOSE'));
  }

  // Future<void> processPaymentAsDirectCharge(PaymentMethod paymentMethod) async {
  //   setState(() { loadings[0] = true; });

  //   //step 2: request to create PaymentIntent, attempt to confirm the payment & return PaymentIntent
  //   final http.Response response = await http
  //       .post('$url?amount=$amount&currency=GBP&paym=${paymentMethod.id}');
  //   print('Now i decode');
  //   if (response.body != null && response.body != 'error') {
  //     final paymentIntentX = jsonDecode(response.body);
  //     final status = paymentIntentX['paymentIntent']['status'];
  //     final strAccount = paymentIntentX['stripeAccount'];

  //     //step 3: check if payment was succesfully confirmed
  //     if (status == 'succeeded') {
  //       //payment was confirmed by the server without need for futher authentification
  //       StripePayment.completeNativePayRequest();
  //       setState(() {
  //         // text = 'Payment completed. ${paymentIntentX['paymentIntent']['amount'].toString()}p succesfully charged';
  //         loadings[0] = false;
  //       });
  //     } else {
  //       //step 4: there is a need to authenticate
  //       StripePayment.setStripeAccount(strAccount);

  //       await StripePayment.confirmPaymentIntent(PaymentIntent(
  //               paymentMethodId: paymentIntentX['paymentIntent']
  //                   ['payment_method'],
  //               clientSecret: paymentIntentX['paymentIntent']['client_secret']))
  //           .then(
  //         (PaymentIntentResult paymentIntentResult) async {
  //           //This code will be executed if the authentication is successful
  //           //step 5: request the server to confirm the payment with
  //           final statusFinal = paymentIntentResult.status;
  //           if (statusFinal == 'succeeded') {
  //             StripePayment.completeNativePayRequest();
  //             setState(() {
  //               loadings[0] = false;
  //             });
  //           } else if (statusFinal == 'processing') {
  //             StripePayment.cancelNativePayRequest();
  //             setState(() {
  //               loadings[0] = false;
  //             });
  //             showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) => ShowDialogToDismiss(
  //                     title: 'Warning',
  //                     content:
  //                         'The payment is still in \'processing\' state. This is unusual. Please contact us',
  //                     buttonText: 'CLOSE'));
  //           } else {
  //             StripePayment.cancelNativePayRequest();
  //             setState(() {
  //               loadings[0] = false;
  //             });
  //             showDialog(
  //                 context: context,
  //                 builder: (BuildContext context) => ShowDialogToDismiss(
  //                     title: 'Error',
  //                     content:
  //                         'There was an error to confirm the payment. Details: $statusFinal',
  //                     buttonText: 'CLOSE'));
  //           }
  //         },
  //         //If Authentication fails, a PlatformException will be raised which can be handled here
  //       ).catchError((e) {
  //         //case B1
  //         StripePayment.cancelNativePayRequest();
  //         setState(() {
  //           loadings[0] = false;
  //         });
  //         showDialog(
  //             context: context,
  //             builder: (BuildContext context) => ShowDialogToDismiss(
  //                 title: 'Error',
  //                 content:
  //                     'There was an error to confirm the payment. Please try again with another card',
  //                 buttonText: 'CLOSE'));
  //       });
  //     }
  //   } else {
  //     //case A
  //    StripePayment.cancelNativePayRequest();
  //     setState(() {
  //       loadings[0] = false;
  //     });
  //     showDialog(
  //         context: context,
  //         builder: (BuildContext context) => ShowDialogToDismiss(
  //             title: 'Error',
  //             content:
  //                 'There was an error in creating the payment. Please try again with another card',
  //             buttonText: 'CLOSE'));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(
        documentNode: gql('''
          query user {
            user {
              id
              firstName
              lastName
              credits
            }
          }
        '''),
        fetchPolicy: FetchPolicy.noCache,
      ),
      builder: (
        QueryResult result, {
        Refetch refetch,
        FetchMore fetchMore,
      }) {

        sop.User user;
        if (result.data != null && result.data["user"] != null && !result.loading) {
          print('Shop user: ' + result.data["user"].toString());
          user = sop.User.fromJSON(result.data["user"]);
        }

        Widget body = Mutation(
          options: MutationOptions(
            documentNode: gql('''
              mutation pay(\$data: PayInput!) {
                pay(data: \$data)
              }
            '''), // this is the mutation string you just created
            // you can update the cache based on results
            update: (Cache cache, QueryResult result) {
              return cache;
            },
            // or do something with the result.data on completion
            onCompleted: (dynamic resultData) {
              // print('onCompleted: ' + resultData.hasException);
            },
          ),
          builder: (
            RunMutation runMutation,
            QueryResult mutationResult,
          ) {
            
            return Container(
              child: ListView(
                children: [
                  ListTileShop(
                    title: '1 crédit',
                    loading: loadings[0],
                    price: 4.99,
                    onPress: () async {
                      StripePayment.paymentRequestWithNativePay(
                        androidPayOptions: AndroidPayPaymentRequest(
                          totalPrice: "1.20",
                          currencyCode: "EUR",
                        ),
                        applePayOptions: ApplePayPaymentOptions(
                          countryCode: 'FR',
                          currencyCode: 'EUR',
                          items: [
                            ApplePayItem(
                              label: 'Test',
                              amount: '13',
                            )
                          ],
                        ),
                      ).then((token) {
                        print('stripe token: ' + token.toString());
                        // setState(() {
                        //   _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Received ${token.tokenId}')));
                        //   _paymentToken = token;
                        // });
                      }).catchError((error) {
                        print('stripe error: ' + error.toString());
                      });
                      // checkIfNativePayReady(runMutation);
                      // MultiSourceResult result = runMutation({
                      //   "data": {
                      //     "amount": 1
                      //   }
                      // });
                
                      // setState(() { loadings[0] = true; });
                      // QueryResult queryResult = await result.networkResult;
                      // setState(() { loadings[0] = false; });
                    }
                  ),
                  Divider(),
                  ListTileShop(
                    title: '5 crédits',
                    loading: loadings[1],
                    price: 19.99,
                    onPress: () async {
                      MultiSourceResult result = runMutation({
                        "data": {
                          "amount": 5
                        }
                      });
                
                      setState(() { loadings[1] = true; });
                      QueryResult queryResult = await result.networkResult;
                      setState(() { loadings[1] = false; });
                    }
                  ),
                  Divider(),
                  ListTileShop(
                    title: '10 crédits',
                    loading: loadings[2],
                    price: 34.99,
                    onPress: () async {
                      MultiSourceResult result = runMutation({
                        "data": {
                          "amount": 10
                        }
                      });
                
                      setState(() { loadings[2] = true; });
                      QueryResult queryResult = await result.networkResult;
                      setState(() { loadings[2] = false; });
                    }
                  )
                ],
              ),
            );
          }
        );

        Widget appBar = AppBar(
          title: Text('Boutique'),
          actions: [// TODO : result.loading doesnt work
            user == null || result.loading || result.data == null ? Container(
              child: IconButton(
                  icon: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator()
                ),
              )
            ) : Container(
              margin: EdgeInsets.only(top: 16, right: 16),
              child: Text(
                user.credits.toString() + ' crédits',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold
                ),
              )
            )
          ],
        );


        return WillPopScope(
          onWillPop: () async => _onWillPop(user),
          child: widget.isPopup ? Scaffold(
            appBar: appBar,
            body: body
          ) : MyScaffold(
            appBar: appBar,
            body: body
          ),
        );
      }
    );
  }
}
