import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:parameter_page/services/parameter_page/parameter_page_service.dart';
import 'package:parameter_page/widgets/landing_page_widget.dart';
import 'package:parameter_page/widgets/open_page_widget.dart';
import 'package:parameter_page/widgets/parameter_page_scaffold_widget.dart';

import 'services/dpm/dpm_service.dart';

String _openTitle = "";

List<GoRoute> configureRoutes(
    DpmService dpmService, ParameterPageService pageService) {
  return [
    GoRoute(
        name: "LandingPage",
        path: "/",
        builder: (context, state) => LandingPageWidget(
              onOpenPage: () => context.go("/open"),
              onCreateNewPage: () => context.go("/page"),
            )),
    GoRoute(
        name: "OpenParameterPage",
        path: "/open",
        builder: (context, state) => OpenPageWidget(
            key: const Key("open_page_route"),
            onOpen: (id, title) {
              _openTitle = title;
              context.go("/page/$id");
            },
            service: pageService)),
    GoRoute(
        name: "NewParameterPage",
        path: "/page",
        builder: (context, state) => ParameterPageScaffoldWidget(
            dpmService: dpmService, pageService: pageService)),
    GoRoute(
        name: "DisplayParameterPage",
        path: "/page/:id",
        builder: (context, state) => ParameterPageScaffoldWidget(
            dpmService: dpmService,
            pageService: pageService,
            title: _openTitle,
            openPageId: state.pathParameters['id']))
  ];
}
