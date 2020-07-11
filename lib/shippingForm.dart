import 'package:flutter/material.dart';
import 'shippingModel.dart';

class ShippingForm extends StatefulWidget {
  @override
  _ShippingFormState createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  final _formKey = GlobalKey<FormState>();
  String dropdownValue = 'National Capital Territory of Delhi';
  ShippingModel model = ShippingModel();
  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;

    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topCenter,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: MyTextFormField(
                        hintText: 'First Name',
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter your first name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          model.firstName = value;
                        },
                      ),
                    ),
                    Container(
                      alignment: Alignment.topCenter,
                      width: halfMediaWidth,
                      child: MyTextFormField(
                        hintText: 'Last Name',
                        validator: (String value) {
                          if (value.isEmpty) {
                            return 'Enter your last name';
                          }
                          return null;
                        },
                        onSaved: (String value) {
                          model.lastName = value;
                        },
                      ),
                    )
                  ],
                ),
              ),
              MyTextFormField(
                hintText: 'Address',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter your address';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.address = value;
                },
              ),
              MyTextFormField(
                hintText: 'City',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter your city';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.city = value;
                },
              ),
              MyTextFormField(
                hintText: 'Pincode',
                validator: (String value) {
                  if (value.isEmpty) {
                    return 'Enter your pincode';
                  }
                  return null;
                },
                onSaved: (String value) {
                  model.pinCode = value;
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: dropdownValue,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 24,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 2,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      dropdownValue = newValue;
                      model.state = dropdownValue;
                    });
                  },
                  items: <String>[
                    'Andaman and Nicobar Islands',
                    'Andhra Pradesh',
                    'Arunachal Pradesh',
                    'Assam',
                    'Bihar',
                    'Chandigarh',
                    'Chhattisgarh',
                    'Dadra and Nagar Haveli',
                    'Daman and Diu',
                    'Goa',
                    'Gujarat',
                    'Haryana',
                    'Himachal Pradesh',
                    'Jammu and Kashmir',
                    'Jharkhand',
                    'Karnataka',
                    'Kerala',
                    'Lakshadweep',
                    'Madhya Pradesh',
                    'Maharashtra',
                    'Manipur',
                    'Meghalaya',
                    'Mizoram',
                    'Nagaland',
                    'National Capital Territory of Delhi',
                    'Odisha',
                    'Pondicherry',
                    'Punjab',
                    'Rajasthan',
                    'Sikkim',
                    'Tamil Nadu',
                    'Telangana',
                    'Tripura',
                    'Uttar Pradesh',
                    'Uttarakhand',
                    'West Bengal',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
                child: RaisedButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      Navigator.pushNamed(
                        context,
                        '/paymentPage',
                        arguments: ShippingModel(
                          firstName: model.firstName,
                          lastName: model.lastName,
                          address: model.address,
                          city: model.city,
                          state: model.state,
                          pinCode: model.pinCode,
                        ),
                      );
                    }
                  },
                  child: Text(
                    'Update Details',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MyTextFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;
  MyTextFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(25, 10, 25, 10),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}
