import 'package:flutter/material.dart';

import '../configs/media_QSize.dart';
import '../widgets/RefAudioPlayUI.dart';
import '../widgets/Volume.dart';

class TreatmentSection extends StatefulWidget {
  const TreatmentSection({super.key});

  @override
  State<TreatmentSection> createState() => _TreatmentSectionState();
}

class _TreatmentSectionState extends State<TreatmentSection> {
  @override
  Widget build(BuildContext context) {
    MediaQSize().initMQ(context); //唯一一页
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //没有返回键
        // backgroundColor: Colors.white,
        toolbarHeight: 70, //leading和title那行的位置高度
        centerTitle: true, //设置即可标题居中
        title: Text('开始治疗',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: (25 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
            ),
      ),
      body: Stack(children: [
        RefAudioPlayUI(),
        Container(
            padding: const EdgeInsets.only(
                    left: 20, top: 100, right: 20, bottom: 300) *
                MediaQSize.heightRefScale,
            child: const VolumeControl(leftVolume: 30, rightVolume: 70)),
        Padding(
          padding: EdgeInsets.only(
                  left: 0.27 * MediaQSize.thisDsize.width,
                  top: 0.35 * MediaQSize.thisDsize.height) *
              MediaQSize.heightRefScale,
          child: Column(
            children: [
              ListTile(
                  title: Text("耳鸣频率:4kHz",
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale)))),
              ListTile(
                  title: Text("耳鸣响度:50dB",
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale)))),
              ListTile(
                  title: Text("治疗音乐:夏夜雨声",
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale)))),
              ListTile(
                  title: Text("治疗强度:强",
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale)))),
              ListTile(
                  title: Text("治疗宽度:宽",
                      style: TextStyle(
                          fontSize: (20 * MediaQSize.heightRefScale)))),
            ],
          ),
        ),
      ]

          //      ListView(
          //   children: const [
          //     ListTile(
          //       title: Text("夏夜雨声"),
          //     ),
          //     Divider(),
          //     ListTile(
          //       title: Text("山间流水"),
          //     ),
          //     Divider(),
          //     ListTile(
          //       title: Text("林间小溪"),
          //     ),
          //     Divider(),
          //   ],
          // ),
          // //4-定时设置
          // ListView(
          //   children: const [
          //     ListTile(
          //       title: Text("定时时长"),
          //     )
          //   ],
          // ),
          ),
    );
  }
}
