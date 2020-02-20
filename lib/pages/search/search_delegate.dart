import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';

import '../../components/components.dart';
import '../../models/models.dart';
import '../../actions/actions.dart';
import '../../theme.dart';
import '../../icons.dart';

typedef SearchItemCall = void Function(String item);

class SearchBarDelegate extends SearchDelegate<String> {

  List<TagEntity>tags;
  List<String>histories = [];

  SearchBarDelegate(this.tags);

  @override
  String get searchFieldLabel => '搜索';

  @override
  List<Widget> buildActions(BuildContext context) {
    //右侧显示内容 这里放清除按钮
    return [
      IconButton(
        icon: Icon(Icons.clear, size: 20,),
        onPressed: () {
          query = "";
          showSuggestions(context);
        },
      ),
      IconButton(
        icon: Icon(MaIcon.search),
        onPressed: () {
          showResults(context);
        },
      ),
    ];
  }

  @override
  void showResults(BuildContext context){
    super.showResults(context);
    if(query == '') return;
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(SaveSearchHistoryAction(query: query));
  }

  @override
  Widget buildLeading(BuildContext context) {
    //左侧显示内容 这里放了返回按钮
    return IconButton(
      icon: Icon(MaIcon.back, color: Colors.black),
      onPressed: () {
        if (query.isEmpty) {
          close(context, null);
        } else {
          query = "";
          showSuggestions(context);
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    //点击了搜索显示的页面
    return Center(
      child: Text('12312321'),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //点击了搜索窗显示的页面
    return SearchContentView(tags, histories);
  }

  @override
  ThemeData appBarTheme(BuildContext context) {
    return super.appBarTheme(context);
  }
}

class SearchContentView extends StatefulWidget {
  List<TagEntity>tags;
  List<String>histories;

  SearchContentView(this.tags, this.histories);

  @override
  _SearchContentViewState createState() => _SearchContentViewState(tags, histories);
}

class _SearchContentViewState extends State<SearchContentView> {
  List<TagEntity>tags;
  List<String> histories;
  List<String>tagStrs;

  _SearchContentViewState(this.tags, this.histories){
    tagStrs = tags.asMap().entries
        .map<String>((entry) => entry.value.name).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Row(
              children: <Widget>[
                Icon(Icons.whatshot, color: MaTheme.redNormal,),
                SizedBox(width: 10,),
                Text('大家都在搜',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 10,),
              ],
            ),
          ),
          SearchItemView(false, items: tagStrs),
          SizedBox(height: 10,),
          Divider(height: 1, color: MaTheme.greyLight,),
          SizedBox(height: 10,),
          Container(
            margin: EdgeInsets.only(top: 20),
            child: Row(
              children: <Widget>[
                Icon(Icons.history, color: MaTheme.maYellows,),
                SizedBox(width: 10,),
                Text('历史记录',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(width: 10,),
                GestureDetector(
                  child: Icon(MaIcon.delete, color: MaTheme.maYellows, size: 20,),
                  onTap: _clear,
                )
              ],
            ),
          ),
          SearchItemView(true),
        ],
      ),
    );
  }

  void _clear(){
    var store = StoreProvider.of<AppState>(context);
    store.dispatch(ClearSearchHistoryAction());
  }
}

class SearchItemView extends StatefulWidget {
  List<String> items;
  bool isHistory;
  _ViewModel vm;
  SearchItemView(this.isHistory, {this.items, this.vm});

  @override
  _SearchItemViewState createState(){
    if(isHistory){
      return _SearchItemViewState();
    }
    else{
      return _SearchItemViewState(items: items);
    }
  }
}

class _SearchItemViewState extends State<SearchItemView> {
  List<String> items;
  _SearchItemViewState({this.items});

  Widget _buildItemView(BuildContext context, List<String> strings){
    return Container(
        child: Wrap(
          spacing: 10,
          children: strings.map((string) {
            return SearchItem(title: string);
          }).toList(),
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(!widget.isHistory){
      return _buildItemView(context, items);
    }
    else{
      return StoreConnector<AppState, _ViewModel>(
        converter: (store) => _ViewModel(
          histories: store.state.discovery.histories,
        ),
        builder: (context, vm) => _buildItemView(context, vm.histories),
      );
    }
  }

}

class SearchItem extends StatefulWidget {
  @required
  final String title;
  const SearchItem({Key key, this.title}) : super(key: key);
  @override
  _SearchItemState createState() => _SearchItemState();
}

class _SearchItemState extends State<SearchItem> {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        child: Chip(
          label: Text(widget.title, style: TextStyle(color: MaTheme.maYellows),),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: MaTheme.maYellows),
          ),
          backgroundColor: Colors.white,
        ),
        onTap: () {
          print(widget.title);
        },
      ),
    );
  }
}

class _ViewModel{
  List<String> histories;

  _ViewModel({
    this.histories,
  });
}