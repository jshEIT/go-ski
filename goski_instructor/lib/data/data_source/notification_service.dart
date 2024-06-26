import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:goski_instructor/const/util/custom_dio.dart';
import 'package:goski_instructor/data/model/notification.dart';
import 'package:goski_instructor/main.dart';

class NotificationService extends GetxService {
  final baseUrl = dotenv.env['BASE_URL'];

  Future<List<NotiResponse>> fetchNotificationList() async {
    try {
      dynamic response = await CustomDio.dio.get(
        '$baseUrl/notification',
      );
      logger.w("notificationList: $response");

      if (response.statusCode == 200) {
        var data = response.data['data'];
        List<NotiResponse> notifications = List<NotiResponse>.from(
            data.map((item) => NotiResponse.fromJson(item)));
        return notifications;
      } else {
        logger.e("Failed to fetch data: Status code ${response.statusCode}");
        return [];
      }
    } catch (e) {
      logger.e('Error fetching NotificationList from server: $e');
      return [];
    }
  }

  Future<bool> deleteNotification(int notificationId) async {
    try {
      dynamic response = await CustomDio.dio.delete(
        '$baseUrl/notification/delete/$notificationId',
      );
      if (response.data['status'] == "success") {
        return true;
      }
    } catch (e) {
      logger.e("Failed to delete notification : $e");
    }
    return false;
  }
}
