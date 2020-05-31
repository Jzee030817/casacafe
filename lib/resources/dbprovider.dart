import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/cartline_model.dart';
import '../models/modifiers_model.dart';
import '../models/store_model.dart';
import '../models/user_model.dart';
import '../models/item_models.dart';

class DbProvider {
  Database db;

  Future<void> init() async {
    Directory docsDir = await getApplicationDocumentsDirectory();
    final path = join(docsDir.path, "cdcv2.db");
    db = await openDatabase(path, version: 1,
        onCreate: (Database newDb, int version) async {
      // Create keys table
      print('Creating keys table');
      newDb.execute("""CREATE TABLE Keys (
        name TEXT PRIMARY KEY,
        value TEXT
      )
      """);
      // Create Items table
      print('creating items table');
      newDb.execute("""CREATE TABLE Items (
            codigo TEXT PRIMARY KEY, 
            nombre TEXT, 
            descripcion TEXT, 
            precio REAL,
            imagen TEXT,
            codCategoria TEXT,
            categoria TEXT,
            imgCategoria TEXT,
            codGrupo TEXT,
            grupo TEXT,
            imgGrupo TEXT,
            tieneModificadores INTEGER, 
            valorPuntos REAL,
            prodUnico INTEGER
          )
        """);
      // Create Stores table
      print('creating stores table');
      newDb.execute("""CREATE TABLE Stores (
            codTienda TEXT PRIMARY KEY,
            nomTienda TEXT,
            nomCorto TEXT,
            direcc1 TEXT,
            direcc2 TEXT,
            direcc3 TEXT,
            direcc4 TEXT,
            numTelef TEXT,
            gpsLat REAL,
            gpsLong REAL,
            imagen TEXT
          )
        """);
      // Create User table
      print('creating users table');
      newDb.execute("""CREATE TABLE Users (
            idUser TEXT PRIMARY KEY,
            tokenSesion TEXT,
            nombre TEXT,
            correo TEXT,
            numTarjeta TEXT,
            saldo REAL,
            puntos REAL
          )
        """);
      // Create CartLine table
      print('creating cartlines table');
      newDb.execute("""CREATE TABLE CartLines (
            noLinea INTEGER PRIMARY KEY,
            noItem TEXT,
            itemDesc TEXT, 
            qty INTEGER,
            precioPuntos REAL,
            precioUnitario REAL,
            totalPuntos REAL,
            totalLinea REAL,
            codMod1 TEXT,
            descMod1 TEXT,
            valMod1 TEXT,
            tipMod1 INTEGER,
            preMod1 REAL,
            ptsMod1 REAL, 
            codMod2 TEXT,
            descMod2 TEXT,
            valMod2 TEXT,
            tipMod2 INTEGER,
            preMod2 REAL,
            ptsMod2 REAL, 
            codMod3 TEXT,
            descMod3 TEXT,
            valMod3 TEXT,
            tipMod3 INTEGER,
            preMod3 REAL,
            ptsMod3 REAL, 
            codMod4 TEXT,
            descMod4 TEXT,
            valMod4 TEXT,
            tipMod4 INTEGER,
            preMod4 REAL,
            ptsMod4 REAL, 
            imageUrl TEXT
          )
        """);
      // Create Modifiers table
      newDb.execute("""CREATE TABLE Modifiers (
          code TEXT, 
          description TEXT,
          prompt TEXT,
          subcode TEXT,
          subdescription TEXT,
          coditem TEXT,
          tipoPrecio INTEGER,
          precioAdic REAL,
          puntosAdic REAL, 
          PRIMARY KEY (code, subcode)
        )
        """);
    });
  }

  // Item Related methods
  Future<int> addItem(ItemModel item) async {
    if (db == null) await init();

    return db.insert("Items", item.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<ItemModel> getItem(String itemId) async {
    if (db == null) await init();

    final maps = await db.query(
      "Items",
      columns: null,
      where: "codigo = ?",
      whereArgs: [itemId],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  Future<List<ItemModel>> getTopLevelList() async {
    if (db == null) await init();

    final list = await db.query(
      "Items",
      columns: ['codCategoria', 'categoria', 'imgcategoria'],
      distinct: true,
    );
    List<ItemModel> items = [];

    for (int i = 0; i < list.length; i++) {
      items.add(ItemModel.fromDb(list[i]));
    }
    return items;
  }

  Future<List<ItemModel>> getSecondLevelList(String topLevel) async {
    if (db == null) await init();

    final list = await db.query(
      "Items",
      columns: ["codGrupo", "grupo", "imgGrupo"],
      where: "codCategoria = ?",
      whereArgs: [topLevel],
      distinct: true,
    );
    List<ItemModel> items = [];

    for (int i = 0; i < list.length; i++) {
      items.add(ItemModel.fromDb(list[i]));
    }

    return items;
  }

  Future<List<ItemModel>> getItemList(String topLevel) async {
    if (db == null) await init();

    final list = await db.query(
      "Items",
      columns: [
        "codigo",
        "nombre",
        "descripcion",
        "imagen",
        "precio",
        "tieneModificadores"
      ],
      where: "codGrupo = ?",
      whereArgs: [topLevel],
      distinct: true,
    );
    List<ItemModel> items = [];

    for (int i = 0; i < list.length; i++) {
      items.add(ItemModel.fromDb(list[i]));
    }

    return items;
  }

  Future<int> addStore(StoreModel store) async {
    if (db == null) await init();

    return db.insert("Stores", store.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<StoreModel>> getStoresList() async {
    if (db == null) await init();

    final list = await db.query(
      "Stores",
      columns: null,
    );

    List<StoreModel> stores = [];
    for (int i = 0; i < list.length; i++) {
      stores.add(StoreModel.fromDb(list[i]));
    }

    return stores;
  }

  Future<int> putCartLine(CartLineModel crline) async {
    if (db == null) await init();
    return db.insert("CartLines", crline.toMapForDb(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> removeCartLine(int noLinea) async {
    if (db == null) await init();
    return await db.delete(
      "CartLines",
      where: "noLinea = ?",
      whereArgs: [noLinea],
    );
  }

  Future<int> removeOrder() async {
    if (db == null) await init();
    return db.rawDelete(
      "DELETE FROM CartLines", 
    );
  }

  Future<int> addModifiers(List<ModifierModel> mods) async {
    int dev = 0;
    double pre = 0;
    if (db == null) await init();
    for (ModifierModel mod in mods) {
      for (ElementModel ele in mod.elementos) {
        pre = ele.precioAdic * 100;
        ModLine mdl = ModLine(
            code: mod.code,
            description: mod.description,
            prompt: mod.prompt,
            subcode: ele.subCode,
            subdescription: ele.description,
            coditem: ele.codItem,
            tipoPrecio: ele.tipoPrecio,
            precioAdic: pre.round() / 100,
            puntosAdic: ele.puntosAdic
        );

        //dev += await db.rawInsert("INSERT INTO Modifiers (code, description, prompt, subcode, subdescription, coditem) VALUES ('${mod.code}', '${mod.description}', '${mod.prompt}', '${ele.subCode}', '${ele.description}', '${ele.codItem}')");
        dev += await db.insert(
          "Modifiers",
          mdl.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
        print('Added ${mod.code} ${ele.subCode}');
      }
    }

    return dev;
  }

  Future<List<CartLineModel>> getCartLines() async {
    if (db == null) await init();

    final list = await db.rawQuery("""
      SELECT 
        c.noLinea, c.noItem, c.itemDesc, c.qty, c.precioPuntos, c.precioUnitario, 
        ((c.precioPuntos + ifnull(m1.puntosAdic, 0) + ifnull(m2.puntosAdic, 0) + ifnull(m3.puntosAdic, 0) + ifnull(m4.puntosAdic, 0)) * c.qty) totalPuntos, 
        ((c.precioUnitario + ifnull(m1.precioAdic, 0) + ifnull(m2.precioAdic, 0) + ifnull(m3.precioAdic, 0) + ifnull(m4.precioAdic, 0)) * c.qty) totalLinea, 
        c.codMod1, m1.subdescription descMod1, c.valMod1, m1.tipoPrecio tipMod1, m1.precioAdic preMod1, m1.puntosAdic ptsMod1, 
        c.codMod2, m2.subdescription descMod2, c.valMod2, m2.tipoPrecio tipMod2, m2.precioAdic preMod2, m2.puntosAdic ptsMod2, 
        c.codMod3, m3.subdescription descMod3, c.valMod3, m3.tipoPrecio tipMod3, m3.precioAdic preMod3, m3.puntosAdic ptsMod3, 
        c.codMod4, m4.subdescription descMod4, c.valMod4, m4.tipoPrecio tipMod4, m4.precioAdic preMod4, m4.puntosAdic ptsMod4, 
        c.imageUrl  
      FROM 
        CartLines c 
        LEFT JOIN Modifiers m1 on c.codMod1 = m1.code and c.valMod1 = m1.subcode
        LEFT JOIN Modifiers m2 on c.codMod2 = m2.code and c.valMod2 = m2.subcode
        LEFT JOIN Modifiers m3 on c.codMod3 = m3.code and c.valMod3 = m3.subcode
        LEFT JOIN Modifiers m4 on c.codMod4 = m4.code and c.valMod4 = m4.subcode
    """);

    List<CartLineModel> lines = [];
    for (int i = 0; i < list.length; i++) {
      lines.add(CartLineModel.fromDb(list[i]));
    }

    return lines;
  }

  Future<UserModel> getUserData() async {
    if (db == null) await init();
    final list = await db.query(
      "Users",
      columns: null,
    );
    if (list.isEmpty)
      return UserModel.anonimous();
    else
      return UserModel.fromDb(list.first);
  }

  Future<int> addUser(UserModel user) async {
    if (db == null) await init();
    if (user.idUser != '') {
      return db.insert("Users", user.toMapForDb(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } else {
      return 0;
    }
  }

  Future<int> closeSession() async {
    if (db == null) await init();
    return db.delete("Users");
  }
}

final dbProvider = DbProvider();
