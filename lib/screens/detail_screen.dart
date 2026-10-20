import 'package:anime/widgets/app_scaffold.dart';
import 'package:provider/provider.dart';

import '../data/dummy_data.dart';
import '../models/anime.dart';
import '../providers/app_state_provider.dart';
import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final matchingAnime = DummyData.animeList.where((anime) => anime.id == id);
    final Anime? anime = matchingAnime.isEmpty ? null : matchingAnime.first;

    if (anime == null) {
      return AppScaffold(
        appBar: AppBar(title: const Text('Error')),
        body: const Center(child: Text('Anime tidak ditemukan')),
      );
    }

    return AppScaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            pinned: true,
            expandedHeight: screenHeight * 0.32,
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Container(
              margin: EdgeInsets.all(screenWidth * 0.02),
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(anime.imagePath, fit: BoxFit.cover),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.75),
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: screenHeight * 0.025,
                    left: screenWidth * 0.04,
                    right: screenWidth * 0.04,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          anime.title,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.07,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.005),
                        Text(
                          anime.genre,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: screenWidth * 0.04,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber,
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: Colors.white,
                              size: screenWidth * 0.04,
                            ),
                            SizedBox(width: screenWidth * 0.01),
                            Text(
                              anime.rating,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: screenWidth * 0.035,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: screenWidth * 0.03),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.03,
                          vertical: screenHeight * 0.01,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF0b395e),
                          borderRadius: BorderRadius.circular(
                            screenWidth * 0.02,
                          ),
                        ),
                        child: Text(
                          '${anime.totalEpisodes} Episodes',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: screenWidth * 0.035,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Consumer<AppStateProvider>(
                    builder: (context, favoriteProvider, child) {
                      final isFavorite = favoriteProvider.isFavorite(anime.id);

                      return GestureDetector(
                        onTap: () => favoriteProvider.toggleFavorite(anime),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.03,
                            vertical: screenHeight * 0.01,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: screenWidth * 0.02,
                                offset: Offset(0, screenHeight * 0.005),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(
                              screenWidth * 0.02,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isFavorite
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.white,
                                size: screenWidth * 0.04,
                              ),
                              SizedBox(width: screenWidth * 0.01),
                              Text(
                                isFavorite
                                    ? 'Added to Favorites'
                                    : 'Add to Favorites',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: screenWidth * 0.035,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Text(
                    'Synopsis',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: screenWidth * 0.05,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.015),
                  Text(
                    anime.description,
                    textAlign: TextAlign.justify,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: screenWidth * 0.038,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
