import 'package:graphql_flutter/graphql_flutter.dart';
import '../configurations/graphQLConfiguration.dart';

class GraphQLApiClient{

  GraphQLConfiguration _graphQLConfiguration = GraphQLConfiguration();

  Future<QueryResult> execute (String qry) async{
    GraphQLClient _client = _graphQLConfiguration.clientToQuery();
    QueryResult result = await _client.query(
      QueryOptions(
        document: qry,
      ),
    );

    return result;
  }
}