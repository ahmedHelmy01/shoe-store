class ContactModel {
  final int id;
  final String name;
  final String email;
  final String subject;
  final String message;
  final bool isRead;
  final DateTime? createdAt;

  ContactModel({
    required this.id,
    required this.name,
    required this.email,
    required this.subject,
    required this.message,
    required this.isRead,
    this.createdAt,
  });

  factory ContactModel.fromJson(Map<String, dynamic> json) {
    return ContactModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      subject: json['subject'] ?? '',
      message: json['message'] ?? '',
      isRead: json['is_read'] == true || json['is_read'] == 1,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at']) : null,
    );
  }

  static List<ContactModel> demo() => [
    ContactModel(
      id: 1,
      name: "Ahmed Ali",
      email: "ahmed.ali@example.com",
      subject: "Product Availability Inquiry",
      message: "Hello, I wanted to ask if the Organic Vitamin C Serum will be back in stock soon? I've been waiting for weeks.",
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    ContactModel(
      id: 2,
      name: "Sarah Johnson",
      email: "sarah.j@web.com",
      subject: "Shipping Delay",
      message: "My order #4452 hasn't arrived yet. The tracking info says it's still in the warehouse. Can you check please?",
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
    ),
    ContactModel(
      id: 3,
      name: "Mohamed Hassan",
      email: "m.hassan@service.net",
      subject: "Partnership Proposal",
      message: "We are a local logistics company interested in partnering with Tarshouby Store for last-mile delivery in Alexandria.",
      isRead: false,
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ContactModel(
      id: 4,
      name: "John Doe",
      email: "j.doe@test.com",
      subject: "Wrong Item Received",
      message: "I received a different shampoo than the one I ordered. I ordered the anti-dandruff one but got the herbal one.",
      isRead: true,
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];
}
