
import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;

import 'package:provider/provider.dart';
import 'package:flutter_tests/providers/NewStateOfPlayProvider.dart';

class NewStateOfPlayProperty extends StatefulWidget {
  NewStateOfPlayProperty({Key key}) : super(key: key);

  @override
  _NewStateOfPlayPropertyState createState() => new _NewStateOfPlayPropertyState();
}

class _NewStateOfPlayPropertyState extends State<NewStateOfPlayProperty> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _refController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _floorController= new TextEditingController();
  TextEditingController _buildingController= new TextEditingController();
  TextEditingController _doorController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  List<sop.Property>  _propertyList;
  sop.Property currentProperty;

  @override
  void initState() {
    _propertyList = new List<sop.Property>();
    _getDropDownMenuItems();
    currentProperty = new sop.Property();
    
    super.initState();
  }

  @override
  void dispose() {
    _refController.dispose();
    _addressController.dispose();
    _floorController.dispose();
    _buildingController.dispose();
    _doorController.dispose();
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
                    child: Text("Known Property's"),
                    onPressed: (){
                      _showSelectKnownPropertyDialog(context);
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
                  child: Consumer<NewStateOfPlayProvider>(
                    builder: (context, newStateOfPlayState, child) {
                      print("in builder for consumer: ");
                      print(newStateOfPlayState.value.property.reference);
                      if (_refController.text != newStateOfPlayState.value.property.reference) {
                        _refController.text = newStateOfPlayState.value.property.reference ?? '';
                      }
                      return TextFormField(
                        controller: _refController,
                        onChanged: (value) {
                          print("TextField new value: ");
                          print(value);
                          newStateOfPlayState.value.property.reference = value;
                          context.read<NewStateOfPlayProvider>().update(newStateOfPlayState.value);
                        },
                        decoration: InputDecoration(
                          labelText: "Property's Ref",
                        ),
                        validator: (String value) {
                          return value.trim().isEmpty ? "required" : null;
                        },
                      );
                    },
                  )
                ),
              ],
            ),
            SizedBox(height: sizedBoxHeight,),             
            Row(
              children: [
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  child: TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: "Property's address",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  child: TextFormField(
                    controller: _floorController,
                    decoration: InputDecoration(
                      labelText: "Property's Floor",
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
                  child: TextFormField(
                    controller: _buildingController,
                    decoration: InputDecoration(
                      labelText: "Property's Building",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  child: TextFormField(
                    controller: _doorController,
                    decoration: InputDecoration(
                      labelText: "Property's Door",
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
                  child: TextFormField(
                    controller: _postalCodeController,
                    decoration: InputDecoration(
                      labelText: "Property's Postal Code",
                    ),
                    validator: (String value) {
                      return value.trim().isEmpty ? "required" : null;
                    },
                  ),
                ),
                SizedBox(width: sizedBoxWidth,),             
                Container(
                  width: MediaQuery.of(context).size.width /3,
                  child: TextFormField(
                    controller: _cityController,
                    decoration: InputDecoration(
                      labelText: "Property's City",
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
                  child: MaterialButton( 
                    child: Text("Save"),
                    color: Colors.blueGrey,
                    onPressed:()  {
                      //_submit(context);

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
      currentProperty.address = _doorController.text;
      currentProperty.postalCode = _postalCodeController.text;
      currentProperty.city = _cityController.text;
      done = true;
    } 
    else{
      _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 
    }
    return done;  
  }
 //TODO Get Propertys List
  void _getDropDownMenuItems() {
    setState(() {
      _propertyList.add(new sop.Property(reference: "ref1", address: "007 Here Street"));
      _propertyList.add(new sop.Property(reference: "ref1", address: "007 Here Street"));
    });
    print('lilength:'+_propertyList.length.toString());
  }

  void _showSelectKnownPropertyDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Property's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Property",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                ),                
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: _propertyList.length,
                    itemBuilder: (BuildContext context, int index) {
                      sop.Property  _property= _propertyList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentProperty = _property;
                            _refController.text = currentProperty.reference;
                            _addressController.text = currentProperty.address;
                            _floorController.text = currentProperty.floor.toString();
                            _buildingController.text = currentProperty.building;
                            _doorController.text = currentProperty.door;
                            _postalCodeController.text = currentProperty.postalCode;
                            _cityController.text = currentProperty.city;
                          });
                        },
                        title: Text(_property.reference+" "+_property.address),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  } 

}