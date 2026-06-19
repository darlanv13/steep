abstract class DataService {
  Future<Map<String, dynamic>> getDashboardKpis(String fleet, String shift, String period);
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period);
  Future<void> addActionPlan(Map<String, dynamic> plan);
  Future<void> updateActionPlan(String id, Map<String, dynamic> updates);
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet);
  Future<void> updateChecklist(String id, Map<String, dynamic> updates);
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet);
  Future<void> updateComplianceData(String id, Map<String, dynamic> updates);
  Future<List<Map<String, dynamic>>> getGeofences();
  Future<void> addGeofence(Map<String, dynamic> geofence);
  Future<void> updateGeofence(String id, Map<String, dynamic> updates);
  Future<List<Map<String, dynamic>>> getIrisEvents();
  Future<List<Map<String, dynamic>>> getRcaAnalyses(String shift, String fleet, String period);
  Future<void> addRcaAnalysis(Map<String, dynamic> analysis);
  Future<void> updateRcaAnalysis(String id, Map<String, dynamic> updates);
  Future<List<Map<String, dynamic>>> getUsers();
  Future<void> addUser(Map<String, dynamic> user);
  Future<List<Map<String, dynamic>>> getDrivers();
  Future<void> addDriver(Map<String, dynamic> driver);
  Future<List<Map<String, dynamic>>> getVehicles();
  Future<void> addVehicle(Map<String, dynamic> vehicle);
}
