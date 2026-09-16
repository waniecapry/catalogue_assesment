import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:assortment/main.dart';
import 'package:assortment/assortment.dart';

void main() 
{
    testWidgets( "shows the assortment home screen", (tester) async
    {
        await tester.pumpWidget( const App() );

        expect( find.text( "Assorta" ), findsOneWidget );
        expect( find.text( "Find your next favourite product" ), findsOneWidget );
        expect( find.text( "Explore products" ), findsOneWidget );
    });
    testWidgets( "Explore products button in main screen is clickable", (tester) async
    {
        await tester.pumpWidget( const App() );

        await tester.tap( find.text( "Explore products" ) );
        await tester.pump();
        await tester.pump( const Duration( milliseconds: 500 ) );

        expect( find.byType( SearchBar ), findsOneWidget );
        expect( find.text( "Search products" ), findsOneWidget );
    });
    test( "maps known API categories", ()
    {
        expect
        (
            AssortmentCategory.fromString( "beauty" ),
            AssortmentCategory.beauty
        );
    });
    test( "maps unsupported API categories to other", ()
    {
        expect
        (
            AssortmentCategory.fromString( "unknown-category" ),
            AssortmentCategory.other
        );
    });
    test( "parses a product response and calculates its discounted price", ()
    {
        final product = AssortmentProduct.productFromJson
        ({
            "id": 10,
            "title": "Test product",
            "description": "Description",
            "category": "beauty",
            "price": 100,
            "discountPercentage": 20,
            "rating": 4.5,
            "stock": 7,
            "tags": [ "test" ],
            "brand": "Example",
            "sku": "SKU-10",
            "weight": 2,
            "dimensions": { "width": 1, "height": 2, "depth": 3 },
            "warrantyInformation": "One year",
            "shippingInformation": "Ships tomorrow",
            "availabilityStatus": "In Stock",
            "meta":
            {
                "createdAt": "2026-01-01T00:00:00.000Z",
                "updatedAt": "2026-01-02T00:00:00.000Z",
                "barcode": "123",
                "qrCode": "https://example.com/qr"
            },
            "images": [ "https://example.com/image.png" ],
            "thumbnail": "https://example.com/thumbnail.png"
        });

        expect( product.id, "10" );
        expect( product.category, AssortmentCategory.beauty );
        expect( product.dimension.toString(), "1.0 x 2.0 x 3.0" );
        expect( product.discountedPrice, closeTo( 80, 0.001 ) );
    });
}