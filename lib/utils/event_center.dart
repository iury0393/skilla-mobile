import 'package:event/event.dart';

class EventCenter {
  //EXAMPLE
  final newPostEvent = Event<NewPostEventArgs>();

  static EventCenter _instance = EventCenter();

  static EventCenter getInstance() {
    if (_instance == null) {
      _instance = EventCenter();
    }
    return _instance;
  }
}

class NewPostEventArgs extends EventArgs {
  String id;

  NewPostEventArgs(this.id);
}
