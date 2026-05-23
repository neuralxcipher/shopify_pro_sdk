/// Concrete implementation of CartRepository.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import '../../../../core/cache/cache_policy.dart';
import '../../../../core/client/shopify_config.dart';
import '../../../../core/errors/shopify_exception.dart';
import '../../../../core/graphql/graphql_engine.dart';
import '../../../../core/graphql/query_builder.dart';
import '../../data/models/cart.dart';
import '../../data/models/cart_line.dart';
import '../../data/mutations/cart_mutations.dart';
import '../../data/queries/cart_queries.dart';
import '../../domain/repositories/cart_repository.dart';

final class CartRepositoryImpl implements CartRepository {
  const CartRepositoryImpl({
    required this.engine,
    required this.config,
  });

  final GraphQLEngine engine;
  final ShopifyConfig config;

  @override
  Future<Cart> createCart({
    List<CartLineInput>? lines,
    String? note,
    List<CartAttribute>? attributes,
    String? buyerEmail,
    String? customerAccessToken,
    String? country,
    String? language,
  }) async {
    final input = <String, dynamic>{
      if (lines != null && lines.isNotEmpty)
        'lines': lines.map((l) => l.toJson()).toList(),
      if (note != null) 'note': note,
      if (attributes != null && attributes.isNotEmpty)
        'attributes': attributes.map((a) => a.toJson()).toList(),
      if (buyerEmail != null || customerAccessToken != null)
        'buyerIdentity': {
          if (buyerEmail != null) 'email': buyerEmail,
          if (customerAccessToken != null)
            'customerAccessToken': customerAccessToken,
          'countryCode': country ?? config.country,
        },
    };

    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartCreate)
          .variable('input', input)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('CartCreate')
          .build(),
    );

    return _extractCart(data, 'cartCreate');
  }

  @override
  Future<Cart> getCart(
    String cartId, {
    String? country,
    String? language,
  }) async {
    final data = await engine.query(
      GraphQLRequestBuilder()
          .query(CartQueries.getCart)
          .variable('cartId', cartId)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('GetCart')
          .build(),
      cachePolicy: CachePolicy.networkFirst,
      cacheTtl: CacheTtl.cart,
    );

    final cartJson = data['cart'] as Map<String, dynamic>?;
    if (cartJson == null) {
      throw ShopifyNotFoundException('Cart not found: $cartId');
    }
    return Cart.fromJson(cartJson);
  }

  @override
  Future<Cart> addLines(
    String cartId,
    List<CartLineInput> lines, {
    String? country,
    String? language,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartLinesAdd)
          .variable('cartId', cartId)
          .variable('lines', lines.map((l) => l.toJson()).toList())
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('CartLinesAdd')
          .build(),
    );
    return _extractCart(data, 'cartLinesAdd');
  }

  @override
  Future<Cart> updateLines(
    String cartId,
    List<CartLineUpdateInput> lines, {
    String? country,
    String? language,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartLinesUpdate)
          .variable('cartId', cartId)
          .variable('lines', lines.map((l) => l.toJson()).toList())
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('CartLinesUpdate')
          .build(),
    );
    return _extractCart(data, 'cartLinesUpdate');
  }

  @override
  Future<Cart> removeLines(
    String cartId,
    List<String> lineIds, {
    String? country,
    String? language,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartLinesRemove)
          .variable('cartId', cartId)
          .variable('lineIds', lineIds)
          .variable('country', country ?? config.country)
          .variable('language', language ?? config.language)
          .operationName('CartLinesRemove')
          .build(),
    );
    return _extractCart(data, 'cartLinesRemove');
  }

  @override
  Future<Cart> applyDiscountCode(String cartId, String discountCode) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartDiscountCodesUpdate)
          .variable('cartId', cartId)
          .variable('discountCodes', [discountCode])
          .operationName('CartDiscountCodesUpdate')
          .build(),
    );
    return _extractCart(data, 'cartDiscountCodesUpdate');
  }

  @override
  Future<Cart> removeDiscountCodes(String cartId) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartDiscountCodesUpdate)
          .variable('cartId', cartId)
          .variable('discountCodes', <String>[])
          .operationName('CartDiscountCodesUpdate')
          .build(),
    );
    return _extractCart(data, 'cartDiscountCodesUpdate');
  }

  @override
  Future<Cart> updateNote(String cartId, String note) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartNoteUpdate)
          .variable('cartId', cartId)
          .variable('note', note)
          .operationName('CartNoteUpdate')
          .build(),
    );
    return _extractCart(data, 'cartNoteUpdate');
  }

  @override
  Future<Cart> updateBuyerIdentity(
    String cartId, {
    String? email,
    String? customerAccessToken,
    String? countryCode,
  }) async {
    final data = await engine.mutate(
      GraphQLRequestBuilder()
          .query(CartMutations.cartBuyerIdentityUpdate)
          .variable('cartId', cartId)
          .variable('buyerIdentity', {
            if (email != null) 'email': email,
            if (customerAccessToken != null)
              'customerAccessToken': customerAccessToken,
            if (countryCode != null) 'countryCode': countryCode,
          })
          .operationName('CartBuyerIdentityUpdate')
          .build(),
    );
    return _extractCart(data, 'cartBuyerIdentityUpdate');
  }

  Cart _extractCart(Map<String, dynamic> data, String mutationKey) {
    final result = data[mutationKey] as Map<String, dynamic>;
    _throwIfUserErrors(result['userErrors']);
    final cartJson = result['cart'] as Map<String, dynamic>?;
    if (cartJson == null) {
      throw const ShopifyGraphQLException('Cart mutation returned no cart',
          errors: []);
    }
    return Cart.fromJson(cartJson);
  }

  void _throwIfUserErrors(dynamic errors) {
    if (errors is! List || errors.isEmpty) return;
    final messages = errors
        .whereType<Map<String, dynamic>>()
        .map((e) => e['message'] as String? ?? 'Unknown error')
        .join('; ');
    if (messages.isNotEmpty) {
      throw ShopifyGraphQLException(messages, errors: []);
    }
  }
}
