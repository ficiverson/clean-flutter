import 'package:cleanflutter/ui/model/user.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:flutter/widgets.dart';


class RowView extends StatelessWidget {

  User user;

  RowView(User user) {
    this.user = user;
  }

  //TODO add a link to second screen with a gesture detector??
  @override
  Widget build(BuildContext context) {
    return new Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        child: new Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              new Container(
                  margin: const EdgeInsets.only(left: 16.0),
                  width: 40.0,
                  height: 40.0,
                  decoration: new BoxDecoration(
                      borderRadius: new BorderRadius.all(
                          new Radius.circular(50.0)),
                      image: new DecorationImage(
                          image: new NetworkImage(user.picture),
                          fit: BoxFit.cover),
                      color: AppColors.blue_bubble)),
              new Container(
                  width: 250.0,
                  decoration: new BoxDecoration(
                      color: AppColors.blue_bubble,
                      borderRadius:
                      new BorderRadius.all(new Radius.circular(10.0))),
                  margin: new EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 0.0),
                  child: new Column(children: <Widget>[new Container(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text("Name: " + user.first,
                          maxLines: 3,
                          style: new TextStyle(color: AppColors.white))),
                  new Container(
                      padding: new EdgeInsets.all(10.0),
                      child: new Text("City: " + user.city,
                          maxLines: 3,
                          style: new TextStyle(color: AppColors.white))),
                  ]))
            ]));
  }

}