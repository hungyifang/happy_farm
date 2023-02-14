import 'package:flutter/material.dart';
import 'package:happy_farm/layouts/main_layout.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
// firestore db
import 'package:cloud_firestore/cloud_firestore.dart';
// UI
import 'dart:ui';
import 'package:indexed/indexed.dart';
import 'package:flutter/services.dart';
// GetX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RegisterController extends GetxController {
  late BuildContext context;
  RegisterController({required this.context});

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final formKey = GlobalKey<FormState>();
  final dateController = TextEditingController();
  final startController = TextEditingController();
  final endController = TextEditingController();
  final priceController = TextEditingController();
  final maxController = TextEditingController();
  final recruitController = TextEditingController();
  final locationController = TextEditingController();
  final notesController = TextEditingController();
  final box = GetStorage();
  var listData = <dynamic>[].obs;

  @override
  onInit() async {
    super.onInit();
    await getData();
  }

  @override
  void onClose() {
    dateController.dispose();
    startController.dispose();
    endController.dispose();
    priceController.dispose();
    maxController.dispose();
    recruitController.dispose();
    locationController.dispose();
    notesController.dispose();
    super.onClose();
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return '此為必填欄位';
    }
    return null;
  }

  Future<void> getData() async {
    var data = await _db
        .collection('recruit')
        .orderBy('start', descending: true)
        .get();
    listData.assignAll(data.docs.map((doc) {
      var map = doc.data();
      map['id'] = doc.id;
      return map;
    }).toList());
  }

  String currentUserId() {
    return jsonDecode(box.read('user'))['uid'];
  }

  void create() async {
    if (formKey.currentState!.validate()) {
      var uid = currentUserId();
      Timestamp start = Timestamp.fromDate(
          DateTime.parse("${dateController.text} ${startController.text}"));
      Timestamp end = Timestamp.fromDate(
          DateTime.parse("${dateController.text} ${endController.text}"));
      Map<String, dynamic> submitData = {
        "recruiter": recruitController.text,
        "location": locationController.text,
        "max_people": int.parse(maxController.text),
        "notes": notesController.text,
        "price": int.parse(priceController.text),
        "participants": [],
        "start": start,
        "end": end,
        "creator": uid,
      };
      var result = await _db
          .collection("recruit")
          .add(submitData)
          .then((documentSnapshot) {
        // print("Added Data with ID: ${documentSnapshot.id}");
        Get.dialog(
          AlertDialog(
            // title: const Text('Dialog'),
            content: const Text('成功建立新團'),
            actions: [
              TextButton(
                child: const Text("關閉"),
                onPressed: () async {
                  await getData();
                  Get.back();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      }).onError((e, _) {
        // print("Error writing document: $e");
      });
    } else {
      Get.dialog(
        AlertDialog(
          // title: const Text('Dialog'),
          content: const Text('表單未填妥'),
          actions: [
            TextButton(
              child: const Text("關閉"),
              onPressed: () => Get.back(),
            ),
          ],
        ),
      );
    }
  }

  void patch(
      {required String docID, required Map<String, dynamic> data}) async {
    final doc = _db.collection("recruit").doc(docID);
    var result = _db.runTransaction((transaction) async {
      transaction.update(doc, data);
    }).then(
      (value) {
        Get.dialog(
          AlertDialog(
            content: const Text('更新成功'),
            actions: [
              TextButton(
                child: const Text("關閉"),
                onPressed: () async {
                  await getData();
                  Get.back();
                  if (context.mounted) Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
      onError: (e) {
        // print("Error updating document $e");
      },
    );
  }

  Future<void> delete({required String docID}) async {
    var result = await _db
        .collection("recruit")
        .doc(docID)
        .delete()
        .then((documentSnapshot) {
      Get.dialog(
        AlertDialog(
          content: const Text('刪除成功'),
          actions: [
            TextButton(
              child: const Text("關閉"),
              onPressed: () async {
                await getData();
                Get.back();
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }).onError((e, _) {
      // print("Error writing document: $e");
    });
  }

  void warning({required String docID}) {
    Get.dialog(
      AlertDialog(
        content: const Text('確定要刪除嗎？'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            onPressed: () async {
              await delete(docID: docID);
            },
            child: const Text("確定"),
          ),
          TextButton(
            onPressed: () async {
              Get.back();
            },
            child: const Text("取消"),
          ),
        ],
      ),
    );
  }

  void resetForm() {
    formKey.currentState?.reset();
    dateController.text = '';
    startController.text = '';
    endController.text = '';
    priceController.text = '';
    maxController.text = '';
    recruitController.text = '';
    locationController.text = '';
    notesController.text = '';
    // focusNode.requestFocus();
  }
}

class RegisterPage extends GetView<RegisterController> {
  RegisterPage({super.key});

  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<List> getList() async {
    var data = await _db
        .collection('recruit')
        .orderBy('start', descending: true)
        .get();
    return data.docs.map((doc) => doc.data()).toList();
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    Get.put(RegisterController(context: context));
    Widget body = Stack(
      children: [
        Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 5, 10, 0),
                  child: ElevatedButton(
                    onPressed: () {
                      controller.resetForm();
                      showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              contentPadding: EdgeInsets.zero,
                              scrollable: true,
                              content: Indexer(
                                clipBehavior: Clip.none,
                                children: <Widget>[
                                  Indexed(
                                      index: 10,
                                      child: Form(
                                        key: controller.formKey,
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Container(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 20, 0, 0),
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: Center(
                                                  child: RichText(
                                                text: const TextSpan(children: [
                                                  TextSpan(
                                                      text: "建立新團",
                                                      style: TextStyle(
                                                        color: Colors.black54,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        fontSize: 20,
                                                      )),
                                                  // WidgetSpan(
                                                  //   child:
                                                  //       Transform.translate(
                                                  //     offset: const Offset(
                                                  //         0.0, -5.0),
                                                  //     child: const Text(
                                                  //       '*',
                                                  //       style: TextStyle(
                                                  //           color:
                                                  //               Colors.red,
                                                  //           fontSize: 16),
                                                  //     ),
                                                  //   ),
                                                  // ),
                                                ]),
                                              )),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller: controller
                                                    .recruitController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '主揪 *',
                                                  icon: Icon(
                                                    Icons.account_box,
                                                    size: 30,
                                                  ),
                                                ),
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller: controller
                                                    .locationController,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '地點 *',
                                                  icon: Icon(
                                                    Icons.location_on,
                                                    size: 30,
                                                  ),
                                                ),
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.dateController,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '日期 *',
                                                  icon: Icon(
                                                    Icons.calendar_today,
                                                    size: 30,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  var pickedDate =
                                                      await showDatePicker(
                                                    initialDate: DateTime.now(),
                                                    firstDate:
                                                        DateTime(2020, 01),
                                                    lastDate:
                                                        DateTime(2100, 12),
                                                    context: context,
                                                  );
                                                  if (pickedDate != null) {
                                                    if (!mounted) return;
                                                    String formattedDate =
                                                        DateFormat('yyyy-MM-dd')
                                                            .format(pickedDate);
                                                    controller.dateController
                                                        .text = formattedDate;
                                                  }
                                                },
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.startController,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '開始時間 *',
                                                  icon: Icon(
                                                    Icons.schedule,
                                                    size: 30,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  var pickedtime =
                                                      await showTimePicker(
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    context: context,
                                                  );
                                                  if (pickedtime != null) {
                                                    if (!mounted) return;
                                                    DateTime parsedTime =
                                                        DateFormat.jm().parse(
                                                            pickedtime
                                                                .format(context)
                                                                .toString());
                                                    String formattedTime =
                                                        DateFormat('HH:mm:ss')
                                                            .format(parsedTime);
                                                    controller.startController
                                                        .text = formattedTime;
                                                  }
                                                },
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      55, 10, 10, 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.endController,
                                                readOnly: true,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '結束時間 *',
                                                ),
                                                onTap: () async {
                                                  var pickedtime =
                                                      await showTimePicker(
                                                    initialTime:
                                                        TimeOfDay.now(),
                                                    context: context,
                                                  );
                                                  if (pickedtime != null) {
                                                    if (!mounted) return;
                                                    DateTime parsedTime =
                                                        DateFormat.jm().parse(
                                                            pickedtime
                                                                .format(context)
                                                                .toString());
                                                    String formattedTime =
                                                        DateFormat('HH:mm:ss')
                                                            .format(parsedTime);
                                                    controller.endController
                                                        .text = formattedTime;
                                                  }
                                                },
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.maxController,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '人數上限 *',
                                                  icon: Icon(
                                                    Icons.group_add,
                                                    size: 30,
                                                  ),
                                                ),
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.priceController,
                                                textInputAction:
                                                    TextInputAction.done,
                                                keyboardType:
                                                    const TextInputType
                                                            .numberWithOptions(
                                                        signed: true,
                                                        decimal: true),
                                                inputFormatters: <
                                                    TextInputFormatter>[
                                                  FilteringTextInputFormatter
                                                      .digitsOnly
                                                ],
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '費用 *',
                                                  icon: Icon(
                                                    Icons.paid,
                                                    size: 30,
                                                  ),
                                                ),
                                                validator: controller.validator,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5,
                                                      horizontal: 10),
                                              child: TextFormField(
                                                controller:
                                                    controller.notesController,
                                                maxLines: null,
                                                // minLines: 3,
                                                keyboardType:
                                                    TextInputType.multiline,
                                                decoration:
                                                    const InputDecoration(
                                                  labelText: '備註',
                                                  icon: Icon(
                                                    Icons.description,
                                                    size: 30,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: ElevatedButton(
                                                onPressed: controller.create,
                                                child: Container(
                                                  height: 60,
                                                  decoration:
                                                      const BoxDecoration(
                                                          color: Colors.blue),
                                                  child: const Center(
                                                      child: Text(
                                                    "送出",
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.w800),
                                                  )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      )),
                                  Indexed(
                                    index: 100,
                                    child: Positioned(
                                      right: 5,
                                      top: 5,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context,
                                                  rootNavigator: true)
                                              .pop();
                                        },
                                        child: const CircleAvatar(
                                          radius: 12,
                                          backgroundColor: Colors.red,
                                          child: Icon(
                                            Icons.close,
                                            size: 18,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                    },
                    child: const Text(
                      "揪團",
                      style: TextStyle(fontWeight: FontWeight.w400),
                    ),
                  ),
                )
              ],
            ),
            Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.topCenter,
                child: Obx(
                  () => Table(
                    columnWidths: <int, TableColumnWidth>{
                      //指定索引及固定列寬
                      0: FixedColumnWidth(
                          (MediaQuery.of(context).size.width - 20) * 0.175),
                      1: FixedColumnWidth(
                          (MediaQuery.of(context).size.width - 20) * 0.225),
                      2: FixedColumnWidth(
                          (MediaQuery.of(context).size.width - 20) * 0.4),
                      3: FixedColumnWidth(
                          (MediaQuery.of(context).size.width - 20) * 0.1),
                      4: FixedColumnWidth(
                          (MediaQuery.of(context).size.width - 20) * 0.1),
                    },
                    border: const TableBorder(
                      top: BorderSide(
                          color: Colors.black87,
                          width: 1.0,
                          style: BorderStyle.solid),
                      bottom: BorderSide(
                          color: Colors.black87,
                          width: 1.0,
                          style: BorderStyle.solid),
                      horizontalInside: BorderSide(
                          color: Colors.black87,
                          width: 1.0,
                          style: BorderStyle.solid),
                    ),
                    children: [
                      TableRow(children: [
                        Container(
                          padding: const EdgeInsets.fromLTRB(2.5, 5, 0, 5),
                          child: const Text(
                            '主揪',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(2.5, 5, 0, 5),
                          child: const Text(
                            '地點',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(2.5, 5, 0, 5),
                          child: const Text(
                            '時間',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(2.5, 5, 0, 5),
                          child: const Text(
                            '人數',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.fromLTRB(2.5, 5, 5, 0),
                          child: const Text(
                            '',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ]),
                      ...controller.listData.map<TableRow>((recruit) {
                        Timestamp start = recruit['start'];
                        Timestamp end = recruit['end'];
                        DateTime convertStart =
                            DateTime.parse(start.toDate().toString());
                        DateTime convertEnd =
                            DateTime.parse(end.toDate().toString());
                        String time =
                            "${convertStart.year.toString()}-${convertStart.month.toString().padLeft(2, '0')}-${convertStart.day.toString().padLeft(2, '0')} ${convertStart.hour.toString().padLeft(2, '0')}:${convertStart.minute.toString().padLeft(2, '0')}～${convertEnd.hour.toString().padLeft(2, '0')}:${convertEnd.minute.toString().padLeft(2, '0')}";

                        List participants = recruit['participants'];
                        int participantsCount = participants.length;
                        String condition =
                            "${participantsCount.toString()} / ${recruit['max_people'].toString()}";

                        bool isCreator =
                            recruit['creator'] == controller.currentUserId();
                        bool isParticipant =
                            participants.contains(controller.currentUserId());

                        return TableRow(children: [
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: Text(
                                  recruit['recruiter'],
                                  style: const TextStyle(fontSize: 12),
                                )),
                          ),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                recruit['location'],
                                style: const TextStyle(fontSize: 12),
                              )),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(time,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    fontFeatures: [
                                      FontFeature.tabularFigures()
                                    ],
                                  ))),
                          TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Text(
                                condition,
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontFeatures: [FontFeature.tabularFigures()],
                                ),
                              )),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: IconButton(
                              icon: const Icon(Icons.more_vert),
                              color: Colors.black87,
                              tooltip: '報名詳細',
                              onPressed: () {
                                // print(recruit['id']);
                                Get.dialog(
                                  AlertDialog(
                                    contentPadding: EdgeInsets.zero,
                                    scrollable: true,
                                    content: Indexer(
                                      clipBehavior: Clip.none,
                                      children: <Widget>[
                                        Indexed(
                                          index: 10,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.fromLTRB(
                                                        0, 20, 0, 0),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                child: Center(
                                                    child: RichText(
                                                  text: TextSpan(children: [
                                                    TextSpan(
                                                        text:
                                                            "${convertStart.year.toString()}-${convertStart.month.toString().padLeft(2, '0')}-${convertStart.day.toString().padLeft(2, '0')} ${recruit['location']}",
                                                        style: const TextStyle(
                                                          color: Colors.black54,
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: 20,
                                                        )),
                                                  ]),
                                                )),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text(
                                                  '主揪：${recruit['recruiter']}',
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text(
                                                    '地點：${recruit['location']}'),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text('時間：$time'),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text('人數：$condition'),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text(
                                                    '費用：${recruit['price']}'),
                                              ),
                                              Container(
                                                alignment: Alignment.centerLeft,
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 5,
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.075),
                                                child: Text(
                                                    '備註：${recruit['notes']}'),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.025),
                                                child: Row(
                                                  children: [
                                                    Visibility(
                                                      maintainSize: true,
                                                      maintainAnimation: true,
                                                      maintainState: true,
                                                      visible: isCreator,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          style: const ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Colors
                                                                          .red)),
                                                          onPressed: () =>
                                                              controller.warning(
                                                                  docID: recruit[
                                                                      'id']),
                                                          child: const Center(
                                                              child: Text(
                                                            "刪除",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    // Visibility(
                                                    //   maintainSize: true,
                                                    //   maintainAnimation: true,
                                                    //   maintainState: true,
                                                    //   visible: isCreator,
                                                    //   child: Padding(
                                                    //     padding:
                                                    //         const EdgeInsets
                                                    //                 .symmetric(
                                                    //             vertical: 10,
                                                    //             horizontal: 10),
                                                    //     child: ElevatedButton(
                                                    //       style: const ButtonStyle(
                                                    //           backgroundColor:
                                                    //               MaterialStatePropertyAll(
                                                    //                   Colors
                                                    //                       .deepOrangeAccent)),
                                                    //       onPressed:
                                                    //           controller.create,
                                                    //       child: const Center(
                                                    //           child: Text(
                                                    //         "修改",
                                                    //         style: TextStyle(
                                                    //             color: Colors
                                                    //                 .white,
                                                    //             fontWeight:
                                                    //                 FontWeight
                                                    //                     .w600),
                                                    //       )),
                                                    //     ),
                                                    //   ),
                                                    // ),
                                                    const Spacer(),
                                                    Visibility(
                                                      visible: !isParticipant,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          onPressed: () =>
                                                              controller.patch(
                                                                  docID:
                                                                      recruit[
                                                                          'id'],
                                                                  data: {
                                                                "participants":
                                                                    FieldValue
                                                                        .arrayUnion([
                                                                  controller
                                                                      .currentUserId()
                                                                ])
                                                              }),
                                                          child: const Center(
                                                              child: Text(
                                                            "報名",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                    Visibility(
                                                      visible: isParticipant,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                vertical: 10,
                                                                horizontal: 10),
                                                        child: ElevatedButton(
                                                          style: const ButtonStyle(
                                                              backgroundColor:
                                                                  MaterialStatePropertyAll(
                                                                      Colors
                                                                          .red)),
                                                          onPressed: () =>
                                                              controller.patch(
                                                                  docID:
                                                                      recruit[
                                                                          'id'],
                                                                  data: {
                                                                "participants":
                                                                    FieldValue
                                                                        .arrayRemove([
                                                                  controller
                                                                      .currentUserId()
                                                                ])
                                                              }),
                                                          child: const Center(
                                                              child: Text(
                                                            "取消報名",
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600),
                                                          )),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Indexed(
                                          index: 100,
                                          child: Positioned(
                                            right: 5,
                                            top: 5,
                                            child: InkWell(
                                              onTap: () {
                                                Navigator.of(context,
                                                        rootNavigator: true)
                                                    .pop();
                                              },
                                              child: const CircleAvatar(
                                                radius: 12,
                                                backgroundColor: Colors.red,
                                                child: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ]);
                      }).toList()
                    ],
                  ),
                )),
          ],
        ),
        Positioned(
            bottom: 15,
            right: 15,
            child: FloatingActionButton(
              hoverElevation: 5,
              hoverColor: Colors.lightBlue,
              backgroundColor: Colors.blue,
              foregroundColor: Colors.white,
              mini: true,
              onPressed: () async {
                await controller.getData();
              },
              child: const Icon(Icons.autorenew),
            )),
      ],
    );
    return MainLayout(body: body, title: '報名', index: 1);
  }
}
