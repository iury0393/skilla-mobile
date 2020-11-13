import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:skilla/Post/post_network.dart';
import 'package:skilla/utils/model/post.dart';
import 'package:skilla/utils/network/base_response.dart';

class PostBloc {
  StreamController<BaseResponse<void>> postController;
  TextEditingController textCaptionController;
  TextEditingController textFilesController;

  PostBloc() {
    postController = StreamController();
    textCaptionController = TextEditingController();
    textFilesController = TextEditingController();
  }

  dispose() {
    postController.close();
    textCaptionController.dispose();
    textFilesController.dispose();
  }

  doRequestAddPost(String secureUrl) async {
    postController.add(BaseResponse.loading());
    try {
      var body = Post(
        caption: textCaptionController.text,
        files: secureUrl,
        tags: "",
      ).toJson();
      await PostNetwork().doRequestAddPost(body);
      postController.add(BaseResponse.completed());
    } catch (e) {
      postController.add(BaseResponse.error(e.toString()));
    }
  }
}
