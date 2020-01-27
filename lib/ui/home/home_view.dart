import 'package:clay_containers/constants.dart';
import 'package:clay_containers/widgets/clay_containers.dart';
import 'package:cleanflutter/injection/dependency_injection.dart';
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
import 'package:injector/injector.dart';

enum StateMenu { LIST, POINTER, ANIMATION }

class MyHomePage extends StatefulWidget {
  @override
  State createState() => new MyHomePageState();
}

class MyHomePageState extends State<MyHomePage>
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

  MyHomePageState() {
    DependencyInjector().injectByView(this);
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
              color: AppColors.platinumdark,
              child: new ListView.builder(
                key: Key("user_list"),
                itemCount: _users.length,
                reverse: false,
                itemBuilder: (_, int index) {
                  return new RowView(_users[index]);
                },
              ));
        }
        return returnWidget;

      case StateMenu.ANIMATION:
        return new Container(
            child: FlightAnimation(key: Key("custom_animation")));

      case StateMenu.POINTER:
        return new Container(
            key: Key("custom_pointer"),
            decoration: new BoxDecoration(
              color: Colors.white,
              border: new Border.all(
                color: AppColors.blue_bubble,
                width: 2.0,
              ),
            ),
            child: new Center(child: new CustomTouchView()));

      default:
        throw new StateError('Unexpected action [${currentState}]');
    }
  }

  //create a menu bar
  generateMenu() {
    ClayContainer menuHome = ClayContainer(
        emboss: currentState == StateMenu.LIST,
        curveType: currentState == StateMenu.LIST ? CurveType.concave : CurveType.convex,
        borderRadius: 50,
        parentColor: Color(0xFFF2F2F2),
        child: new IconButton(
          key: Key("user_list_item"),
          icon: new Icon(Icons.rss_feed, color: AppColors.blue_bubble),
          padding: new EdgeInsets.all(0.0),
          disabledColor: AppColors.dimgrey,
          onPressed: () {
            setState(() {
              currentState = StateMenu.LIST;
            });
          },
        ));
    ClayContainer menuScan;
    menuScan = ClayContainer(
        emboss: currentState == StateMenu.POINTER,
        curveType: currentState == StateMenu.POINTER ? CurveType.concave : CurveType.convex,
        borderRadius: 50,
        parentColor: Color(0xFFF2F2F2),
        child: new IconButton(
          key: Key("custom_pointer_item"),
          icon: new Icon(Icons.touch_app, color: AppColors.blue_bubble),
          padding: new EdgeInsets.all(0.0),
          disabledColor: AppColors.dimgrey,
          onPressed: () {
            setState(() {
              currentState = StateMenu.POINTER;
            });
          },
        ));

    ClayContainer menuSettings = ClayContainer(
        emboss: currentState == StateMenu.ANIMATION,
        curveType: currentState == StateMenu.ANIMATION ? CurveType.concave : CurveType.convex,
        borderRadius: 50,
        parentColor: Color(0xFFF2F2F2),
        child: new IconButton(
          key: Key("custom_animation_item"),
          icon: new Icon(Icons.flight_land, color: AppColors.blue_bubble),
          padding: new EdgeInsets.all(0.0),
          disabledColor: AppColors.dimgrey,
          onPressed: () {
            setState(() {
              currentState = StateMenu.ANIMATION;
            });
          },
        ));

    List<Widget> optionsMenu = new List<Widget>();
    optionsMenu.add(menuHome);
    optionsMenu.add(menuScan);
    optionsMenu.add(menuSettings);
    return new Container(
        height: _margin * 3,
        decoration: new BoxDecoration(
            color: Color(0xFFF2F2F2),
            border: new Border(
                top: new BorderSide(color: AppColors.dimgrey, width: 0.1))),
        child: new ButtonBar(
          mainAxisSize: MainAxisSize.min,
          alignment: MainAxisAlignment.spaceAround,
          children: optionsMenu,
        ));
  }

  Widget generateFakeMenu() {
    return new Container(
        height: _margin * 3,
        decoration: new BoxDecoration(
            color: AppColors.white,
            border: new Border(
                top: new BorderSide(color: AppColors.dimgrey, width: 0.1))),
        child: Center(child: Text('Hi! This is Flutter :)')));
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
      endDrawer: DrawerMenu(_reloadData),
      body: getMainBody(),
      bottomNavigationBar: generateMenu(),
    );
    return new IPhoneXPadding(child: _scaffold);
  }

  @override
  void initState() {
    super.initState();
    _presenter = Injector.appInstance.getDependency<HomePresenter>();
    _presenter.init();
  }

  @override
  void dispose() {
    _presenter.dispose();
    Injector.appInstance.removeByKey<HomeViewContract>();
    super.dispose();
  }

  //view implementation methods
  void _reloadData(DataPolicy policy) {
    setState(() {
      _presenter.onReloadData(policy);
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
    setState(() => _loading = false);
    print(msg);
  }

  @override
  onUpdateChannel(result) {
    print("Result >>> $result");
  }
}
