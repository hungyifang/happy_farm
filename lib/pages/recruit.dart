import 'package:flutter/material.dart';
import 'package:happy_farm/layouts/main_layout.dart';
import 'package:intl/intl.dart';
// tools
import 'package:happy_farm/tools/random_generator.dart';
// UI
import 'package:flutter/services.dart';
// GetX
import 'package:get/get.dart';
// controller
import 'package:happy_farm/controllers/recruit.dart';

class RecruitPage extends GetView<RecruitController> {
  RecruitPage({super.key});

  final List<GlobalObjectKey<FormState>> formKeyList = List.generate(
      3, (index) => GlobalObjectKey<FormState>(RandomGenerator.string(10)));

  List<Step> getSteps(BuildContext context, [bool mounted = true]) {
    String time = '';
    if (controller.dateController.text != '' &&
        controller.startController.text != '' &&
        controller.endController.text != '') {
      DateTime convertStart = DateTime.parse(
          "${controller.dateController.text} ${controller.startController.text}");
      DateTime convertEnd = DateTime.parse(
          "${controller.dateController.text} ${controller.endController.text}");
      time =
          "${convertStart.year.toString()}-${convertStart.month.toString().padLeft(2, '0')}-${convertStart.day.toString().padLeft(2, '0')} ${convertStart.hour.toString().padLeft(2, '0')}:${convertStart.minute.toString().padLeft(2, '0')}～${convertEnd.hour.toString().padLeft(2, '0')}:${convertEnd.minute.toString().padLeft(2, '0')}";
    }

    return [
      Step(
          state: controller.currentStep.value > 0
              ? StepState.complete
              : StepState.indexed,
          isActive: controller.currentStep.value >= 0,
          title: const Text('基本'),
          content: Form(
              key: formKeyList[0],
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      controller: controller.recruitController,
                      decoration: const InputDecoration(
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
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: TextFormField(
                      controller: controller.locationController,
                      decoration: const InputDecoration(
                        labelText: '地點 *',
                        icon: Icon(
                          Icons.location_on,
                          size: 30,
                        ),
                      ),
                      validator: controller.validator,
                    ),
                  ),
                ],
              ))),
      Step(
          state: controller.currentStep.value > 1
              ? StepState.complete
              : StepState.indexed,
          isActive: controller.currentStep.value >= 1,
          title: const Text('時間'),
          content: Form(
            key: formKeyList[1],
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  controller: controller.dateController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '日期 *',
                    icon: Icon(
                      Icons.calendar_today,
                      size: 30,
                    ),
                  ),
                  onTap: () async {
                    var pickedDate = await showDatePicker(
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020, 01),
                      lastDate: DateTime(2100, 12),
                      context: context,
                    );
                    if (pickedDate != null) {
                      if (!mounted) return;
                      String formattedDate =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                      controller.dateController.text = formattedDate;
                    }
                  },
                  validator: controller.validator,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  controller: controller.startController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '開始時間 *',
                    icon: Icon(
                      Icons.schedule,
                      size: 30,
                    ),
                  ),
                  onTap: () async {
                    var pickedtime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    if (pickedtime != null) {
                      if (!mounted) return;
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedtime.format(context).toString());
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      controller.startController.text = formattedTime;
                    }
                  },
                  validator: controller.validator,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(55, 10, 10, 10),
                child: TextFormField(
                  controller: controller.endController,
                  readOnly: true,
                  decoration: const InputDecoration(
                    labelText: '結束時間 *',
                  ),
                  onTap: () async {
                    var pickedtime = await showTimePicker(
                      initialTime: TimeOfDay.now(),
                      context: context,
                    );
                    if (pickedtime != null) {
                      if (!mounted) return;
                      DateTime parsedTime = DateFormat.jm()
                          .parse(pickedtime.format(context).toString());
                      String formattedTime =
                          DateFormat('HH:mm:ss').format(parsedTime);
                      controller.endController.text = formattedTime;
                    }
                  },
                  validator: controller.timeValidator,
                ),
              ),
            ]),
          )),
      Step(
          state: controller.currentStep.value > 2
              ? StepState.complete
              : StepState.indexed,
          isActive: controller.currentStep.value >= 2,
          title: const Text('詳細'),
          content: Form(
            key: formKeyList[2],
            child: Column(children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  controller: controller.maxController,
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
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
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  controller: controller.priceController,
                  textInputAction: TextInputAction.done,
                  keyboardType: const TextInputType.numberWithOptions(
                      signed: true, decimal: true),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  decoration: const InputDecoration(
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
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                child: TextFormField(
                  controller: controller.notesController,
                  maxLines: null,
                  // minLines: 3,
                  keyboardType: TextInputType.multiline,
                  decoration: const InputDecoration(
                    labelText: '備註',
                    icon: Icon(
                      Icons.description,
                      size: 30,
                    ),
                  ),
                ),
              ),
            ]),
          )),
      Step(
        isActive: controller.currentStep.value >= 3,
        title: const Text('確認'),
        content: Column(children: [
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '主揪：${controller.recruitController.text}',
              textAlign: TextAlign.left,
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '地點：${controller.locationController.text}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '時間：$time',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '人數上限：${controller.maxController.text}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '費用：${controller.priceController.text}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
          Container(
            alignment: Alignment.centerLeft,
            padding: EdgeInsets.symmetric(
                vertical: 5,
                horizontal: MediaQuery.of(context).size.width * 0.075),
            child: Text(
              '備註：${controller.notesController.text}',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ]),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, [bool mounted = true]) {
    Get.put(RecruitController(context: context));

    int steps = getSteps(context).length - 1;

    Widget body = Obx(() => Stepper(
          type: StepperType.horizontal,
          steps: getSteps(context),
          currentStep: controller.currentStep.value,
          onStepContinue: () async {
            if (controller.isLastStep(steps)) {
              bool allPass = false;
              for (var key in formKeyList) {
                key.currentState?.validate() ?? false
                    ? allPass = true
                    : allPass = false;
              }
              allPass
                  ? controller.create()
                  : Get.dialog(
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
            } else {
              if (formKeyList[controller.currentStep.value]
                      .currentState
                      ?.validate() ??
                  false) {
                controller.currentStep.value += 1;
              }
            }
          },
          onStepCancel: () {
            controller.currentStep.value == 0
                ? Get.toNamed('/register')
                : controller.currentStep.value -= 1;
          },
          onStepTapped: (value) {
            if (value > controller.currentStep.value) {
              if (formKeyList[controller.currentStep.value]
                      .currentState
                      ?.validate() ??
                  false) {
                controller.currentStep.value = value;
              }
            } else {
              controller.currentStep.value = value;
            }
          },
          controlsBuilder: (context, details) {
            return Container(
              margin: const EdgeInsets.only(top: 50),
              child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  onPressed: details.onStepCancel,
                  child: const Text('返回'),
                ),
                const SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    onPressed: details.onStepContinue,
                    child: Text(controller.isLastStep(steps) ? '完成' : '下一步')),
              ]),
            );
          },
        ));
    return MainLayout(body: body, title: '建立新團', index: 1);
  }
}
