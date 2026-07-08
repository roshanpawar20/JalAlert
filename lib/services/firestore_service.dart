import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/report_model.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<ReportModel>> getReports() {
    return _firestore
        .collection("reports")
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return ReportModel.fromFirestore(
          doc.id,
          doc.data(),
        );
      }).toList();
    });
  }
}