import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:goski_student/const/color.dart';
import 'package:goski_student/const/font_size.dart';
import 'package:goski_student/data/data_source/lesson_payment_service.dart';
import 'package:goski_student/data/model/instructor.dart';
import 'package:goski_student/data/model/reservation.dart';
import 'package:goski_student/data/repository/lesson_payment_repository.dart';
import 'package:goski_student/main.dart';
import 'package:goski_student/ui/component/goski_card.dart';
import 'package:goski_student/ui/component/goski_container.dart';
import 'package:goski_student/ui/component/goski_instructor_card.dart';
import 'package:goski_student/ui/component/goski_sub_header.dart';
import 'package:goski_student/ui/component/goski_text.dart';
import 'package:goski_student/ui/lesson/u023_lesson_reservation.dart';
import 'package:goski_student/ui/reservation/u022_instructors_introduction.dart';
import 'package:goski_student/view_model/lesson_payment_view_model.dart';
import 'package:goski_student/view_model/reservation_view_model.dart';
import 'package:goski_student/view_model/student_info_view_model.dart';

final BeginnerInstructorListViewModel beginnerInstructorListViewModel =
    Get.find<BeginnerInstructorListViewModel>();
final ReservationViewModel reservationViewModel =
    Get.find<ReservationViewModel>();

class ReservationTeamDetailScreen extends StatefulWidget {
  final BeginnerResponse teamInformation;

  const ReservationTeamDetailScreen({super.key, required this.teamInformation});

  @override
  State<ReservationTeamDetailScreen> createState() =>
      _ReservationTeamDetailScreenState();
}

class _ReservationTeamDetailScreenState
    extends State<ReservationTeamDetailScreen> {
  @override
  void initState() {
    beginnerInstructorListViewModel.getBeginnerInstructorList(
      widget.teamInformation.instructors,
      reservationViewModel.reservation.value.studentCount,
      reservationViewModel.reservation.value.duration,
      reservationViewModel.reservation.value.level,
      widget.teamInformation.teamId,
      widget.teamInformation.lessonType,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: GoskiSubHeader(
        title: tr(widget.teamInformation.teamName),
      ),
      body: GoskiContainer(
          buttonName: tr('reserveTeam', args: [
            NumberFormat('###,###,###').format(widget.teamInformation.cost)
          ]),
          onConfirm: () {
            Get.to(
                LessonReservationScreen(
                  teamInformation: widget.teamInformation,
                ), binding: BindingsBuilder(() {
              Get.lazyPut(() => LessonPaymentService());
              Get.lazyPut(() => LessonPaymentRepository());
              // Get.put(() => StudentInfoViewModel());
              Get.lazyPut(() => StudentInfoViewModel());
              Get.lazyPut(() => LessonPaymentViewModel());
            }));
          },
          child: SingleChildScrollView(
            child: Column(
              children: [
                GoskiCard(
                  child: Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: DecoratedBox(
                          decoration: const BoxDecoration(
                              color: goskiLightGray,
                              border: Border(
                                  bottom: BorderSide(
                                color: goskiDashGray,
                                width: 1.0, // 경계선 두께
                                style: BorderStyle.solid,
                              ))),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GoskiText(
                                text: tr(widget.teamInformation.teamName),
                                size: goskiFontXLarge,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  screenSizeController.getWidthByRatio(0.05),
                            ),
                            child: Column(
                              children: widget.teamInformation.teamImages
                                  .map((teamImage) => Image.network(
                                        teamImage.teamImageUrl,
                                        width: double.infinity,
                                      ))
                                  .toList(),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal:
                                  screenSizeController.getWidthByRatio(0.05),
                              vertical:
                                  screenSizeController.getWidthByRatio(0.03),
                            ),
                            child: GoskiText(
                                text: widget.teamInformation.description,
                                size: goskiFontLarge),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                GoskiCard(
                  child: Obx(() => ListTileTheme(
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 12.0),
                        horizontalTitleGap: 0,
                        minLeadingWidth: 0,
                        dense: true,
                        child: ExpansionTile(
                          collapsedShape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          shape: const RoundedRectangleBorder(
                            side: BorderSide.none,
                          ),
                          title: GoskiText(
                            text: tr('instructorList'),
                            size: goskiFontXLarge,
                          ),
                          subtitle: GoskiText(
                            text: tr('ifSelectInstructor'),
                            size: goskiFontMedium,
                            color: goskiDarkGray,
                          ),
                          children: beginnerInstructorListViewModel.instructors
                              .asMap()
                              .entries
                              .map((entry) {
                            int index = entry.key;
                            Instructor instructor = entry.value;
                            String instPosition;
                            Color instbadgeColor;
                            switch (instructor.position) {
                              case 1:
                                instPosition = tr('boss');
                                instbadgeColor = goskiBlue;
                                break;
                              case 2:
                                instPosition = tr('eduTeamLeader');
                                instbadgeColor = goskiBlue;
                                break;
                              case 3:
                                instPosition = tr('teamLeader');
                                instbadgeColor = goskiDarkPink;
                                break;
                              case 4:
                                instPosition = tr('instructor');
                                instbadgeColor = goskiDarkGray;
                                break;
                              default:
                                instPosition = tr('instructor');
                                instbadgeColor = goskiDarkGray;
                            }
                            return GestureDetector(
                              // FIXME : 강사카드를 누르면 해당 강사 Detail부터 보여질 수 있도록 수정
                              onTap: () {
                                print(
                                    "강사 : ${instructor.userName}, index : $index");
                                Get.to(InstructorsIntroductionScreen(
                                  teamInfo: widget.teamInformation,
                                  instructorList:
                                      beginnerInstructorListViewModel
                                          .instructors,
                                  index: index,
                                ));
                              },
                              child: GoskiInstructorCard(
                                name: instructor.userName,
                                position: instPosition,
                                badgeColor: instbadgeColor,
                                description: instructor.description,
                                imagePath: instructor.instructorUrl,
                              ),
                            );
                          }).toList(),
                        ),
                      )),
                ),
              ],
            ),
          )),
    );
  }
}
