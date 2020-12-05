import 'package:flutter/material.dart';

class NewStateOfPlayInterlocutors extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    double thirdScreen = MediaQuery.of(context).size.height / 3.36;
    double halfScreen = MediaQuery.of(context).size.width / 2;
    double tenthScreen = MediaQuery.of(context).size.width / 70;

    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return  Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: thirdScreen,
            child: Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [ 
                MaterialButton(
                  height: thirdScreen-20,
                  minWidth: halfScreen,
                  onPressed: () => Navigator.pushNamed(context, '/new/owner'),
                  child: Text('Owner')
                ),
                VerticalDivider(endIndent: 20,),
              ],
            ),
          ),
          Container(
            height: thirdScreen,
            child:Row(     
              mainAxisAlignment: MainAxisAlignment.start,
              children: [ 
                MaterialButton(
                  height: thirdScreen,
                  minWidth: halfScreen,
                  onPressed: () => Navigator.pushNamed(context, '/new/estateAgent'),
                  child: Text('Estate Agent')
                ),
                VerticalDivider(),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Nom & Prénom: data"),
                    SizedBox(height:tenthScreen),
                    Text("addresse: data"),
                    SizedBox(height:tenthScreen),
                    Text("infos: data"),
                  ],
                ),
              ],
            ),
          ),
          Container(
            height: thirdScreen,
            child:Row(  
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [ 
                MaterialButton(
                  minWidth: halfScreen,
                  height: thirdScreen-20,
                  onPressed: () => Navigator.pushNamed(context, '/new/tenants'),
                  child: Text('Tenants')
                ),
                VerticalDivider(indent: 20,),
              ],
            ),          
          ),
        ],
      ),              
    );
  }
}