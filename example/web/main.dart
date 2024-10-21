import 'package:web/web.dart' as web;
import 'package:practicing_dart_web_worker/practicing_dart_web_worker.dart';

void main() {
  final element = web.document.querySelector('#output') as web.HTMLDivElement;

  initializeWebWorker();

  getWebWorkerStream().listen((data) {
    if (data is! int) {
      terminateWebWorker();
      return;
    }
    element.innerText = element.innerText + String.fromCharCode(data.toInt());
    print(data);
    if (data >= 122) terminateWebWorker();
  });
}
