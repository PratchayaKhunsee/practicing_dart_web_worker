import 'dart:async';
import 'dart:js_interop';

/// Javascript's web worker.
///
/// Read more: [Web Worker API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API)
@JS('Worker')
extension type _Worker._(JSObject _) implements JSObject {
  external _Worker(String url);
  external void postMessage(JSArray message, [JSAny options]);
  external void terminate();
  external void addEventListener(String event, JSFunction callback);
  external void removeEventListener(String event, JSFunction callback);
}

/// Javascript's MessageEvent instance
///
/// Read more: [MessageEvent](https://developer.mozilla.org/en-US/docs/Web/API/MessageEvent)
@JS('MessageEvent')
extension type _MessageEvent._(JSObject _) implements JSObject {
  external JSAny get data;
}

_Worker? _worker;
StreamController<dynamic>? _streamController;
JSExportedDartFunction? _callback;

/// Initialize web worker dependencies. Only run the worker from "worker.js" URL path.
void initializeWebWorker() {
  final worker = _worker ??= _Worker('worker.js');
  _streamController ??= StreamController.broadcast();
  worker.addEventListener('message', _callback ??= _listenMessage.toJS);
}

/// Get web worker data receving stream.
Stream<dynamic> getWebWorkerStream() => (_streamController ??= StreamController.broadcast()).stream;

/// Terminate web worker dependencies.
void terminateWebWorker() {
  _streamController?.close();
  _streamController = null;
  final cb = _callback;
  if (cb != null) _worker?.removeEventListener('message', cb);
  _worker?.terminate();
  _worker = null;
}

/// Listen data from "worker.js" and convert data to Dart's equivalence.
void _listenMessage(_MessageEvent event) {
  _streamController?.sink.add(event.data.dartify());
}
