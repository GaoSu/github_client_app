import 'package:flukit/flukit.dart';
import 'package:flutter/material.dart';
import 'package:github_client_app/states/index.dart';
import 'package:provider/provider.dart';
import 'package:github_client_app/widgets/repo_item.dart';
import 'package:github_client_app/models/index.dart';
import 'package:github_client_app/common/index.dart';

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
      drawer: MyDrawer(),
    );
  }

  Widget _buildBody() {
    UserModel userModel = Provider.of<UserModel>(context);
    if (!userModel.isLogin) {
      return Center(
        child: RaisedButton(
          child: Text("Logined"),
          onPressed: () {
            //去登陆页面
            Navigator.pushNamed(context, "/login");
          },
        ),
      );
    } else {
      return InfiniteListView<Repo>(
        onRetrieveData: (int page, List<Repo> items, bool refresh) async {
          print("current page :${page}, refresh${refresh}");
          var data = await Git(context).getRepos(
            refresh: refresh,
            queryParameters: {
              'page': page,
              'page_size': 20,
            },
          );
          //把请求到的新数据添加到items中
          items.addAll(data);
          return false;
        },
        itemBuilder: (List list, int index, BuildContext ctx) {
          // 项目信息列表项
          return RepoItem(list[index]);
        },
      );
    }
  }
}

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: MediaQuery.removePadding(
        context: context,
        removeTop: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: _buildMenus(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Consumer(
        builder: (BuildContext context, UserModel value, Widget child) {
      return GestureDetector(
        child: Container(
          color: Theme.of(context).primaryColor,
          padding: EdgeInsets.only(top: 40, bottom: 20),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ClipOval(
                    child: value.isLogin
                        ? gmAvatar(value.user.avatar_url, width: 80)
                        : Image.asset(
                            "imgs/avatar-default.png",
                            width: 80,
                          )),
              ),
              Text(
                value.isLogin
                    ? value.user.login
                    : "Login",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ],
          ),
        ),
        onTap: () {
          if (!value.isLogin) {
            Navigator.pushNamed(context, "/login");
          }
        },
      );
    });
  }

  Widget _buildMenus() {
    return Consumer(
        builder: (BuildContext context, UserModel userModel, Widget child) {
      // var gm = GmLocalizations.of(context);
      return ListView(
        children: [
          ListTile(
            leading: Icon(Icons.color_lens),
            title: Text("换肤"),
            onTap: () => Navigator.pushNamed(context, "themes"),
          ),
          ListTile(
            leading: Icon(Icons.language),
            title: Text("语言"),
            onTap: () => Navigator.pushNamed(context, "themes"),
          ),
          _buildLogoutWidget(context, userModel),
        ],
      );
    });
  }

  Widget _buildLogoutWidget(BuildContext context, UserModel userModel) {
    if (userModel.isLogin) {
      return ListTile(
        leading: Icon(Icons.power_settings_new),
        title: Text("logout"),
        onTap: () {
          showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                content: Text("Logout"),
                actions: [
                  FlatButton(
                    child: Text("cancel"),
                    onPressed: () => Navigator.pop(context),
                  ),
                  FlatButton(
                    child: Text("confirm"),
                    onPressed: () {
                      userModel.user = null;
                      Navigator.pop(context);
                    },
                  ),
                ],
              );
            },
          );
        },
      );
    } else {
      return Text("");
    }
  }
}
