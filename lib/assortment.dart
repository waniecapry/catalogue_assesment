import "dart:developer";

import "package:dio/dio.dart"; // Using dio for handling the HTTP client.

class Assortment // This class represents the app. Assortment stands for Product Catalogue. Anything constants, variables, methods that belong to the app should be placed here
{
    static const String appName = "Assorta"; // constants with lowerCamelCase following Dart convention.
    static const String appDescription = "Experience the finest way to shop";
    static final Dio _dio = Dio();

    static Future<List<Map<String, dynamic>>> getProductList( int offset, int limit ) async
    {
        final List<Map<String, dynamic>> products = [];

        Response r = await _dio.get
        (
            "https://dummyjson.com/products",
            queryParameters: { "limit": limit, "skip": offset },
            options: Options( responseType: ResponseType.json )
        );                                                                          log( "Response data: ${r.data}" );

        for( final product in r.data["products"] )
        {
            products.add( Map<String, dynamic>.from( product ) );
        }                                                                           log( "products: $products" );

        return products;
    }
    static Future<List<Map<String, dynamic>>> searchProduct( String query, int offset, int limit ) async
    {
        final List<Map<String, dynamic>> products = [];

        Response r = await _dio.get
        (
            "https://dummyjson.com/products/search",
            queryParameters: { "q": query, "limit": limit, "skip": offset },
            options: Options( responseType: ResponseType.json ),
        );                                                                          log( "Response data: ${r.data}" );

        for( final product in r.data["products"] )
        {
            products.add( Map<String, dynamic>.from( product ) );
        }                                                                           log( "products: $products" );

        return products;
    }
}