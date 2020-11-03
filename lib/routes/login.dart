import 'package:flutter/material.dart';
import 'package:github_client_app/common/funs.dart';
import 'package:github_client_app/common/git_api.dart';
import 'package:github_client_app/l10n/location_intl.dart';
import 'package:github_client_app/models/index.dart';
import 'package:github_client_app/states/index.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool pwdShow = false;
  GlobalKey _formKey = GlobalKey<FormState>();

  TextEditingController _nameController = TextEditingController();
  TextEditingController _pwdController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var gm = GmLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(gm.login),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                autofocus: true,
                controller: _nameController,
                decoration: InputDecoration(
                    labelText: gm.userName, prefixIcon: Icon(Icons.person)),
                validator: (v) {
                  return v.trim().length > 0 ? null : gm.userNameRequired;
                },
                // initialValue: "GaoSu",
              ),
              TextFormField(
                // initialValue: "LHqwer123456",
                controller: _pwdController,
                decoration: InputDecoration(
                  labelText: gm.password,
                  prefixIcon: Icon(Icons.lock),
                  suffixIcon: IconButton(
                    icon: Icon(
                      pwdShow ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() {
                        pwdShow = !pwdShow;
                      });
                    },
                  ),
                ),
                obscureText: !pwdShow,
                validator: (v) {
                  return v.trim().length > 5 ? null : gm.passwordRequired;
                },
              ),
              SizedBox(
                height: 30,
              ),
              ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: double.infinity,
                  minHeight: 45,
                ),
                child: RaisedButton(
                  color: Theme.of(context).primaryColor,
                  onPressed: _onLogin,
                  child: Text(
                    gm.login,
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    //验证
    if (!(_formKey.currentState as FormState).validate()) {
      return;
    }
    //显示加载框
    showLoading(context);
    User user;
    try {
      user =
          await Git(context).login(_nameController.text, _pwdController.text);
      print("suer${user}");
      Provider.of<UserModel>(context, listen: false).user = user;
    } catch (e) {
      if (e.response?.statusCode == 401) {
        showToast(GmLocalizations.of(context).userNameOrPasswordWrong);
      } else {
        showToast(e.toString());
      }
      print(e);
    } finally {
      Navigator.of(context).pop();
    }
    if (user != null) {
      Navigator.of(context).pop();
    }
  }
}
