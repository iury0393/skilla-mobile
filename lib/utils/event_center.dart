import 'package:event/event.dart';

class EventCenter {
  final editEvent = Event<EditEventArgs>();

  static EventCenter _instance = EventCenter();

  static EventCenter getInstance() {
    if (_instance == null) {
      _instance = EventCenter();
    }
    return _instance;
  }
}

class EditEventArgs extends EventArgs {
  bool isEdited;

  EditEventArgs(this.isEdited);
}
