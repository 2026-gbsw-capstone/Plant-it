import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plant_it_fe/models/plant_care_guide_model.dart';
import 'package:plant_it_fe/models/plant_diary_model.dart';
import 'package:plant_it_fe/models/plant_model.dart';
import 'package:plant_it_fe/models/user_model.dart';
import 'package:plant_it_fe/services/api_service.dart';
import 'package:plant_it_fe/services/auth_service.dart';
import 'package:plant_it_fe/services/firebase_messaging_service.dart';
import 'package:plant_it_fe/services/image_upload_service.dart';
import 'package:plant_it_fe/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

part 'onboarding/onboarding_screen.dart';
part 'auth/auth_screen.dart';
part 'auth/password_reset_screen.dart';
part 'auth/google_auth_screen.dart';
part 'home/plant_home_shell.dart';
part 'home/plants_tab.dart';
part 'plant/plant_detail_screen.dart';
part 'encyclopedia/encyclopedia_tab.dart';
part 'profile/profile_tab.dart';
part 'profile/settings_screen.dart';
part 'profile/app_info_screen.dart';
part 'profile/notification_screen.dart';
part 'plant/add_plant_sheet.dart';
part 'plant/diary_sheet.dart';
part 'plant/plant_chat_panel.dart';
part 'shared/app_widgets.dart';

const _fallbackPlantImage = 'assets/images/figma/plant_pot.jpg';

class ProfileRouteScreen extends StatefulWidget {
  const ProfileRouteScreen();

  @override
  State<ProfileRouteScreen> createState() => ProfileRouteScreenState();
}

class ProfileRouteScreenState extends State<ProfileRouteScreen> {
  late Future<UserModel> _user;

  @override
  void initState() {
    super.initState();
    _user = ApiService.instance.getMe();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: _user,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Scaffold(body: _CenteredProgress());
        }
        if (!snapshot.hasData) {
          return Scaffold(
            body: _ErrorState(
              message: snapshot.error?.toString() ?? '오류가 발생했어요.',
              onRetry: () => setState(() => _user = ApiService.instance.getMe()),
            ),
          );
        }
        return Scaffold(body: SafeArea(child: ProfileTab(user: snapshot.requireData)));
      },
    );
  }
}
