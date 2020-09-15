import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'dart:io';
import 'package:flutter_radio_player/flutter_radio_player.dart';
import 'dart:async';
import 'package:flutter_share/flutter_share.dart';
import 'politica.dart';
import 'homescreen.dart';
import 'sobre.dart';
import 'package:url_launcher/url_launcher.dart';

class Conteudo extends StatefulWidget {
  var playerState = FlutterRadioPlayer.flutter_radio_paused;

  

  var volume = 0.8;
  @override
  _ConteudoState createState() => _ConteudoState();
}

class _ConteudoState extends State<Conteudo> {

FlutterRadioPlayer _flutterRadioPlayer = new FlutterRadioPlayer();


  @override
void initState(){
  super.initState();
  SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
  ]);
}

  Future<void> share() async {
    await FlutterShare.share(
        title: 'Compartilhar App',
        text: 'Conheça o app da Radio Verde Vale',
        linkUrl: 'https://apps.apple.com/br/app/radio-verde-vale-fm/id1526290059',
        chooserTitle: ' ');
  }

  Future<void> initRadioService() async {
    try {
      await _flutterRadioPlayer.init(
          "Radio Verde Vale", "Ao Vivo", "https://player.stream2.com.br/proxy/8478/stream", "true");
    } on PlatformException {
      print("Não foi possivel acessar a radio agora...");
    }
  }

  _exit() async{
    if (await _flutterRadioPlayer.isPlaying()){_flutterRadioPlayer.stop(); exit(0);} else {exit(0);}
  }

  void cancel(timer){}

  
  @override
  Widget build(BuildContext context) {    
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Verde Vale',
      theme: ThemeData.light(),
      home: Scaffold(      
      body: 
        WebView(
          initialUrl: 'https://verdevale.radiostreaming.com.br/',
          javascriptMode: JavascriptMode.unrestricted,
        ),
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              DrawerHeader(
                child: Center(
                  child: FlatButton(
                    child: Image.asset('imagens/cropped-favicon.png'),
                    onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                    color: Colors.transparent,
                  ),
                ),
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text('HOME'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
              ),
              ListTile(
                leading: Icon(FontAwesome.whatsapp),
                title: Text('WHATSAPP'),
                onTap: _launchURL,
              ),
              ListTile(
                leading: Icon(FontAwesome.facebook),
                title: Text('FACEBOOK'),
                onTap: _launchURL2,
              ),
              ListTile(
                leading: Icon(FontAwesome.instagram),
                title: Text('INSTAGRAM'),
                onTap: _launchURL3,
              ),
              ListTile(
                leading: Icon(Icons.phone),
                title: Text('LIGUE PRA GENTE'),
                onTap: _launchURL4,
              ),
              ListTile(
                leading: Icon(Icons.share),
                title: Text('COMPARTILHAR'),
                onTap: share,
              ),
              ListTile(
                leading: Icon(Icons.copyright),
                title: Text('SOBRE O APP'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => SobreOApp()));
                        },
              ),
              ListTile(
                leading: Icon(Icons.public),
                title: Text('POLÍTICA DE PRIVACIDADE'),
                onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => PoliticaDePrivacidade()));
                        },
              ),
            ],
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.black,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            title:  Text('.'),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IconButton(
                        icon: Icon(Icons.home, color: Colors.white),
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage()));
                        },
                      ),
            ),
          ),
          BottomNavigationBarItem(
            title:  Text('.'),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: StreamBuilder(
                              stream: _flutterRadioPlayer.isPlayingStream,
                              initialData: widget.playerState,
                              builder:
                                  (BuildContext context, AsyncSnapshot<String> snapshot) {
                                String returnData = snapshot.data;
                                print("object data: " + returnData);
                                switch (returnData) {
                                  case FlutterRadioPlayer.flutter_radio_stopped:
                                    return RaisedButton(
                                        child: Text("Ouça Agora!"),
                                        onPressed: () async {
                                          await initRadioService();
                                        });
                                    break;
                                  case FlutterRadioPlayer.flutter_radio_loading:
                                    return Text("Carregando...");
                                  case FlutterRadioPlayer.flutter_radio_error:
                                    return RaisedButton(
                                        child: Text("Tentar Novamente ?"),
                                        onPressed: () async {
                                          await initRadioService();
                                        });
                                    break;
                                  default:
                                    return Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: <Widget>[
                                          IconButton(
                                              onPressed: () async {
                                                print("button press data: " +
                                                    snapshot.data.toString());
                                                await _flutterRadioPlayer.playOrPause();
                                              },
                                              icon: snapshot.data ==
                                                      FlutterRadioPlayer
                                                          .flutter_radio_playing
                                                  ? Icon(Icons.pause, color: Colors.white)
                                                  : Icon(Icons.play_arrow, color: Colors.white)),
                                          ]);
                                    break;
                                }
                              }),
            ),
          ),
          BottomNavigationBarItem(
            title: Text('.'),
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 30.0),
              child: IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white),
                        onPressed: _exit,
                      ),
            ),
          )
        ],
      ),
      ),
    );
  }
}

_launchURL() async {
  const url = 'http://wa.me/554836586060&text=';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL2() async {
  const url = 'fb://page/592018724176699/';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL3() async {
  const url = 'instagram://user?username=radioverdevalefm';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

_launchURL4() async {
  const url = 'tel:+554836586060';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
