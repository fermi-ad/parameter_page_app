import 'package:flutter/material.dart';

class LandingPageWidget extends StatelessWidget {
  final Function() onOpenPage;

  final Function() onCreateNewPage;

  const LandingPageWidget(
      {super.key, required this.onOpenPage, required this.onCreateNewPage});

  @override
  Widget build(BuildContext context) {
    return Row(key: const Key("landing_page"), children: [
      const Spacer(),
      Column(children: [
        const Spacer(),
        _buildWelcomeBanner(),
        const SizedBox(height: 16.0),
        _buildOpenParameterPageButton(),
        const SizedBox(height: 16.0),
        _buildCreateNewParameterPageButton(),
        const Spacer()
      ]),
      const Spacer()
    ]);
  }

  Widget _buildWelcomeBanner() {
    return const Text("Welcome!");
  }

  Widget _buildOpenParameterPageButton() {
    return SizedBox(
        width: 256.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0.0,
                minimumSize: const Size.fromHeight(40)),
            onPressed: onOpenPage,
            child: const Text(
                style: TextStyle(color: Colors.white),
                "Open a Parameter Page")));
  }

  Widget _buildCreateNewParameterPageButton() {
    return SizedBox(
        width: 256.0,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                elevation: 0.0,
                minimumSize: const Size.fromHeight(40)),
            onPressed: onCreateNewPage,
            child: const Text(
                style: TextStyle(color: Colors.white),
                "Create a New Parameter Page")));
  }
}