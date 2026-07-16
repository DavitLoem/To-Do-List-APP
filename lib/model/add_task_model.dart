import 'dart:convert';

List<TaskModel> taskModelFromJson(String str) =>
    List<TaskModel>.from(json.decode(str).map((x) => TaskModel.fromJson(x)));

String taskModelToJson(List<TaskModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class TaskModel {
  String id;
  String title;
  String description;
  String status;
  String priority;
  String categoryId;
  DateTime dueDate;
  bool isFavorite;
  bool isArchived;
  String userId;
  bool isDeleted;
  DateTime createdAt;
  DateTime updatedAt;

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.status,
    required this.priority,
    required this.categoryId,
    required this.dueDate,
    required this.isFavorite,
    required this.isArchived,
    required this.userId,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) => TaskModel(
    id: json["id"] ?? '',
    title: json["title"] ?? '',
    description: json["description"] ?? '',
    status: json["status"] ?? 'pending',
    priority: json["priority"] ?? '',
    categoryId: json["category_id"] ?? '',
    dueDate: DateTime.parse(json["due_date"]),
    isFavorite: json["is_favorite"] ?? false,
    isArchived: json["is_archived"] ?? true,
    userId: json["user_id"] ?? '',
    isDeleted: json["is_deleted"] ?? false,
    createdAt: DateTime.parse(json["created_at"]),
    updatedAt: DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "status": status,
    "priority": priority,
    "category_id": categoryId,
    "due_date": dueDate.toIso8601String(),
    "is_favorite": isFavorite,
    "is_archived": isArchived,
    "user_id": userId,
    "is_deleted": isDeleted,
    "created_at": createdAt.toIso8601String(),
    "updated_at": updatedAt.toIso8601String(),
  };
}
