abstract class ItemEvent {}

class FetchItems extends ItemEvent {
  final String query;

  FetchItems(this.query);
}
