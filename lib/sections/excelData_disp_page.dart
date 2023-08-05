import 'package:flutter/material.dart';
import 'package:tinnitus_quizs/configs/audio_set.dart';
import '../configs/media_QSize.dart';

//量表结果的历史记录
class excelDataDisPage extends StatefulWidget {
  // String data;
  const excelDataDisPage({super.key}); //, required this.data

  @override
  State<excelDataDisPage> createState() => _excelDataDisPageState();
}

class _excelDataDisPageState extends State<excelDataDisPage> {
  @override
  Widget build(BuildContext context) {
    List<List<dynamic>>? data = AudioConfig.excelData;
    return Scaffold(
      appBar: AppBar(
        //automaticallyImplyLeading: false, //不显示默认的小返回键
        centerTitle: true,
        title: Text(
          '校准数据展示',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 25 * MediaQSize.heightRefScale),
        ),
        toolbarHeight: 50 * MediaQSize.heightRefScale, //leading和title那行的位置高度
      ),
      body: Padding(
        padding: EdgeInsets.only(
            left: 180.0 * MediaQSize.widthRefScale,
            top: 30 * MediaQSize.heightRefScale),
        child: SizedBox(
          height: 750 * MediaQSize.heightRefScale,
          child: Center(
              child: ListView.builder(
            itemCount: data?.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(
                    'Frequency: ${data![index][0].value},     SPL: ${data[index][1].value}'),
              );
            },
          )),
        ),
      ),
    );
  }
}
