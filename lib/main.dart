import "package:flutter/material.dart";

import "assortment.ui.dart";

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
            home: const AssortmentUiMainScreen()
        );
    }
}