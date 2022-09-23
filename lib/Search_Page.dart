import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:jaegojochi/stock_Detail_Info.dart';
import 'db/Stock.dart';
import 'db/DatabaseHelper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({
    Key? key,
  }) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late Future<File> imageFile;
  late List<Stock> stocks = [];

  @override
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
      cursorColor: Colors.black,
      style: const TextStyle(
        color: Colors.black,
        fontSize: 20,
      ),
      decoration: const InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        hintText: 'Search',
      ),
    );
  }

  Widget _searchListView() {
    return ListView.separated(
      itemCount: _searchIndexList.length,
      itemBuilder: (ctx, index) {
        return Container(
          height: 70,
          padding: const EdgeInsets.all(5),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              stocks[index].image!.toString() == ''
                  ? Image.asset('assets/image/no_stock_image.jpg',
                      width: MediaQuery.of(context).size.height * 0.069,
                      height: MediaQuery.of(context).size.height * 0.069,
                      fit: BoxFit.fill)
                  : Container(
                      width: MediaQuery.of(context).size.height * 0.069,
                      height: MediaQuery.of(context).size.height * 0.069,
                      child: Image.memory(
                          Base64Decoder().convert(stocks[index].image!),
                          fit: BoxFit.cover),
                    ),
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                alignment: Alignment.center,
                child: Text(stocks[index].name.toString(),
                    overflow: TextOverflow.ellipsis),
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.2,
                alignment: Alignment.center,
                child: Text(stocks[index].amount.toString() +
                    stocks[index].unit.toString()),
              ),
              IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => stock_Detail_Info(
                          name: stocks[index].name.toString(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert))
            ],
          ),
        );
      },
      separatorBuilder: (context, index) {
        return const Divider(
          thickness: 1,
          color: Colors.black,
        );
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _searchTextField(),
      ),
      body: _searchListView(),
    );
  }
}
