import 'package:flutter/material.dart';

class NewStateOfPlayInterlocutors extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // SignUpPage builds its own Navigator which ends up being a nested
    // Navigator in our app.
    return  Container(
      child: Row(
        children: [
          Column(
            children: [
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context, '/new/owner'),
                child: Text('Owner')
              ),
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context, '/new/estateAgent'),
                child: Text('Estate Agent')
              ),
            ],
          ),
          Column(
            children: [
              //add co-tenant !! must be held as list !
              RaisedButton(
                onPressed: () => Navigator.pushNamed(context, '/new/tenants'),
                child: Text(
                  'Tenants'
                )
              ),
            ],
          ),           
        ]
      )
    );
  }
}