import 'package:flutter/material.dart';

class ParameterPageTabbarWidget extends StatefulWidget {
  List<String> titles;

  const ParameterPageTabbarWidget({super.key, this.titles});

  @override
  State<ParameterPageTabbarWidget> createState() {
    return _ParameterPageTabbarState();
  }
}

class _ParameterPageTabbarState extends State<ParameterPageTabbarWidget> {
  @override
  Widget build(BuildContext context) {
    List<Widget> tabs = [];

    for (String title in widget.titles) {
      tabs.add(Tab(text: title));
    }

    return PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: Visibility(
            visible: _isTabBarVisible(),
            child: Row(children: [
              Expanded(
                  child: TabBar(
                      key: const Key("parameter_page_tabbar"),
                      controller: _tabController,
                      tabs: tabs,
                      onTap: (tabIndex) => setState(
                          () => _page!.switchTab(to: titles[tabIndex])))),
              Visibility(
                  visible: _page != null && _page!.editing(),
                  child: IconButton(
                    key: const Key("create_tab_button"),
                    icon: const Icon(Icons.add),
                    onPressed: _handleCreateNewTab,
                  ))
            ])));
  }
}
