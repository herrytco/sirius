import 'dart:io';

abstract class FolderProvider {
  Future<Directory> get root;
}
