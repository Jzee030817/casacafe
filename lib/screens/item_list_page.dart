import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../blocs/item_provider.dart';
import '../config/app_strings.dart';
import '../models/item_models.dart';
import '../resources/api_response.dart';

import 'error_page.dart';
import 'loading_page.dart';

class ItemList extends StatelessWidget {
  final String title;
  final String filter;

  ItemList({this.title, this.filter});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ItemListBody(filter: filter),
    );
  }
}

class ItemListBody extends StatelessWidget {
  final String filter;

  ItemListBody({this.filter});

  Widget build(BuildContext context) {
    final bloc = ItemProvider.of(context);
    bloc.getItemLst(filter);

    return StreamBuilder<ApiResponse<List<ItemModel>>>(
      stream: bloc.itemItmStream,
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
                onRetryPressed: () => bloc.getItemsGrp(filter),
              );
              break;
          }
        }

        return Container();
      },
    );
  }

  Widget buildList(
      BuildContext context, ItemBloc bloc, List<ItemModel> itemList) {
    return ListView.builder(
      itemCount: itemList.length,
      itemBuilder: (context, int index) {
        final ItemModel item = itemList[index];

        return GestureDetector(
          child: Container(
            height: 100.0,
            child: Card(
              child: Row(
                children: <Widget>[
                  //FadeInImage.assetNetwork(placeholder: constPlaceholderImage, image: item.imagen), 
                  Container(
                    height: 100,
                    child: CachedNetworkImage(
                      imageUrl: item.imagen,
                      placeholder: (context, url) =>
                        Image.asset(constPlaceholderImage),
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('${item.nombre}'),
                      subtitle: Text(item.descripcion),
                    ),
                  ),
                ],
              ),
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/item',
              arguments: item,
            );
          },
        );
      },
    );
  }
}
