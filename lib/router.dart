import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
import 'screens/product_form_screen.dart';
import 'models/product.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/add-product',
      builder: (context, state) => const ProductFormScreen(),
    ),
    GoRoute(
      path: '/edit-product',
      builder: (context, state) {
        final product = state.extra as Product;
        return ProductFormScreen(
          product: product,
          isEdit: true,
        );
      },
    ),
  ],
);
