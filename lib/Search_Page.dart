import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';

class SearchPage extends StatefulWidget {
  final String name;

  const SearchPage({Key? key, required this.name}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _filter = TextEditingController();
  String _searchText = '';

  late Future<File> imageFile;
  List<Stock> selectStock = [];
  late List<Stock> stocks = [];

  void initState() {
    super.initState();
    stocks = [];
    refreshlist();
  }

  refreshlist() {
    DatabaseHelper.instance.getStocks().then((imgs) {
      setState(() {
        stocks.clear();
        stocks.addAll(imgs);
      });
    });
  }

  bool _searchBoolean = false;
  List<int> _searchIndexList = [];

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < stocks.length; i++) {
            if (stocks[i].name.toString().contains(s)) {
              _searchIndexList.add(i);
            }
          }
        });
      },

      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(
              child: ListTile(
            leading: Container(
                width: 60,
                height: 60,
                child: Image(image: FileImage(File(stocks[index].image!)))),
            title: Text(stocks[index].name.toString()),
            subtitle: Text(stocks[index].amount.toString() +
                stocks[index].unit.toString()),
          ));
        });
  }

  Widget _defaultListView() {
    return ListView.builder(
        itemCount: stocks.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
            leading: Container(
                width: 60,
                height: 60,
                child: Image(image: FileImage(File(stocks[index].image!)))),
            title: Text(stocks[index].name.toString()),
            subtitle: Text(stocks[index].amount.toString() +
                stocks[index].unit.toString()),
          ));
        });
  }

  @override
  Widget build(BuildContext context) {
    // var name = _filter.text;

    return Scaffold(
        appBar: AppBar(
            title: !_searchBoolean ? Text(widget.name) : _searchTextField(),
            actions: !_searchBoolean
                ? [
                    IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = true;
                            _searchIndexList = [];
                          });
                        })
                  ]
                : [
                    IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchBoolean = false;
                          });
                        })
                  ]),
        body: !_searchBoolean ? _defaultListView() : _searchListView());
  }
}
