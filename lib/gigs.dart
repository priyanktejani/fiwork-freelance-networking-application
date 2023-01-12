import 'package:flutter/material.dart';

class Gigs {
  Gigs(
      {this.recipeName = '',
      this.recipeImage = '',
      this.recipeMaker = '',
      this.category = '',
      this.startColor,
      this.endColor});

  String recipeName;
  String recipeImage;
  String recipeMaker;
  String category;
  Color? startColor;
  Color? endColor;
}

var gigs = [
  Gigs(
    recipeName: 'Wordpress, Game Development, Mobile Apps',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Foodie Yuki',
    category: 'Programming & Tech',
    startColor: const Color(0xFF212121),
    endColor: const Color(0xFF424242),
  ),
  Gigs(
    recipeName: 'Logo & Brand Identity, Art & Illustration',
    recipeImage: 'graphic-design.jpg',
    recipeMaker: 'Marianne Turner',
    category: 'Graphics & Design',
    startColor: const Color(0xFF621e14),
    endColor: const Color(0xFFd13b10),
  ),
  Gigs(
    recipeName: 'Marketing Strategy, Social Media Marketing, Local SEO',
    recipeImage: 'digital-marketing.jpg',
    recipeMaker: 'Jennifer Joyce',
    category: 'Digital Marketing',
    startColor: const Color(0xFFe18b41),
    endColor: const Color(0xFFc7c73d),
  ),
  Gigs(
    recipeName: 'Easy classic lasagne',
    recipeImage: 'img-classic-lasange.webp',
    recipeMaker: 'Angela Boggiano',
    category: 'Writing & Translation',
    startColor: const Color(0xFFaf781d),
    endColor: const Color(0xFFd6a651),
  ),
  Gigs(
    recipeName: 'Easy teriyaki chicken',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Esther Clark',
    category: 'Video & Animation',
    startColor: const Color(0xFF9a9d9a),
    endColor: const Color(0xFFb9b2b5),
  ),
  Gigs(
    recipeName: 'Easy chocolate fudge cake',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Member recipe by misskay',
    category: 'Music & Audio',
    startColor: const Color(0xFF2e0f07),
    endColor: const Color(0xFF653424),
  ),
  Gigs(
    recipeName: 'One-pan spaghetti with nduja, fennel & olives',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Cassie Best',
    category: 'Programming & Tech',
    startColor: const Color(0xFF8b1d07),
    endColor: const Color(0xFFee882d),
  ),
  Gigs(
    recipeName: 'Easy pancakes',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Cassie Best',
    category: 'Business',
    startColor: const Color(0xFFa1783c),
    endColor: const Color(0xFFf3dc37),
  ),
  Gigs(
    recipeName: 'Easy chicken fajitas',
    recipeImage: 'programming.jpg',
    recipeMaker: 'Steven Morris',
    category: 'Lifestyle',
    startColor: const Color(0xFF3e4824),
    endColor: const Color(0xFF5da6a6),
  ),
];