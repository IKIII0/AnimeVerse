import 'package:anime/data/dummy_data.dart';
import 'package:flutter/material.dart';

import '../widgets/app_scaffold.dart';
import '../widgets/favorite_anime_card.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Favorite Anime',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w800,
            fontSize: screenWidth * 0.06,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(vertical: screenHeight * 0.01),
        itemCount: DummyData.animeList.length,
        itemBuilder: (context, index) {
          final anime = DummyData.animeList[index];
          return FavoriteAnimeCard(
            title: anime.title,
            genre: anime.genre,
            rating: anime.rating,
            imagePath: anime.imagePath,
          );
        },
      ),
    );
  }
}
