import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class DrawerMenu extends StatefulWidget {

  final Function reloadData;

  DrawerMenu(this.reloadData);

  @override
  State createState() => new _DrawerMenuState();
}

class _DrawerMenuState extends State<DrawerMenu> {

  @override
  Widget build(BuildContext context) {
    return new Drawer(
        child: new Center(
            child: new Column(mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  new CupertinoButton(
                      color: AppColors.palidwhite,
                      child: new Text(
                          "From network",
                          style: new TextStyle(color: AppColors.blue_bubble)),
                      onPressed: () {
                        widget.reloadData(DataPolicy.network);
                      }),
                  new CupertinoButton(
                      color: AppColors.palidwhite,
                      child: new Text(
                          "From network_cache",
                          style: new TextStyle(color: AppColors.blue_bubble)),
                      onPressed: () {
                        widget.reloadData(DataPolicy.network_cache);
                      }),
                  new CupertinoButton(
                      color: AppColors.palidwhite,
                      child: new Text(
                          "From local storage",
                          style: new TextStyle(color: AppColors.blue_bubble)),
                      onPressed: () {
                        widget.reloadData(DataPolicy.cache);
                      })
                ])));
  }


}