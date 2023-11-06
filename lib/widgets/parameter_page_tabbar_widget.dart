import 'package:flutter/material.dart';

class ParameterPageTabbarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final List<String> tabTitles;

  final Function(String) onTabSwitched;

  final Function() onCreateNewTab;

  final Function(String) onDeleteTab;

  final bool editing;

  const ParameterPageTabbarWidget(
      {super.key,
      required this.tabTitles,
      required this.onTabSwitched,
      required this.onCreateNewTab,
      required this.onDeleteTab,
      required this.editing});

  @override
  State<ParameterPageTabbarWidget> createState() {
    return _ParameterPageTabbarState();
  }

  @override
  Size get preferredSize => const Size(double.infinity, 50);
}

class _ParameterPageTabbarState extends State<ParameterPageTabbarWidget>
    with TickerProviderStateMixin {
  @override
  void initState() {
    _resetTabController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tabTitles.length != _tabController?.length) {
      _resetTabController();
    }

    return PreferredSize(
        preferredSize: const Size(double.infinity, 50),
        child: Visibility(
            visible: !_hideTabbar(),
            child: Row(children: [
              Expanded(
                  child: TabBar(
                      key: const Key("parameter_page_tabbar"),
                      controller: _tabController,
                      tabs: _buildTabs(),
                      onTap: (tabIndex) =>
                          widget.onTabSwitched(widget.tabTitles[tabIndex]))),
              Visibility(
                  visible: widget.editing,
                  child: IconButton(
                    key: const Key("create_tab_button"),
                    icon: const Icon(Icons.add),
                    onPressed: widget.onCreateNewTab,
                  ))
            ])));
  }

  List<Tab> _buildTabs() {
    List<Tab> tabs = [];

    final tabCanBeDeleted = widget.editing && widget.tabTitles.length != 1;

    for (String title in widget.tabTitles) {
      tabs.add(Tab(
          child: Row(children: [
        Text(title),
        const Spacer(),
        Visibility(
            visible: tabCanBeDeleted,
            child: IconButton(
                icon: const Icon(Icons.delete, size: 16.0),
                onPressed: () => widget.onDeleteTab(title))),
      ])));
    }

    return tabs;
  }

  bool _hideTabbar() {
    return widget.editing == false &&
        widget.tabTitles.length == 1 &&
        widget.tabTitles[0] == "Tab 1";
  }

  void _resetTabController() {
    _tabController =
        TabController(length: widget.tabTitles.length, vsync: this);
  }

  TabController? _tabController;
}