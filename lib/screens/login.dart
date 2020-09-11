

import 'package:firebase_auth/firebase_auth.dart';
import 'package:zz/%20helper/login_background.dart';
import 'package:zz/data/join_or_login.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zz/screens/main_page.dart';


class AuthPage extends StatelessWidget {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // 암호키 설정하기

  final TextEditingController _emailController =
      TextEditingController(); // 이메일 컨트롤러
  final TextEditingController _passwordController =
      TextEditingController(); //암호 컨트롤러

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size; // 사이즈 비율 조정 하기

    return Scaffold(
        body: Stack(
      alignment: Alignment.center,
      children: [
        CustomPaint(
          //백그라운드 이미지 넣기
          size: size,
          painter: LoginBackground(isJoin: Provider.of<JoinOrLogin>(context).isJoin),  //login_background.dart 참고
        ),
        Column(
          // 전체 위치 조정
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _logoImage,
            Stack(
              children: [
                _inputForm(size), //입력 위젯
                _authButton(size), //로그인 입력
              ],
            ),
            Container(
              //거부 문장
              height: size.height * 0.1,
            ),
            Consumer<JoinOrLogin>(       //consumer
              builder: (context, joinOrLogin, child) => GestureDetector(
                onTap: () {
                  JoinOrLogin joinOrLogin = Provider.of<JoinOrLogin>(
                    context);
                  joinOrLogin.toggle();
                },
                child: Text(joinOrLogin.isJoin?"Don't Have an Account? Sign in":"Don't Have an Account? Create One",
                  style: TextStyle(color:joinOrLogin.isJoin?Colors.red:Colors.blue ),)),

            ),



            Container(
              height: size.height * 0.05,
            )
          ],
        )
      ],
    ));
  }

  void _register(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance.
      createUserWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null){
      final snacbar = SnackBar(content: Text('Please try again later. '),);
      Scaffold.of(context).showSnackBar(snacbar);


    }
    
    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context)=>MainPage(email: user.email)));
  }

  void _login(BuildContext context) async {
    final AuthResult result = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: _emailController.text, password: _passwordController.text);
    final FirebaseUser user = result.user;

    if(user == null){
      final snacbar = SnackBar(content: Text('Please try again later. '),);
      Scaffold.of(context).showSnackBar(snacbar);


    }

    // Navigator.push(context,
    //     MaterialPageRoute(builder: (context)=>MainPage(email: user.email)));
  }

  Widget get _logoImage => Expanded(
        //이미지 조정하기
        child: Padding(
          padding: const EdgeInsets.only(top: 50, left: 25, right: 25),
          child: FittedBox(
            fit: BoxFit.contain,
            child: CircleAvatar(
              backgroundImage: AssetImage("assets/koko.gif"),
            ),
          ),
        ),
      );

  Widget _authButton(Size size) {
    //로그인 버튼 위
    return Positioned(
      //로그인 버튼 사이즈
      left: size.width * 0.15,
      right: size.width * 0.15,
      bottom: 0,
      child: SizedBox(
        height: 50,
        child: Consumer<JoinOrLogin>(
          builder: (context, joinOrLogin, child) => RaisedButton(
              child: Text(
                joinOrLogin.isJoin?"Join":'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              //로그인 버튼 만들기
              color: joinOrLogin.isJoin?Colors.red:Colors.blue,
              shape:
                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  joinOrLogin.isJoin?_register(context):_login(context);
                  //print(_passwordController.text.toString());
                  //print("button pressed!!");

                }
              }),
        ),
      ),
      // Container(width:100, height:50, color: Colors.black,)
    );
  }

  Widget _inputForm(Size size) {
    return Padding(
      padding: EdgeInsets.all(size.width * 0.05), //정렬하기
      child: Card(
        //카드 네모 박수 주기
        shape: RoundedRectangleBorder(
            //라운드 주기
            borderRadius: BorderRadius.circular(16)),

        elevation: 6, //아래 그림자 주기
        child: Padding(
          padding: const EdgeInsets.only(
              //라운드 더주기
              left: 12,
              right: 12,
              top: 12,
              bottom: 32),
          child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    //이메일 로그인 화면
                    controller: _emailController, //컨트롤러 사용
                    decoration: InputDecoration(
                        //아이콘 사용
                        icon: Icon(Icons.account_circle),
                        labelText: 'Email'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please input correct Email.';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    //패스워드 화면
                    obscureText: true, //암호 *** 나타내기
                    controller: _passwordController, // 컨트롤러 사용
                    decoration: InputDecoration(
                        icon: Icon(Icons.vpn_key), labelText: 'Password'),
                    validator: (String value) {
                      if (value.isEmpty) {
                        return 'Please input correct Password.';
                      }
                      return null;
                    },
                  ),
                  Container(
                    //잊어버리다 화면
                    height: 8,
                  ),
                  Text("Forget Password")
                ],
              )),
        ),
      ),
    );
  }
}
