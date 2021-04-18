
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

enum EmailSignInFormType{signIn,register}

class EmailSignInForm extends StatefulWidget with EmailandPasswordValidators {
  EmailSignInForm({@required this.auth});
  final AuthBase auth; 
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
   final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passFocusNode = FocusNode();
  String get _email=> _emailController.text;
  String get _pass=>  _passController.text;

  EmailSignInFormType _formType= EmailSignInFormType.signIn;
  bool _submitted = false;
  bool _isLoading = false;
  void _submit()async{
    setState(() {
      _submitted=true;
      _isLoading=true;
    });
    try{
    
    if(_formType== EmailSignInFormType.signIn){
      await widget.auth.signInWithEmailAndPassword(_email,_pass);
    }
    else{
      await widget.auth.createUserWithEmailAndPassword(_email, _pass);
    }
    Navigator.of(context).pop();
    }catch(e){print(e.toString());
    }finally{
      setState(() {
        _isLoading=false;
      });
    }
  }
  void _toggleFormType(){
    setState(() {
      _formType=_formType==EmailSignInFormType.signIn?
        EmailSignInFormType.register:EmailSignInFormType.signIn;
      _submitted=false;
    });
    _emailController.clear();
    _passController.clear();
  }
  void _emailEditingComplete(){
    final newFocus = widget.emailValidator.isValid(_email)
    ? _passFocusNode:_emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }
  List<Widget> _buildChildren(){
    final primaryText = _formType==EmailSignInFormType.signIn?
                        'Sign In': 'Create an account';
    final secondaryText = _formType==EmailSignInFormType.signIn?
                        'Need an account? Register':
                        'Have an acoount? Sign In';
    bool submitEnabled = widget.emailValidator.isValid(_email)&&
                          widget.passwordValidator.isValid(_pass)
                          && !_isLoading;
    return [
      _buildEmailTextField(),
      SizedBox(height:8.0),
      _buildPasswordTextField(),
      SizedBox(height:8.0),
      FormSubmitButton(text: primaryText, onPressed: submitEnabled?_submit:null),
      SizedBox(height:8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: !_isLoading? _toggleFormType:null
      )
    ];
  }

  TextField _buildPasswordTextField(){
    bool showErrorText =_submitted && !widget.passwordValidator.isValid(_pass);
    return TextField(
      controller: _passController,
      focusNode: _passFocusNode,
      decoration: InputDecoration(
        labelText:'Password',
        // hintText:'test@test.com',
        errorText: showErrorText?widget.invalidPassErrorText:null,
        enabled: _isLoading==false
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
      onEditingComplete: _submit,
      onChanged: (password)=>_updateState(),
      
    );
  }

  TextField _buildEmailTextField(){
    bool showErrorText = _submitted && !widget.emailValidator.isValid(_email);
    return TextField(
      decoration: InputDecoration(
        labelText:'Email',
        hintText:'test@test.com',
        errorText: showErrorText?widget.invalidEmailErrorText:null  ,
        enabled: _isLoading==false,
      ),
      controller: _emailController,
      focusNode: _emailFocusNode,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      onEditingComplete: _emailEditingComplete,
      onChanged: (email)=> _updateState(),
    );
  }

  void _updateState(){
    print("email: $_email, password: $_pass");
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children:_buildChildren() ,
        
      ),
    );
  }
}



