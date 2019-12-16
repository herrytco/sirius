import 'dart:io';

import 'package:sirius/folder/i_folder_provider.dart';

class TestFolderProvider extends FolderProvider {
  Future<Directory> get root async {
    return Directory(".");
  }
}
