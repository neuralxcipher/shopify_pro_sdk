// ignore_for_file: inference_failure_on_collection_literal

/// Mock HTTP client for unit testing shopify_pro_sdk.
///
/// Developed and maintained by Abrar Ali — NEURALXCIPHER (PRIVATE) LIMITED
library;

import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

class MockHttpClient extends Mock implements http.Client {}

/// Builds a fake [http.Response] with a JSON body.
http.Response fakeJsonResponse(
  Map<String, dynamic> body, {
  int statusCode = 200,
}) =>
    http.Response(
      jsonEncode(body),
      statusCode,
      headers: {'content-type': 'application/json'},
    );

/// Wraps [data] in a GraphQL `{ "data": ... }` envelope.
Map<String, dynamic> gqlData(Map<String, dynamic> data) => {'data': data};

/// Returns a GraphQL error envelope.
Map<String, dynamic> gqlErrors(List<String> messages) => {
      'errors': messages
          .map((m) => {'message': m, 'locations': [], 'path': []})
          .toList(),
    };
