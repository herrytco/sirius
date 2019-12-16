import 'dart:io';

import 'package:sirius/folder/i_folder_provider.dart';
import 'package:path_provider/path_provider.dart';

class PathFolderProvider extends FolderProvider {
  Future<Directory> get root async {
    return await getApplicationDocumentsDirectory();
  }
}
