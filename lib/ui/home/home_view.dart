import 'package:cleanflutter/ui/animation/flight_animation.dart';
import 'package:cleanflutter/ui/customview/custom_touch_view.dart';
import 'package:cleanflutter/ui/home/drawer_menu.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cleanflutter/data/result/result.dart';
import 'package:cleanflutter/ui/home/home_presenter.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:cleanflutter/ui/utils/uxhelper/iphone_x_padding.dart';
import 'package:cleanflutter/ui/utils/uxhelper/padding_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:cleanflutter/ui/home/row_view.dart';

enum StateMenu { LIST, POINTER, ANIMATION }

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage>
    with TickerProviderStateMixin
    implements HomeViewContract {

  StateMenu currentState = StateMenu.LIST;
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
    switch (currentState) {
      case StateMenu.LIST:
        var returnWidget;
        if (_loading) {
          returnWidget = new Center(child: new Text("Loading all data"));
        } else {
          returnWidget = new Container(
              color: AppColors.platinumdark, child: new ListView.builder(
            itemCount: _users.length,
            reverse: false,
            itemBuilder: (_, int index) {
              return new RowView(_users[index]);
            },
          ));
        }
        return returnWidget;

      case StateMenu.ANIMATION:
        return new Container(child: new FlightAnimation());

      case StateMenu.POINTER:
        return new Container(
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(
                color: AppColors.blue_bubble,
                width: 2.0,
              ),
            ),
            child: new Center(
                child: new CustomTouchView()
            ));

      default:
        throw new StateError('Unexpected action [${currentState}]');
    }
  }

  //create a menu bar
  generateMenu() {
    IconButton menuHome = new IconButton(
      icon: new Icon(Icons.rss_feed, color: AppColors.blue_bubble),
      padding: new EdgeInsets.all(0.0),
      disabledColor: AppColors.dimgrey,
      onPressed: () {
        setState(() {
          currentState = StateMenu.LIST;
        });
      },
    );
    IconButton menuScan;
    menuScan = new IconButton(
      icon: new Icon(Icons.touch_app, color: AppColors.blue_bubble),
      padding: new EdgeInsets.all(0.0),
      disabledColor: AppColors.dimgrey,
      onPressed: () {
        setState(() {
          currentState = StateMenu.POINTER;
        });
      },
    );

    IconButton menuSettings = new IconButton(
      icon: new Icon(Icons.flight_land, color: AppColors.blue_bubble),
      padding: new EdgeInsets.all(0.0),
      disabledColor: AppColors.dimgrey,
      onPressed: () {
        setState(() {
          currentState = StateMenu.ANIMATION;
        });
      },
    );

    List<Widget> optionsMenu = new List<Widget>();
    optionsMenu.add(menuHome);
    optionsMenu.add(menuScan);
    optionsMenu.add(menuSettings);
    return new Container(
        height: _margin * 2.5,
        decoration: new BoxDecoration(
            color: AppColors.white,
            border: new Border(
                top: new BorderSide(color: AppColors.dimgrey, width: 0.1))),
        child: new ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.spaceAround,
          children: optionsMenu,
        ));
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
      bottomNavigationBar: generateMenu(),
    );
    return new IPhoneXPadding(child: _scaffold);
  }

  @override
  void initState() {
    super.initState();
    _presenter = new HomePresenter(this);
    _presenter.init();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }

  //view implementation methods
  void _reloadData(DataPolicy policy) {
    setState(() {
      _presenter.fetchUsers(policy);
      Navigator.of(context).pop();
    });
  }

  @override
  onLoadUsers(List<User> users) {
    _users = users;
    setState(() => _loading = false);
  }

  @override
  onError(String msg) {
    //TODO show a popup with the error
    print(msg);
  }

  @override
  onUpdateChannel(result) {
    print("Result $result");
  }
}
