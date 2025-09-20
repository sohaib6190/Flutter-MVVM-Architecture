part of 'generic_widgets.dart';
class GenericTabBarScreen extends StatelessWidget {
  final List<TabBarDataModel> tabs;

  const GenericTabBarScreen({super.key, required this.tabs});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child:Column(
          children: [
            12.h,
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 46,
                padding: EdgeInsets.all(4),
                
                decoration: BoxDecoration(
                  color: const Color(0xFFEDEDED),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: TabBar(
                  indicatorWeight: 3.0,
                  
                 indicatorSize:TabBarIndicatorSize.tab,
                 dividerColor: Colors.transparent,
                  indicator: BoxDecoration(
                    color: AppColorTheme().primary,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.black54,
                  

                  labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                  tabs: tabs.map((tab) => Tab(text: tab.title)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: tabs.map((tab) => tab.child).toList(),
              ),
            ),
          ],
        ),
     
    );
  }
}

class TabBarDataModel {
  final String title;
  final Widget child;

  TabBarDataModel({required this.title, required this.child});
}