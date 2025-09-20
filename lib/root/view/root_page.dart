part of 'view.dart';


class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
      return MultiBlocProvider(
      providers: [
     
        BlocProvider(
          create:
              (context) => MapsCubit(
                MapsRepository(context.read<GeneralRepository>()),
              ),
        ),
        BlocProvider(
          create:
              (context) => SocialCubit(
                SocialRepository(context.read<GeneralRepository>()),
              ),
        ),
           BlocProvider(
          create:
              (context) => SocialCubit(
                SocialRepository(context.read<GeneralRepository>()),
              ),
        ),
           BlocProvider(
          create:
              (context) => SocialCubit(
                SocialRepository(context.read<GeneralRepository>()),
              ),
        ),
           BlocProvider(
          create:
              (context) => SocialCubit(
                SocialRepository(context.read<GeneralRepository>()),
              ),
        ),
  
      ],
      child: _HomeView(),
    );
  }
}



class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    int navBarIndex =
        context.select((RootCubit cubit) => cubit.state.navBarItem.index);

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, _) {
        if (didPop) return;
        if (navBarIndex == 0) {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
        } else {
          FocusManager.instance.primaryFocus?.unfocus();
          context.read<RootCubit>().getNavBarItem(NavBarItem.maps);
        }
      },
      child: SafeArea(
        top: false,
        right: false,
        left: false,
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          body: _HomeViewPages(),
          bottomNavigationBar: _BottomNavBar(),
        ),
      ),
    );
  }
}

class _HomeViewPages extends StatelessWidget {
  const _HomeViewPages();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      buildWhen: (previous, current) =>
          previous.navBarItem != current.navBarItem,
      builder: (context, state) {
        return IndexedStack(
          index: _getPageIndex(state),
          children: const [
            MapsPage(),
            JobsPage(),
            SocialPage(),
            AdsPage(),
            MorePage(),
          ],
        );
      },
    );
  }

  int _getPageIndex(RootState state) {
    switch (state.navBarItem) {
      case NavBarItem.maps:
        return 0;
      case NavBarItem.jobs:
        return 1;
      case NavBarItem.social:
        return 2;
      case NavBarItem.ads:
        return 3;
      case NavBarItem.more:
        return 4;
    }
  }
}

class _BottomNavBar extends StatelessWidget {
  const _BottomNavBar();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RootCubit, RootState>(
      buildWhen: (previous, current) =>
          previous.navBarItem != current.navBarItem,
      builder: (context, state) {
        return BottomNavBarWidget(
          currentIndex: state.navBarItem.index,
          onTapMaps: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<RootCubit>().getNavBarItem(NavBarItem.maps);
          },
          onTapJobs: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<RootCubit>().getNavBarItem(NavBarItem.jobs);
          },
          onTapSocial: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<RootCubit>().getNavBarItem(NavBarItem.social);
          },
          onTapAds: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<RootCubit>().getNavBarItem(NavBarItem.ads);
          },
          onTapMore: () {
            FocusManager.instance.primaryFocus?.unfocus();
            context.read<RootCubit>().getNavBarItem(NavBarItem.more);
          },
        );
      },
    );
  }
}
