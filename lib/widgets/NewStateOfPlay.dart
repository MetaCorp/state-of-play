import 'package:flutter/material.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/InterlocutorsViews/NewStateOfPlayEstateAgent.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/InterlocutorsViews/NewStateOfPlayTenant.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayDivers.dart';

import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayInterlocutors.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/InterlocutorsViews/NewStateOfPlayOwner.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayProperty.dart';

import 'package:flutter_tests/models/StateOfPlay.dart' as sop;
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlaySignature.dart';
import 'package:flutter_tests/widgets/newStateOfPlay/NewStateOfPlayRoomDetail.dart';

import 'package:provider/provider.dart';

import 'package:flutter_tests/providers/NewStateOfPlayProvider.dart';

class NewStateOfPlay extends StatefulWidget {
  NewStateOfPlay({Key key}) : super(key: key);

  @override
  _NewStateOfPlayState createState() => new _NewStateOfPlayState();
}
//https://api.flutter.dev/flutter/widgets/Navigator-class.html
class _NewStateOfPlayState extends State<NewStateOfPlay>{

  List<int> _pageList = new List<int>();
  int _currentPage;
  Color iconColor = Colors.black;

  @override
  void initState() {
    _fillPageList();
    _currentPage = _pageList[0];
    super.initState();
  }
    
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    double appBarHeight = MediaQuery.of(context).size.height/10;

    return ChangeNotifierProvider(
      create: (context) => NewStateOfPlayProvider(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          centerTitle: true,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
              children :[
                MaterialButton(
                  child: Text("Step 1\nInterlocuteurs", textAlign: TextAlign.center,),
                  onPressed: (){
                    setState(() {
                      _currentPage = 0;
                    });
                  },
                ),
                Icon(Icons.chevron_right_sharp, color: iconColor,),
                MaterialButton(
                  child: Text("Step 2\nPropriété", textAlign: TextAlign.center,),
                  onPressed: (){
                    setState(() {
                      _currentPage = 1;
                    });  
                  },
                ),
                Icon(Icons.chevron_right_sharp, color: iconColor,),

                MaterialButton(
                  child: Text("Step 3\nDétail pièces", textAlign: TextAlign.center,),
                  onPressed: (){
                    setState(() {
                      _currentPage = 2;
                    }); 
                  },
                ),
                Icon(Icons.chevron_right_sharp, color: iconColor,),
                MaterialButton(
                  child: Text("Step 4\nDivers"),
                  onPressed: (){
                    setState(() {
                      _currentPage = 3;
                    }); 
                  },
                ),
                Icon(Icons.chevron_right_sharp, color: iconColor,),
                MaterialButton(
                  child: Text("Step 5\nSignatures", textAlign: TextAlign.center,),
                  onPressed: (){
                    setState(() {
                      _currentPage = 4;
                    }); 
                  },
                ),
              ],
            ),       
          leading: IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              //save state          
            },         
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: () {
                setState(() {
                  //Todo send mails + end Page 
                  _currentPage = _currentPage == 4 ? 4 : _currentPage+=1;
                });
              },
            ),
          ],
        ),
        body: _currentPage == 0 ? NewStateOfPlayInterlocutors() :
              _currentPage == 1 ? NewStateOfPlayProperty() :
              _currentPage == 2 ? NewStateOfPlayRoomDetail() :
              _currentPage == 3 ? NewStateOfPlayDivers() :
              _currentPage == 4 ? NewStateOfPlaySignature() : null,
      ),
    );
  }
  
  void _fillPageList() {
    int step1 = 0;
    int step2 = 1;
    int step3 = 2;
    int step4 = 3;
    int step5 = 4;

    _pageList.add(step1);
    _pageList.add(step2);
    _pageList.add(step3);
    _pageList.add(step4);
    _pageList.add(step5); 
  } 

}
class NewStateOfPlayRouter extends StatefulWidget {
  NewStateOfPlayRouter({Key key}) : super(key: key);

  @override
  _NewStateOfPlayRouterState createState() => new _NewStateOfPlayRouterState();
}

class _NewStateOfPlayRouterState extends State<NewStateOfPlayRouter> {

 @override
  void initState() {
    super.initState();
  }
    
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return Navigator(
      initialRoute: 'new/StateOfPlay',
      onGenerateRoute: (RouteSettings settings) {
        WidgetBuilder builder;
        switch (settings.name) {
          case 'new/StateOfPlay':
          // Assume CollectPersonalInfoPage collects personal info and then
          // navigates to 'signup/choose_credentials'.
            builder = (BuildContext _) => NewStateOfPlay();
            break;
          case '/new/estateAgent':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayEstateAgent();
            break;
          case '/new/tenants':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayTenant();
            break;
          case '/new/owner':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayOwner();
            break;
          case '/new/newProperty':
          // Assume ChooseCredentialsPage collects new credentials and then
          // invokes 'onSignupComplete()'.
            builder = (BuildContext _) => NewStateOfPlayOwner();
            break;
          default:
            throw Exception('Invalid route: ${settings.name}');
        }
        return MaterialPageRoute(builder: builder, settings: settings);
      },
    );   
  }
}
    
   


