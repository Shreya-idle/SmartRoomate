class RoomDimensions {
  final double length;
  final double width;
  final double height;
  double get area => length * width;

  RoomDimensions({
    required this.length,
    required this.width,
    required this.height,
  });

  Map<String, dynamic> toJson() => {
    'length': length,
    'width': width,
    'height': height,
  };

  factory RoomDimensions.fromJson(Map<String, dynamic> json) => RoomDimensions(
    length: json['length'],
    width: json['width'],
    height: json['height'],
  );
}

class SensorData {
  final double noiseLevel; // dB measurement
  final int lightLevel; // Lux measurement
  final double temperature; // Celsius
  final String locationAccuracy; // GPS accuracy
  final DateTime measuredAt;

  SensorData({
    required this.noiseLevel,
    required this.lightLevel,
    required this.temperature,
    required this.locationAccuracy,
    required this.measuredAt,
  });

  Map<String, dynamic> toJson() => {
    'noiseLevel': noiseLevel,
    'lightLevel': lightLevel,
    'temperature': temperature,
    'locationAccuracy': locationAccuracy,
    'measuredAt': measuredAt.toIso8601String(),
  };

  factory SensorData.fromJson(Map<String, dynamic> json) => SensorData(
    noiseLevel: json['noiseLevel'],
    lightLevel: json['lightLevel'],
    temperature: json['temperature'],
    locationAccuracy: json['locationAccuracy'],
    measuredAt: DateTime.parse(json['measuredAt']),
  );
}

class RoomModel {
  final String id;
  final String title;
  final String description;
  final double rent;
  final String location;
  final RoomDimensions dimensions;
  final List<String> amenities;
  final List<String> images;
  final SensorData sensorData;
  final String ownerId;
  final bool isAvailable;
  final DateTime createdAt;
  final String? floorPlanUrl; // AR-generated floor plan
  final bool isVerified; // Biometric verification status

  RoomModel({
    required this.id,
    required this.title,
    required this.description,
    required this.rent,
    required this.location,
    required this.dimensions,
    required this.amenities,
    required this.images,
    required this.sensorData,
    required this.ownerId,
    required this.isAvailable,
    required this.createdAt,
    this.floorPlanUrl,
    this.isVerified = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'description': description,
    'rent': rent,
    'location': location,
    'dimensions': dimensions.toJson(),
    'amenities': amenities,
    'images': images,
    'sensorData': sensorData.toJson(),
    'ownerId': ownerId,
    'isAvailable': isAvailable,
    'createdAt': createdAt.toIso8601String(),
    'floorPlanUrl': floorPlanUrl,
    'isVerified': isVerified,
  };

  factory RoomModel.fromJson(Map<String, dynamic> json) => RoomModel(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    rent: json['rent'],
    location: json['location'],
    dimensions: RoomDimensions.fromJson(json['dimensions']),
    amenities: List<String>.from(json['amenities']),
    images: List<String>.from(json['images']),
    sensorData: SensorData.fromJson(json['sensorData']),
    ownerId: json['ownerId'],
    isAvailable: json['isAvailable'],
    createdAt: DateTime.parse(json['createdAt']),
    floorPlanUrl: json['floorPlanUrl'],
    isVerified: json['isVerified'] ?? false,
  );
}
