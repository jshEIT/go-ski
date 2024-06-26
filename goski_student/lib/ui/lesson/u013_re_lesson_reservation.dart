import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:goski_student/const/color.dart';
import 'package:goski_student/const/font_size.dart';
import 'package:goski_student/main.dart';
import 'package:goski_student/ui/component/goski_card.dart';
import 'package:goski_student/ui/component/goski_container.dart';
import 'package:goski_student/ui/component/goski_expansion_tile.dart';
import 'package:goski_student/ui/component/goski_text.dart';
import 'package:goski_student/ui/component/goski_textfield.dart';

import '../component/goski_border_white_container.dart';
import '../component/goski_payment_button.dart';

// TODO: 재강습 기능 추가시 수정 필요
class ReLessonReservationScreen extends StatefulWidget {
  final List<_DummyStudentInfo> studentInfoList = [];
  bool isCouponSelected = false;
  final List<_DummyAmountOfPayment> amountOfPaymentList = [
    _DummyAmountOfPayment(name: '강습료', price: 120000),
    _DummyAmountOfPayment(name: '강사 지정료', price: 40000),
    _DummyAmountOfPayment(name: '재강습 할인', price: -20000),
  ];
  final List<_DummyPolicy> policyList = [
    _DummyPolicy(title: '필수 약관 전체 동의', isChecked: false),
    _DummyPolicy(title: '[필수] 개인정보 수집 및 이용', isChecked: false),
    _DummyPolicy(title: '[필수] 개인정보 제 3자 제공', isChecked: false),
    _DummyPolicy(title: '[선택] 마케팅 수신 동의', isChecked: false),
  ];

  ReLessonReservationScreen({
    super.key,
  });

  @override
  State<ReLessonReservationScreen> createState() =>
      _ReLessonReservationScreenState();
}

class _ReLessonReservationScreenState extends State<ReLessonReservationScreen> {
  final formatter = NumberFormat.simpleCurrency(locale: 'ko');
  DateTime? _selectedDate;

  int sum() {
    int sum = 0;

    for (int i = 0; i < widget.amountOfPaymentList.length; i++) {
      sum += widget.amountOfPaymentList[i].price;
    }

    return sum;
  }

  void onPolicyCheckboxClicked(_DummyPolicy item, int index, bool value) {
    if (index == 0) {
      for (_DummyPolicy policy in widget.policyList) {
        policy.isChecked = value;
      }
    } else {
      item.isChecked = value;
      bool checkedAll = true;

      for (int i = 1; i < widget.policyList.length; i++) {
        if (!widget.policyList[i].isChecked) {
          checkedAll = false;
          break;
        }
      }

      widget.policyList[0].isChecked = checkedAll;
    }
  }

  /// 특정 날짜 선택 가능한지 확인 하는 함수
  /// showDatePicker의 selectableDayPredicate: _isDateSelectable 처럼 사용하면 됨
  bool _isDateSelectable(DateTime day) {
    List<DateTime> availableDateList = [
      DateTime(2024, 4, 30),
      DateTime(2024, 5, 1),
      DateTime(2024, 5, 3),
      DateTime(2024, 5, 6),
    ];

    for (int i = 0; i < availableDateList.length; i++) {
      if (day.isAtSameMomentAs(availableDateList[i])) return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final titlePadding = screenSizeController.getHeightByRatio(0.010);
    final contentPadding = screenSizeController.getHeightByRatio(0.015);
    final cardPadding = screenSizeController.getWidthByRatio(0.03);
    final checkboxSize = screenSizeController.getWidthByRatio(0.05);

    return GoskiContainer(
      buttonName: tr('reservationConfirm', args: ['140,000']),
      onConfirm: () {},
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 예약 정보
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('reservationInfo'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    GoskiExpansionTile(
                      title: GoskiText(
                        text: tr('refundPolicy'),
                        size: goskiFontSmall,
                      ),
                      children: const [
                        GoskiText(
                          text:
                              '환불규정 내용입니다1\n환불규정 내용입니다2\n환불규정 내용입니다3\n환불규정 내용입니다4',
                          size: goskiFontSmall,
                        ),
                      ],
                    ),
                    SizedBox(height: contentPadding),
                    const GoskiText(
                      text: 'XX스키장 - 승민 스키교실\n지정강사 : 고승민',
                      size: goskiFontMedium,
                    ),
                  ],
                ),
              ),
            ),
            // 일정 선택
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('selectDateTime'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    GoskiBorderWhiteContainer(
                      child: TextWithIconRow(
                        text: _selectedDate != null
                            ? '${_selectedDate!.year}.${_selectedDate!.month.toString().padLeft(2, '0')}.${_selectedDate!.day.toString().padLeft(2, '0')}'
                            : tr('hintDate'),
                        textColor:
                            _selectedDate != null ? goskiBlack : goskiDarkGray,
                        icon: Icons.calendar_month,
                        onClicked: () {
                          // TODO. 날짜 선택 버튼을 눌렀을 때 동작 추가 필요
                          showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(DateTime.now().year + 1),
                            selectableDayPredicate: _isDateSelectable,
                          ).then((selectedDate) {
                            return setState(() {
                              _selectedDate = selectedDate;
                            });
                          });
                        },
                      ),
                    ),
                    SizedBox(height: titlePadding),
                    GoskiBorderWhiteContainer(
                      child: TextWithIconRow(
                        text: tr('hintTime'),
                        textColor: goskiDarkGray,
                        icon: Icons.access_time_rounded,
                        onClicked: () {
                          // TODO. 시간 선택 버튼을 눌렀을 때 동작 추가 필요
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 수강생 정보
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('studentInfo'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    GoskiText(
                      text: tr('reservationPeopleCount',
                          args: [widget.studentInfoList.length.toString()]),
                      size: goskiFontMedium,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: widget.studentInfoList.length,
                      itemBuilder: (context, index) {
                        _DummyStudentInfo item = widget.studentInfoList[index];

                        return GoskiExpansionTile(
                          title: GoskiText(
                            text: '${index + 1}. ${item.name}',
                            size: goskiFontMedium,
                          ),
                          children: [
                            Row(
                              children: [
                                GoskiText(
                                  text:
                                      '${item.age} / ${item.gender}\n${item.height} / ${item.weight} / ${item.feetSize}',
                                  size: goskiFontMedium,
                                ),
                              ],
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  widget.studentInfoList.removeAt(index);
                                });
                              },
                              child: Padding(
                                padding: EdgeInsets.only(
                                    right: screenSizeController
                                        .getWidthByRatio(0.01)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GoskiText(
                                      text: tr('delete'),
                                      size: goskiFontMedium,
                                      color: goskiDarkGray,
                                      textDecoration: TextDecoration.underline,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: titlePadding);
                      },
                    ),
                    SizedBox(height: titlePadding),
                    InkWell(
                      onTap: () {
                        // TODO. 진짜 수강생 정보 추가 로직으로 변경 필요
                        setState(() {
                          widget.studentInfoList.add(
                            _DummyStudentInfo(
                              name: '임종율',
                              gender: '남성',
                              age: '20대',
                              height: '170 ~ 179cm',
                              weight: '70 ~ 79kg',
                              feetSize: '270mm',
                            ),
                          );
                        });
                      },
                      child: GoskiBorderWhiteContainer(
                        child: GoskiText(
                          text: tr('addAccount'),
                          size: goskiFontMedium,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 요청사항
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('requestMessage'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    GoskiTextField(
                      hintText: tr('hintRequestMessage'),
                      hasInnerPadding: false,
                      maxLines: 5,
                      minLines: 1,
                      onTextChange: (text) {
                        // TODO: 로직 추가 필요
                      },
                    ),
                  ],
                ),
              ),
            ),
            // 쿠폰 선택
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        GoskiText(
                          text: tr('coupon'),
                          size: goskiFontLarge,
                          isBold: true,
                        ),
                        GoskiText(
                          text: tr('couponSelectCount', args: ['3']),
                          size: goskiFontMedium,
                        ),
                      ],
                    ),
                    SizedBox(height: titlePadding),
                    InkWell(
                      onTap: () {
                        setState(() {
                          widget.isCouponSelected = !widget.isCouponSelected;
                        });
                      },
                      child: GoskiBorderWhiteContainer(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoskiText(
                              text: widget.isCouponSelected
                                  ? tr('discount', args: ['20,000'])
                                  : tr('hintSelectCoupon'),
                              size: goskiFontMedium,
                              color: widget.isCouponSelected
                                  ? goskiLightPink
                                  : goskiDarkGray,
                              isBold: widget.isCouponSelected,
                            ),
                            const Icon(
                                size: goskiFontLarge,
                                Icons.keyboard_arrow_right)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // 결제 금액 확인
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('confirmAmountOfPayment'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    ListView.separated(
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.amountOfPaymentList.length,
                      itemBuilder: (context, index) {
                        _DummyAmountOfPayment item =
                            widget.amountOfPaymentList[index];

                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            GoskiText(
                              text: item.name,
                              size: goskiFontMedium,
                            ),
                            GoskiText(
                              text: tr(
                                'price',
                                args: [
                                  index != 0 && item.price > 0
                                      ? '+${formatter.format(item.price)}'
                                      : formatter.format(item.price)
                                ],
                              ),
                              size: goskiFontMedium,
                            ),
                          ],
                        );
                      },
                      separatorBuilder: (context, index) {
                        return SizedBox(height: titlePadding / 2);
                      },
                    ),
                    Divider(
                      thickness: 1,
                      height: contentPadding * 2,
                      color: goskiBlack,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GoskiText(
                          text: tr('amountOfPayment'),
                          size: goskiFontMedium,
                          isBold: true,
                        ),
                        GoskiText(
                          text: tr('price', args: [(formatter.format(sum()))]),
                          size: goskiFontMedium,
                          isBold: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // 결제 수단
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    GoskiText(
                      text: tr('paymentType'),
                      size: goskiFontLarge,
                      isBold: true,
                    ),
                    SizedBox(height: titlePadding),
                    GoskiPaymentButton(
                      width: screenSizeController.getWidthByRatio(1),
                      text: tr('kakaoPay'),
                      imagePath: 'assets/images/person1.png',
                      // TODO. 카카오페이 버튼으로 변경 필요
                      backgroundColor: kakaoYellow,
                      foregroundColor: goskiBlack,
                      onTap: () {},
                    ),
                    SizedBox(height: titlePadding),
                    GoskiPaymentButton(
                      width: screenSizeController.getWidthByRatio(1),
                      text: tr('naverPay'),
                      imagePath: 'assets/images/person2.png',
                      // TODO. 네이버페이 버튼으로 변경 필요
                      backgroundColor: naverPayGreen,
                      foregroundColor: goskiWhite,
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ),
            GoskiCard(
              child: Padding(
                padding: EdgeInsets.all(cardPadding),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.policyList.length,
                  itemBuilder: (context, index) {
                    _DummyPolicy item = widget.policyList[index];

                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          onPolicyCheckboxClicked(item, index, !item.isChecked);
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: contentPadding),
                        child: Row(
                          children: [
                            SizedBox(
                              width: checkboxSize,
                              height: checkboxSize,
                              child: Checkbox(
                                activeColor: goskiBlack,
                                visualDensity: VisualDensity.compact,
                                value: item.isChecked,
                                onChanged: (value) {
                                  setState(() {
                                    onPolicyCheckboxClicked(
                                        item, index, value!);
                                  });
                                },
                              ),
                            ),
                            SizedBox(width: titlePadding),
                            GoskiText(
                              text: item.title,
                              size: goskiFontMedium,
                              isBold: index == 0 ? true : false,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            SizedBox(height: contentPadding * 2),
          ],
        ),
      ),
    );
  }
}

class TextWithIconRow extends StatelessWidget {
  final String text;
  final Color textColor;
  final IconData icon;
  final VoidCallback onClicked;

  const TextWithIconRow(
      {super.key,
      required this.text,
      required this.icon,
      required this.onClicked,
      this.textColor = goskiBlack});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onClicked,
      child: Row(
        children: [
          Expanded(
            child: GoskiText(
              text: text,
              size: goskiFontMedium,
              color: textColor,
            ),
          ),
          Icon(
            size: goskiFontLarge,
            icon,
          ),
        ],
      ),
    );
  }
}

class _DummyStudentInfo {
  final String name, gender, age, height, weight, feetSize;

  _DummyStudentInfo({
    required this.name,
    required this.gender,
    required this.age,
    required this.height,
    required this.weight,
    required this.feetSize,
  });
}

class _DummyAmountOfPayment {
  final String name;
  final int price;

  _DummyAmountOfPayment({
    required this.name,
    required this.price,
  });
}

class _DummyPolicy {
  final String title;
  bool isChecked;

  _DummyPolicy({
    required this.title,
    required this.isChecked,
  });
}
