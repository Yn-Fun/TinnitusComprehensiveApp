import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/media_QSize.dart';

import '../configs/app_colors.dart';
import '../main.dart';

class DeviceInfoCalib extends StatefulWidget {
  const DeviceInfoCalib({super.key});

  @override
  State<DeviceInfoCalib> createState() => _DeviceInfoCalibState();
}

class _DeviceInfoCalibState extends State<DeviceInfoCalib> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      children: [
        Row(
          children: [
            Expanded(
                flex: 1,
                child: UserAccountsDrawerHeader(
                  decoration: const BoxDecoration(color: AppColors.pPurple), //楣
                  // decoration: const BoxDecoration(color: Colors.white),
                  accountName: Row(
                    children: const [
                      Text(
                        "耳鸣综合诊疗仪，QEHS-TI03",
                        style: TextStyle(fontSize: 28, color: Colors.white),
                      ),
                      //图放这里更小了
                    ],
                  ),

                  //用户名

                  accountEmail: null, //可放其他信息
                  currentAccountPictureSize: const Size.fromRadius(45), //头像大小

                  currentAccountPicture: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Image.asset(
                      'assets/images/laucher_qehs.png',
                      fit: BoxFit.contain,
                      // width: 50, //目录需要写完整
                    ),
                  ),
                ))
          ],
        ),
        ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.people),
            ),
            title: Text(
              "应用信息",
              style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
            ),
            subtitle: Text(
              "QEHS-TI03",
              style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
            )),
        const Divider(),
        ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.settings),
            ),
            title: Text("系统要求",
                style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
            subtitle: Text(
              "Android 10",
              style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
            )),
        const Divider(),
        ListTile(
            leading: const CircleAvatar(
              child: Icon(Icons.download_sharp),
            ),
            title: Text("APK安装路径（建议）",
                style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale))),
            subtitle: Text(
              "/storage/emulated/0/Download——外部存储公有下载目录",
              style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
            )),
        const Divider(),
        SizedBox(
          height: 50 * MediaQSize.heightRefScale,
        ),
        TextButton.icon(
          onPressed: () {
            readExcelData(); //已经已到main函数去了
            Navigator.pushNamed(context, "/excelDataDisp");
          },
          icon: Icon(
            Icons.table_chart_outlined,
            size: 30 * MediaQSize.heightRefScale,
          ),
          label: Text(
            "查看校准数据(导自Excel)",
            style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
          ),
        ),
        SizedBox(
          height: 50 * MediaQSize.heightRefScale,
        ),
        ListTile(
          title: TextButton.icon(
            onPressed: () {
              Navigator.pushNamed(context, "/calibration");
            },
            icon: Icon(
              Icons.playlist_add_check_circle,
              size: 50 * MediaQSize.heightRefScale,
            ),
            label: Text(
              "设备校准",
              style: TextStyle(fontSize: (30 * MediaQSize.heightRefScale)),
            ),
          ),
          subtitle: Center(
            child: Text(
              "(此功能入口仅限开发者使用)",
              style: TextStyle(fontSize: (20 * MediaQSize.heightRefScale)),
            ),
          ),
        ),
      ],
    ));
  }

  // Future<void> readExcelData() async {
  //   // String filePath = '/storage/emulated/0/Download/ForCalib_301Freq_SplDiff1k.xlsx';
  //   String filePath = '/storage/emulated/0/Download/XLSX2.xlsx';
  //   final file = File(filePath);
  //   if (await file.exists()) {
  //     print("文件存在");
  //     final bytes = await file.readAsBytes();
  //     final decoder = Excel.decodeBytes(bytes);
  //     final sheet = decoder.tables['Sheet1'];
  //     AudioConfig.excelData = sheet?.rows; //存起来
  //   } else {
  //     print('File not found');
  //   }

  //   // for (var table in excel.tables.keys) {  //遍历几个sheet子表     // print(table); //sheet Name
  //   //   print(excel.tables[table]?.maxCols); //两列    //   print(excel.tables[table]?.maxRows);
  //   //   for (var row in excel.tables[table]!.rows) {    //     print('$row');    //   }
  //   // }
  // }
}
