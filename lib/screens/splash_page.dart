import 'package:fl_ax_cdc/config/app_style.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/services.dart';

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  final int _numPages = 4;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Color.fromRGBO(25, 139, 57, 1.0) : Color.fromRGBO(151, 151, 151, 1.0),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: fondo,
      body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        height: 520.0,
                        child: PageView(
                          physics: ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'assets/Iconos_Generales/meeting-point.svg'),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Compártenos tu ubicación',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15.0),
                                  Center(
                                    child: Text(
                                      'Danos permiso de conocer tu ubicación para poder mostrarte las sucursales más cercanas.',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18.0,
                                          height: 1.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'assets/Iconos_Generales/food (1).svg'),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Ordena tu bebida favorita',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    'Ordena por adelantado tu bebida favorita.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        height: 1.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'assets/Iconos_Generales/shop.svg'),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Recoge tu pedido',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    'Selecciona una sucursal en la cual puedas recoger tu pedido.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        height: 1.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.all(40.0),
                              child: Column(
                                children: <Widget>[
                                  SvgPicture.asset(
                                      'assets/Iconos_Generales/notification.svg'),
                                  SizedBox(height: 30.0),
                                  Text(
                                    'Notificaciones',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 23.0,
                                        height: 1.5,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 15.0),
                                  Text(
                                    'Danos permiso de enviarte notificaciones para que estés siempre informado.',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18.0,
                                        height: 1.0,
                                        fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                      _currentPage != _numPages - 1
                          ? Expanded(
                              child: Align(
                                alignment: FractionalOffset.bottomCenter,
                                child: MaterialButton(
                                  onPressed: () {
                                    _pageController.nextPage(
                                      duration: Duration(milliseconds: 500),
                                      curve: Curves.ease,
                                    );
                                  },
                                  minWidth: 200.0,
                                  height: 50.0,
                                  color: Colors.green,
                                  shape:  new RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Text(
                                        'Continuar',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 22.0,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Text(''),
                    ],
                )
              )
            )
          ),
          bottomSheet: _currentPage == _numPages - 1
          ? Container(
              height: 100.0,
              width: double.infinity,
              color: Colors.white,
              child: GestureDetector(
                onTap: () => {
                  Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false)
                },
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: 30.0),
                    child: Text(
                      'Iniciar',
                      style: TextStyle(
                        color: Color(0xFF5B16D0),
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            )
          : Text('')
    );
  }
}
