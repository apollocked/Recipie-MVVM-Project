import 'package:dio_receipe/data/model/receipe_model.dart';
import 'package:dio_receipe/data/services/recepie_service.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  ReceipeModel? receipeModel;
  @override
  void initState() {
    super.initState();
    getReceipeData();
  }

  Future<void> getReceipeData() async {
    try {
      receipeModel = await RecepieService().getRecepie();
      setState(() {});
    } on Exception catch (e) {
      ScaffoldMessenger.of(
        // ignore: use_build_context_synchronously
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Recipes"),
        backgroundColor: Colors.lime[600],
      ),
      body: SafeArea(
        child: receipeModel == null
            ? const Center(
                child: CircularProgressIndicator(),
              ) // Show loader while null
            : Column(
                children: [
                  // 2. Use Expanded ONLY here to let the List fill the screen
                  Expanded(
                    child: ListView.builder(
                      itemCount: receipeModel?.recipes?.length ?? 0,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text('${receipeModel?.recipes?[index].name}'),
                          leading: const Icon(Icons.restaurant_menu),
                        );
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lime[600],
        onPressed: getReceipeData, // 3. Set refresh to call your data method
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
