import 'package:flutter/material.dart';

class Items {
  final String title;
  final IconData? icon;
  const Items({required this.title, this.icon});
}

class MenuItems {
  static List<Items> items = [itemBlog, about];
  static const itemBlog =
      Items(title: "Blog", icon: Icons.library_books_outlined);
  static const about = Items(title: "About Us", icon: Icons.info_outlined);
}
