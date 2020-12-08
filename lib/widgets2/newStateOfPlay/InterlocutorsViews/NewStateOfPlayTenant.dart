import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


class NewStateOfPlayTenant extends StatefulWidget {
  NewStateOfPlayTenant({Key key}) : super(key: key);

  @override
  _NewStateOfPlayTenantState createState() => new _NewStateOfPlayTenantState();
}

class _NewStateOfPlayTenantState extends State<NewStateOfPlayTenant> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  List<sop.Tenant>  itemList;
  sop.Tenant currentTenant;

  @override
  void initState() {
    itemList = new List<sop.Tenant>();
    _getDropDownMenuItems();
    currentTenant = new sop.Tenant();
    
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
       title: Text('Locataire'),
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
                      child: Text("Known Tenant's"),
                      onPressed: (){
                        _showSelectKnownTenantDialog(context);
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
                        labelText: "Tenant's Firstname",
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
                        labelText: "Tenant's Lastname",
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
                        labelText: "Tenant's Company name",
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
                        labelText: "Tenant's Address",
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
                        labelText: "Tenant's Postal Code",
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
                        labelText: "Tenant's City",
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
      ),
    );
  }
  
  bool _submit(BuildContext context){
    bool done = false;
    print(currentTenant.firstname);
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
      currentTenant.firstname = _firstnameController.text;
      currentTenant.lastname = _lastnameController.text;
      currentTenant.address = _addressController.text;
      currentTenant.postalCode = _postalCodeController.text;
      currentTenant.city = _cityController.text;
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get Tenants List
  void _getDropDownMenuItems() {
    sop.Tenant Tenant = new sop.Tenant(firstname: "Leo", lastname:"Sza", address: "75 rue duTest",postalCode: "94800",city: "Paris");
    sop.Tenant Tenant2 = new sop.Tenant(firstname: "Leo2", lastname:"Sza2");
    setState(() {
      itemList.add(Tenant);
      itemList.add(Tenant2);
    });
    print('lilength:'+itemList.length.toString());
  }

  void _showSelectKnownTenantDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Tenant's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for Tenant",
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
                      var Tenant = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentTenant = Tenant;
                            _firstnameController.text = currentTenant.firstname;
                            _lastnameController.text = currentTenant.lastname;
                            _addressController.text = currentTenant.address;
                            _postalCodeController.text = currentTenant.postalCode;
                            _cityController.text = currentTenant.city;
                          });
                        },
                        title: Text(Tenant.firstname+" "+Tenant.lastname),
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