import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'setstate/cart_page_setstate.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'cubit/cart_page_cubit.dart';
import 'bloc/cart_page_bloc.dart';

void main() {
  runApp(
    const ProviderScope(
      child: CartApp(),
    ),
  );
}

class CartApp extends StatelessWidget {
  const CartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Four Ways',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart Four Ways'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const SetStateCartPage(),
                  ),
                );
              },
              child: const Text('setState'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const RiverpodCartPage(),
                  ),
                );
              },
              child: const Text('Riverpod'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const CubitCartPage(),
                  ),
                );
              },
              child: const Text('Cubit'),
            ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const BlocCartPage(),
                  ),
                );
              },
              child: const Text('Bloc'),
            ),
          ],
        ),
      ),
    );
  }
}
