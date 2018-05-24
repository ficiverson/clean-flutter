import 'package:cleanflutter/ui/detail/datail_presenter.dart';
import 'package:cleanflutter/ui/model/user.dart';
import 'package:flutter/material.dart';
import 'package:cleanflutter/ui/utils/uxhelper/app_colors.dart';
import 'package:cleanflutter/ui/utils/uxhelper/iphone_x_padding.dart';
import 'package:flutter/cupertino.dart';

//TODO draw the view of the user
class DetailPage extends StatefulWidget {

  DetailPage({Key key})
      : super(key: key);

  @override
  State createState() => new _DetailPageState();
}


class _DetailPageState extends State<DetailPage>
    with TickerProviderStateMixin
    implements DetailViewContract {

  DetailPresenter _presenter;
  Scaffold _scaffold;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  MediaQueryData queryData;


  _DetailPageState() {
    _presenter = new DetailPresenter(this);
  }

  //Build UI
  getMainBody() {
    return new Text("Add content!!!");
  }


  //Lifecycle methods
  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);

    _scaffold = new Scaffold(
        key: _scaffoldKey,
        appBar: new AppBar(
            backgroundColor: AppColors.blue_bubble,
            title: new Text("Detail")),
        body: getMainBody()
    );
    return new IPhoneXPadding(child: _scaffold);
  }

  @override
  void initState() {
    super.initState();
    _presenter = new DetailPresenter(this);
    _presenter.init();
  }

  @override
  void dispose() {
    _presenter.dispose();
    super.dispose();
  }
}
