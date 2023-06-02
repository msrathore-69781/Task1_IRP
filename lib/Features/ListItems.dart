import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:irp/Features/bloc/list_item_bloc.dart';
import '../Data/Item.dart';

class ListItm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'API ListView Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ListItem(),
    );
  }
}

class ListItem extends StatefulWidget {
  @override
  _ListItemState createState() => _ListItemState();
}

class _ListItemState extends State<ListItem> {
  List<Item> items = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    var url = Uri.https('api.github.com', '/users/freeCodeCamp/repos', {
      'type': 'public', // Add query parameter to fetch only public repositories
    });
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      setState(() {
        items = List<Item>.from(data.map((item) => Item.fromJson(item)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    ListItemBloc l=ListItemBloc();
    return BlocConsumer<ListItemBloc, ListItemState>(
      bloc: l,
      listenWhen: (previous, current) {
        if (current is ShowSelectedList){
          return true;
        }
        else
        return false;
      },
      listener: (context, state) {
        List<Item> selectedItems =
                  items.where((item) => item.selected).toList();
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: Text('Selected Items'),
                    content: Column(
                      children:
                          selectedItems.map((item) => Text(item.name)).toList(),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Close'),
                      ),
                    ],
                  );
                },
              );
      },
      builder: (context, state) {
        
        return Scaffold(
          appBar: AppBar(
            title: Text('List Of GitHub Repositories'),
          ),
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(items[index].name),
                leading: Checkbox(
                  value: items[index].selected,
                  onChanged: (bool? value) {
                    setState(() {
                      items[index].selected = value!;
                    });
                  },
                ),
              );
            },
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // Display the selected items
              l.add(SelectedComponents());
            },
            child: Icon(Icons.check),
          ),
        );
      },
    );
  }
}
