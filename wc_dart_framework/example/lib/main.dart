import 'package:example/bloc_example/bloc_example_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wc_dart_framework/wc_dart_framework.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  LoggingUtils.initialize();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getTemporaryDirectory()).path,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BlocExampleBloc(),
      lazy: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Example'),
        ),
        body: Center(
          child: Builder(builder: (context) {
            return ElevatedButton(
              child: const Text('Update Bloc'),
              onPressed: () => BlocExampleBloc.of(context).updateData(),
            );
          }),
        ),
      ),
    );
  }
}
