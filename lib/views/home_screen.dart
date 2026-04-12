// ignore_for_file: deprecated_member_use

import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';
import 'dart:ui'; // Required for BackdropFilter (Blur)
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReceipeModel? receipeModel;
  final Set<int> _favorites = {};

  // --- REFINED COLOR PALETTE ---
  final Color bgSlate = const Color(0xFFF1F5F9);
  final Color brandAmber = const Color(0xFFFFC107);
  final Color deepNavy = const Color(0xFF0F172A);

  @override
  void initState() {
    super.initState();
    getReceipeData();
  }

  Future<void> getReceipeData() async {
    try {
      final data = await RecepieService().getRecepie();
      setState(() => receipeModel = data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error: $e"),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  void _showDetailsPopUp(dynamic recipe) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(35)),
        ),
        child: Column(
          children: [
            // Fixed Header Grabber
            const SizedBox(height: 12),
            Container(
              width: 50,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(10),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title: Bold and clear
                    Text(
                      recipe.name ?? "",
                      style: TextStyle(
                        color: deepNavy,
                        fontSize: 24, // Increased for clarity
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "${recipe.cuisine} • ${recipe.difficulty}".toUpperCase(),
                      style: TextStyle(
                        color: brandAmber,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const Divider(height: 40, thickness: 1),

                    // Section: Ingredients
                    _sectionHeader("INGREDIENTS"),
                    const SizedBox(height: 15),
                    ...recipe.ingredients!
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.check_circle_outline,
                                  color: brandAmber,
                                  size: 18,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontSize: 16, // Highly readable size
                                      color: Colors.black87,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),

                    const SizedBox(height: 30),

                    // Section: Instructions
                    _sectionHeader("INSTRUCTIONS"),
                    const SizedBox(height: 15),
                    ...recipe.instructions!
                        .asMap()
                        .entries
                        .map(
                          (entry) => Padding(
                            padding: const EdgeInsets.only(bottom: 18),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 12,
                                  backgroundColor: brandAmber.withOpacity(0.2),
                                  child: Text(
                                    "${entry.key + 1}",
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: deepNavy,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Expanded(
                                  child: Text(
                                    entry.value,
                                    style: const TextStyle(
                                      fontSize: 16, // Increased for clarity
                                      height: 1.5,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                        .toList(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to keep headers consistent
  Widget _sectionHeader(String title) {
    return Text(
      title,
      style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: 15,
        color: deepNavy.withOpacity(0.7),
        letterSpacing: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgSlate,
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: brandAmber,
        elevation: 0,
        title: Text(
          "RECIPES",
          style: TextStyle(
            color: deepNavy,
            fontWeight: FontWeight.w900,
            letterSpacing: 2,
            fontSize: 20,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: deepNavy),
            onPressed: () {},
          ),
        ],
      ),
      body: receipeModel == null
          ? Center(child: CircularProgressIndicator(color: brandAmber))
          : ListView.builder(
              padding: const EdgeInsets.symmetric(vertical: 20),
              itemCount: receipeModel?.recipes?.length ?? 0,
              itemBuilder: (context, index) {
                final recipe = receipeModel!.recipes![index];
                final isFav = _favorites.contains(recipe.id);

                return Container(
                  height: 450,
                  margin: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 15,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(35),
                    boxShadow: [
                      BoxShadow(
                        color: deepNavy.withOpacity(0.3),
                        blurRadius: 25,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(35),
                          child: Image.network(
                            recipe.image ?? '',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(35),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.black.withOpacity(0.1),
                                Colors.transparent,
                                deepNavy.withOpacity(0.9),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        left: 20,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                ),
                              ),
                              child: Text(
                                recipe.cuisine?.toUpperCase() ?? "",
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 20,
                        right: 20,
                        child: FloatingActionButton.small(
                          backgroundColor: isFav
                              ? Colors.redAccent
                              : Colors.white,
                          elevation: 0,
                          onPressed: () => setState(
                            () => isFav
                                ? _favorites.remove(recipe.id)
                                : _favorites.add(recipe.id!),
                          ),
                          child: Icon(
                            isFav ? Icons.favorite : Icons.favorite_border,
                            color: isFav ? Colors.white : deepNavy,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(35),
                          ),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              padding: const EdgeInsets.all(25),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.1),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    recipe.name ?? "",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      _glassStat(
                                        Icons.timer,
                                        "${recipe.cookTimeMinutes}m",
                                      ),
                                      _glassStat(
                                        Icons.local_fire_department,
                                        "${recipe.caloriesPerServing} cal",
                                      ),
                                      _glassStat(
                                        Icons.star,
                                        "${recipe.rating}",
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: brandAmber,
                                      foregroundColor: deepNavy,
                                      minimumSize: const Size(
                                        double.infinity,
                                        54,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(18),
                                      ),
                                      elevation: 0,
                                    ),
                                    onPressed: () => _showDetailsPopUp(recipe),
                                    child: const Text(
                                      "VIEW DETAILS",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w900,
                                        fontSize: 14,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _glassStat(IconData icon, String label) => Row(
    children: [
      Icon(icon, color: brandAmber, size: 20),
      const SizedBox(width: 6),
      Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 14,
        ),
      ),
    ],
  );
}
