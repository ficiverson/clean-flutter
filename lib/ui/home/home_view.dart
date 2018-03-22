import 'package:flutter/material.dart';
import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/model/user.dart';
import 'package:cleanflutter/ui/home/home_presenter.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:cleanflutter/ui/utils/uxhelper/iphone_x_padding.dart';
import 'package:cleanflutter/ui/utils/uxhelper/padding_utils.dart';
import 'package:flutter/cupertino.dart';

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin
    implements HomeViewContract {

  HomePresenter _presenter;
  Scaffold _scaffold;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MediaQueryData queryData;
  double _margin = 20.0;
  bool _loading = true;
  List<User> _users = new List<User>();


  _MyHomePageState() {
    _presenter = new HomePresenter(this);
  }

  //Build UI
  getMainBody() {
    if (_loading) {
      return new Center(child: new Text("Loading all data"));
    } else {
      return new Container(
          color: AppColors.platinumdark, child: new ListView.builder(
        itemCount: _users.length,
        reverse: false,
        itemBuilder: (_, int index) {
          return geRow(_users[index]);
        },
      ));
    }
  }

  Widget geRow(User user) {
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

  Widget getLanguageDrawer() {
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
                        setState(() {
                          _presenter.fetchUsers(DataPolicy.network);
                          Navigator.of(context).pop();
                        });
                      }),
                  new CupertinoButton(
                      color: AppColors.palidwhite,
                      child: new Text(
                          "From network_cache",
                          style: new TextStyle(color: AppColors.blue_bubble)),
                      onPressed: () {
                        setState(() {
                          _presenter.fetchUsers(DataPolicy.network_cache);
                          Navigator.of(context).pop();
                        });
                      }),
                  new CupertinoButton(
                      color: AppColors.palidwhite,
                      child: new Text(
                          "From local storage",
                          style: new TextStyle(color: AppColors.blue_bubble)),
                      onPressed: () {
                        setState(() {
                          _presenter.fetchUsers(DataPolicy.cache);
                          Navigator.of(context).pop();
                        });
                      })
                ])));
  }
//create a menu bar
//  generateMenu() {
//    IconButton menuHome = new IconButton(
//      icon: new Icon(Icons.rss_feed, color: AppColors.blue_bubble),
//      padding: new EdgeInsets.all(0.0),
//      disabledColor: AppColors.dimgrey,
//      onPressed: () {
//
//      },
//    );
//    IconButton menuScan;
//    menuScan = new IconButton(
//      icon: new Icon(Icons.landscape, color: AppColors.blue_bubble),
//      padding: new EdgeInsets.all(0.0),
//      disabledColor: AppColors.dimgrey,
//      onPressed: () {
//
//      },
//    );
//
//    IconButton menuSettings = new IconButton(
//      icon: new Icon(Icons.radio, color: AppColors.blue_bubble),
//      padding: new EdgeInsets.all(0.0),
//      disabledColor: AppColors.dimgrey,
//      onPressed: () {
//
//      },
//    );

 //   List<Widget> optionsMenu = new List<Widget>();
//    optionsMenu.add(menuHome);
//    optionsMenu.add(menuScan);
//    optionsMenu.add(menuSettings);
//    return new Container(
//        height: _margin * 2.5,
//        decoration: new BoxDecoration(
//            color: AppColors.white,
//            border: new Border(
//                top: new BorderSide(color: AppColors.dimgrey, width: 0.1))),
//        child: new ButtonBar(
//          mainAxisSize: MainAxisSize.min,
//          alignment: MainAxisAlignment.spaceAround,
//          children: optionsMenu,
//        ));
//  }


  //Lifecycle methods
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    _margin = PaddingUtils.getMargin(
        queryData.size.height, queryData.devicePixelRatio);

    _scaffold = new Scaffold(
      key: _scaffoldKey,
      appBar: new AppBar(
          backgroundColor: AppColors.blue_bubble,
          title: new Text("Clean flutter"),
          actions: <Widget>[
            new IconButton(
                icon: new Icon(Icons.highlight, color: AppColors.palidwhite),
                onPressed: () {
                  if (_scaffoldKey.currentState.hasEndDrawer) {
                    _scaffoldKey.currentState.openEndDrawer();
                  }
                },
                color: AppColors.white,
                iconSize: 35.0)
          ]),
      endDrawer: getLanguageDrawer(),
      body: getMainBody(),
     //bottomNavigationBar: generateMenu(),
    );
    return new IPhoneXPadding(child: _scaffold);
  }

  @override
  void initState() {
    super.initState();
    _presenter = new HomePresenter(this);
    _presenter.fetchUsers(DataPolicy.network_cache);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //view implementation methods

  @override
  onLoadUsers(Result<List<User>> result) {
    if (result.status == Status.ok) {
      _users = result.getData();
      setState(() => _loading = false);
    } else {
      print("error sorry :(");
    }
  }
}
