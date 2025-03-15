import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class YemenFitnessClubsMap extends StatefulWidget {
  @override
  _YemenFitnessClubsMapState createState() => _YemenFitnessClubsMapState();
}

class _YemenFitnessClubsMapState extends State<YemenFitnessClubsMap> {
  late GoogleMapController mapController;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Set<Marker> _markers = {};
  LatLng _yemenCenter = LatLng(15.3694, 44.1910);
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _loadClubs();
  }

  void _loadClubs() {
    _firestore.collection('yemenFootballClubs').snapshots().listen((snapshot) {
      setState(() {
        _markers.clear();
        for (var doc in snapshot.docs) {
          final data = doc.data();
          _markers.add(Marker(
            markerId: MarkerId(doc.id),
            position: LatLng(data['latitude'], data['longitude']),
            infoWindow: InfoWindow(
              title: data['name'],
              snippet: '${data['city']} - ${data['stadium']}',
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          ));
        }
      });
    });
  }

  void _showAddClubDialog(LatLng position) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController cityController = TextEditingController();
    final TextEditingController stadiumController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('إضافة نادي جديد'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: 'اسم النادي',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'المدينة',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: stadiumController,
                  decoration: InputDecoration(
                    labelText: 'مكان النادي',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    cityController.text.isEmpty ||
                    stadiumController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('جميع الحقول مطلوبة')),
                  );
                  return;
                }

                setState(() => _isSaving = true);
                await _addClubToFirestore(
                  position,
                  nameController.text,
                  cityController.text,
                  stadiumController.text,
                );
                setState(() => _isSaving = false);
                Navigator.pop(context);
              },
              child: _isSaving
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text('حفظ النادي'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _addClubToFirestore(
      LatLng position,
      String name,
      String city,
      String stadium
      ) async {
    try {
      await _firestore.collection('yemenFootballClubs').add({
        'name': name,
        'city': city,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'stadium': stadium,
        'timestamp': FieldValue.serverTimestamp()
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تمت إضافة $name بنجاح!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('خطأ في حفظ النادي: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('أنديةالياقة البدنية اليمنية'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadClubs,
          )
        ],
      ),
      body: GoogleMap(
        onMapCreated: (controller) => mapController = controller,
        initialCameraPosition: CameraPosition(
          target: _yemenCenter,
          zoom: 7,
        ),
        markers: _markers,
        myLocationEnabled: true,
        mapType: MapType.normal,
        onLongPress: (LatLng position) => _showAddClubDialog(position),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.center_focus_strong),
        onPressed: () => mapController.animateCamera(
          CameraUpdate.newLatLngZoom(_yemenCenter, 7),
        ),
      ),
    );
  }
}