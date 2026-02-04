part of 'root_cubit.dart';

enum NavBarItem { maps, jobs, social, ads, more }

class RootState extends Equatable {
  const RootState({
    this.navBarItem = NavBarItem.maps,
  });


  final NavBarItem navBarItem;

  RootState copyWith({
    NavBarItem? navBarItem,
  }) =>
      RootState(
        navBarItem: navBarItem ?? this.navBarItem,
      );

  @override
  List<Object> get props => [
        navBarItem,
      ];
}
