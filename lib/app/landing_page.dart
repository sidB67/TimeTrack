
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/homepage.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';
import 'package:time_tracker_flutter_course/app/sign_in/sign_in_page.dart';
import 'dart:async';
class LandingPage extends StatelessWidget {
   LandingPage({@required this.auth});
  final AuthBase auth;
  
 // ignore: deprecated_member_use
 
 
  // @override
  // void initState() {
    
  //   super.initState();
    
  //   widget.auth.onAuthStateChanged.listen((event) {print('user: ${event?.uid}'); });

  // }
  @override
  Widget build(BuildContext context) {
   return StreamBuilder<FUser>(
     stream: auth.onAuthStateChanged,
     builder: (context,snapshot){
      if(snapshot.connectionState== ConnectionState.active){
        FUser user = snapshot.data;
        if(user==null){
        return SignInPage( auth: auth);
        }
        return HomePage( auth: auth);
      }
           
       
        
      else{
        return Scaffold(body: Center(child: CircularProgressIndicator(),),);
      }
     }
   );
  }
}
