import 'package:flutter_bloc/flutter_bloc.dart';
import 'item_event.dart';
import 'item_state.dart';
import '../services/api_service.dart';

class ItemBloc extends Bloc<ItemEvent, ItemState> {
  final ApiService apiService;

  ItemBloc(this.apiService) : super(ItemInitial());

  Stream<ItemState> mapEventToState(ItemEvent event) async* {
    if (event is FetchItems) {
      yield ItemLoading();
      try {
        final items = await apiService.fetchItems(event.query);
        yield ItemLoaded(items);
      } catch (e) {
        yield ItemError('Failed to fetch data');
      }
    }
  }
}
