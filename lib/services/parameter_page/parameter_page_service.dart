import 'package:parameter_page/entities/parameter_page.dart';

abstract class ParameterPageService {
  Future<List<dynamic>> fetchPages();

  Future<ParameterPage> fetchPage({required String id});

  Future<String> createPage({required String withTitle});

  //Future<void> deletePage({required String withPageId});

  Future<void> savePage({required String id, required ParameterPage page});

  Future<String> renamePage({required String id, required String newTitle});
}
