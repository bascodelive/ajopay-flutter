import 'dart:convert';
import 'dart:typed_data';

import 'package:cross_file/cross_file.dart';
import 'package:share_plus/share_plus.dart';

/// Hands the OS share sheet an in-memory CSV file — no disk write, no
/// storage permission needed. "Save to Files"/"Save to Downloads" is
/// just one of the share sheet's own destinations, so this covers both
/// "share it" and "save it" with one call.
Future<void> shareCsv({required String csv, required String fileName}) async {
  final file = XFile.fromData(
    Uint8List.fromList(utf8.encode(csv)),
    name: fileName,
    mimeType: 'text/csv',
  );
  await Share.shareXFiles([file]);
}
