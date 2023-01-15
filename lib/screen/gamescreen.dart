import 'dart:ffi';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hangman1/utils.dart';
import 'TextStyle/textstyle.dart';
import 'package:audioplayers/audioplayers.dart';

class Gamescreen extends StatefulWidget {
  const Gamescreen({Key? key}) : super(key: key);

  @override
  _GamescreenState createState() => _GamescreenState();
}

//

// If file located in assets folder like assets/sounds/note01.wave"

class _GamescreenState extends State<Gamescreen> {
  final player = AudioPlayer();
  playsound(String title) async {
    await player.play(AssetSource(title));
  }

  var score = 0;
  var lives = 7;
  var str = Word[Random().nextInt(Word.length)];
  var alpha = [];
  var letter1 = List.from(letter);

  String create() {
    String word1 = " ";
    for (var i = 0; i < str.length; i++) {
      if (alpha.contains(str[i])) {
        word1 += str[i];
      } else {
        word1 += '?';
      }
    }
    return word1;
  }

  opendialog(String Title, String sound) {
    if (sound == 1) {
      playsound(sound);
    }
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
              width: MediaQuery.of(context).size.width / 2,
              height: 180,
              decoration: BoxDecoration(color: Colors.deepOrange),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  textstyle(Title, 20),
                  SizedBox(
                    height: 5,
                  ),
                  textstyle("your points $score", 20),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    width: MediaQuery.of(context).size.width / 2,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {
                          lives = 7;
                          alpha.clear();
                          score = 0;
                          str = Word[Random().nextInt(Word.length)];
                          letter1 = List.from(letter);
                        });
                        if (sound == 1) {
                          playsound('game-start-6104.mp3');
                        }
                      },
                      child: Center(child: textstyle('PLAY AGAIN', 10)),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  checkletter(String alphabet) {
    if (str.contains(alphabet)) {
      setState(() {
        alpha.add(alphabet);
        letter1[letter1.indexOf(alphabet)] = '_';
        score += 5;
      });
      if (sound == 1) {
        playsound('correct-2-46134.mp3');
      }
    } else if (lives > 1) {
      setState(() {
        lives -= 1;
        score -= 5;
      });
      if (sound == 1) {
        playsound('negative_beeps-6008.mp3');
      }
    } else {
      opendialog('you lost', 'failure-drum-sound-effect-2-7184.mp3');
    }

    bool iswon = true;
    for (int i = 0; i < str.length; i++) {
      String char = str[i];
      if (!alpha.contains(char)) {
        setState(() {
          iswon = false;
        });
        break;
      }
    }
    if (iswon) {
      opendialog('Hooray you won', 'success-fanfare-trumpets-6185.mp3');
    }
  }

  int sound = 0;
  final play = "beep-03.wav";

  final soundlist = [Icons.volume_up_sharp, Icons.volume_mute_sharp];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black45,
        centerTitle: true,
        title: textstyle("HangMan", 30),
        actions: [
          Container(
            width: 60,
            margin: EdgeInsets.only(right: 20, top: 2.5, left: 20),
            child: InkWell(
                onTap: () async {
                  await player.play(AssetSource('beep.wav'));
                  setState(() {
                    if (sound == 1) {
                      sound = 0;
                    } else {
                      sound = 1;

                      print(sound);
                    }
                  });
                },
                child: Icon(
                  soundlist[sound],
                  color: Colors.white,
                  size: 30,
                )),
          )
        ],
      ),
      body: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(20),
              color: Colors.blue,
              child: textstyle('score point-:$score', 10),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              color: Colors.blueGrey,
              margin: EdgeInsets.all(20),
              child: Image(
                height: 150,
                width: 150,
                image: AssetImage("assets/images/hangman.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10),
              child: textstyle("Lives-$lives", 10),
            ),
            Container(
              margin: EdgeInsets.all(20),
              child: textstyle(create(), 30),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(left: 10),
              child: GridView.count(
                  crossAxisCount: 7,
                  shrinkWrap: true,
                  children: <Widget>[
                    for (var item in letter1)
                      InkWell(
                          onTap: () {
                            checkletter(item);
                          },
                          child: Center(child: textstyle(item, 20)))
                  ]),
            )
          ],
        ),
      ),
    );
  }
}
