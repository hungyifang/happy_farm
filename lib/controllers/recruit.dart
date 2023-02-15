import 'package:flutter/material.dart';
import 'dart:convert';
// firestore db
import 'package:cloud_firestore/cloud_firestore.dart';
// GetX
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class RecruitController extends GetxController {
  late BuildContext context;
  RecruitController({required this.context});

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  
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
  var currentStep = 0.obs;

  @override
  onInit() async {
    super.onInit();
    print(Get.currentRoute);
    if (Get.currentRoute == '/register') {
      await getData();
    }
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

  bool isLastStep(int steps) {
    return currentStep.value == steps;
  }

  String? validator(String? value) {
    if (value == null || value.isEmpty) {
      return '此為必填欄位';
    }
    return null;
  }

  String? timeValidator(String? value) {
    if (value == null || value.isEmpty) {
      return '此為必填欄位';
    }
    if (startController.text != '' &&
        endController.text != '' &&
        dateController.text != '') {
      var start =
          DateTime.parse("${dateController.text} ${startController.text}");
      var end = DateTime.parse("${dateController.text} ${endController.text}");
      var diff = end.difference(start);
      if (diff.isNegative || diff.inHours == 0) {
        return '請確認時間';
      }
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
                resetForm();
                await getData();
                Get.toNamed('/register');
                // Get.back();
                // if (context.mounted) Navigator.of(context).pop();
              },
            ),
          ],
        ),
      );
    }).onError((e, _) {
      // print("Error writing document: $e");
    });
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
                Get.back();
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
              await getData();
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
    dateController.text = '';
    startController.text = '';
    endController.text = '';
    priceController.text = '';
    maxController.text = '';
    recruitController.text = '';
    locationController.text = '';
    notesController.text = '';
    currentStep.value = 0;
    // focusNode.requestFocus();
  }

}
