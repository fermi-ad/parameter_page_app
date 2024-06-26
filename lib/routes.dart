import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_controls_core/flutter_controls_core.dart';
import 'package:parameter_page/services/authorization/authorization_service.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/services/settings_permission/settings_permission_service.dart';
import 'package:parameter_page/services/user_device/user_device_service.dart';
import 'package:parameter_page/widgets/auth_adapter_widget.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'package:parameter_page/widgets/parameter_page_scaffold_widget.dart';

List<GoRoute> configureRoutes(
    ACSysServiceAPI dpmService,
    ParameterPageService pageService,
    UserDeviceService deviceService,
    SettingsPermissionService permissionsService,
    AuthorizationService authService) {
  return [
    GoRoute(
        name: "LandingPage",
        path: "/",
        builder: (context, state) => AuthAdapterWidget(
            service: authService,
            child: LandingPageWidget(
              onOpenPage: () => context.go("/open"),
              onCreateNewPage: () => context.go("/page"),
            ))),
    GoRoute(
        name: "OpenParameterPage",
        path: "/open",
        builder: (context, state) => AuthAdapterWidget(
            service: authService,
            child: OpenPageWidget(
                key: const Key("open_page_route"),
                onOpen: (id, title) {
                  context.go("/page/$id");
                },
                service: pageService))),
    GoRoute(
        name: "NewParameterPage",
        path: "/page",
        builder: (context, state) => AuthAdapterWidget(
            service: authService,
            child: ParameterPageScaffoldWidget(
                acsysService: dpmService,
                pageService: pageService,
                deviceService: deviceService,
                settingsPermissionService: permissionsService))),
    GoRoute(
        name: "DisplayParameterPage",
        path: "/page/:id",
        builder: (context, state) => AuthAdapterWidget(
            service: authService,
            child: ParameterPageScaffoldWidget(
                acsysService: dpmService,
                pageService: pageService,
                deviceService: deviceService,
                settingsPermissionService: permissionsService,
                openPageId: state.pathParameters['id'])))
  ];
}
