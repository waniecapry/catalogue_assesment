import "dart:developer";

import "package:flutter/material.dart";

import "assortment.dart";

class AssortmentUi // Represents the app in handling UI logic. Anything common for accross the apps should be put here.
{
    static const kPadding = EdgeInsets.all( 16 );

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
                        Navigator.push
                        (
                            context,
                            MaterialPageRoute
                            (
                                builder: (context)=> const _AssortmentUiProductListScreen()
                            )
                        );
                    }
                )
            )
        );
    }
}
class _AssortmentUiProductListScreen extends StatefulWidget 
{
    const _AssortmentUiProductListScreen();

    @override State<_AssortmentUiProductListScreen> createState()=> _AssortmentUiProductListScreenState();
}
class _AssortmentUiProductListScreenState extends State<_AssortmentUiProductListScreen> 
{
    static const int _limit = 20; // Number of products to fetch per request. I make it as const first, but if the UI allow users to set the limit, I will make it as variable and set it from the UI.

    final ScrollController _scrollController = ScrollController();
    final List<AssortmentProduct> _products = [];
    int _offset = 0;
    bool _hasMoreProducts = true;

    @override void initState()
    {
        super.initState();
        _loadProducts();
    }
    @override Widget build( BuildContext context ) 
    {
        return Scaffold
        (
            body: RefreshIndicator // Used to reload the products.
            (
                onRefresh: _refreshProducts,
                child: CustomScrollView
                (
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    slivers: 
                    [
                        SliverPadding
                        (
                            padding: AssortmentUi.kPadding,
                            sliver: SliverGrid
                            (
                                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent
                                (
                                    maxCrossAxisExtent: 220,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.80
                                ),
                                delegate: SliverChildBuilderDelegate( (context, index) 
                                {
                                    final product = _products[index];

                                    return Text( product.title );
                                }, childCount: _products.length )
                            )
                        ),
                    ]
                )
            )
        );
    }
    Future<void> _refreshProducts() async
    {
        await _loadProducts();
    }
    Future<void> _loadProducts() async 
    {
        try 
        {
            final products = await Assortment.getProductList( _offset, _limit );

            setState( () 
            {
                _products.addAll( products );
            });
        } 
        catch( error ) 
        {
            log( "$error" );
        }
    }
}