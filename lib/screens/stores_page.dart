import 'package:fl_ax_cdc/blocs/item_provider.dart';
import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:fl_ax_cdc/models/store_model.dart';
import 'package:fl_ax_cdc/resources/api_response.dart';
import 'package:fl_ax_cdc/screens/error_page.dart';
import 'package:fl_ax_cdc/screens/loading_page.dart';
import 'package:flutter/material.dart';
import '../config/app_strings.dart';

class StoresPage extends StatelessWidget {
  Widget build(context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(strLabelStores),
      ),
      body: StoresPageBody(),
    );
  }
}

class StoresPageBody extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = ItemProvider.of(context);
    bloc.getStoresList();

    return StreamBuilder<ApiResponse<List<StoreModel>>>(
      stream: bloc.storeStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          switch (snapshot.data.status) {
            case Status.loading:
              return Loading(
                loadingMessage: snapshot.data.message,
              );
            case Status.completed:
              return storesList(context, bloc, snapshot.data.data);
            case Status.error:
              return ErrorPage(
                errorMessage: snapshot.data.message,
                onRetryPressed: () => bloc.getStoresList(),
              );
          }
        }

        return Container();
      },
    );
  }

  Widget storesList(
    BuildContext context, ItemBloc bloc, List<StoreModel> stores) {
    // double deviceHeight = MediaQuery.of(context).size.height;
    double deviceWidth = MediaQuery.of(context).size.width;

    return ListView.builder(
      itemCount: stores.length,
      itemBuilder: (context, int index) {
        final StoreModel store = stores[index];

        return Card(
          child: Row(
            children: <Widget>[
              FadeInImage.assetNetwork(
                placeholder: constPlaceholderStore,
                image: store.imagen,
                height: 100,
                alignment: Alignment.centerLeft,
              ),
              Container(
                height: 100,
                width: deviceWidth - 186,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      store.nomTienda,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        color: appTheme.primaryColor,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      store.direcc1,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
