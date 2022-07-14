import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Stock.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController _filter = TextEditingController();
  String _searchText = '';

  // TextEditingController _filter 상태변화감지
  _SearchPageState(){
    _filter.addListener(() {
      setState((){
        _searchText = _filter.text;
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // The search area here
          title: Container(
            width: double.infinity,
            height: 40,
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Center(
              child: TextField(
                // focusNode: focusNode,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search, size: 20,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState((){
                        _filter.clear();
                        _searchText = '';
                      });
                    },
                  ),
                  hintText: 'Search…',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: OutlineInputBorder(
                      borderSide : BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  enabledBorder: OutlineInputBorder(
                      borderSide : BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  border: OutlineInputBorder(
                      borderSide : BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                ),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
              ),
            ),
          )),
    );
  }
}