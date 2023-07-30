import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';



class Vehicle {
  final String name;
  final String model;
  final double fuelEfficiency;
  final int age;

  Vehicle({
    required this.name,
    required this.model,
    required this.fuelEfficiency,
    required this.age,
  });

  factory Vehicle.fromMap(Map<String, dynamic> map) {
    return Vehicle(
      name: map['name'] as String,
      model: map['model'] as String,
      fuelEfficiency: map['fuelEfficiency'].toDouble(),
      age: map['age'].toInt(),
    );
  }
}

enum ColorCriteria { green, amber, red }

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = true;

  final Map<ColorCriteria, Color> colorMap = {
    ColorCriteria.green: Colors.green.shade200,
    ColorCriteria.amber: Colors.amber.shade200,
    ColorCriteria.red: Colors.red.shade200,
  };

  Future<void> _fetchVehicles() async {
    final response = await http.get(Uri.parse('http://localhost:4500/api/vehicles/'));
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _vehicles = data.map((item) => Vehicle.fromMap(item)).toList();
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to fetch vehicles');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchVehicles();
  }

  Future<void> _refreshVehicles() async {
    await Future.delayed(Duration(seconds: 2));
    await _fetchVehicles();
  }

  Color getColorForVehicle(Vehicle vehicle) {
    if (vehicle.fuelEfficiency >= 15.0 && vehicle.age <= 5) {
      return colorMap[ColorCriteria.green]!;
    } else if (vehicle.fuelEfficiency >= 15.0) {
      return colorMap[ColorCriteria.amber]!;
    } else {
      return colorMap[ColorCriteria.red]!;
    }
  }

  Widget buildVehicleTile(Vehicle vehicle) {
    final tileColor = getColorForVehicle(vehicle);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: ListTile(
          title: Text(
            vehicle.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
              fontSize: 17,
            ),
          ),
          subtitle: Text(
            '${vehicle.model} - ${vehicle.fuelEfficiency} km/l - ${vehicle.age} years old',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'Quicksand',
            ),
          ),
        ),
      ),
    );
  }

  void _showBottomPopup() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          padding: EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Colour Information',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Quicksand',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.circle, color: colorMap[ColorCriteria.green],),
                  SizedBox(width: 10,),
                  Text('Fuel efficient and low pollutant', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.circle, color: colorMap[ColorCriteria.amber],),
                  SizedBox(width: 10,),
                  Text('Fuel efficient and moderately pollutant', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Icon(Icons.circle, color: colorMap[ColorCriteria.red],),
                  SizedBox(width: 10,),
                  Text('High fuel consumption and  pollutant', style: TextStyle(fontFamily: 'Quicksand', fontWeight: FontWeight.bold),)
                ],
              ),
              SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.blueAccent,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.blueAccent,
          title: ShaderMask(
            blendMode: BlendMode.srcIn,
            shaderCallback: (Rect bounds) {
              return const LinearGradient(
                colors: [Colors.white, Colors.white70],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ).createShader(bounds);
            },
            child: const Text(
              "Vehicle List",
              style: TextStyle(
                  color: Color.fromRGBO(88, 101, 242, 0.9),
                  fontSize: 25,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.bold),
            ),
          ),
          actions: [
            IconButton(onPressed: _showBottomPopup, icon:Icon(Icons.info)),
          ],
        ),
        body:RefreshIndicator(
          onRefresh: _refreshVehicles,
          child: Column(
            children: [
              SizedBox(height: 10,),
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50.0),
                      topRight: Radius.circular(50.0),
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 28.0 , right: 28.0),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      Expanded(
                        child:  _isLoading
                            ? const Center(
                          child: CircularProgressIndicator( color: Colors.blueAccent,),
                        )
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListView.builder(
                            itemCount: _vehicles.length,
                            itemBuilder: (context, index) {
                              final vehicle = _vehicles[index];
                              return buildVehicleTile(vehicle);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

