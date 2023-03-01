import 'package:bliss_store/services/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/category_model.dart';

class CategoryRepository {
  CollectionReference<CategoryModel> categoryRef =
      FirebaseService.db.collection("categories").withConverter<CategoryModel>(
            fromFirestore: (snapshot, _) {
              return CategoryModel.fromFirebaseSnapshot(snapshot);
            },
            toFirestore: (model, _) => model.toJson(),
          );
  Future<List<QueryDocumentSnapshot<CategoryModel>>> getCategories() async {
    try {
      var data = await categoryRef.get();
      bool hasData = data.docs.isNotEmpty;
      if (!hasData) {
        makeCategory().forEach((element) async {
          await categoryRef.add(element);
        });
      }
      final response = await categoryRef.get();
      var category = response.docs;
      return category;
    } catch (err) {
      print(err);
      rethrow;
    }
  }

  Future<DocumentSnapshot<CategoryModel>> getCategory(String categoryId) async {
    try {
      print(categoryId);
      final response = await categoryRef.doc(categoryId).get();
      return response;
    } catch (e) {
      rethrow;
    }
  }

  List<CategoryModel> makeCategory() {
    return [
      CategoryModel(
          categoryName: "Painting",
          status: "active",
          imageUrl:
              "data:image/jpeg;base64,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"),
      CategoryModel(
          categoryName: "Sketch",
          status: "active",
          imageUrl:
              "https://www.google.com/url?sa=i&url=https%3A%2F%2Findianartideas.in%2Fblog%2Fpersonalized-art%2F10-exceptional-pencil-portrait-artists&psig=AOvVaw1bqi9CIbvhHBYt5URiOU4R&ust=1677683108410000&source=images&cd=vfe&ved=0CA8QjRxqFwoTCJihwd6-uP0CFQAAAAAdAAAAABAE"),
      CategoryModel(
          categoryName: "Ceramic",
          status: "active",
          imageUrl:
              "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQSEGmdZT5US_kks4H_yOSC81TGcoJNyvSLC18Gh4wL&s"),
      CategoryModel(
          categoryName: "Sculpture",
          status: "active",
          imageUrl:
              "https://i2.wp.com/d3d2ir91ztzaym.cloudfront.net/uploads/2020/07/computer-peripherals.jpeg"),
      CategoryModel(
          categoryName: "Digital Art",
          status: "active",
          imageUrl:
              "https://img.texasmonthly.com/2013/04/ESSENTIALS_680X382.jpg"),
    ];
  }
}
