import 'dart:io';

void main() {
  final tempDir = Directory(Directory.systemTemp.path);
  print('Temp directory path: ${tempDir.path}');
  try {
    final List<FileSystemEntity> files = tempDir.listSync();
    print('Total files in temp: ${files.length}');
    for (final file in files) {
      if (file.path.contains('autozy')) {
        print('Found: ${file.path}');
      }
    }
  } catch (e) {
    print('Error listing temp dir: $e');
  }
}
