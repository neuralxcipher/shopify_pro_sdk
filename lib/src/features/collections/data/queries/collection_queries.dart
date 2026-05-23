/// GraphQL queries for the collections feature.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class CollectionQueries {
  static const String _imageFragment = '''
    fragment ImageFields on Image {
      id url altText width height
    }
  ''';

  static const String getCollections = r'''
    query GetCollections(
      $first: Int!,
      $after: String,
      $country: CountryCode,
      $language: LanguageCode
    ) @inContext(country: $country, language: $language) {
      collections(first: $first, after: $after) {
        pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
        edges {
          node {
            id title handle description descriptionHtml updatedAt
            image { ...ImageFields }
            seo { title description }
          }
        }
      }
    }
  ''' + _imageFragment;

  static const String getCollectionByHandle = r'''
    query GetCollectionByHandle(
      $handle: String!,
      $productsFirst: Int!,
      $productsAfter: String,
      $sortKey: ProductCollectionSortKeys,
      $reverse: Boolean,
      $country: CountryCode,
      $language: LanguageCode
    ) @inContext(country: $country, language: $language) {
      collectionByHandle(handle: $handle) {
        id title handle description descriptionHtml updatedAt
        image { ...ImageFields }
        seo { title description }
        products(
          first: $productsFirst
          after: $productsAfter
          sortKey: $sortKey
          reverse: $reverse
        ) {
          pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
          edges {
            node {
              id title handle description availableForSale
              productType vendor tags
              featuredImage { ...ImageFields }
              priceRange {
                minVariantPrice { amount currencyCode }
                maxVariantPrice { amount currencyCode }
              }
              variants(first: 5) {
                edges {
                  node {
                    id title availableForSale
                    price { amount currencyCode }
                    compareAtPrice { amount currencyCode }
                    selectedOptions { name value }
                  }
                }
              }
            }
          }
        }
      }
    }
  ''' + _imageFragment;

  static const String getCollectionById = r'''
    query GetCollectionById($id: ID!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      collection(id: $id) {
        id title handle description descriptionHtml updatedAt
        image { ...ImageFields }
        seo { title description }
      }
    }
  ''' + _imageFragment;
}

enum CollectionProductSortKey {
  manual,
  bestSelling,
  title,
  price,
  created,
  collectionDefault,
  relevance,
}
