import 'package:cacai/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:cacai/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:cacai/ui/views/home/home_view.dart';
import 'package:cacai/ui/views/navigation_bar_with_f_a_b/navigation_bar_with_f_a_b_view.dart';
import 'package:cacai/ui/views/startup/startup_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

import 'package:cacai/ui/views/login/login_view.dart';
import 'package:cacai/ui/views/signup/signup_view.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: BottomNavDrawer),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: SignupView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: NavigationService),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}
