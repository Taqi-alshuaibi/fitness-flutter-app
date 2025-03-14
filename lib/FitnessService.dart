import 'dart:convert';
import 'package:http/http.dart' as http;

class FitnessService {
  final String baseUrl = "http://192.168.0.138/fitnes/index.php";

  // الحصول على جميع التمارين
  Future<List<dynamic>> getAllWorkouts() async {
    final response = await http.get(Uri.parse('$baseUrl/workouts'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل في جلب قائمة التمارين الرياضية');
    }
  }

  // إضافة تمرين جديد
  Future<Map<String, dynamic>> addWorkout(
      String exercise,
      int duration,
      int calories,
      String date,
      String location,
      ) async {
    final response = await http.post(
      Uri.parse('$baseUrl/workouts'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exercise': exercise,
        'duration': duration,
        'calories': calories,
        'date': date,
        'location': location, // أضيفت هنا حسب البارامتر
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('تعذر إضافة التمرين الجديد: ${response.body}');
    }
  }

  // تحديث بيانات التمرين
  Future<Map<String, dynamic>> updateWorkout(
      int id,
      String exercise,
      int duration,
      int calories,
      String date,
      ) async {
    final response = await http.put(
      Uri.parse('$baseUrl/workouts/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'exercise': exercise,
        'duration': duration,
        'calories': calories,
        'date': date,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('فشل في تحديث بيانات التمرين: ${response.body}');
    }
  }

  // حذف تمرين
  Future<Map<String, dynamic>> deleteWorkout(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/workouts/$id '),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('تعذر حذف التمرين المحدد: ${response.body}');
    }
  }
}