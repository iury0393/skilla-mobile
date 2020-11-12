import 'package:event/event.dart';

class EventCenter {
  final editEvent = Event<EditEventArgs>();
  final newPostEvent = Event<NewPostEventArgs>();
  final deletePostEvent = Event<DeletePostEventArgs>();
  final scrollEvent = Event<ScrollEventArgs>();

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

class NewPostEventArgs extends EventArgs {
  bool isNewPost;

  NewPostEventArgs(this.isNewPost);
}

class DeletePostEventArgs extends EventArgs {
  bool isDeletedPost;

  DeletePostEventArgs(this.isDeletedPost);
}

class ScrollEventArgs extends EventArgs {
  bool isScrolling;

  ScrollEventArgs(this.isScrolling);
}
