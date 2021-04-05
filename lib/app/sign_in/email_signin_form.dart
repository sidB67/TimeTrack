import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/app/services/auth.dart';

enum EmailSignInFormType{signIn,register}

class EmailSignInForm extends StatefulWidget {
  EmailSignInForm({@required this.auth});
  final AuthBase auth; 
  @override
  _EmailSignInFormState createState() => _EmailSignInFormState();
}

class _EmailSignInFormState extends State<EmailSignInForm> {
  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passController = TextEditingController();
  String get _email=> _emailController.text;
  String get _pass=>  _passController.text;
  EmailSignInFormType _formType= EmailSignInFormType.signIn;
  void _submit()async{
    try{
    if(_formType== EmailSignInFormType.signIn){
      await widget.auth.signInWithEmailAndPassword(_email,_pass);
    }
    else{
      await widget.auth.createUserWithEmailAndPassword(_email, _pass);
    }
    Navigator.of(context).pop();
    }catch(e){print(e.toString());}
  }
  void _toggleFormType(){
    setState(() {
      _formType=_formType==EmailSignInFormType.signIn?
        EmailSignInFormType.register:EmailSignInFormType.signIn;
    });
    _emailController.clear();
    _passController.clear();
  }
  List<Widget> _buildChildren(){
    final primaryText = _formType==EmailSignInFormType.signIn?
                        'Sign In': 'Create an account';
    final secondaryText = _formType==EmailSignInFormType.signIn?
                        'Need an account? Register':
                        'Have an acoount? Sign In';
    return [
      _BuildEmail(emailController: _emailController),
      SizedBox(height:8.0),
      _BuildPass(passController: _passController),
      SizedBox(height:8.0),
      FormSubmitButton(text: primaryText, onPressed: _submit),
      SizedBox(height:8.0),
      FlatButton(
        child: Text(secondaryText),
        onPressed: _toggleFormType
      )
    ];
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

class _BuildPass extends StatelessWidget {
  const _BuildPass({
    Key key,
    @required TextEditingController passController,
  }) : _passController = passController, super(key: key);

  final TextEditingController _passController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _passController,
      decoration: InputDecoration(
        labelText:'Password',
        // hintText:'test@test.com',
        
      ),
      obscureText: true,
      textInputAction: TextInputAction.done,
    );
  }
}

class _BuildEmail extends StatelessWidget {
  const _BuildEmail({
    Key key,
    @required TextEditingController emailController,
  }) : _emailController = emailController, super(key: key);

  final TextEditingController _emailController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      decoration: InputDecoration(
        labelText:'Email',
        hintText:'test@test.com',
        
      ),
      controller: _emailController,
      autocorrect: false,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
    );
  }
}