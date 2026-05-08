import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:plant_it_fe/models/plant_care_guide_model.dart';
import 'package:plant_it_fe/models/plant_diary_model.dart';
import 'package:plant_it_fe/models/plant_model.dart';
import 'package:plant_it_fe/models/user_model.dart';
import 'package:plant_it_fe/services/api_service.dart';
import 'package:plant_it_fe/services/auth_service.dart';
import 'package:plant_it_fe/services/firebase_messaging_service.dart';
import 'package:plant_it_fe/theme.dart';

part 'onboarding/onboarding_screen.dart';
part 'auth/auth_screen.dart';
part 'auth/google_auth_screen.dart';
part 'home/plant_home_shell.dart';
part 'home/plants_tab.dart';
part 'plant/plant_detail_screen.dart';
part 'encyclopedia/encyclopedia_tab.dart';
part 'profile/profile_tab.dart';
part 'plant/add_plant_sheet.dart';
part 'plant/diary_sheet.dart';
part 'plant/plant_chat_panel.dart';
part 'shared/app_widgets.dart';

const _fallbackPlantImage = 'assets/images/figma/plant_pot.jpg';
