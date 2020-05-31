import 'package:cached_network_image/cached_network_image.dart';
import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:flutter/material.dart';
import '../blocs/item_provider.dart';
import '../config/app_strings.dart';
import '../models/item_models.dart';
import '../resources/api_response.dart';

import 'error_page.dart';
import 'loading_page.dart';

class SubMenu extends StatelessWidget {
  final String title;
  final String filter;

  SubMenu({this.title, this.filter});

  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: SubmenuBody(filter: filter),
    );
  }
}

class SubmenuBody extends StatelessWidget {
  final String filter;

  SubmenuBody({this.filter});

  Widget build(BuildContext context) {
    final bloc = ItemProvider.of(context);
    bloc.getItemsGrp(filter);

    return StreamBuilder<ApiResponse<List<ItemModel>>>(
      stream: bloc.itemGrpStream,
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
      BuildContext context, ItemBloc bloc, List<ItemModel> itemlist) {
    return ListView.builder(
      itemCount: itemlist.length,
      itemBuilder: (context, int index) {
        final ItemModel item = itemlist[index];

        return GestureDetector(
          child: Card(
            child: Row(children: <Widget>[
              //FadeInImage.assetNetwork(placeholder: constPlaceholderImage, image: item.imgGrupo, height: 150, alignment: Alignment.centerLeft,), 
              Container(
                height: 100,
                child: CachedNetworkImage(
                  imageUrl: item.imgGrupo,
                  placeholder: (context, url) => Image.asset(constPlaceholderImage),
                ),
              ),
              Text(item.grupo, 
                style: TextStyle(  
                  color: appTheme.primaryColor,
                  fontSize: 16.0,
                  height: 2,
                ),
              )
            ],),
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(8.0)),
            ),
          ),
          onTap: () {
            Navigator.pushNamed(
              context,
              '/list',
              arguments: item,
            );
          },
        );
      },
    );
  }
}
