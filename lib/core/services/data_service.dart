abstract class DataService {
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period);
  Future<void> addActionPlan(Map<String, dynamic> plan);
}
