//以下为文件6-quizSettingPage.dart中的内容：

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tinnitus_quizs/quiz_models/StoreQuizsTodate.dart';
import '../configs/media_QSize.dart';

//量表结果的历史记录
class quizSettingPage extends StatefulWidget {
  // String data;
  const quizSettingPage({super.key}); //, required this.data

  @override
  State<quizSettingPage> createState() => _quizSettingPageState();
}

class _quizSettingPageState extends State<quizSettingPage> {
  @override
  Widget build(BuildContext context) {
    // //调用函数 获取设备尺寸信息和缩放比
    // MediaQSize().initMQ(context);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,
        title: Text(
          '更多功能',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
        ),
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
        backgroundColor: Colors.white,
      ),
      //暂时不用了
      // floatingActionButton: Container(
      //     height: 80, //调整FloatingActionButton的大小
      //     width: 80,
      //     padding: const EdgeInsets.all(5),
      //     margin: const EdgeInsets.only(top: 37), //调整FloatingActionButton的位置

      //     child: FloatingActionButton(
      //       backgroundColor: AppColors.blue1,
      //       child: Container(
      //         margin: const EdgeInsets.all(0.1),
      //         // padding: const EdgeInsets.all(0.5),
      //         child: Flex(
      //             direction: Axis.vertical,
      //             mainAxisAlignment: MainAxisAlignment.center,
      //             children: const [
      //               Icon(
      //                 Icons.refresh,
      //                 size: 40,
      //                 color: Colors.white,
      //               ),
      //               Text(
      //                 "刷新",
      //                 style: TextStyle(color: Colors.white, fontSize: 15),
      //               ),
      //             ]),
      //       ),
      //       onPressed: () {
      //         Navigator.pushNamed(context, "/qrDisplay");
      //       },
      //     )),
      // floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, //纵向居中
          children: [
            Text("请用设备扫描读取：",
                style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale)),
            SizedBox(
              height: 20 * MediaQSize.heightRefScale,
            ),
            QrImage(
              data: StoreQuizs.strdata,
              size: 300 * MediaQSize.heightRefScale,
            ),
          ],
        ),
      ),
    );
  }
}
