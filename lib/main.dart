import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swapi/people_response.dart';

enum ItemType {
  data,
  loading,
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Swapi',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Swapi'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({Key? key, required this.title}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _scrollController = ScrollController();
  final _listData = <Data>[];
  final _dio = Dio();

  String? _nextUrl;
  var _isLoading = false;
  var _paddingBottom = 0.0;
  var _errorMessage = '';

  @override
  void initState() {
    _doLoadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _doLoadData();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQueryData = MediaQuery.of(context);
    _paddingBottom = mediaQueryData.padding.bottom;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildWidgetBody(),
    );
  }

  Widget _buildWidgetBody() {
    if (_errorMessage.isNotEmpty) {
      return _buildWidgetInfoTryAgain(_errorMessage);
    }

    if (_listData.isEmpty) {
      if (_isLoading) {
        return const Center(
          child: CircularProgressIndicator.adaptive(),
        );
      } else {
        return _buildWidgetInfoTryAgain('Data not available');
      }
    } else {
      return ListView.separated(
        controller: _scrollController,
        padding: EdgeInsets.only(
          left: 16,
          top: 16,
          right: 16,
          bottom: _paddingBottom > 0 ? _paddingBottom : 16,
        ),
        itemBuilder: (context, index) {
          final itemPeople = _listData[index];
          final typeData = itemPeople.itemType;
          if (typeData == ItemType.loading) {
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          } else if (typeData == ItemType.data) {
            return Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      itemPeople.people?.name ?? '-',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    Text(
                      itemPeople.people?.gender ?? '-',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      itemPeople.people?.birthYear ?? '-',
                      style: Theme.of(context).textTheme.caption,
                    ),
                  ],
                ),
              ),
            );
          } else {
            return Container();
          }
        },
        separatorBuilder: (context, index) => Container(
          height: 8,
        ),
        itemCount: _listData.length,
      );
    }
  }

  Widget _buildWidgetInfoTryAgain(String text) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(text),
          ElevatedButton(
            child: const Text('Try Again'),
            onPressed: () {
              _doLoadData();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _doLoadData() async {
    _errorMessage = '';
    var url = '';
    if (_listData.isEmpty) {
      url = 'https://swapi.dev/api/people?page=1';
    } else {
      url = _nextUrl ?? '';
    }
    if (url.isEmpty) {
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await _dio.get(url);
      if (response.statusCode.toString().startsWith('2')) {
        final peopleResponse = PeopleResponse.fromJson(response.data);
        if (_listData.isNotEmpty) {
          /// Hapus widget elemen loading
          final lastItem = _listData.last;
          if (lastItem.itemType == ItemType.loading) {
            _listData.removeLast();
          }
        }

        /// Masukkan data baru kedalam _listData
        _listData.addAll(
          peopleResponse.results.map(
            (element) {
              return Data(
                people: element,
                itemType: ItemType.data,
              );
            },
          ),
        );

        /// Jika nilai _nextUrl != null maka, tambahkan widget elemen loading
        _nextUrl = peopleResponse.nextUrl;
        if (_nextUrl != null) {
          _listData.add(
            Data(
              people: null,
              itemType: ItemType.loading,
            ),
          );
        }
      } else {
        /// Munculkan pesan error
        _listData.clear();
        _errorMessage = "Failed to get data";
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage)));
      }
    } catch (error) {
      /// Munculkan pesan error
      _errorMessage = 'Failed to get data';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(_errorMessage)));
    } finally {
      setState(() => _isLoading = false);
    }
  }
}

class Data {
  final ItemPeopleResponse? people;
  final ItemType itemType;

  Data({
    required this.people,
    required this.itemType,
  });
}
