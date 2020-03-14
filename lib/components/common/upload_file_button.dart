import 'dart:async';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:megacademia/theme.dart';
import 'package:flutter/services.dart';

import '../../icons.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../components/components.dart';

class UploadFile extends StatelessWidget{

  final iconColor;
  final iconSize;

  UploadFile({this.iconColor = Colors.black, this.iconSize = 25.0});

  @override
  Widget build(BuildContext context){
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 30.0),
        child: Icon(MaIcon.uploadFile,
          color: iconColor,
          size: iconSize,
        ),
      ),
      onTap: ()=>_uploadFile(context),
    );
  }

  void _uploadFile(BuildContext context) async{
    var file = await FilePicker.getFile();
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(uploadFileAction(
      file.path,
      onSucceed:(sharingUrl){
        showDialog(
          context: context,
          builder: (context){
            return AlertDialog(
              title: Text("分享文件"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('分享链接：', style: TextStyle(color: MaTheme.maYellows),),
                  Text(
                    sharingUrl,
                    maxLines: 5,
                    softWrap: true,
                    style: TextStyle(color: MaTheme.greyNormal),)
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text("复制"),
                  onPressed: (){
                    Clipboard.setData(ClipboardData(text: sharingUrl));
                    Navigator.of(context).pop();
                  }, //关闭对话框
                ),
              ],
            );
          }
        );
      },
      onFailed: (notice) {
        createFailedSnackBar(context, notice: notice);
      },
    ));
  }
}