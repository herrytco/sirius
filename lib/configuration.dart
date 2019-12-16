import 'package:sirius/folder/i_folder_provider.dart';
import 'package:sirius/folder/path_folder_provider.dart';

class Configuration {
  static final FolderProvider folderProvider = PathFolderProvider();
}
