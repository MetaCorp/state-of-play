import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/utilities/IconButtonLoading.dart';

import 'package:feature_discovery/feature_discovery.dart';

import 'package:open_file/open_file.dart';
import 'package:flutter_tests/GeneratePdf.dart';
import 'package:flutter_tests/widgets/shop/Shop.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayDetails/NewStateOfPlayDetails.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayMisc/NewStateOfPlayMisc.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/newStateOfPlayInterlocutors/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/stateOfPlay/newStateOfPlay/NewStateOfPlaySignature/NewStateOfPlaySignature.dart';

import 'package:flutter_pdfview/flutter_pdfview.dart';

typedef SaveCallback = void Function();
typedef DeleteCallback = void Function();

class NewStateOfPlayContent extends StatefulWidget {
  NewStateOfPlayContent({ Key key, this.stateOfPlay, this.onSave, this.title, this.onDelete, this.saveLoading, this.user }) : super(key: key);
  
  final String title;
  final sop.StateOfPlay stateOfPlay;
  final SaveCallback onSave;
  final DeleteCallback onDelete;
  final bool saveLoading;
  final sop.User user;

  @override
  _NewStateOfPlayContentState createState() => new _NewStateOfPlayContentState();
}

class _NewStateOfPlayContentState extends State<NewStateOfPlayContent> {

  final _formKey = GlobalKey<FormState>();
  
  int _selectedIndex = 0;
  bool _isPdfLoading = false;

  @override
  void initState() { 
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((Duration duration) {
      Future.delayed(const Duration(seconds: 1), () => FeatureDiscovery.discoverFeatures(
        context,
        const <String>{
          'navigate_newsop',
          'add_interlocutor',
          'select_interlocutor'
        },
      )); 
    });
  }

  void onNext() {
    print('property: ' + widget.stateOfPlay.property.address);
    setState(() {
      _selectedIndex = _selectedIndex + 1;
    });
  }

  void _showDialogDelete(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Supprimer '" + widget.stateOfPlay.property.address + ', ' + widget.stateOfPlay.property.postalCode + ' ' + widget.stateOfPlay.property.city + "' ?"),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('SUPPRIMER'),
            onPressed: () {
              widget.onDelete();
            }
          )
        ],
      )
    );
  }
  
  void _showDialogCompleteInterlocutors(context) async {
    await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Pour accéder à la page 'Signatures', veuillez compléter les champs Propriétaire, Mandataire, Locataires et Propriété de la page 'Interlocuteurs'."),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context);
            }
          ),
          new FlatButton(
            child: Text('COMPLÉTER'),
            onPressed: () async {
              Navigator.pop(context);
              setState(() { _selectedIndex = 0; });
            }
          )
        ],
      )
    );
  }
  
  Future<bool> _showDialogPay(context) async {
    return await showDialog(
      context: context,
      child: AlertDialog(
        content: Text("Pour générer le pdf d'état des lieux, il vous faut 1 crédit que vous pouvez acheter dans notre boutique."),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context, false);
            }
          ),
          new FlatButton(
            child: Text('BOUTIQUE'),
            onPressed: () async {
              bool ret = await Navigator.push(context, PageRouteBuilder(pageBuilder: (_, __, ___) => Shop(isPopup: true,)));
              Navigator.pop(context, ret);
            }
          )
        ],
      )
    );
  }

  Future<bool> _showDialogConfirmPay(context) async {
    
    return await showDialog(
      context: context,
      child: AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text("Vous vous apprétez à dépenser 1 crédit pour la génération du pdf d'état des lieux. (" + widget.user.credits.toString() + " crédit" + (widget.user.credits > 1 ? "s": "") + " disponible" + (widget.user.credits > 1 ? "s": "") + ".)"),
            SizedBox(height: 16),
            Container(  
              height: 300,  
              decoration: BoxDecoration(// TODO: can't use a Flexible inside BoxDecoration
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10),
                    topRight: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    bottomRight: Radius.circular(10)
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: PDFView(
                defaultPage: 0,
                fitEachPage: false,
                filePath: widget.stateOfPlay.newPdf.path,
                enableSwipe: false,
                swipeHorizontal: false,
                autoSpacing: true,
                pageFling: true,
                // onRender: (_pages) {
                //   setState(() {
                //     pages = _pages;
                //     isReady = true;
                //   });
                // },
                onError: (error) {
                  print(error.toString());
                },
                // onPageError: (page, error) {
                //   print('$page: ${error.toString()}');
                // },
                // onViewCreated: (PDFViewController pdfViewController) {
                //   .complete(pdfViewController);
                // },
                // onPageChanged: (int page, int total) {
                //   print('page change: $page/$total');
                // },
                ),
              )          
          ],
        ),
        actions: [
          new FlatButton(
            child: Text('ANNULER'),
            onPressed: () {
              Navigator.pop(context, false);
            }
          ),
          new FlatButton(
            child: Text('CONFIRMER'),
            onPressed: () async {
              Navigator.pop(context, true);
            }
          )
        ],
      )
    );
  }

  _onSave() async {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      bool ret = false;
      // TODO : abonnement LEO
      if (widget.user.credits == 0) {
        ret = await _showDialogPay(context);
      }

      if (ret || widget.user.credits > 0) {

        setState(() { _isPdfLoading = true; });
        
        for (var i = 0; i < widget.stateOfPlay.rooms.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.rooms[i].decorations.length; j++) {
            
            for (var k = 0; k < widget.stateOfPlay.rooms[i].decorations[j].images.length; k++) {
              
              widget.stateOfPlay.rooms[i].decorations[j].imageIndexes.add(widget.stateOfPlay.images.length);

              widget.stateOfPlay.images.add({
                "type": "network",
                "image": widget.stateOfPlay.rooms[i].decorations[j].images[k]
              });
            }

            for (var k = 0; k < widget.stateOfPlay.rooms[i].decorations[j].newImages.length; k++) {
              
              widget.stateOfPlay.rooms[i].decorations[j].imageIndexes.add(widget.stateOfPlay.images.length);

              widget.stateOfPlay.images.add({
                "type": "file",
                "image": widget.stateOfPlay.rooms[i].decorations[j].newImages[k]
              });

            }
          }
        }

        for (var i = 0; i < widget.stateOfPlay.meters.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.meters[i].images.length; j++) {
            
            widget.stateOfPlay.meters[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "network",
              "image": widget.stateOfPlay.meters[i].images[j]
            });
          }

          for (var j = 0; j < widget.stateOfPlay.meters[i].newImages.length; j++) {
            
            widget.stateOfPlay.meters[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "file",
              "image": widget.stateOfPlay.meters[i].newImages[j]
            });
          }
        }

        for (var i = 0; i < widget.stateOfPlay.keys.length; i++) {
          
          for (var j = 0; j < widget.stateOfPlay.keys[i].images.length; j++) {
            
            widget.stateOfPlay.keys[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "network",
              "image": widget.stateOfPlay.keys[i].images[j]
            });
          }

          for (var j = 0; j < widget.stateOfPlay.keys[i].newImages.length; j++) {
            
            widget.stateOfPlay.keys[i].imageIndexes.add(widget.stateOfPlay.images.length);

            widget.stateOfPlay.images.add({
              "type": "file",
              "image": widget.stateOfPlay.keys[i].newImages[j]
            });
          }
        }

        widget.stateOfPlay.newPdf = await generatePdf(widget.stateOfPlay);
        print('generatedPdf: ' + widget.stateOfPlay.newPdf.toString());

        
        bool retConfirmPay = await _showDialogConfirmPay(context);
        if (retConfirmPay == null || !retConfirmPay) {
          setState(() { _isPdfLoading = false; });
          return;}

        widget.onSave();
        OpenFile.open(widget.stateOfPlay.newPdf.path);
        setState(() { _isPdfLoading = false; });
      }

    }
  }

  @override
  Widget build(BuildContext context) {

    final List<Widget> _tabsContent = [
      NewStateOfPlayInterlocutors(
        stateOfPlay: widget.stateOfPlay,
      ),
      // NewStateOfPlayProperty(
      //   property: widget.stateOfPlay.property,
      //   onNext: onNext,
      // ),
      NewStateOfPlayDetails(
        rooms: widget.stateOfPlay.rooms,
      ),
      NewStateOfPlayMisc(
        stateOfPlay: widget.stateOfPlay,
      ),
      NewStateOfPlaySignature(
        stateOfPlay: widget.stateOfPlay,
        onSave: _onSave,
        formKey: _formKey,
        isPdfLoading: _isPdfLoading,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [// TODO : isPdfLoading doesnt work
          _selectedIndex == _tabsContent.length - 1 ? IconButtonLoading(
            loading: widget.saveLoading || _isPdfLoading,
            icon: Icon(Icons.check),
            onPressed: () => _onSave(),
          ) : Container(),
          widget.onDelete != null ? PopupMenuButton(
            icon: Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text("Supprimer"),
                value: "delete",
              )
            ],
            onSelected: (result) {
              print("onSelected: " + result);
              if (result == "delete")
                _showDialogDelete(context);
            }
          ) : Container(),
        ]
      ),
      body: _tabsContent[_selectedIndex],
      bottomNavigationBar: SizedBox(
        // height: 70,
          child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
              icon: DescribedFeatureOverlay(
                featureId: 'navigate_newsop',
                tapTarget: Icon(Icons.group),
                title: Text("Naviguez"),
                description: Text("Pour naviguer facilement entre les différentes étapes de la création d'un état des lieux, utilisez la bar en bas de l'app."),
                child: Icon(Icons.group),
                // SizedBox(
                //     height: 30,
                //     child: Stack(
                //     alignment: Alignment.topCenter,
                //     children: [
                //       Icon(Icons.group),
                //       Positioned(
                //         top: 15.0,
                //         child: Stack(
                //           alignment: Alignment.center,
                //             children: <Widget>[
                //               Icon(
                //                 Icons.brightness_1,
                //                 size: 20.0, color: Colors.transparent,),//Colors.green[800]),
                //               Center(
                //                 child: Positioned(
                //                   child: Text("1"),
                //                   ),
                //               ),                                                                     
                //             ],
                //         )
                //       ),
                //     ],
                //   ),
                // ) 
              ),
              label: 'Interlocuteurs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.apps),
              label: 'Pièces',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'Divers',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.edit),
              label: 'Signatures',
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.white,
          backgroundColor: Colors.grey,
          onTap: (index) {
            if (index == 3 && ((widget.stateOfPlay.owner == null || widget.stateOfPlay.owner.lastName == null)
              || (widget.stateOfPlay.representative == null || widget.stateOfPlay.representative.lastName == null)
              || (widget.stateOfPlay.property == null || widget.stateOfPlay.property.address == null)
              || (widget.stateOfPlay.tenants.length == 0))) {
              _showDialogCompleteInterlocutors(context);
              return;
            }

            setState(() { _selectedIndex = index; });
          },
        ),
      )
    );
  }
}
