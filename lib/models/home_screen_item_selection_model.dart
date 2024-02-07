////Still not used.....can be safely deleted.

class HomeScreenItemSelectionModel {
  final String firstName;
  final String lastName;
  final String email;
  final bool isSelected;
  late final bool isSaved;
  HomeScreenItemSelectionModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.isSelected}) {
    // isSaved = firstName;
  }
}
