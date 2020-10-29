
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


class NewStateOfPlaySignature extends StatefulWidget {
  NewStateOfPlaySignature({Key key}) : super(key: key);

  @override
  _NewStateOfPlaySignatureState createState() => new _NewStateOfPlaySignatureState();
}

class _NewStateOfPlaySignatureState extends State<NewStateOfPlaySignature> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  //List<sop.Signature>  itemList;
  //sop.Signature currentSignature;

  @override
  void initState() {
    //itemList = new List<sop.Signature>();
    _getDropDownMenuItems();
    //currentSignature = new sop.Signature();
    
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

    return SingleChildScrollView(
      reverse: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [  
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  //width: sizedBoxWidth /3,
                  width: MediaQuery.of(context).size.width /3,
                  child: MaterialButton(
                    color: Colors.blueGrey,
                    child: Text("Known Signature's"),
                    onPressed: (){
                      _showSelectKnownSignatureDialog(context);
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                SizedBox(width: sizedBoxWidth,),     
              ],
            ),
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _firstnameController,
                    decoration: InputDecoration(
                      labelText: "Signature's Firstname",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      labelText: "Signature's Lastname",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),     
              ],
            ),
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _companyController,
                    decoration: InputDecoration(
                      labelText: "Signature's Company name",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Signature's Address",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _postalCodeController,
                    decoration: InputDecoration(
                      labelText: "Signature's Postal Code",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: "Signature's City",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),                       
              ],
            ),
            SizedBox(height: sizedBoxHeight,),  
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                SizedBox(width: sizedBoxWidth,),             
                SizedBox(width: MediaQuery.of(context).size.width /3,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                  child: MaterialButton( 
                    child: Text("Save"),
                    color: Colors.blueGrey,
                    onPressed:()  {
                      _submit(context);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight,),  
          ],      
        ),
      ),
    );
  }
  
  bool _submit(BuildContext context){
    bool done = false;
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
/*       currentSignature.address = _addressController.text;
      currentSignature.postalCode = _postalCodeController.text;
      currentSignature.city = _cityController.text; */
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get Signatures List
  void _getDropDownMenuItems() {
    setState(() {

    });
  }

  void _showSelectKnownSignatureDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Signature's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Signature",
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
                      var Signature = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentSignature = Signature;
                            _addressController.text = currentSignature.address;
                            _postalCodeController.text = currentSignature.postalCode;
                            _cityController.text = currentSignature.city;
                          });
                        },
                        title: Text(Signature.reference+" "+Signature.address),
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