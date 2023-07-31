import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

final ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient> (
      GraphQLClient(
        link: HttpLink(dotenv.env['PARAM_GRAPHQL_URL'] as String), 
        cache: GraphQLCache(store: InMemoryStore()),
      )
    );

