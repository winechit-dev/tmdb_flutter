import 'package:flutter/cupertino.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tmdb_flutter/app/app.dart';
import 'package:tmdb_flutter/bootstrap.dart';

Future<void> main() async {
  // Ensure Flutter bindings are initialized before loading .env
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables from .env file
  await dotenv.load();

  // Run the app with bootstrap
  await bootstrap(() => const App());
}
