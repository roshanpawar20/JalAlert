class ReportModel {
  final String id;
  final String issue;
  final String waterLevel;
  final String address;
  final double latitude;
  final double longitude;

  ReportModel({
    required this.id,
    required this.issue,
    required this.waterLevel,
    required this.address,
    required this.latitude,
    required this.longitude,
  });

  factory ReportModel.fromFirestore(
    String id,
    Map<String, dynamic> data,
  ) {
    return ReportModel(
      id: id,
      issue: data["issue"] ?? "",
      waterLevel: data["waterLevel"] ?? "Low",
      address: data["address"] ?? "",
      latitude: (data["latitude"] ?? 0).toDouble(),
      longitude: (data["longitude"] ?? 0).toDouble(),
    );
  }
}