import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/widgets/myRadioBtnVertical.dart';

import '../configs/app_colors.dart';
import '../configs/media_QSize.dart';
import '../widgets/ResidualConfirm.dart';
import '../widgets/TinnMatch.dart';
import '../widgets/hearingThresholdInput.dart';
import '../widgets/myRadioBtnHorizon.dart';
import '../widgets/playBarJustUI.dart';

class TinnTest extends StatefulWidget {
  const TinnTest({Key? key}) : super(key: key);

  @override
  State<TinnTest> createState() => _TinnTestState();
}

class _TinnTestState extends State<TinnTest>
    with SingleTickerProviderStateMixin {
  //混入一个mixin //定义一个controller
  late TabController _tabController;

  //生命周期函数:当组件初始化的时候就会触发
  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
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
        title: Text('耳鸣检测',
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: (25 * MediaQSize.heightRefScale)) //以竖直缩放比为字体大小的依据
            ),
        bottom: TabBar(
            padding: const EdgeInsets.all(1), //浮上来一些
            isScrollable: true,
            labelPadding: const EdgeInsets.only(left: 30, right: 30), //两栏的举例
            labelColor: Colors.white,
            unselectedLabelColor: Colors.grey[300],
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
            controller: _tabController, //注意：配置controller需要去掉TabBar上面的const
            tabs: [
              Tab(
                child: Text("耳鸣侧别",
                    style: TextStyle(
                        fontSize: (18 * MediaQSize.heightRefScale))), //抬头名
              ),
              Tab(
                child: Text("听力阈值",
                    style:
                        TextStyle(fontSize: (18 * MediaQSize.heightRefScale))),
              ),
              Tab(
                child: Text("耳鸣类型",
                    style:
                        TextStyle(fontSize: (18 * MediaQSize.heightRefScale))),
              ),
              Tab(
                child: Text("耳鸣匹配",
                    style:
                        TextStyle(fontSize: (18 * MediaQSize.heightRefScale))),
              ),
              Tab(
                child: Text("结果验证",
                    style:
                        TextStyle(fontSize: (18 * MediaQSize.heightRefScale))),
              )
            ]),
      ),

      //组件页面
      body: TabBarView(controller: _tabController, children: [
        //S2-1-耳鸣侧别
        Column(
          children: [
            MyRadioButtonTemp(
              title: '请选择您的耳鸣耳侧',
              options: const ['左耳', '右耳', '双耳'],
              onSelection: (selectedOption) {
                // 在这里处理选择的选项
                print(selectedOption);
              },
            ),
            SizedBox(
              height: 100 * MediaQSize.heightRefScale,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.pPurple,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(30) * MediaQSize.widthRefScale,
                ),
              ),
              onPressed: () {},
              child: Text('确认',
                  style: TextStyle(fontSize: (23 * MediaQSize.widthRefScale))),
            ),
          ],
        ),

        //S2-2-听力阈值
        // 获取输入的左耳和右耳在7个频率点处的听力阈值。
        Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, top: 50),
          child: Column(
            children: [
              Text("请在表格中输入您的声导听力阈值\n(单位：dB HL)",
                  style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale))),
              SizedBox(
                height: 60 * MediaQSize.heightRefScale,
              ),
              HearingThresholdInput(),
            ],
          ),
        ),

        //S2-3-耳鸣类型
        Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // MyRadioButtonTemp(
            //   title: '请选择与您耳鸣最相似的声音',
            //   options: const ['纯音', '噪声1(窄带)', '噪声2(中带)', '噪声3(宽带)'],
            //   onSelection: (selectedOption) {
            //     // 在这里处理选择的选项
            //     print(selectedOption);
            //   },
            // ),
            const SizedBox(height: 80),
            const HorizontalOptionSelector(
              title: '请选择与您耳鸣最相似的声音',
              options: ['纯音', '噪声1', '噪声2', '噪声3'],
            ),
            const SizedBox(height: 50),
            PlayBarJustUI(), //太简陋了
          ],
        ),

        //S2-4-耳鸣频率+响度匹配
        TinnitusMatchWidget(),
        //还有很多问题
        //5-定时设置

        ResidualConfirm(),
      ]),
    );
  }
}
