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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 20.0),
              Icon(Icons.fastfood, size: 52.0, color: Colors.black),
              SizedBox(height: 20.0),
              receipeModel == null
                  ? const Center(
                      child: CircularProgressIndicator(),
                    ) // Show loader while null
                  : Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black, width: 1.5),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      height: MediaQuery.of(context).size.height - 260,
                      child: ListView.builder(
                        itemCount: receipeModel?.recipes?.length ?? 0,
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(
                              vertical: 4.0,
                              horizontal: 10.0,
                            ),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.lime[600]!),
                            ),
                            child: Text(
                              '${receipeModel?.recipes?[index].name}',
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
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
