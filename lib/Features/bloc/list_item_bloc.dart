import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'list_item_event.dart';
part 'list_item_state.dart';

class ListItemBloc extends Bloc<ListItemEvent, ListItemState> {
  ListItemBloc() : super(ListItemInitial()) {
   on<SelectedComponents>(selectedComponents);
  }

  FutureOr<void> selectedComponents(SelectedComponents event, Emitter<ListItemState> emit) {
  emit(ShowSelectedList());
  
  }
}
