import 'package:flutter/material.dart';

// IMAGES
const kAppBarImg =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546364/App/vgwp9nhciqeuiqieevpe.png';
const kIntro1 =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546383/App/rndhn6wikxwo4vsupexz.png';
const kIntro2 =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546378/App/ezmtsy4nupyin3t8bmrn.png';
const kIntro3 =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546374/App/ian9tmkbqwg3jgbgz6gu.png';
const kLogo =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546365/App/oyqhsohhve0ny19uwssx.png';
const kGoogle =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546364/App/duwvq0nx8nu1ipssxzsz.jpg';
const kGoogleDev =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546365/App/wjyodpiqhffpldq01zvc.png';
const kIbm =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546364/App/hs7ofanrsg6rtnj8peu9.jpg';
const kIbmDev =
    'https://res.cloudinary.com/duujebpq4/image/upload/v1605546364/App/wazvggsssgjpvuieqk2h.png';
// COLORS
const kPurpleColor = Color(0xFF5931BF);
const kPurpleLightColor = Color(0xFF6945C5);
const kPurpleLighterColor = Color(0xFFAB97DF);
const kTransparent = Colors.transparent;
const kGreyColor = Color(0xFFC5C7CD);
const kRedColor = Color(0xFFEE6851);
const kSkillaPurple = Color(0xFF5931bf);
// API INFO
const kClientId = 'b7c96a89-eb9d-41a5-887f-aeccef11997e';
const kBaseURL = 'https://skilla-backend.herokuapp.com/';
const kApiBaseUrl = 'https://api.cloudinary.com/v1_1/duujebpq4/image/upload';
const kUploadPreset = 'otwdwv0m';
const kCloudName = 'duujebpq4';
// SENTRY
const kSentry_DSN =
    "https://cb87a7a092424e2e88359f621969eeb3@o475394.ingest.sentry.io/5513392";
// FIREBASE ANALYTICS
//>> SIGN IN SCREEN
//>>>> TRACK PAGE
const kScreenNameSignIn = "signIn";
const kScreenClassOverrideSignIn = "SignInScreen";
//>>>> TRACK CLICK
const kNameSignIn = "do_sign_in";
const kNameNavigateSignIn = "do_navigate_to_sign_up";
//>> SIGN UP SCREEN
//>>>> TRACK PAGE
const kScreenNameSignUp = "signUp";
const kScreenClassOverrideSignUp = "SignUpScreen";
//>>>> TRACK CLICK
const kNameSignUp = "do_sign_up";
const kNameNavigateSignUp = "do_navigate_to_sign_in";
//>> PROFILE SCREEN
//>>>> TRACK PAGE
const kScreenNameProfile = "profile";
const kScreenClassOverrideProfile = "ProfileScreen";
//>>>> TRACK CLICK
const kNameProfile = "do_follow_profile";
const kNameEditProfile = "do_edit_profile";
const kNameLogOutProfile = "do_log_out_profile";
const kNameNavigateFollowerProfile = "do_navigate_follower_profile";
const kNameNavigateFollowingProfile = "do_navigate_following_profile";
const kNameNavigateWebsiteProfile = "do_navigate_website_profile";
const kNameShareProfile = "do_share_profile";
const kNameNavigateCurriculumProfile = "do_navigate_curriculum_profile";
const kNameNavigatePostDetailProfile = "do_navigate_post_detail_profile";
//>> FOLLOWING SCREEN
//>>>> TRACK PAGE
const kScreenNameFollowing = "following";
const kScreenClassOverrideFollowing = "FollowingScreen";
//>>>> TRACK CLICK
const kNameNavigateProfileFollowing = "do_navigate_profile_following";
//>> FOLLOWER SCREEN
//>>>> TRACK PAGE
const kScreenNameFollower = "follower";
const kScreenClassOverrideFollower = "FollowerScreen";
//>>>> TRACK CLICK
const kNameNavigateProfileFollower = "do_navigate_profile_follower";
//>> EDIT SCREEN
//>>>> TRACK PAGE
const kScreenNameEdit = "edit";
const kScreenClassOverrideEdit = "EditScreen";
//>>>> TRACK CLICK
const kNameEdit = "do_edit";
const kNameEditAvatar = "do_edit_avatar";
//>> CURRICULUM SCREEN
//>>>> TRACK PAGE
const kScreenNameCurriculum = "curriculum";
const kScreenClassOverrideCurriculum = "CurriculumScreen";
//>> POST SCREEN
//>>>> TRACK PAGE
const kScreenNamePost = "post";
const kScreenClassOverridePost = "PostScreen";
//>>>> TRACK CLICK
const kNamePost = "do_post";
const kNameGalleryPost = "do_photo_in_gallery_post";
const kNameCameraPost = "do_photo_in_camera_post";
//>> POST DETAIL SCREEN
//>>>> TRACK PAGE
const kScreenNamePostDetail = "postDetail";
const kScreenClassOverridePostDetail = "PostDetailScreen";
//>>>> TRACK CLICK
const kNameDeletePost = "do_delete_post_detail";
const kNameToggleLikePost = "do_toggle_like";
const kNameNavigateLikePost = "do_navigate_like_post_detail";
const kNameAddComment = "do_add_comment";
const kNameDeleteComment = "do_delete_comment";
//>> FEED SCREEN
//>>>> TRACK PAGE
const kScreenNameFeed = "feed";
const kScreenClassOverrideFeed = "FeedScreen";
//>>>> TRACK CLICK
const kNameNavigatePostFeed = "do_navigate_like_post_detail";
//>> SEARCH SCREEN
//>>>> TRACK PAGE
const kScreenNameSearch = "search";
const kScreenClassOverrideSearch = "SearchScreen";
//>>>> TRACK CLICK
const kNameNavigateProfileSearch = "do_navigate_profile_search";
