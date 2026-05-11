/// Contact Request Model
///
/// Data structure for submitting a support or inquiry message 
/// via the POST /api/store/contact endpoint.
class ContactRequestModel {
  final int? companyId;
  final String name;
  final String email;
  final String mobile;
  final String subject;
  final String message;

  ContactRequestModel({
    this.companyId,
    required this.name,
    required this.email,
    required this.mobile,
    required this.subject,
    required this.message,
  });

  Map<String, dynamic> toJson() {
    return {
      'company_id': companyId ?? 1,
      'name': name,
      'email': email,
      'mobile': mobile,
      'subject': subject,
      'message': message,
    };
  }
}
