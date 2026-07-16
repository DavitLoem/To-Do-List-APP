import 'package:to_do_list/core/api/network/api_client.dart';
import 'package:to_do_list/model/add_task_model.dart';

class TaskServices {
  final ApiClient _apiClient = ApiClient();

  // POST: Create a new task
  Future<dynamic> addTask(TaskModel task) async {
    return _apiClient.post('/tasks/', data: task.toJson());
  }

  // GET: List tasks with optional filters
  Future<dynamic> getTasks({
    String? status,
    String? priority,
    bool? isArchived = true,
    String sortBy = 'created_at',
  }) async {
    Map<String, dynamic> queryParams = {
      if (status != null) 'status': status,
      if (priority != null) 'priority': priority,
      if (isArchived != null) 'is_archived': isArchived,
      'sort_by': sortBy,
    };

    return _apiClient.get('/tasks/', queryParameters: queryParams);
  }

  // PUT: Update a task
  Future<dynamic> updateTask(String id, TaskModel task) async {
    return _apiClient.put('/tasks/$id', data: task.toJson());
  }

  // DELETE: Move a task to trash
  Future<dynamic> deleteTask(String id) async {
    return _apiClient.delete('/tasks/$id');
  }

  Future<dynamic> getCategories() async {
    return _apiClient.get('/categories/');
  }
}
