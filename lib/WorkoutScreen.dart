import 'package:flutter/material.dart';
import 'FitnessService.dart';

class WorkoutScreen extends StatefulWidget {
  const WorkoutScreen({super.key});

  @override
  State<WorkoutScreen> createState() => _WorkoutScreenState();
}

class _WorkoutScreenState extends State<WorkoutScreen> {
  final TextEditingController _exerciseController = TextEditingController();
  final TextEditingController _durationController = TextEditingController();
  final TextEditingController _caloriesController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  List<dynamic> workouts = [];
  int? _editingIndex;
  bool _showAddWorkoutForm = false;

  final FitnessService _fitnessService = FitnessService();

  @override
  void initState() {
    super.initState();
    _fetchWorkouts();
  }

  Future<void> _fetchWorkouts() async {
    try {
      final data = await _fitnessService.getAllWorkouts();
      setState(() {
        workouts = data;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في تحميل التمارين: $e')),
      );
    }
  }

  Future<void> _addOrUpdateWorkout() async {
    if (_exerciseController.text.isNotEmpty &&
        _durationController.text.isNotEmpty &&
        _caloriesController.text.isNotEmpty &&
        _locationController.text.isNotEmpty) {
      try {
        if (_editingIndex == null) {
          await _fitnessService.addWorkout(
            _exerciseController.text,
            int.parse(_durationController.text),
            int.parse(_caloriesController.text),
            DateTime.now().toIso8601String().split('T')[0],
            _locationController.text,
          );
        } else {
          await _fitnessService.updateWorkout(
            workouts[_editingIndex!]['id'],
            _exerciseController.text,
            int.parse(_durationController.text),
            int.parse(_caloriesController.text),
            DateTime.now().toIso8601String().split('T')[0],
          );
        }
        _fetchWorkouts();
        _exerciseController.clear();
        _durationController.clear();
        _caloriesController.clear();
        _locationController.clear();
        setState(() {
          _editingIndex = null;
          _showAddWorkoutForm = false;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('فشل في حفظ التمرين: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('يرجى ملء جميع الحقول')),
      );
    }
  }

  Future<void> _deleteWorkout(int index) async {
    try {
      await _fitnessService.deleteWorkout(workouts[index]['id']);
      _fetchWorkouts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('فشل في حذف التمرين: $e')),
      );
    }
  }

  void _editWorkout(int index) {
    setState(() {
      _editingIndex = index;
      _exerciseController.text = workouts[index]['exercise_name'];
      _durationController.text = workouts[index]['duration'].toString();
      _caloriesController.text = workouts[index]['calories_burned'].toString();
      _locationController.text = workouts[index]['location'];
      _showAddWorkoutForm = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('تمارين رياضية'),
        centerTitle: true,
        backgroundColor: const Color(0xFF34A694),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0F3443), Color(0xFF34A694)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: workouts.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          title: Text(
                            workouts[index]['exercise_name'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F3443),
                            ),
                          ),
                          subtitle: Text(
                            'المدة: ${workouts[index]['duration']} دقيقة\nالسعرات المحروقة: ${workouts[index]['calories_burned']}\nالموقع: ${workouts[index]['location']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _editWorkout(index),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteWorkout(index),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 100), // مساحة إضافية للزر
                ],
              ),
            ),
          ),
          // زر الإضافة المثبت في الأسفل
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  _showAddWorkoutForm = !_showAddWorkoutForm;
                  if (!_showAddWorkoutForm) {
                    _exerciseController.clear();
                    _durationController.clear();
                    _caloriesController.clear();
                    _locationController.clear();
                    _editingIndex = null;
                  }
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF34A694),
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                "إضافة تمرين",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          // نموذج الإضافة/التعديل
          if (_showAddWorkoutForm)
            Positioned(
              bottom: 80,
              left: 20,
              right: 20,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextField(
                      controller: _exerciseController,
                      decoration: const InputDecoration(
                        hintText: 'اسم التمرين',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _durationController,
                      decoration: const InputDecoration(
                        hintText: 'المدة (دقائق)',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _caloriesController,
                      decoration: const InputDecoration(
                        hintText: 'السعرات المحروقة',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _locationController,
                      decoration: const InputDecoration(
                        hintText: 'الموقع',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _addOrUpdateWorkout,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF34A694),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text(
                        _editingIndex == null ? "إضافة" : "تعديل",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}