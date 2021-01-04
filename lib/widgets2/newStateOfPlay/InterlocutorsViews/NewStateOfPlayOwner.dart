import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


class NewStateOfPlayOwner extends StatefulWidget {
  NewStateOfPlayOwner({Key key}) : super(key: key);

  @override
  _NewStateOfPlayOwnerState createState() => new _NewStateOfPlayOwnerState();
}

class _NewStateOfPlayOwnerState extends State<NewStateOfPlayOwner> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  List<sop.Owner>  itemList;
  sop.Owner currentOwner;

  @override
  void initState() {
    itemList = new List<sop.Owner>();
    _getDropDownMenuItems();
    currentOwner = new sop.Owner();
    
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

    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        centerTitle: true,
       title: Text('Propriétaire'),
        leading: GestureDetector(
          child: Icon(Icons.arrow_back),
          onTap: () {
            MediaQuery.of(context).viewInsets.bottom == 0 ? 
            Navigator.pop(context) : FocusScope.of(context).unfocus() ;
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              //save state
              if(_submit(context)){
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                      child: Text("Known Owner's"),
                      onPressed: (){
                        _showSelectKnownOwnerDialog(context);
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
                    child: TextFormField(
                      controller: _firstnameController,
                      decoration: InputDecoration(
                        labelText: "Owner's Firstname",
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
                      controller: _lastnameController,
                      decoration: InputDecoration(
                        labelText: "Owner's Lastname",
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
                      controller: _companyController,
                      decoration: InputDecoration(
                        labelText: "Owner's Company name",
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
                    child: TextFormField(
                      controller: _addressController,
                      decoration: InputDecoration(
                        labelText: "Owner's Address",
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
                    child: TextFormField(
                      controller: _postalCodeController,
                      decoration: InputDecoration(
                        labelText: "Owner's Postal Code",
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
                        labelText: "Owner's City",
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
      ),
    );
  }
  
  bool _submit(BuildContext context){
    bool done = false;
    debugPrint(currentOwner.firstname);
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
      currentOwner.firstname = _firstnameController.text;
      currentOwner.lastname = _lastnameController.text;
      currentOwner.company = _companyController.text;
      currentOwner.address = _addressController.text;
      currentOwner.postalCode = _postalCodeController.text;
      currentOwner.city = _cityController.text;
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get Owners List
  void _getDropDownMenuItems() {
    sop.Owner owner = new sop.Owner(firstname: "Leo", lastname:"Sza",company: "yolo", address: "75 rue duTest",postalCode: "94800",city: "Paris");
    sop.Owner owner2 = new sop.Owner(firstname: "Leo2", lastname:"Sza2");
    setState(() {
      itemList.add(owner);
      itemList.add(owner2);
    });
    debugPrint('lilength:'+itemList.length.toString());
  }

  void _showSelectKnownOwnerDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Owner's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Owner",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0))),
                  ),
                ),                
                SingleChildScrollView(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: itemList.length,
                    itemBuilder: (BuildContext context, int index) {
                      var owner = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentOwner = owner;
                            _firstnameController.text = currentOwner.firstname;
                            _lastnameController.text = currentOwner.lastname;
                            _companyController.text = currentOwner.company; 
                            _addressController.text = currentOwner.address;
                            _postalCodeController.text = currentOwner.postalCode;
                            _cityController.text = currentOwner.city;
                          });
                        },
                        title: Text(owner.firstname+" "+owner.lastname),
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