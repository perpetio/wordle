import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/countdown_timer_controller.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:twemoji/twemoji.dart';
import 'package:wordle/core/const/color_constants.dart';
import 'package:wordle/core/const/text_constants.dart';
import 'package:wordle/core/data/data_singleton.dart';
import 'package:wordle/core/data/enums/message_types.dart';
import 'package:wordle/core/presentation/home/cubit/home_cubit.dart';
import 'package:wordle/core/presentation/home/widget/home_content.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        ?.addPostFrameCallback((_) => _showTimerIfNeeded());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 50),
            child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return BackdropFilter(
                          filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
                          child: Dialog(
                            shape: const RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(24.0)),
                            ),
                            child: _buildDialogBody(),
                          ),
                        );
                      });
                },
                child: const Icon(Icons.help_outline)),
          ),
        ],
        title: Text(
          TextConstants.gameTitle,
          style: GoogleFonts.mulish(fontSize: 32, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: _buildBody(context),
    );
  }

  BlocProvider<HomeCubit> _buildBody(BuildContext context) {
    return BlocProvider<HomeCubit>(
      create: (BuildContext context) => HomeCubit(),
      child: BlocConsumer<HomeCubit, HomeState>(
        listenWhen: (_, currState) => true,
        listener: (context, state) {
          final homeCubit = BlocProvider.of<HomeCubit>(context);
          if (state is SnackBarMessage) {
            SnackBarMessage message = state;
            _showMessage(message, context);
          } else if (state is WinGameState) {
            _makeWin(homeCubit);
          } else if (state is LoseGameState) {
            _makeLose(homeCubit);
          }
        },
        buildWhen: (_, currState) => currState is HomeInitial,
        builder: (context, state) {
          return HomeContent(
            key: UniqueKey(),
          );
        },
      ),
    );
  }

  void _showMessage(SnackBarMessage myMessage, BuildContext context) {
    switch (myMessage.type) {
      case MessageTypes.info:
        showTopSnackBar(
          context,
          CustomSnackBar.info(
            message: myMessage.message,
          ),
        );
        break;
      case MessageTypes.success:
        showTopSnackBar(
          context,
          CustomSnackBar.success(
            message: myMessage.message,
          ),
        );
        break;
      case MessageTypes.error:
        showTopSnackBar(
          context,
          CustomSnackBar.error(
            message: myMessage.message,
          ),
        );
        break;
    }
  }

  _buildDialogBody() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 20),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(50)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            alignment: Alignment.center,
            width: double.infinity,
            child: Text(TextConstants.howToPlayTitle,
                style: GoogleFonts.mulish(
                    fontSize: 32, fontWeight: FontWeight.w700)),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(TextConstants.howToPlayText,
              style: GoogleFonts.mulish(
                  fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: ColorConstants.primaryGreyLight,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "A",
                    style: GoogleFonts.mulish(
                        fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Text(TextConstants.howToPlayRole1,
                  style: GoogleFonts.mulish(
                      fontSize: 15, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: ColorConstants.primaryOrange,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "A",
                    style: GoogleFonts.mulish(
                        fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                width: 16,
              ),
              Flexible(
                  child: Text(TextConstants.howToPlayRole2,
                      style: GoogleFonts.mulish(
                          fontSize: 15, fontWeight: FontWeight.w600))),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                    color: ColorConstants.primaryGreen,
                    borderRadius: BorderRadius.circular(12)),
                child: Center(
                  child: Text(
                    "A",
                    style: GoogleFonts.mulish(
                        fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
              const SizedBox(
                width: 20,
              ),
              Flexible(
                  child: Text(TextConstants.howToPlayRole3,
                      style: GoogleFonts.mulish(
                          fontSize: 15, fontWeight: FontWeight.w600))),
            ],
          ),
        ],
      ),
    );
  }

  void _showTimerIfNeeded() async {
    final s = await DataSingleton().createWord();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey("last_game_word")) {
      if (prefs.getString("last_game_word") == s) {
        _showTimerDialog(prefs.getBool("last_game_result") ?? false);
      }
    }
  }

  void _makeWin(homeCubit) async {
    await _writeResults(true);
    await homeCubit.clearGameArea();
    _showTimerIfNeeded();
  }

  void _makeLose(homeCubit) async {
    await _writeResults(false);
    await homeCubit.clearGameArea();
    _showTimerIfNeeded();
  }

  Future _writeResults(bool isWin) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final lastWord = DataSingleton().secretWord;
    if (lastWord.isNotEmpty) {
      await prefs.setString('last_game_word', lastWord);
      await prefs.setBool('last_game_result', isWin);
    }
  }

  void _showTimerDialog(bool isWin) {
    final now = DateTime.now();
    final nextMidnight =
        DateTime(now.year, now.month, now.day).add(const Duration(days: 1));
    final int endTime = DateTime.now().millisecondsSinceEpoch +
        nextMidnight.difference(now).inMilliseconds;
    final CountdownTimerController _countDownController =
        CountdownTimerController(endTime: endTime, onEnd: _dismissTimerDialog);
    showDialog(
        barrierDismissible: false,
        context: context,
        barrierColor: Colors.transparent,
        builder: (BuildContext ctx) {
          return BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
            child: Dialog(
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
              ),
              backgroundColor: isWin
                  ? ColorConstants.primaryGreenLight
                  : ColorConstants.primaryRedLight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        isWin ? TextConstants.youWin : TextConstants.youLose,
                        style: GoogleFonts.mulish(
                            fontSize: 32, fontWeight: FontWeight.w700),
                      )),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Twemoji(
                      emoji: isWin ? '🎉' : '😩',
                      height: 80,
                      width: 80,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: Center(
                          child: Text(
                        TextConstants.nextWordle,
                        style: GoogleFonts.mulish(
                            fontSize: 25, fontWeight: FontWeight.w700),
                      )),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    CountdownTimer(
                      controller: _countDownController,
                      widgetBuilder: (_, CurrentRemainingTime? time) {
                        if (time == null) {
                          return Container();
                        }
                        final duration = Duration(
                            hours: time.hours ?? 0,
                            minutes: time.min ?? 0,
                            seconds: time.sec ?? 0);

                        return Text(
                          _durationToString(duration),
                          style: GoogleFonts.mulish(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  void _dismissTimerDialog() async{
    await DataSingleton().createWord();
    Navigator.of(context, rootNavigator: true).pop();
  }

  String _durationToString(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "${twoDigits(duration.inHours)}:$twoDigitMinutes:$twoDigitSeconds";
  }
}
