/// GraphQL queries for the Cart API.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class CartQueries {
  static const String getCart = r'''
    query GetCart($cartId: ID!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      cart(id: $cartId) {
        id
        checkoutUrl
        totalQuantity
        note
        createdAt
        updatedAt
        cost {
          subtotalAmount { amount currencyCode }
          totalAmount    { amount currencyCode }
          totalTaxAmount { amount currencyCode }
        }
        discountCodes { code applicable }
        attributes { key value }
        lines(first: 250) {
          edges {
            node {
              id
              quantity
              attributes { key value }
              cost {
                subtotalAmount { amount currencyCode }
                totalAmount    { amount currencyCode }
              }
              discountAllocations {
                discountedAmount { amount currencyCode }
              }
              merchandise {
                ... on ProductVariant {
                  id title availableForSale sku
                  price           { amount currencyCode }
                  compareAtPrice  { amount currencyCode }
                  image           { id url altText }
                  selectedOptions { name value }
                  product         { id title handle }
                }
              }
            }
          }
        }
      }
    }
  ''';
}
