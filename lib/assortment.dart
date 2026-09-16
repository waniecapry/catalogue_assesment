class Assortment // This class represents the app. Assortment stands for Product Catalogue. Anything constants, variables, methods that belong to the app should be placed here
{
    static const String appName = "Assorta"; // constants with lowerCamelCase following Dart convention.
    static const String appDescription = "Experience the finest way to shop";

    static Future<List<Map<String, Object>>> getProductList( int offset, int limit ) async
    {
        final List<Map<String, Object>> products = [];

        return products;
    }
    static Future<List<Map<String, Object>>> searchProduct( String query, int offset, int limit ) async
    {
        final List<Map<String, Object>> products = [];

        return products;
    }
}