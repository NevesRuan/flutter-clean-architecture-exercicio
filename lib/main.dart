import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'presentation/pages/root_page.dart';
import 'presentation/viewmodels/product_viewmodel.dart';
import 'presentation/viewmodels/session_viewmodel.dart';
import 'data/repositories/product_repository_impl.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'data/datasources/product_remote_datasource.dart';
import 'data/datasources/product_cache_datasource.dart';
import 'data/datasources/auth_remote_datasource.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final dio = Dio();
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => SessionViewModel(
            AuthRepositoryImpl(AuthRemoteDatasource(dio)),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductViewModel(
            ProductRepositoryImpl(
              ProductRemoteDatasource(dio),
              ProductCacheDatasource(),
            ),
          ),
        ),
      ],
      child: MaterialApp(
        title: 'Product App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        home: const RootPage(),
      ),
    );
  }
}
