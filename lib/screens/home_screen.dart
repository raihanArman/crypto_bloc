import 'package:crypto_bloc/blocs/crypto/crypto_bloc.dart';
import 'package:crypto_bloc/models/coin_model.dart';
import 'package:crypto_bloc/repositories/crypto_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ScrollController? _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {
    _scrollController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Top Coins'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Theme.of(context).primaryColor, Colors.grey[900]!],
          ),
        ),
        child: BlocBuilder<CryptoBloc, CryptoState>(
          builder: (context, state) {
            switch (state.status) {
              case CryptoStatus.loaded:
                return RefreshIndicator(
                  color: Theme.of(context).accentColor,
                  onRefresh: () async {
                    context.read<CryptoBloc>().add(RefreshCoins());
                  },
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (notification) =>
                        _onScrollNotification(notification),
                    child: ListView.builder(
                        controller: _scrollController,
                        itemCount: state.coins.length,
                        itemBuilder: (BuildContext context, int index) {
                          final coin = state.coins[index];
                          return ListTile(
                            leading: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${++index}',
                                  style: TextStyle(
                                      color: Theme.of(context).accentColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            title: Text(
                              coin.fullName,
                              style: TextStyle(color: Colors.white),
                            ),
                            subtitle: Text(
                              coin.name,
                              style: TextStyle(color: Colors.white70),
                            ),
                            trailing: Text(
                              '${coin.price.toStringAsFixed(4)}',
                              style: TextStyle(
                                  color: Theme.of(context).accentColor,
                                  fontWeight: FontWeight.w600),
                            ),
                          );
                        }),
                  ),
                );
              case CryptoStatus.error:
                return Center(
                  child: Text(
                    state.failure.message,
                    style: TextStyle(
                      color: Theme.of(context).accentColor,
                      fontSize: 18,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );
              default:
                return Center(
                    child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation(Theme.of(context).accentColor),
                ));
            }
          },
        ),
      ),
    );
  }

  bool _onScrollNotification(ScrollNotification notification) {
    if (notification is ScrollEndNotification &&
        _scrollController!.position.extentAfter == 0) {
      print('Reach end');
      context.read<CryptoBloc>().add(LoadMoreCoins());
    }

    return false;
  }
}
