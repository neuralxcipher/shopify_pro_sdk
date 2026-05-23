/// Abstract search repository contract.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/utils/cursor_pagination.dart';
import '../../../products/data/models/product.dart';
import '../../data/models/search_result.dart';

abstract interface class SearchRepository {
  Future<ShopifyPage<Product>> search(
    String query, {
    int first = 20,
    String? after,
    String? country,
    String? language,
  });

  Future<PredictiveSearchResult> predictiveSearch(
    String query, {
    String? country,
    String? language,
  });
}
