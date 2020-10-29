import 'package:flutter/material.dart';
import 'package:flutter_tests/models/StateOfPlay.dart' as sop;


class NewStateOfPlayEstateAgent extends StatefulWidget {
  NewStateOfPlayEstateAgent({Key key}) : super(key: key);

  @override
  _NewStateOfPlayEstateAgentState createState() => new _NewStateOfPlayEstateAgentState();
}

class _NewStateOfPlayEstateAgentState extends State<NewStateOfPlayEstateAgent> {

  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _firstnameController= new TextEditingController();
  TextEditingController _lastnameController= new TextEditingController();
  TextEditingController _companyController= new TextEditingController();
  TextEditingController _addressController= new TextEditingController();
  TextEditingController _postalCodeController= new TextEditingController();
  TextEditingController _cityController= new TextEditingController();

  List<sop.Owner>  itemList;
  sop.Owner currentEstateAgent;

  @override
  void initState() {
    itemList = new List<sop.Owner>();
    _getDropDownMenuItems();
    currentEstateAgent = new sop.Owner();
    
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
       title: Text('Agent immobilier'),
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
                      child: Text("Known EstateAgent's"),
                      onPressed: (){
                        _showSelectKnownEstateAgentDialog(context);
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
                        labelText: "EstateAgent's Firstname",
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
                        labelText: "EstateAgent's Lastname",
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
                        labelText: "EstateAgent's Company name",
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
                        labelText: "EstateAgent's Address",
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
                        labelText: "EstateAgent's Postal Code",
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
                        labelText: "EstateAgent's City",
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
    print(currentEstateAgent.firstname);
    if (_formKey.currentState.validate() ) {
      _formKey.currentState.save();
      currentEstateAgent.firstname = _firstnameController.text;
      currentEstateAgent.lastname = _lastnameController.text;
      currentEstateAgent.company = _companyController.text;
      currentEstateAgent.address = _addressController.text;
      currentEstateAgent.postalCode = _postalCodeController.text;
      currentEstateAgent.city = _cityController.text;
      done = true;
    }
    
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Required Field's aren't filled"))); 

    return done;  
  }
 //TODO Get EstateAgents List
  void _getDropDownMenuItems() {
    sop.Owner owner = new sop.Owner(firstname: "Leo", lastname:"Sza",company: "yolo", address: "75 rue duTest",postalCode: "94800",city: "Paris");
    sop.Owner owner2 = new sop.Owner(firstname: "Leo2", lastname:"Sza2");
    setState(() {
      itemList.add(owner);
      itemList.add(owner2);
    });
    print('lilength:'+itemList.length.toString());
  }

  void _showSelectKnownEstateAgentDialog(context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("EstateAgent's List"),
          content: Container(
            height: MediaQuery.of(context).size.height /1.5,
            width: MediaQuery.of(context).size.width /3,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    labelText: "Search for EstateAgent",
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
                      var estateAgent = itemList[index];
                      return ListTile(
                        onTap: (){
                          setState(() {
                            currentEstateAgent = estateAgent;
                            _firstnameController.text = currentEstateAgent.firstname;
                            _lastnameController.text = currentEstateAgent.lastname;
                            _companyController.text = currentEstateAgent.company; 
                            _addressController.text = currentEstateAgent.address;
                            _postalCodeController.text = currentEstateAgent.postalCode;
                            _cityController.text = currentEstateAgent.city;
                          });
                        },
                        title: Text(estateAgent.firstname+" "+estateAgent.lastname),
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