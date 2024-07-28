// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:async';

class Utility {
  // Singleton Implementation
  factory Utility() => sharedReference;
  static final sharedReference = Utility._sharedInstance();
  Utility._sharedInstance();
  //

  String formatDate(DateTime date) {
    String day = date.day.toString().padLeft(2, '0');
    String month = date.month.toString().padLeft(2, '0');
    String year = date.year.toString();
    return "$day-$month-$year";
  }

  Future<String?> imagePicker() async {
    final completer = Completer<String?>();
    final uploadInput = html.FileUploadInputElement();
    uploadInput.accept = 'image/*';
    uploadInput.click();

    uploadInput.onChange.listen((e) {
      final files = uploadInput.files;

      if (files?.length == 1) {
        final reader = html.FileReader();
        reader.readAsDataUrl(files![0]);
        reader.onLoadEnd.listen((e) {
          completer.complete(reader.result as String?);
        });
      } else {
        completer.complete(null); // Handle error or no file selection
      }
    });

    return completer.future;
  }

  void openLink(String url) {
    html.window.open(url, '');
  }
}
