//以下为文件3-quizSelectionPage.dart中的内容：
// 不然会和UI的size冲突

import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/app_colors.dart';
import '../configs/media_QSize.dart';
import '../quiz_models/Quiz_types.dart';
import '../quiz_models/QuizeLoadHelper.dart';
import '../quiz_models/StoreQuizsTodate.dart';

///量表展示栏目，
///加载量表基本信息，从折叠内页跳转 到 问卷入口（目前统一一个）
class QuizSelectionPage extends StatefulWidget {
  const QuizSelectionPage({super.key});
  @override
  QuizSelectionPageState createState() => QuizSelectionPageState();
}

class QuizSelectionPageState extends State<QuizSelectionPage> {
  //实例化一个问卷类
  // late List<QuizInfo> quizsList;
  late Future<bool> hasLoadAllQuizsFuture; //用于显示异步加载的flag

  @override
  //状态的重初始化
  void initState() {
    super.initState();
    hasLoadAllQuizsFuture = loadAllQuizs();
  }

//TODO 加载问卷的方式
  Future<bool> loadAllQuizs() async {
    //返回的是json文件路径 string类型
    final quizLoadHelper = QuizLoadHelper(); //实例化 1个文件转化的工具类quizLoadHelper
    //quizsList = []; //存放加载后的若干问卷
    for (QuizTypes aQuiztype in QuizTypes.values) {
      final tempquiz =
          await quizLoadHelper.getQuiz(aQuiztype); //get到了QuizInfo类的量表信息
      // 有问题就中断
      if (tempquiz == null) {
        return false;
      }
      StoreQuizs.quizsList.add(tempquiz);
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    // MediaQSize.thisDsize = MediaQuery.of(context).size;
    // print(MediaQSize.thisDsize); // 参考7寸Size(600.0, 912.0)，10寸:Size(800.0, 1232.0)
    //调用函数 获取设备尺寸信息和缩放比
    MediaQSize().initMQ(context); //唯一一页
    return FutureBuilder(
      future: hasLoadAllQuizsFuture, //先加载再return
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasData && snapshot.data == true) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              automaticallyImplyLeading: false, //不显示默认的小返回键
              centerTitle: true,
              title: Text(
                '耳鸣问诊',
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 18 * MediaQSize.heightRefScale,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              ),
              toolbarHeight:
                  50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
              leading: Builder(
                builder: (BuildContext context) {
                  return IconButton(
                    tooltip: "量表的更多操作",
                    icon: const Icon(Icons.more_horiz_outlined,
                        size: 30, color: Colors.black),
                    onPressed: () {
                      Scaffold.of(context).openDrawer(); //设置好打开侧栏
                    },
                  );
                },
              ),

              actions: [
                IconButton(
                  icon: const Icon(
                    IconData(0xe904, fontFamily: 'Path4icons'),
                    color: Colors.black,
                  ),
                  iconSize: 23 * MediaQSize.heightRefScale,
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierDismissible:
                          false, // user must tap button for close dialog!
                      builder: (BuildContext context) {
                        return AlertDialog(
                          contentPadding:
                              const EdgeInsets.fromLTRB(0, 20, 0, 20) *
                                  MediaQSize.widthRefScale,
                          icon: Stack(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                        left: 60, right: 60, top: 40) *
                                    MediaQSize.widthRefScale,
                                child: Text(
                                  '确认要重置数据吗？',
                                  style: TextStyle(
                                      fontSize: 20 * MediaQSize.widthRefScale,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Positioned(
                                bottom: 30 * MediaQSize.widthRefScale,
                                right: 0 * MediaQSize.widthRefScale,
                                child: IconButton(
                                    icon: Icon(Icons.cancel_outlined,
                                        color: AppColors.darkgrey,
                                        size:
                                            20 * MediaQSize.widthRefScale), //叉
                                    onPressed: Navigator.of(context).pop),
                              )
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          actionsAlignment: MainAxisAlignment.spaceEvenly,
                          content: Container(
                              width: MediaQSize.thisDsize.width * 0.3,
                              height: MediaQSize.thisDsize.height * 0.03,
                              alignment: Alignment.center,
                              child: Text('重置后数据全部删除',
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontSize:
                                          16 * MediaQSize.widthRefScale))),
                          actions: <Widget>[
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.Superlightgrey,
                                    side: const BorderSide(
                                        color: AppColors.pPurple, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: SizedBox(
                                    width: 25.5 * 4 * MediaQSize.widthRefScale,
                                    height: 8.8 * 5 * MediaQSize.widthRefScale,
                                    child: Center(
                                      child: Text(
                                        "否，继续作答",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              16 * MediaQSize.widthRefScale,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15 * MediaQSize.widthRefScale)
                              ],
                            ),
                            SizedBox(width: 15 * MediaQSize.widthRefScale),
                            Column(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.Superlightgrey,
                                    side: const BorderSide(
                                        color: AppColors.pPurple, width: 1.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                    StoreQuizs.clearAllQuizs();
                                  },
                                  child: SizedBox(
                                    width: 25.5 * 4 * MediaQSize.widthRefScale,
                                    height: 8.8 * 5 * MediaQSize.widthRefScale,
                                    child: Center(
                                      child: Text(
                                        "是，确认重置",
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500,
                                          fontSize:
                                              16 * MediaQSize.widthRefScale,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 15 * MediaQSize.widthRefScale)
                              ],
                            ),
                            SizedBox(height: 15 * MediaQSize.widthRefScale)
                          ],
                        );
                      },
                    );
                    setState(() {});
                  },
                )
              ],
            ),
            //侧拉栏
            drawer: Drawer(
                child: Scaffold(
              body: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 150 * MediaQSize.heightRefScale),
                    const Divider(),
                    TextButton.icon(
                        onPressed: () {
                          Navigator.pushNamed(context, '/qrDisplay');
                        },
                        icon: Icon(
                            const IconData(0xe901, fontFamily: 'BT3icons'),
                            size: 23 * MediaQSize.heightRefScale),
                        label: Text(
                          "二维码生成",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16 * MediaQSize.heightRefScale),
                        )),
                    const Divider(),
                    TextButton.icon(
                      onPressed: () {
                        // Navigator.pushNamed(context, "/quizhistory");//bug是由二维码界面进入历史记录界面后，如果按返回，会仍保留了删除前的码界面
                        Navigator.pushNamed(context,
                            "/quizhistory"); //更改为直接替代，直接返回结果界面，而不是二维码界面，免得上述问题
                      },
                      icon: Icon(const IconData(0xe902, fontFamily: 'BT3icons'),
                          size: 25 * MediaQSize.heightRefScale),
                      label: Text("本地记录",
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 16 * MediaQSize.heightRefScale)),
                    ),
                    const Divider(),
                  ],
                ),
              ),
            )),

            body: Container(
              height: MediaQSize.thisDsize.height,
              width: MediaQSize.thisDsize.width,
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/bg0.png"),
                      fit: BoxFit.cover)), //背景图0
              child: ListView(
                // mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                      padding: EdgeInsets.only(
                          left: 4 * 5.2 * MediaQSize.widthRefScale,
                          right: 4 * 5.2 * MediaQSize.widthRefScale,
                          top: 40 * MediaQSize.heightRefScale),
                      child: TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, "/thiIntro");
                        },
                        child: const Image(
                            image: AssetImage("assets/images/thi.png"),
                            fit: BoxFit.fill),
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 54 * 5.2 * MediaQSize.widthRefScale,
                          height: 50 * 5.2 * MediaQSize.widthRefScale,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0) *
                              MediaQSize.heightRefScale,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/vasIntro");
                            },
                            child: const Image(
                                image: AssetImage("assets/images/vas.png"),
                                fit: BoxFit.fill),
                          )),
                      Container(
                          width: 54 * 5.2 * MediaQSize.widthRefScale,
                          height: 50 * 5.2 * MediaQSize.widthRefScale,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0) *
                              MediaQSize.heightRefScale,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/tfiIntro");
                            },
                            child: const Image(
                                image: AssetImage("assets/images/tfi.png"),
                                fit: BoxFit.fill),
                          ))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                          width: 54 * 5.2 * MediaQSize.widthRefScale,
                          height: 50 * 5.2 * MediaQSize.widthRefScale,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0) *
                              MediaQSize.heightRefScale,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/teqIntro");
                            },
                            child: const Image(
                                image: AssetImage("assets/images/teq.png"),
                                fit: BoxFit.fill),
                          )),
                      Container(
                          width: 54 * 5.2 * MediaQSize.widthRefScale,
                          height: 50 * 5.2 * MediaQSize.widthRefScale,
                          margin: const EdgeInsets.fromLTRB(0, 10, 0, 0) *
                              MediaQSize.heightRefScale,
                          child: TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, "/psqiIntro");
                            },
                            child: const Image(
                                image: AssetImage("assets/images/psqi.png"),
                                fit: BoxFit.fill),
                          ))
                    ],
                  )
                ],
              ),
            ),
          );
        } else if (snapshot.hasError ||
            (snapshot.connectionState == ConnectionState.done &&
                snapshot.data == false)) {
          return AlertDialog(
            title: const Text('加载出错!'),
            actions: <Widget>[
              TextButton(
                child: const Text('重试'),
                onPressed: () => setState(() {
                  hasLoadAllQuizsFuture = loadAllQuizs();
                }),
              )
            ],
          );
        } else {
          return const Center(child: CircularProgressIndicator()); //加载中的提示动画
        }
      },
    );
  }
}
