import 'package:cleanflutter/ui/home/drawer_menu.dart';
import 'package:flutter/material.dart';
import 'package:cleanflutter/model/result.dart';
import 'package:cleanflutter/model/user.dart';
import 'package:cleanflutter/ui/home/home_presenter.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:cleanflutter/ui/utils/uxhelper/iphone_x_padding.dart';
import 'package:cleanflutter/ui/utils/uxhelper/padding_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:cleanflutter/ui/home/row_view.dart';

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
          return new RowView(_users[index]);
        },
      ));
    }
  }

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
      endDrawer: new DrawerMenu(_reloadData),
      body: getMainBody(),
    );
    return new IPhoneXPadding(child: _scaffold);
  }

  @override
  void initState() {
    super.initState();
    _presenter = new HomePresenter(this);
  }

  @override
  void dispose() {
    super.dispose();
  }

  //view implementation methods
  void _reloadData(DataPolicy policy){
    setState(() {
      _presenter.fetchUsers(policy);
      Navigator.of(context).pop();
    });
  }


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
