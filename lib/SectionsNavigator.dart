//以下为文件2-SectionsNavigator.dart中的内容：
import 'package:flutter/material.dart';
import 'package:flutter_splash_screen/flutter_splash_screen.dart';
import '../configs/app_colors.dart';
import 'configs/media_QSize.dart';
import 'sections/s1_quiz_selection.dart';
import 'sections/s2_tinn_test.dart';
import 'sections/s3_treatment.dart';
import 'sections/s4_tinn_hearthres.dart';
import 'sections/s5_deviceinfo_calib.dart';

//底部一级目录导航 sectiions 的切换（使用bottomnavigationbar）
class SectionsNavigator extends StatefulWidget {
  int bottomIdx = 0; //一级目录默认位置
  SectionsNavigator({super.key, required this.bottomIdx});
  @override
  State<SectionsNavigator> createState() => _SectionsNavigatorState();
}

class _SectionsNavigatorState extends State<SectionsNavigator> {
  final List<Widget> _sections = [
    //一级目录 section  底部3 模块
    const QuizSelectionPage(),
    // const qrDisplayPage(),
    // const QuizLocalHisPage()
    const TinnTest(),
    const TreatmentSection(),
    const TinnHearThres(),
    const DeviceInfoCalib()
  ];

  @override
  void initState() {
    // 在某个有状态的组件中 关闭启动屏
    super.initState();
    Future.delayed(const Duration(milliseconds: 3000), () {
      FlutterSplashScreen.hide();
    }); // Future.delayed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _sections[widget.bottomIdx], //默认从第三模块
      bottomNavigationBar: BottomNavigationBar(
          showSelectedLabels: true,
          selectedItemColor: AppColors.pPurple,
          unselectedLabelStyle:
              TextStyle(fontSize: 18 * MediaQSize.widthRefScale),
          selectedLabelStyle:
              TextStyle(fontSize: 20 * MediaQSize.widthRefScale),
          selectedIconTheme: IconThemeData(
              color: AppColors.pPurple,
              size: 50 * MediaQSize.widthRefScale), //选中图标配色
          unselectedIconTheme:
              IconThemeData(size: 38 * MediaQSize.widthRefScale),
          currentIndex: widget.bottomIdx, //第几个菜单选中
          type: BottomNavigationBarType.fixed, //底部同时有＞3个的sections的时候 必须配置
          elevation: 10 * MediaQSize.widthRefScale,
          onTap: (index) {
            //点击菜单触发的方法
            setState(() {
              widget.bottomIdx = index; //index为当前被点击的索引
            });
          },
          //配合的
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.inventory_outlined), label: "耳鸣问诊"),
            BottomNavigationBarItem(
                icon: Icon(Icons.important_devices), label: "耳鸣检测"),
            BottomNavigationBarItem(
                icon: Icon(Icons.play_circle_outline), label: "开始治疗"),
            BottomNavigationBarItem(
                icon: Icon(Icons.tire_repair_rounded), label: "耳鸣听阈"),
            BottomNavigationBarItem(icon: Icon(Icons.info), label: "设备信息")
          ]),
    );
  }
}
