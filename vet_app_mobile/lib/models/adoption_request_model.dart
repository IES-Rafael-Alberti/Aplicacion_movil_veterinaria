import 'adoption_model.dart';

class AdoptionRequest {
  final String name;
  final String email;
  final String phone;
  final String reason;
  final AdoptionPet pet;
  final DateTime date;

  AdoptionRequest({
    required this.name,
    required this.email,
    required this.phone,
    required this.reason,
    required this.pet,
    required this.date,
  });
}

class AdoptionRequestHistory {
  static final List<AdoptionRequest> _requests = [];

  static List<AdoptionRequest> get requests => List.unmodifiable(_requests);

  static void add(AdoptionRequest request) {
    _requests.add(request);
  }
}
