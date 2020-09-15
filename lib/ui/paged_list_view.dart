import 'package:cubit_sample/bloc/bloc_list.dart';
import 'package:flutter/material.dart';

typedef ListItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class PagedListView extends StatelessWidget {
  final VoidCallback onLoadNextPage;

  final PagedListAsyncState state;

  final ListItemWidgetBuilder itemBuilder;

  const PagedListView(this.state,
      {Key key, @required this.itemBuilder, this.onLoadNextPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (state.hasData) {
      //Empty state
      if (state.payload.isEmpty) {
        return Center(child: Text('Empty state'));
      }
      //Data state
      return NotificationListener<ScrollUpdateNotification>(
        onNotification: (notification) {
          if (notification.metrics.pixels ==
              notification.metrics.maxScrollExtent) {
            onLoadNextPage?.call();
          }
          return true;
        },
        child: ListView.builder(
            itemBuilder: (context, index) =>
                itemBuilder(context, state.payload.elementAt(index)),
            itemCount: state.payload.length),
      );
    }
    //Error state
    if (state.hasError) {
      return Center(child: Text(state.error?.toString()));
    }
    //Progress state
    if (state.inProgress) {
      return Center(child: CircularProgressIndicator());
    }

    return SizedBox();
  }
}
