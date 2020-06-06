import 'package:flutter/material.dart';

import './config/app_strings.dart';
import './config/app_style.dart';
import './blocs/item_provider.dart';
import './blocs/user_provider.dart';
import 'models/item_models.dart';
import 'screens/cart_page.dart';
import 'screens/checkout_page.dart';
import 'screens/item_list_page.dart';
import 'screens/item_page.dart';
import 'screens/login_page.dart';
import 'screens/menu_page.dart';
import 'screens/page_404.dart';
import 'screens/pwdchange_page.dart';
import 'screens/signup_page.dart';
import 'screens/stores_page.dart';
import 'screens/submenu_page.dart';
import 'screens/user_page.dart';

void main() => runApp(CdcApp());

class CdcApp extends StatelessWidget {
  Widget build(context) {
    return UserProvider(
      child: ItemProvider(
        child: MaterialApp(
          theme: appTheme,
          title: strTitleApp,
          onGenerateRoute: routes,
        ),
      ),
    );
  }

  Route routes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return loadMainMenu();
        break;
      case '/cat':
        final ItemModel item = settings.arguments;
        return loadCatMenu(item);
        break;
      case '/list':
        final ItemModel item = settings.arguments;
        return loadItemList(item);
        break;
      case '/item':
        final ItemModel item = settings.arguments;
        return loadItemPage(item);
        break;
      case '/store':
        return loadStoresPage();
        break;
      case '/cart':
        return loadCartPage();
        break;
      case '/checkout':
        return loadCheckoutPage();
        break;
      case '/login':
        return loadLoginPage();
        break;
      case '/signup':
        return loadSignupPage();
        break;
      case '/user':
        return loadUserPage();
        break;
      case '/PwdChange':
        return loadPwdChange();
        break;
    }

    return load404Page();
  }

  MaterialPageRoute loadPwdChange() {
    return MaterialPageRoute(  
      builder: (context) {
        return PwdchangePage();
      },
    );
  }

  MaterialPageRoute loadLoginPage() {
    return MaterialPageRoute(
      builder: (context) {
        return LoginPage();
      },
    );
  }

  MaterialPageRoute loadSignupPage() {
    return MaterialPageRoute(builder: (context) {
      return SignupPage();
    });
  }

  MaterialPageRoute loadCheckoutPage() {
    return MaterialPageRoute(
      builder: (context) {
        return CheckoutPage(
          title: strCheckoutPage,
        );
      },
    );
  }

  MaterialPageRoute loadCartPage() {
    return MaterialPageRoute(
      builder: (context) {
        return CartPage(
          title: strLabelCart,
        );
      },
    );
  }

  MaterialPageRoute loadMainMenu() {
    return MaterialPageRoute(builder: (context) {
      return Menu(
        title: strTitleApp,
        filter: '',
      );
    });
  }

  MaterialPageRoute loadCatMenu(ItemModel itm) {
    return MaterialPageRoute(builder: (context) {
      return SubMenu(
        title: itm.categoria,
        filter: itm.codCategoria,
      );
    });
  }

  MaterialPageRoute loadItemList(ItemModel itm) {
    return MaterialPageRoute(builder: (context) {
      return ItemList(
        title: itm.grupo,
        filter: itm.codGrupo,
      );
    });
  }

  MaterialPageRoute loadItemPage(ItemModel itm) {
    return MaterialPageRoute(builder: (context) {
      //if (loggedIn()) {
      return ItemPage(
        title: itm.nombre,
        item: itm,
      );
    });
  }

  MaterialPageRoute loadStoresPage() {
    return MaterialPageRoute(builder: (context) {
      return StoresPage();
    });
  }

  MaterialPageRoute load404Page() {
    return MaterialPageRoute(builder: (context) {
      return Page404();
    });
  }

  MaterialPageRoute loadUserPage() {
    return MaterialPageRoute(builder: (context) {
      return UserPage();
    });
  }
  
}
