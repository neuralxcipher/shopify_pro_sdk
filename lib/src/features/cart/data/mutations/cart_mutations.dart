/// GraphQL mutations for the Cart API.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

// Cart fields are inlined in each mutation to keep all strings as single
// raw string literals — avoids both concatenation and interpolation lints.

abstract final class CartMutations {
  static const String cartCreate = r'''
    mutation CartCreate($input: CartInput!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      cartCreate(input: $input) {
        cart {
          id checkoutUrl totalQuantity note createdAt updatedAt
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
                id quantity
                attributes { key value }
                cost {
                  subtotalAmount { amount currencyCode }
                  totalAmount    { amount currencyCode }
                }
                discountAllocations { discountedAmount { amount currencyCode } }
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
        userErrors { field message code }
      }
    }
  ''';

  static const String cartLinesAdd = r'''
    mutation CartLinesAdd($cartId: ID!, $lines: [CartLineInput!]!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      cartLinesAdd(cartId: $cartId, lines: $lines) {
        cart {
          id checkoutUrl totalQuantity note createdAt updatedAt
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
                id quantity
                cost {
                  subtotalAmount { amount currencyCode }
                  totalAmount    { amount currencyCode }
                }
                discountAllocations { discountedAmount { amount currencyCode } }
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
        userErrors { field message code }
      }
    }
  ''';

  static const String cartLinesUpdate = r'''
    mutation CartLinesUpdate($cartId: ID!, $lines: [CartLineUpdateInput!]!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      cartLinesUpdate(cartId: $cartId, lines: $lines) {
        cart {
          id checkoutUrl totalQuantity note
          cost {
            subtotalAmount { amount currencyCode }
            totalAmount    { amount currencyCode }
          }
          discountCodes { code applicable }
          lines(first: 250) {
            edges {
              node {
                id quantity
                cost { subtotalAmount { amount currencyCode } }
                merchandise {
                  ... on ProductVariant {
                    id title price { amount currencyCode }
                    selectedOptions { name value }
                    product { id title handle }
                  }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  static const String cartLinesRemove = r'''
    mutation CartLinesRemove($cartId: ID!, $lineIds: [ID!]!, $country: CountryCode, $language: LanguageCode)
    @inContext(country: $country, language: $language) {
      cartLinesRemove(cartId: $cartId, lineIds: $lineIds) {
        cart {
          id checkoutUrl totalQuantity
          cost {
            subtotalAmount { amount currencyCode }
            totalAmount    { amount currencyCode }
          }
          lines(first: 250) {
            edges {
              node {
                id quantity
                cost { subtotalAmount { amount currencyCode } }
                merchandise {
                  ... on ProductVariant {
                    id title price { amount currencyCode }
                    selectedOptions { name value }
                    product { id title handle }
                  }
                }
              }
            }
          }
        }
        userErrors { field message code }
      }
    }
  ''';

  static const String cartDiscountCodesUpdate = r'''
    mutation CartDiscountCodesUpdate($cartId: ID!, $discountCodes: [String!]!) {
      cartDiscountCodesUpdate(cartId: $cartId, discountCodes: $discountCodes) {
        cart {
          id checkoutUrl totalQuantity
          cost {
            subtotalAmount { amount currencyCode }
            totalAmount    { amount currencyCode }
          }
          discountCodes { code applicable }
        }
        userErrors { field message code }
      }
    }
  ''';

  static const String cartNoteUpdate = r'''
    mutation CartNoteUpdate($cartId: ID!, $note: String!) {
      cartNoteUpdate(cartId: $cartId, note: $note) {
        cart { id note }
        userErrors { field message }
      }
    }
  ''';

  static const String cartBuyerIdentityUpdate = r'''
    mutation CartBuyerIdentityUpdate($cartId: ID!, $buyerIdentity: CartBuyerIdentityInput!) {
      cartBuyerIdentityUpdate(cartId: $cartId, buyerIdentity: $buyerIdentity) {
        cart {
          id checkoutUrl totalQuantity
          cost {
            subtotalAmount { amount currencyCode }
            totalAmount    { amount currencyCode }
          }
        }
        userErrors { field message }
      }
    }
  ''';
}
