import "dart:developer";

import "package:flutter/material.dart";

import "assortment.dart";

void main() 
{
    runApp( const App() );
}

class App extends StatelessWidget 
{
    const App( { super.key } );

    @override Widget build( BuildContext context )
    {
        return MaterialApp
        (
            title: "Assortment",
            home: Scaffold
            ( 
                body: GestureDetector
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