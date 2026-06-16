abstract class DataService {
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period);
  Future<void> addActionPlan(Map<String, dynamic> plan);
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet);
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet);
  Future<List<Map<String, dynamic>>> getGeofences();
  Future<List<Map<String, dynamic>>> getIrisEvents();
}
