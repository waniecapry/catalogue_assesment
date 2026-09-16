import "dart:developer";

import "package:flutter/material.dart";

import "assortment.dart";

class AssortmentUi // Represents the app in handling UI logic. Anything common for accross the apps should be put here.
{

}
class AssortmentUiMainScreen extends StatefulWidget // TODO: Beautify the UI/UX and improve the beauty of the app.
{
    const AssortmentUiMainScreen( { super.key } );

    @override State<AssortmentUiMainScreen> createState() => _AssortmentUiMainScreenState();
}
class _AssortmentUiMainScreenState extends State<AssortmentUiMainScreen>
{
    @override Widget build( BuildContext context )
    {
        return Scaffold
        ( 
            body: SafeArea
            (
                child: GestureDetector
                (
                    child: Text( "Welcome" ),
                    onTap: () async
                    {
                        final products = await Assortment.getProductList( 0, 20 );

                        log( "This is the loaded products: $products" );
                    }
                )
            )
        );
    }
}