import 'package:event/event.dart';

class EventCenter {
  final editEvent = Event<EditEventArgs>();
  final newPostEvent = Event<NewPostEventArgs>();
  final deletePostEvent = Event<DeletePostEventArgs>();
  final likeEvent = Event<LikeEventArgs>();
  final unlikeEvent = Event<UnlikeEventArgs>();
  final followEvent = Event<FollowEventArgs>();
  final unFollowEvent = Event<UnFollowEventArgs>();

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

class LikeEventArgs extends EventArgs {
  bool isLike;

  LikeEventArgs(this.isLike);
}

class UnlikeEventArgs extends EventArgs {
  bool isUnlike;

  UnlikeEventArgs(this.isUnlike);
}

class FollowEventArgs extends EventArgs {
  bool isFollow;

  FollowEventArgs(this.isFollow);
}

class UnFollowEventArgs extends EventArgs {
  bool isUnFollow;

  UnFollowEventArgs(this.isUnFollow);
}
