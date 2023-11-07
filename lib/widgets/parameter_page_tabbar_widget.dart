import 'package:flutter/material.dart';

enum TabMenuItem { renameTab, deleteTab }

class ParameterPageTabbarWidget extends StatefulWidget
    implements PreferredSizeWidget {
  final List<String> tabTitles;

  final Function(String) onTabSwitched;

  final Function() onCreateNewTab;

  final Function(String) onDeleteTab;

  final Function(String, String) onRenameTab;

  final bool editing;

  const ParameterPageTabbarWidget(
      {super.key,
      required this.tabTitles,
      required this.onTabSwitched,
      required this.onCreateNewTab,
      required this.onDeleteTab,
      required this.onRenameTab,
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
              Expanded(child: _buildTabBar()),
              Visibility(
                  visible: widget.editing,
                  child: IconButton(
                    key: const Key("create_tab_button"),
                    icon: const Icon(Icons.add),
                    onPressed: widget.onCreateNewTab,
                  ))
            ])));
  }

  TabBar _buildTabBar() {
    return TabBar(
        key: const Key("parameter_page_tabbar"),
        controller: _tabController,
        tabs: _buildTabs(),
        onTap: (tabIndex) => widget.onTabSwitched(widget.tabTitles[tabIndex]));
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
          visible: widget.editing,
          child: PopupMenuButton<TabMenuItem>(
            // Callback that sets the selected popup menu item.
            onSelected: (TabMenuItem selected) =>
                _handleMenuSelection(selected, title),
            itemBuilder: (BuildContext context) =>
                <PopupMenuEntry<TabMenuItem>>[
              const PopupMenuItem<TabMenuItem>(
                value: TabMenuItem.renameTab,
                child: Text('Rename'),
              ),
              PopupMenuItem<TabMenuItem>(
                value: TabMenuItem.deleteTab,
                child: Visibility(
                    visible: tabCanBeDeleted, child: const Text('Delete')),
              ),
            ],
          ),
        )
      ])));
    }

    return tabs;
  }

  void _handleMenuSelection(TabMenuItem selected, String tabTitle) {
    if (selected == TabMenuItem.renameTab) {
      _handleRenameTab(tabTitle);
    } else if (selected == TabMenuItem.deleteTab) {
      _handleDeleteTab(tabTitle);
    }
  }

  void _handleDeleteTab(String withTitle) {
    widget.onDeleteTab(withTitle);
  }

  void _handleRenameTab(String tabTitle) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rename Tab'),
            content: TextField(
              key: const Key("tab_edit_rename_to"),
              onChanged: (value) {
                setState(() {
                  _renameTabTo = value;
                });
              },
            ),
            actions: <Widget>[
              MaterialButton(
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              MaterialButton(
                child: const Text('OK'),
                onPressed: () {
                  widget.onRenameTab(tabTitle, _renameTabTo);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
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

  String _renameTabTo = "";

  TabController? _tabController;
}
