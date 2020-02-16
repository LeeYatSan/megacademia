import '../models/models.dart';

UserEntity noteTransform(var response){
  UserEntity tmp = UserEntity.fromJson(response.data);
  String note = noteTransformStr(tmp.note);
  return tmp.copyWith(note: note);
}

List<UserEntity> noteTransformForUserList(var response){
  List<UserEntity> users = UserListEntity.fromJson(response.data).users;
  List<UserEntity> newList = List<UserEntity>();
  for(UserEntity user in users){
    newList.add(user.copyWith(note: noteTransformStr(user.note)));
  }
  print('newlist len: ${newList.length}');
  return newList;
}

String noteTransformStr(String note){
  return note.replaceAll(new RegExp(r"<br\s*/>"),'\n')
              .replaceAll(new RegExp(r"\s*(<p>)|(</p>)|(<br>)"),'');
}