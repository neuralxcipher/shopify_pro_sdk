/// SearchService — business logic for the search feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../core/utils/cursor_pagination.dart';
import '../../products/data/models/product.dart';
import '../data/models/search_result.dart';
import 'repositories/search_repository.dart';

/// High-level search API exposed via `ShopifyClient.search`.
class SearchService {
  const SearchService(this._repository);

  final SearchRepository _repository;

  /// Full-text search returning a paginated product list.
  Future<ShopifyPage<Product>> search(
    String query, {
    int first = 20,
    String? after,
    String? country,
    String? language,
  }) =>
      _repository.search(
        query,
        first: first,
        after: after,
        country: country,
        language: language,
      );

  /// Fast predictive / autocomplete search for search-as-you-type UIs.
  Future<PredictiveSearchResult> suggest(
    String query, {
    String? country,
    String? language,
  }) =>
      _repository.predictiveSearch(query, country: country, language: language);
}
