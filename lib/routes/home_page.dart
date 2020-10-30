import 'package:flutter/material.dart';
import 'package:github_client_app/states/index.dart';
import 'package:provider/provider.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Github"),
      ),
      body: _buildBody(),
      drawer: Drawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      return Center(
        child: RaisedButton(
          child: Text("Login"),
          onPressed: () {
            //去登陆页面
            Navigator.pushNamed(context, "/login");
          },
        ),
      );
    } else {
      return Text("List");
    }
  }

}
