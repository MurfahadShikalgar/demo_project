// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:practice_application/GraphQl/graphQl_config.dart';
import 'package:practice_application/GraphQl/modals/all_products_model.dart';
import 'package:practice_application/utils/widgets/dialog_widget.dart';

import '../GraphQl/queries/query.dart';

class ApiServiceManager extends GetxController {
  List<AllProductData> allProductList = [];
  bool isLoading = true;

  Future getAllProductsData(BuildContext context) async {
    GraphQLClient client = GraphQlConfig().clientToQuery();
    QueryResult result = await client.query(
      QueryOptions(
        document: gql(allProductsQuery),
        fetchPolicy: FetchPolicy.noCache,
      ),
    );
    if (result.hasException == true) {
      isLoading = false;
      update();
      return ShowDialogs().CustomDialog(
          context, "Error", result.exception.toString(), "Reload", () {
        getAllProductsData(context);
      });
    } else if (result.data != null) {
      isLoading = true;
      allProductList =
          AllProductsModel.fromJson(result.data!['products']).edges!;
      update();
    }
  }
}
