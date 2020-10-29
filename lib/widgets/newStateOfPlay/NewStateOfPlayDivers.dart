
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


class NewStateOfPlayDivers extends StatefulWidget {
  NewStateOfPlayDivers({Key key}) : super(key: key);

  @override
  _NewStateOfPlayDiversState createState() => new _NewStateOfPlayDiversState();
}

class _NewStateOfPlayDiversState extends State<NewStateOfPlayDivers> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  //List<sop.Divers>  itemList;
  //sop.Divers currentDivers;
  List<sop.Equipment> _equipementList;
  bool isSwitched = false;

  @override
  void initState() {
    //itemList = new List<sop.Divers>();
    _equipementList = new List<sop.Equipment>();
    _getDropDownMenuItems();
    //currentDivers = new sop.Divers();
    
    super.initState();
  }

  @override
  void dispose() {
    _firstnameController.dispose();
    _lastnameController.dispose();
    _companyController.dispose();
    _addressController.dispose();
    _postalCodeController.dispose();
    _cityController.dispose();

    super.dispose();
  }
    
  @override
  Widget build(BuildContext context) {

    double sizedBoxWidth = MediaQuery.of(context).size.width / 9;
    double sizedBoxHeight = MediaQuery.of(context).size.height / 22;    
    final bottom = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      child: Row(
        children: [
          Expanded(
            flex: 30,
            child: Container(
              color: Colors.blueGrey,
              child: Column(
                children: [
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: _equipementList.length+1,
                    itemBuilder: (BuildContext context, int index) {
                      if(index == 0){
                        return Row(
                          children: [
                            SizedBox(width: sizedBoxWidth/8),
                            Text("Liste des pièces", textScaleFactor: 2,),
                            SizedBox(width: sizedBoxWidth/8),
                            MaterialButton(
                              minWidth: sizedBoxWidth/7,
                              color: Colors.red,
                              child: Icon(Icons.add),
                              onPressed: (){
                                print("pressed");
                              },
                            ),
                          ],
                        );
                      }
                      index -=1;
                      var equipement = _equipementList[index];
                      return ListTile(
                        title: Text(equipement.type),
                        trailing: Switch(
                          value: isSwitched,
                          onChanged: (bool value) { 
                            setState(() {
                              print("pressed");
                              isSwitched = value;
                            });
                          }, 
                        ),
                        onTap: (){
                          setState(() {

                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ), 
          ),          
          Expanded(
            flex: 70,
            child: Container(
              color: Colors.red
            ), 
          ),
        ],
      ),
    );
  }
  
  bool _submit(BuildContext context){
    bool done = false;
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
/*       currentDivers.address = _addressController.text;
      currentDivers.postalCode = _postalCodeController.text;
      currentDivers.city = _cityController.text; */
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get Diverss List
  void _getDropDownMenuItems() {
    setState(() {
      _equipementList.add(sop.Equipment(type: 'Clées'));
    });
  }

  void _showSelectKnownDiversDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Divers's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Divers",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                ),                
                /* SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var Divers = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentDivers = Divers;
                            _addressController.text = currentDivers.address;
                            _postalCodeController.text = currentDivers.postalCode;
                            _cityController.text = currentDivers.city;
                          });
                        },
                        title: Text(Divers.reference+" "+Divers.address),
                      );
                    },
                  ),
                ), */
              ],
            ),
          ),
        );
      }
    );
  } 

}