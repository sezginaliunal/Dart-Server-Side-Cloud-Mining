import 'dart:io';

import 'package:mime/mime.dart';

String? getMimeType(String filePath) {
  final file = File(filePath);

  try {
    // Dosyanın ilk birkaç baytını okuyarak MIME türünü belirleyin
    final mimeType = lookupMimeType(file.path,
        headerBytes: file.readAsBytesSync().sublist(0, 4));
    return mimeType;
  } catch (e) {
    print('MIME türü belirlenirken bir hata oluştu: $e');
    return null;
  }
}
