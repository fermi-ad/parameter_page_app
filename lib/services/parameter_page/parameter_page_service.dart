import 'package:parameter_page/entities/parameter_page.dart';

abstract class ParameterPageService {
  Future<void> fetchPages(
      {required Function(String errorMessage) onFailure,
      required Function(List<dynamic> pageTitles) onSuccess});

  Future<void> fetchEntries(
      {required String forPageId,
      required Function(String errorMessage) onFailure,
      required Function(List<dynamic> entries) onSuccess});

  Future<String> createPage({required String withTitle});

  Future<void> deletePage(
      {required String withPageId,
      required Function(String errorMessage) onFailure,
      required Function() onSuccess});

  Future<void> savePage(
      {required String id,
      required ParameterPage page,
      required Function() onSuccess});
}
