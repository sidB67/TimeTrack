import 'package:flutter/material.dart';
import 'dart:async';

import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alertdialog.dart';
class HomePage extends StatelessWidget {
  HomePage({@required this.auth});
  
  final AuthBase auth;
  Future <void> _signOut() async{
    try{
      await auth.signOut();
      
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async{
   final didRequestSignOut = await PlatformAlertDialog(title: 'Logout', 
    content: 'Are You Sure You Want to Logout?', 
    defaultActionText: 'Logout',
    cancelActionText: 'Cancel',
    ).show(context);

    if(didRequestSignOut==true){
      _signOut();
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Home Page',
        ),
        actions: [
          FlatButton(
              child: Text(
            'Logout',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
          onPressed: ()=> _confirmSignOut(context),
          ),
        ],
      ),
    );
  }
}
