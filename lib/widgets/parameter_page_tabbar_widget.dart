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

  final int index;

  const ParameterPageTabbarWidget(
      {super.key,
      required this.tabTitles,
      required this.onTabSwitched,
      required this.onCreateNewTab,
      required this.onDeleteTab,
      required this.onRenameTab,
      required this.editing,
      required this.index});

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
                  visible: widget.editing, child: _buildCreateTabButton())
            ])));
  }

  TabBar _buildTabBar() {
    return TabBar(
        key: const Key("parameter_page_tabbar"),
        isScrollable: true,
        controller: _tabController,
        tabs: _buildTabs(),
        onTap: (tabIndex) => widget.onTabSwitched(widget.tabTitles[tabIndex]));
  }

  Widget _buildCreateTabButton() {
    return IconButton(
      key: const Key("create_tab_button"),
      icon: const Icon(Icons.add),
      onPressed: widget.onCreateNewTab,
    );
  }

  List<Tab> _buildTabs() {
    List<Tab> tabs = [];

    final tabCanBeDeleted = widget.editing && widget.tabTitles.length != 1;

    for (String title in widget.tabTitles) {
      tabs.add(Tab(
          child: SizedBox(
              width: 200.0,
              child: Row(children: [
                Expanded(child: Text(title, overflow: TextOverflow.ellipsis)),
                Visibility(
                  visible: widget.editing,
                  child: _buildTabMenuButton(
                      title: title, canBeDeleted: tabCanBeDeleted),
                )
              ]))));
    }

    return tabs;
  }

  PopupMenuButton<TabMenuItem> _buildTabMenuButton(
      {required String title, required bool canBeDeleted}) {
    return PopupMenuButton<TabMenuItem>(
      // Callback that sets the selected popup menu item.
      onSelected: (TabMenuItem selected) =>
          _handleMenuSelection(selected, title),
      itemBuilder: (BuildContext context) {
        return _buildTabMenuItems(canBeDeleted: canBeDeleted);
      },
    );
  }

  List<PopupMenuItem<TabMenuItem>> _buildTabMenuItems(
      {required bool canBeDeleted}) {
    List<PopupMenuItem<TabMenuItem>> ret = [
      const PopupMenuItem<TabMenuItem>(
        value: TabMenuItem.renameTab,
        child: Text('Rename'),
      )
    ];

    if (canBeDeleted) {
      ret.add(const PopupMenuItem<TabMenuItem>(
        value: TabMenuItem.deleteTab,
        child: Text('Delete'),
      ));
    }

    return ret;
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
    final controller = TextEditingController(text: tabTitle);
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Rename Tab'),
            content: TextField(
                key: const Key("tab_edit_rename_to"), controller: controller),
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
                  widget.onRenameTab(tabTitle, controller.text);
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
    _tabController!.animateTo(widget.index);
  }

  TabController? _tabController;
}
