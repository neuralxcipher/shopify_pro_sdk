/// GraphQL queries for customer profile and orders.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

abstract final class CustomerProfileQueries {
  static const String getCustomerWithAddresses = r'''
    query GetCustomerWithAddresses($customerAccessToken: String!) {
      customer(customerAccessToken: $customerAccessToken) {
        id email firstName lastName phone displayName acceptsMarketing createdAt tags
        defaultAddress {
          id address1 address2 city company country countryCodeV2
          firstName lastName phone province provinceCode zip
        }
        addresses(first: 10) {
          edges {
            node {
              id address1 address2 city company country countryCodeV2
              firstName lastName phone province provinceCode zip
            }
          }
        }
      }
    }
  ''';

  static const String getCustomerOrders = r'''
    query GetCustomerOrders($customerAccessToken: String!, $first: Int!, $after: String) {
      customer(customerAccessToken: $customerAccessToken) {
        orders(first: $first, after: $after, sortKey: PROCESSED_AT, reverse: true) {
          pageInfo { hasNextPage endCursor }
          edges {
            node {
              id name orderNumber processedAt financialStatus fulfillmentStatus statusUrl
              totalPriceV2 { amount currencyCode }
              lineItems(first: 5) {
                edges {
                  node {
                    title quantity
                    currentTotalPrice { amount currencyCode }
                    variant {
                      title
                      image { url }
                    }
                  }
                }
              }
            }
          }
        }
      }
    }
  ''';
}
