import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rise/shared/cubit/task_state.dart';

class taskCubit extends Cubit {
  taskCubit() : super(taskInitialState());

  static taskCubit get(context) => BlocProvider.of(context);

  List<Map> tasks = [];
}
