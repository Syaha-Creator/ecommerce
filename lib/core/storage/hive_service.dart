import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  // Initialize Hive
  static Future<void> init() async {
    final appDocumentDir = await getApplicationDocumentsDirectory();
    await Hive.initFlutter(appDocumentDir.path);

    // Register adapters here
    // Hive.registerAdapter(UserAdapter());
    // Hive.registerAdapter(ProductAdapter());
    // ...etc
  }

  // Open a box
  static Future<Box<T>> openBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box<T>(boxName);
    } else {
      return await Hive.openBox<T>(boxName);
    }
  }

  // Get all items from a box
  static Future<List<T>> getAll<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    return box.values.toList();
  }

  // Get item by key
  static Future<T?> get<T>(String boxName, dynamic key) async {
    final box = await openBox<T>(boxName);
    return box.get(key);
  }

  // Add item
  static Future<void> add<T>(String boxName, T item) async {
    final box = await openBox<T>(boxName);
    await box.add(item);
  }

  // Put item with key
  static Future<void> put<T>(String boxName, dynamic key, T item) async {
    final box = await openBox<T>(boxName);
    await box.put(key, item);
  }

  // Delete item by key
  static Future<void> delete<T>(String boxName, dynamic key) async {
    final box = await openBox<T>(boxName);
    await box.delete(key);
  }

  // Clear all items in a box
  static Future<void> clear<T>(String boxName) async {
    final box = await openBox<T>(boxName);
    await box.clear();
  }

  // Close a specific box
  static Future<void> closeBox<T>(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box<T>(boxName).close();
    }
  }

  // Close all boxes
  static Future<void> closeAllBoxes() async {
    await Hive.close();
  }
}
