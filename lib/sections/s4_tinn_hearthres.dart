import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/audio_set.dart';

import '../configs/media_QSize.dart';
import '../widgets/hearingThresholdInput.dart';

class TinnHearThres extends StatefulWidget {
//  const TinnHearThres({super.key});
  const TinnHearThres({Key? key}) : super(key: key);

  @override
  State<TinnHearThres> createState() => _TinnHearThresState();
}

class _TinnHearThresState extends State<TinnHearThres>
    with SingleTickerProviderStateMixin {
  //混入一个mixin //定义一个controller
  late TabController _s4_TabCtrl;

  //生命周期函数:当组件初始化的时候就会触发
  @override
  void initState() {
    super.initState();
    _s4_TabCtrl = TabController(length: 2, vsync: this);
  }

  List<String> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, //没有返回键
        // backgroundColor: Colors.white,
        toolbarHeight: 70, //leading和title那行的位置高度
        centerTitle: true, //设置即可标题居中
        title: Text('耳鸣听阈',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: (25 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
            ),
        bottom: TabBar(
            padding: const EdgeInsets.all(1), //浮上来一些
            isScrollable: true,
            labelPadding: const EdgeInsets.only(left: 30, right: 30), //两栏的举例
            labelColor: Colors.white,
            unselectedLabelColor: Colors.black,
            labelStyle: const TextStyle(fontSize: 23),
            unselectedLabelStyle: const TextStyle(fontSize: 20),
            indicator: const UnderlineTabIndicator(
                borderSide: BorderSide(
              color: Colors.white,
              strokeAlign: StrokeAlign.outside,
              width: 2,
            )),
            indicatorColor: Colors.white,
            indicatorWeight: 2,
            // indicatorPadding: const EdgeInsets.all(10),
            indicatorSize: TabBarIndicatorSize.label, //和文字等宽
            // 方框
            // BoxDecoration(color: AppColors.blueshine, borderRadius: BorderRadius.circular(5),)
            controller: _s4_TabCtrl, //注意：配置controller需要去掉TabBar上面的const
            tabs: [
              Tab(
                child: Text("耳鸣频率处的听力阈值",
                    style: TextStyle(
                        fontSize: (18 * MediaQSize.heightRefScale))), //抬头名
              ),
              Tab(
                child: Text("耳鸣声等响曲线测试",
                    style:
                        TextStyle(fontSize: (18 * MediaQSize.heightRefScale))),
              ),
            ]),
      ),

      //组件页面
      body: TabBarView(controller: _s4_TabCtrl, children: [
        //S4-1-耳鸣听阈
        Column(
          children: [
            const SizedBox(height: 50),
            Text("请调节音量，至刚好能听见耳机里的声音",
                style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
            const SizedBox(height: 200),
            Text('音量',
                style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_downward),
                  onPressed: () =>
                      setState(() => AudioConfig.leftVolume0_100--),
                ),
                Text('${AudioConfig.leftVolume0_100} dB',
                    style:
                        TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
                IconButton(
                  icon: const Icon(Icons.arrow_upward),
                  onPressed: () =>
                      setState(() => AudioConfig.leftVolume0_100++),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const SizedBox(height: 100),
            ElevatedButton(
              onPressed: () {},
              child: Text('确认',
                  style: TextStyle(fontSize: (25 * MediaQSize.heightRefScale))),
            ),
          ],
        ),

        //S2-2-等响曲线
        // 获取输入的左耳和右耳在7个频率点处的听力阈值。
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 50),
          child: Column(
            children: [
              Text("耳鸣声等响曲线（需测试）\n(单位：dB HL)",
                  style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
              SizedBox(
                height: 60 * MediaQSize.heightRefScale,
              ),
              HearingThresholdInput(),
            ],
          ),
        ),
      ]),
    );
  }
}
