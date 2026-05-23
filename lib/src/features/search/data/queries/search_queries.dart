/// GraphQL queries for the search feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class SearchQueries {
  static const String search = r'''
    query Search(
      $query: String!,
      $first: Int!,
      $after: String,
      $sortKey: SearchSortKeys,
      $reverse: Boolean,
      $country: CountryCode,
      $language: LanguageCode
    ) @inContext(country: $country, language: $language) {
      search(
        query: $query
        first: $first
        after: $after
        sortKey: $sortKey
        reverse: $reverse
        types: [PRODUCT]
      ) {
        totalCount
        pageInfo { hasNextPage endCursor }
        edges {
          node {
            ... on Product {
              id title handle description availableForSale
              vendor productType tags
              featuredImage { id url altText }
              priceRange {
                minVariantPrice { amount currencyCode }
                maxVariantPrice { amount currencyCode }
              }
              variants(first: 3) {
                edges {
                  node {
                    id title availableForSale
                    price           { amount currencyCode }
                    compareAtPrice  { amount currencyCode }
                    selectedOptions { name value }
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';

  static const String predictiveSearch = r'''
    query PredictiveSearch($query: String!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      predictiveSearch(query: $query, types: [PRODUCT, COLLECTION, QUERY]) {
        queries { text styledText }
        products {
          id title handle
          featuredImage { id url altText }
          priceRange { minVariantPrice { amount currencyCode } }
        }
        collections {
          id title handle
          image { id url altText }
        }
      }
    }
  ''';
}
