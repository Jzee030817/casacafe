import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:flutter/material.dart';
import '../blocs/user_provider.dart';
import '../blocs/item_provider.dart';
import '../config/app_strings.dart';
import '../models/item_models.dart';
import '../resources/api_response.dart';
import '../screens/error_page.dart';
import '../screens/loading_page.dart';
import '../widgets/drawer_menu.dart';

class Menu extends StatelessWidget {
  final String title;
  final String filter;

  Menu({this.title, this.filter});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      drawer: Drawer(
        child: DrawerMenu(),
      ),
      body: MenuBody(),
    );
  }
}

class MenuBody extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = ItemProvider.of(context);
    final userbloc = UserProvider.of(context);

    bloc.getItemsCat();
    userbloc.restoreSession();

    return StreamBuilder<ApiResponse<List<ItemModel>>>(
      stream: bloc.itemCatStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
              break;
            case Status.completed:
              return buildList(context, bloc, snapshot.data.data);
              break;
            case Status.error:
              return ErrorPage(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => bloc.getItemsCat(),
              );
              break;
          }
        }

        return Container();
      },
    );
  }

  Widget buildList(
      BuildContext context, ItemBloc bloc, List<ItemModel> itemlist) {
    return ListView.builder(
      itemCount: itemlist.length,
      itemBuilder: (context, int index) {
        final ItemModel item = itemlist[index];
        print(item.nombre);
        print(item.descripcion);

        return GestureDetector(
          child: Card(
            child: Row(children: <Widget>[
              //FadeInImage.assetNetwork(placeholder: constPlaceholderImage, image: item.imgCategoria, height: 150, alignment: Alignment.centerLeft,), 
              Container(
                height: 100,
                child: CachedNetworkImage(
                  //width: 150,
                  //height: 150,
                  imageUrl: item.imgCategoria,
                  placeholder: (context, url) => Image.asset(constPlaceholderImage),
                ),
              ),
              Text(item.categoria, 
                style: TextStyle(  
                  color: appTheme.primaryColor,
                  fontSize: 16.0,
                  height: 2,
                ),
              ),
            ],),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/cat',
              arguments: item,
            );
          },
        );
        // return GestureDetector(
        //   child: Card(
        //     child: CachedNetworkImage(
        //       imageUrl: item.imgCategoria,
        //       placeholder: (context, url) => Image.asset(constPlaceholderImage),
        //     ),
        //     clipBehavior: Clip.antiAlias,
        //     elevation: 4.0,
        //     shape: RoundedRectangleBorder(
        //       borderRadius: BorderRadius.all(Radius.circular(8.0)),
        //     ),
        //   ),
        //   onTap: () {
        //     Navigator.pushNamed(
        //       context,
        //       '/cat',
        //       arguments: item,
        //     );
        //   },
        // );
      },
    );
  }
}
