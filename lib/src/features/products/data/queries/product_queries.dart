/// Shopify Storefront GraphQL queries for products.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

/// All GraphQL query/fragment strings for the products feature.
abstract final class ProductQueries {
  // ── Shared fragments ────────────────────────────────────────────────────

  static const String _moneyFragment = '''
    fragment MoneyFields on MoneyV2 {
      amount
      currencyCode
    }
  ''';

  static const String _imageFragment = '''
    fragment ImageFields on Image {
      id
      url
      altText
      width
      height
    }
  ''';

  static const String _variantFragment = '''
    fragment VariantFields on ProductVariant {
      id
      title
      availableForSale
      sku
      barcode
      quantityAvailable
      requiresShipping
      taxable
      price { ...MoneyFields }
      compareAtPrice { ...MoneyFields }
      image { ...ImageFields }
      selectedOptions { name value }
      weight
      weightUnit
    }
  ''';

  static const String _productCoreFragment = '''
    fragment ProductCore on Product {
      id
      title
      handle
      description
      descriptionHtml
      productType
      vendor
      tags
      availableForSale
      totalInventory
      requiresSellingPlan
      publishedAt
      createdAt
      updatedAt
      featuredImage { ...ImageFields }
      seo { title description }
      priceRange {
        minVariantPrice { ...MoneyFields }
        maxVariantPrice { ...MoneyFields }
      }
      compareAtPriceRange {
        minVariantPrice { ...MoneyFields }
        maxVariantPrice { ...MoneyFields }
      }
      options { id name values }
      metafields(identifiers: []) { id namespace key value type description }
    }
  ''';

  // ── Queries ─────────────────────────────────────────────────────────────

  /// Fetch a single product by GID.
  static const String getProductById = r'''
    query GetProductById($id: ID!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      product(id: $id) {
        ...ProductCore
        variants(first: 250) {
          edges { node { ...VariantFields } }
        }
        images(first: 20) {
          edges { node { ...ImageFields } }
        }
        sellingPlanGroups(first: 10) {
          edges {
            node {
              id name appName
              sellingPlans(first: 10) {
                edges { node { id name description recurringDeliveries } }
              }
            }
          }
        }
      }
    }
  ''' +
      _productCoreFragment +
      _variantFragment +
      _imageFragment +
      _moneyFragment;

  static const String getProductByHandle = r'''
    query GetProductByHandle($handle: String!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      productByHandle(handle: $handle) {
        ...ProductCore
        variants(first: 250) {
          edges { node { ...VariantFields } }
        }
        images(first: 20) {
          edges { node { ...ImageFields } }
        }
      }
    }
  ''' +
      _productCoreFragment +
      _variantFragment +
      _imageFragment +
      _moneyFragment;

  static const String getProducts = r'''
    query GetProducts(
      $first: Int!,
      $after: String,
      $sortKey: ProductSortKeys,
      $reverse: Boolean,
      $query: String,
      $country: CountryCode,
      $language: LanguageCode
    ) @inContext(country: $country, language: $language) {
      products(
        first: $first
        after: $after
        sortKey: $sortKey
        reverse: $reverse
        query: $query
      ) {
        pageInfo { hasNextPage hasPreviousPage startCursor endCursor }
        edges {
          node {
            ...ProductCore
            variants(first: 5) { edges { node { ...VariantFields } } }
            images(first: 3)   { edges { node { ...ImageFields   } } }
          }
        }
      }
    }
  ''' +
      _productCoreFragment +
      _variantFragment +
      _imageFragment +
      _moneyFragment;

  static const String getProductRecommendations = r'''
    query GetProductRecommendations($productId: ID!, $intent: ProductRecommendationIntent) {
      productRecommendations(productId: $productId, intent: $intent) {
        ...ProductCore
        variants(first: 5) { edges { node { ...VariantFields } } }
        images(first: 1)   { edges { node { ...ImageFields   } } }
      }
    }
  ''' +
      _productCoreFragment +
      _variantFragment +
      _imageFragment +
      _moneyFragment;
}

/// Sort keys supported by the Shopify products connection.
enum ProductSortKey {
  title,
  productType,
  vendor,
  updatedAt,
  createdAt,
  bestSelling,
  price,
  id,
  relevance,
}

/// Filter input for product queries.
final class ProductFilter {
  const ProductFilter({
    this.available,
    this.productType,
    this.productVendor,
    this.variantOption,
    this.price,
    this.tag,
  });

  final bool? available;
  final String? productType;
  final String? productVendor;
  final VariantOptionFilter? variantOption;
  final PriceFilter? price;
  final String? tag;

  Map<String, dynamic> toJson() => {
        if (available != null) 'available': available,
        if (productType != null) 'productType': productType,
        if (productVendor != null) 'productVendor': productVendor,
        if (variantOption != null) 'variantOption': variantOption!.toJson(),
        if (price != null) 'price': price!.toJson(),
        if (tag != null) 'tag': tag,
      };
}

final class VariantOptionFilter {
  const VariantOptionFilter({required this.name, required this.value});
  final String name;
  final String value;
  Map<String, dynamic> toJson() => {'name': name, 'value': value};
}

final class PriceFilter {
  const PriceFilter({this.min, this.max});
  final double? min;
  final double? max;
  Map<String, dynamic> toJson() => {
        if (min != null) 'min': min,
        if (max != null) 'max': max,
      };
}
