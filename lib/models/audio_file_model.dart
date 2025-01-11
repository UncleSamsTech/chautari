import 'dart:typed_data';

class FileModal {
  String fileName;
  String filePath;
  int size;
  String mimeType;
  Uint8List? bytes;
  FileModal(this.fileName, this.filePath, this.size,this.mimeType,{this.bytes});
}
