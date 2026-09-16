import "dart:developer";

import "package:dio/dio.dart"; // Using dio for handling the HTTP client.

enum AssortmentCategory 
{
    beauty( "beauty", "Beauty" ),
    fragrances( "fragrances", "Fragrances" ),
    furniture( "furniture", "Furniture" ),
    groceries( "groceries", "Groceries" ),
    other( "other", "Other" );

    final String value;
    final String str;

    static AssortmentCategory fromString( final String value ) 
    {
        for( AssortmentCategory cat in AssortmentCategory.values ) 
        {
            if( cat.value == value )
            {
                return cat;
            }
        }

        return AssortmentCategory.other;
    }

    const AssortmentCategory( this.value, this.str );
}

class Assortment // This class represents the app. Its like a namespace. Assortment stands for Product Catalogue. Anything constants, variables, methods that belong to the app should be placed here
{
    static const String appName = "Assorta"; // constants with lowerCamelCase following Dart convention.
    static const String appDescription = "Experience the finest way to shop";
    static final Dio _dio = Dio();

    static Future<List<AssortmentProduct>> getProductList( int offset, int limit ) async
    {
        final List<AssortmentProduct> products = [];

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
    static Future<AssortmentProduct> searchProduct( String query, int offset, int limit ) async
    {
        final List<AssortmentProduct> products = [];

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
class AssortmentDimension 
{
    final double width;
    final double height;
    final double depth;

    AssortmentDimension
    ({
        required this.width,
        required this.height,
        required this.depth
    });
}
class AssortmentProduct // in other OOP this class something like Assortment.Product
{
    final String id;
    final String title;
    final String description;
    final AssortmentCategory category; // enum
    final double price;
    final double discountPercentage;
    final double rating;
    final int stock;
    final List<String> tags;
    final String brand; // If given the list of brands, I will make Brand class and use it here instead of String.
    final String sku;
    final double weight;
    final AssortmentDimension dimension; // dimension class
    final String warrantyInfo;
    final String shippingInfo;
    final String availabilityStatus; // If possible, I will make an enum for this instead of String.
    final List<AssortmentProductReview> reviews = []; // review class
    final AssortmentProductMeta meta; // class
    final List<String> images;
    final String thumbnail;

    AssortmentProduct
    ({
        required this.id,
        required this.title,
        required this.description,
        required this.category,
        required this.price,
        required this.discountPercentage,
        required this.rating,
        required this.stock,
        required this.tags,
        required this.brand,
        required this.sku,
        required this.weight,
        required this.dimension,
        required this.warrantyInfo,
        required this.shippingInfo,
        required this.availabilityStatus,
        required this.meta,
        required this.images,
        required this.thumbnail
    });
    double get discountedPrice 
    {
        return price * (1 - discountPercentage / 100);
    }
    Future<AssortmentProduct> getDetails() async // https://dummyjson.com/products/{id} returns the same data as the list, so I will just return this for now. If the API changes, I will update this method accordingly.
    {
        return this;
    }
}
class AssortmentProductReview // in other OOP this class something like Assortment.Product.Review
{
    final int rating;
    final String comment;
    final DateTime date;
    final String reviewerName;
    final String reviewerEmail;

    AssortmentProductReview
    ({
        required this.rating,
        required this.comment,
        required this.date,
        required this.reviewerName,
        required this.reviewerEmail
    });
}
class AssortmentProductMeta // in other OOP this class something like Assortment.Product.Meta
{
    final DateTime createdAt;
    final DateTime updatedAt;
    final String barcode;
    final String qrUrl;

    AssortmentProductMeta
    ({
        required this.createdAt,
        required this.updatedAt,
        required this.barcode,
        required this.qrUrl
    });
}