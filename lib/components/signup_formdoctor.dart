import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:appointmentapp/api-sql/apiCon.dart';
import 'package:appointmentapp/api-sql/user.dart';
import 'package:appointmentapp/screens/auth_page.dart';

import 'package:appointmentapp/utils/config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:appointmentapp/components/button.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';

import 'package:intl/intl.dart';

import '../api-sql/doctoruser.dart';

class SignupFormDoctor extends StatefulWidget {
  const SignupFormDoctor({Key? key}) : super(key: key);

  @override
  State<SignupFormDoctor> createState() => _SignupFormDoctorState();
}

class _SignupFormDoctorState extends State<SignupFormDoctor> {
  bool obsecurePass = true;
  DateTime pickedDate = DateTime.now();
  String? _selectedSpecialization; // Add this variable to store the selected specialization

  // List of specializations for the dropdown
  final List<Map<String, String>> specializations = [
    {'id': '1', 'name': 'General'},
    {'id': '2', 'name': 'Carediology'},
    {'id': '3', 'name': 'Respirations'},
    {'id': '4', 'name': 'Dermatology'},
    {'id': '5', 'name': 'Gymecology'},
    {'id': '6', 'name': 'Dental'},
    // Add more specializations as needed
  ];
  final _nameController = TextEditingController();
  final _passController = TextEditingController();
  final _emailController = TextEditingController();
  final _birthController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _experienceController = TextEditingController();
  final _hospitalAffiliation = TextEditingController();
  final _educationController = TextEditingController();
  final _aboutDoctorController = TextEditingController();

  Future<void> validateUserEmail() async {

    try {
      final Uri uri = Uri.parse('${API.validateEmail}?Email=${_emailController.text.trim()}');
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final resBody = jsonDecode(response.body);

        if (resBody['emailFound'] != null && resBody['emailFound'] == true) {
          Fluttertoast.showToast(
              msg: 'This Email already exists. Forgot your password?');
        }
        else{
          print("hi");
          saveUserValue();
        }
      } else {
        Fluttertoast.showToast(
            msg: 'Request failed with status: ${response.statusCode}');
      }
    } catch (e) {


      Fluttertoast.showToast(msg: e.toString());
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
saveUserValue() async{

/*
  final List<String> dateParts = _birthController.text.trim().split('/');
  final String formattedDate = '${dateParts[2]}-${dateParts[1]}-${dateParts[0]}';
  final DateTime parsedDate = DateTime.parse(formattedDate);*/
    DoctorUser userModel =DoctorUser(
        1,
        _nameController.text.toString().trim()
        , _passController.text.toString().trim(),
        _emailController.text.toString().trim(),
        pickedDate.toString()
        , _addressController.text.toString().trim()
        , _phoneController.text.toString().trim()
        , _selectedSpecialization!
        ,  _experienceController.text.toString().trim()
        , _hospitalAffiliation.text.toString().trim()
        , _educationController.text.toString().trim()
        , _aboutDoctorController.text.toString().trim())


    ;
    try{
     var res= await http.post(
        Uri.parse(API.signupdoctor),
        body: userModel.toJson(),
      );

     if(res.statusCode==200){
       var resBody=jsonDecode(res.body);

       if(resBody['success']==true){
         print("hi");
         Fluttertoast.showToast(
             msg: 'Congrats Your SignedUP Successfully');

         Future.delayed(Duration(milliseconds: 1000), () {
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => const AuthPage(),
             ),
           );
         });

       }
       else{
         print(resBody['success']);
         Fluttertoast.showToast(
             msg: 'Failed, Please try again');
       }

     }
    }
    catch(e){
      Fluttertoast.showToast(
          msg: 'Congrats Your SignedUP Successfully');

      Future.delayed(Duration(milliseconds: 1000), () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const AuthPage(),
          ),
        );
      });
    }
      /*
      Fluttertoast.showToast(
          msg: e.toString());
    }*/
}

  @override
  Widget build(BuildContext context) {
    Config().init(context);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 15,
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Wrap the Column with SingleChildScrollView
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Center(
                  child: Image.asset(
                    'assets/logo.png',
                  ),
                ),
                const Text(
                  'Create New Account',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _nameController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Full Name',
                    labelText: 'Name',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.person),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _passController,
                  keyboardType: TextInputType.visiblePassword,
                  cursorColor: Config.primaryColor,
                  obscureText: obsecurePass,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    labelText: 'Password',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.lock_outline),
                    prefixIconColor: Config.primaryColor,
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          obsecurePass = !obsecurePass;
                        });
                      },
                      icon: obsecurePass
                          ? const Icon(
                        Icons.visibility_off_outlined,
                        color: Colors.black38,
                      )
                          : const Icon(
                        Icons.visibility_outlined,
                        color: Config.primaryColor,
                      ),
                    ),
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Email Address',
                    labelText: 'Email',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.email),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                CupertinoButton(
                  disabledColor: Colors.black,
                  child: Text(
                    'Birth Date : ${DateFormat('dd/MM/yyyy').format(pickedDate)}',
                    style: TextStyle(
                      fontSize: 25,
                      color: Config.primaryColor,
                    ),
                  ),
                  onPressed: () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: pickedDate,
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => pickedDate = newDate);
                      },
                    ),
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _addressController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Address',
                    labelText: 'Address',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.live_tv),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _phoneController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Phone number',
                    labelText: 'Number',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.phone),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _experienceController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Years Of Experience',
                    labelText: 'Years Of Experience',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.time_to_leave),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _hospitalAffiliation,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Hospital Affiliation',
                    labelText: 'Hospital Affiliation',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.local_hospital),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),

                Config.spaceSmall,
                TextFormField(
                  controller: _educationController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'Education',
                    labelText: 'Education',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.cast_for_education),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                TextFormField(
                  controller: _aboutDoctorController,
                  keyboardType: TextInputType.text,
                  cursorColor: Config.primaryColor,
                  decoration: const InputDecoration(
                    hintText: 'About You',
                    labelText: 'About You',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.pattern),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                DropdownButtonFormField<String>(
                  value: _selectedSpecialization,
                  onChanged: (newValue) {
                    setState(() {
                      _selectedSpecialization = newValue;
                    });
                  },
                  items: specializations.map((spec) {
                    return DropdownMenuItem<String>(
                      value: spec['id'],
                      child: Text(spec['name']!),
                    );
                  }).toList(),
                  decoration: const InputDecoration(
                    hintText: 'Select Specialization',
                    labelText: 'Specialization',
                    alignLabelWithHint: true,
                    prefixIcon: Icon(Icons.category),
                    prefixIconColor: Config.primaryColor,
                  ),
                ),
                Config.spaceSmall,
                Button(
                  width: double.infinity,
                  title: 'Sign up ',
                  onPressed:() {

                    if( _nameController.text.toString().trim() ==''|| _passController.text.toString().trim() ==''|| _emailController.text.toString().trim() ==''
                    ||  _addressController.text.toString().trim() =='' || _phoneController.text.toString().trim() ==''
                        || _experienceController .text.toString().trim() ==''|| _educationController.text.toString().trim() ==''
                        || _hospitalAffiliation.text.toString().trim() ==''|| _aboutDoctorController.text.toString().trim() ==''
                    ){
                      Fluttertoast.showToast(
                          msg: 'Failed, Please Fill All The Data !!!');
                    }
                    else {

                      validateUserEmail();
                    }
                  } ,
                  disable: false ,
                ),
                Config.spaceSmall,
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AuthPage(),
                        ),
                      );
                    },
                    child: const Text(
                      'Login to your account',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
