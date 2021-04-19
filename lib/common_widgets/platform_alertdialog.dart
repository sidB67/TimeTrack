import 'dart:io';

import 'package:time_tracker_flutter_course/common_widgets/platform_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'dart:async';
class PlatformAlertDialog extends PlatformWidget {
  PlatformAlertDialog(
      {@required this.title,
      @required this.content,
      @required this.defaultActionText,
      this.cancelActionText})
      : assert(title != null),
        assert(content != null),
        assert(defaultActionText != null);
  final String title;
  final String content;
  final String defaultActionText;
  final String cancelActionText;
  Future<bool> show(BuildContext context)async{
    return Platform.isIOS? await showCupertinoDialog<bool>(
      context: context,
      builder: (context)=> this
    )
    :await showDialog<bool>(
      context: context,
      builder: (context)=> this,
      barrierDismissible: false

    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
       title: Text(title),
      content: Text(content),
      actions: buildAction(context),
    );
  }
  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: buildAction(context),
    );
  }
  List<Widget> buildAction(BuildContext context){
    final action = <Widget> [];
    if(cancelActionText!=null){
      action.add(
        PlaformAlertDialogAction(
         child: Text(cancelActionText),
         onPressed: ()=> Navigator.of(context).pop(false),
       )
      );
    }
    action.add(
       PlaformAlertDialogAction(
         child: Text(defaultActionText),
         onPressed: ()=> Navigator.of(context).pop(true),
       )
    );
    return action;
  }
}

class PlaformAlertDialogAction extends PlatformWidget{
  final Widget child;
  final VoidCallback onPressed;

  PlaformAlertDialogAction({this.child, this.onPressed});

  @override
  Widget buildCupertinoWidget(BuildContext context) {
      return CupertinoDialogAction(
        child: child,
        onPressed: onPressed,
      );
    }
  
    @override
    Widget buildMaterialWidget(BuildContext context) {
    return FlatButton(
      child: child,
      onPressed: onPressed,
    );
  }
}
