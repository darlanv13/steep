import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';
import 'package:flutter/foundation.dart';
import 'data_service.dart';

class ParseDataService implements DataService {

  Map<String, dynamic> _parseObjectToMap(ParseObject object) {
    // ParseObject gives us standard methods to read its properties
    // We convert it to a Map to match the existing DataService interface
    final map = <String, dynamic>{};
    // getObjectId() -> id
    map['id'] = object.objectId;

    // As parse objects don't expose a simple toMap() for custom fields directly in a dynamic way
    // without knowing keys, we'll try to extract them via the internal JSON representation.
    // Or normally we fetch specific fields. For this generic port, toJson() usually contains the data.
    final json = object.toJson();
    map.addAll(json);
    return map;
  }

  @override
  Future<List<Map<String, dynamic>>> getActionPlans(String shift, String fleet, String period) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('ActionPlans'))
        ..whereEqualTo('shift', shift)
        ..whereEqualTo('fleet', fleet);

      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        return (response.results as List<ParseObject>)
            .map((e) => _parseObjectToMap(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching action plans from Parse: $e");
      return [];
    }
  }

  @override
  Future<void> addActionPlan(Map<String, dynamic> plan) async {
    try {
      final parseObject = ParseObject('ActionPlans');

      plan.forEach((key, value) {
        parseObject.set(key, value);
      });

      await parseObject.save();
    } catch (e) {
      debugPrint("Error adding action plan to Parse: $e");
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getChecklists(String shift, String fleet) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Checklists'))
        ..whereEqualTo('shift', shift)
        ..whereEqualTo('fleet', fleet);

      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        return (response.results as List<ParseObject>)
            .map((e) => _parseObjectToMap(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching checklists from Parse: $e");
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getComplianceData(String fleet) async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('ComplianceData'))
        ..whereEqualTo('fleet', fleet);

      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        return (response.results as List<ParseObject>)
            .map((e) => _parseObjectToMap(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching compliance data from Parse: $e");
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getGeofences() async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('Geofences'));

      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        return (response.results as List<ParseObject>)
            .map((e) => _parseObjectToMap(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching geofences from Parse: $e");
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getIrisEvents() async {
    try {
      final query = QueryBuilder<ParseObject>(ParseObject('IrisEvents'));

      final ParseResponse response = await query.query();

      if (response.success && response.results != null) {
        return (response.results as List<ParseObject>)
            .map((e) => _parseObjectToMap(e))
            .toList();
      }
      return [];
    } catch (e) {
      debugPrint("Error fetching iris events from Parse: $e");
      return [];
    }
  }
}
