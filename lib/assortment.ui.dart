import "dart:developer";

import "package:flutter/material.dart";

import "assortment.dart";

class AssortmentUi // Represents the app in handling UI logic. Anything common for accross the apps should be put here.
{
    static const kPadding = EdgeInsets.all( 16 );
    static const kCollapsedPadding = EdgeInsets.all( 1 );
    static const kVerticalSpacingExtraSmall = SizedBox( height: 2 );
    static const kVerticalSpacingSmall = SizedBox( height: 8 );
    static const kVerticalSpacingMedium = SizedBox( height: 12 );
    static const kVerticalSpacingLarge = SizedBox( height: 16 );
    static const kVerticalSpacingExtraLarge = SizedBox( height: 24 );
    static const kHorizontalSpacingExtraSmall = SizedBox( width: 4 );
    static const kHorizontalSpacingSmall = SizedBox( height: 8 );
    static const kHorizontalSpacingMedium = SizedBox( height: 12 );
    static const kHorizontalSpacingLarge = SizedBox( height: 16 );
    static const kHorizontalSpacingExtraLarge = SizedBox( height: 24 );
    static const kHeaderTextStyle = TextStyle
    (
        fontSize: 20,
        fontWeight: FontWeight.bold
    );
    static const kSubHeaderTextStyle = TextStyle
    (
        fontSize: 14,
        fontWeight: FontWeight.bold
    );
    static const kBodyTextStyle = TextStyle
    (
        fontSize: 10,
        fontWeight: FontWeight.bold
    );
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

    bool get _isBottom 
    {
        if( !_scrollController.hasClients ) 
        {
            return false;
        }

        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;

        return currentScroll >= (maxScroll * 0.9); // Trigger at 90% scroll
    }
    @override void initState()
    {
        super.initState();
        _scrollController.addListener( _onScroll );
        _loadProducts();
    }
    @override void dispose() 
    {
        _scrollController.dispose();
        super.dispose();
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

                                    return _AssortmentUiProductCard( product );
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
        setState( ()
        {
            _products.clear();

            _offset = 0;
            _hasMoreProducts = true;
        });
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

                _offset += products.length;
                _hasMoreProducts = products.length == _limit;
            });
        } 
        catch( error ) 
        {
            log( "$error" );
        }
    }
    void _onScroll() 
    {
        if( _isBottom && _hasMoreProducts ) 
        {
            _loadProducts();
        }
    }
}
class _AssortmentUiProductCard extends StatelessWidget 
{
    final AssortmentProduct product;

    const _AssortmentUiProductCard( this.product );
    
    @override Widget build( BuildContext buildContext ) 
    {
        return Card
        (
            clipBehavior: Clip.antiAlias,
            child: GestureDetector
            (
                onTap: () 
                {
                    Navigator.push
                    (
                        buildContext,
                        MaterialPageRoute( builder: (context)=> _AssortmentUiProductScreen( product ) ),
                    );
                },
                child: Column
                (
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: 
                    [
                        Expanded
                        (
                            child: Hero
                            (
                                tag: "product-${product.id}",
                                child: Image.network
                                (
                                    product.thumbnail,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace)=> const Icon( Icons.image_not_supported_outlined ),
                                    loadingBuilder: (context, child, loadingProgress) 
                                    {
                                        if( loadingProgress == null ) 
                                        {
                                            return child;
                                        }

                                        return const Center( child: CircularProgressIndicator() );
                                    }
                                )
                            )
                        ),
                        Padding
                        (
                            padding: AssortmentUi.kCollapsedPadding,
                            child: Text
                            (
                                product.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AssortmentUi.kBodyTextStyle
                            )
                        ),
                        Row
                        (
                            children: 
                            [
                                Padding
                                (
                                    padding: AssortmentUi.kCollapsedPadding,
                                    child: Text
                                    (
                                        'RM ${product.price.toStringAsFixed( 2 )}',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AssortmentUi.kBodyTextStyle.copyWith( color: const Color.fromARGB(255, 44, 138, 49) )
                                    )
                                ),
                                Padding
                                (
                                    padding: AssortmentUi.kCollapsedPadding,
                                    child: Row
                                    (
                                        mainAxisSize: MainAxisSize.min,
                                        children:
                                        [
                                            const Icon
                                            (
                                                Icons.star_rounded,
                                                color: Colors.amber,
                                                size: 20
                                            ),
                                            AssortmentUi.kHorizontalSpacingExtraSmall,
                                            Text
                                            (
                                                product.rating.toStringAsFixed( 1 ),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: AssortmentUi.kBodyTextStyle
                                            )
                                        ]
                                    )
                                )
                            ]
                        )
                    ]
                )
            )
        );
    }
}
class _AssortmentUiProductScreen extends StatefulWidget
{
    final AssortmentProduct product;

    const _AssortmentUiProductScreen( this.product );

    @override State<_AssortmentUiProductScreen> createState()=> _AssortmentUiProductScreenState();
}
class _AssortmentUiProductScreenState extends State<_AssortmentUiProductScreen>
{
    int _currentImageIndex = 0;

    List<String> get _imageUrls=> widget.product.images.isNotEmpty ? widget.product.images : [ widget.product.thumbnail ];
    @override Widget build( BuildContext context ) 
    {
        final hasDiscount = widget.product.discountPercentage > 0;

        return Scaffold
        (
            appBar: AppBar( title: const Text( "Product details" ) ),
            body: SingleChildScrollView
            (
                child: Column
                (
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children:
                    [
                        Hero
                        (
                            tag: "product-${widget.product.id}",
                            child: AspectRatio
                            (
                                aspectRatio: 1.2,
                                child: ColoredBox
                                (
                                    color: Theme.of( context ).colorScheme.surfaceContainerLowest,
                                    child: Stack
                                    (
                                        fit: StackFit.expand,
                                        children:
                                        [
                                            PageView.builder
                                            (
                                                itemCount: _imageUrls.length,
                                                onPageChanged: (index)
                                                {
                                                    setState( ()=> _currentImageIndex = index );
                                                },
                                                itemBuilder: (context, index)=> Image.network
                                                (
                                                    _imageUrls[index],
                                                    fit: BoxFit.contain,
                                                    errorBuilder: (context, error, stackTrace)=> const Icon
                                                    (
                                                        Icons.image_not_supported_outlined,
                                                        size: 64
                                                    ),
                                                    loadingBuilder: (context, child, loadingProgress)
                                                    {
                                                        if( loadingProgress == null )
                                                        {
                                                            return child;
                                                        }

                                                        return const Center( child: CircularProgressIndicator() );
                                                    }
                                                )
                                            ),
                                            if( _imageUrls.length > 1 ) Positioned
                                            (
                                                right: 12,
                                                bottom: 12,
                                                child: Container
                                                (
                                                    padding: const EdgeInsets.symmetric
                                                    (
                                                        horizontal: 10,
                                                        vertical: 5
                                                    ),
                                                    decoration: BoxDecoration
                                                    (
                                                        color: Colors.black54,
                                                        borderRadius: BorderRadius.circular( 13 )
                                                    ),
                                                    child: Text
                                                    (
                                                        "${_currentImageIndex + 1}/${_imageUrls.length}",
                                                        style: const TextStyle( color: Colors.white, fontSize: 8 )
                                                    )
                                                )
                                            )
                                        ]
                                    )
                                )
                            )
                        ),
                        Padding
                        (
                            padding: AssortmentUi.kPadding,
                            child: Column
                            (
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children:
                                [
                                    Text
                                    (
                                        widget.product.title,
                                        style: Theme.of( context ).textTheme.headlineSmall?.copyWith
                                        (
                                            fontWeight: FontWeight.bold
                                        )
                                    ),
                                    AssortmentUi.kVerticalSpacingSmall,
                                    Wrap
                                    (
                                        spacing: 8,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children:
                                        [
                                            Text
                                            (
                                                "RM ${widget.product.price.toStringAsFixed( 2 )}",
                                                style: Theme.of( context ).textTheme.headlineSmall?.copyWith
                                                (
                                                    color: hasDiscount ? Theme.of( context ).colorScheme.onSurfaceVariant : Colors.green[700],
                                                    decoration: hasDiscount ? TextDecoration.lineThrough : null,
                                                    fontWeight: hasDiscount ? FontWeight.normal : FontWeight.bold
                                                )
                                            ),
                                            if( hasDiscount ) Text
                                            (
                                                "RM ${widget.product.discountedPrice.toStringAsFixed( 2 )}",
                                                style: Theme.of( context ).textTheme.headlineSmall?.copyWith
                                                (
                                                    color: Colors.green[700],
                                                    fontWeight: FontWeight.bold
                                                )
                                            )
                                        ]
                                    ),
                                    AssortmentUi.kVerticalSpacingMedium,
                                    Wrap
                                    (
                                        spacing: 8,
                                        runSpacing: 8,
                                        children:
                                        [
                                            Chip
                                            (
                                                avatar: const Icon
                                                (
                                                    Icons.star_rounded,
                                                    color: Colors.amber,
                                                    size: 20
                                                ),
                                                label: Text( widget.product.rating.toStringAsFixed( 1 ) )
                                            ),
                                            Chip
                                            (
                                                avatar: const Icon( Icons.inventory_2_outlined, size: 18 ),
                                                label: Text( widget.product.availabilityStatus )
                                            ),
                                            if( widget.product.discountPercentage > 0 ) Chip
                                            (
                                                avatar: const Icon( Icons.local_offer_outlined, size: 18 ),
                                                label: Text
                                                (
                                                    "${widget.product.discountPercentage.toStringAsFixed( 1 )}% off"
                                                )
                                            )
                                        ]
                                    ),
                                    AssortmentUi.kVerticalSpacingExtraLarge,
                                    const Text
                                    (
                                        "Description",
                                        style: AssortmentUi.kHeaderTextStyle
                                    ),
                                    AssortmentUi.kVerticalSpacingSmall,
                                    Text
                                    (
                                        widget.product.description,
                                        style: Theme.of( context ).textTheme.bodyLarge
                                    ),
                                    AssortmentUi.kVerticalSpacingExtraLarge,
                                    const Divider(),
                                    AssortmentUi.kVerticalSpacingSmall,
                                    const Text
                                    (
                                        "Product information",
                                        style: AssortmentUi.kHeaderTextStyle
                                    ),
                                    AssortmentUi.kVerticalSpacingSmall,
                                    if( widget.product.brand.isNotEmpty ) _AssortmentUiProductScreenRow
                                    (
                                        Icons.storefront_outlined,
                                        "Brand",
                                        widget.product.brand
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.category_outlined,
                                        "Category",
                                        widget.product.category.str
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.qr_code_2,
                                        "SKU",
                                        widget.product.sku
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.inventory_outlined,
                                        "Stock",
                                        "${widget.product.stock} available"
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.straighten,
                                        "Dimensions",
                                        widget.product.dimension.toString()
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.monitor_weight_outlined,
                                        "Weight",
                                        widget.product.weight.toStringAsFixed( 1 )
                                    ),
                                    AssortmentUi.kVerticalSpacingLarge,
                                    const Text
                                    (
                                        "Delivery and support",
                                        style: AssortmentUi.kHeaderTextStyle
                                    ),
                                    AssortmentUi.kVerticalSpacingSmall,
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.local_shipping_outlined,
                                        "Shipping",
                                        widget.product.shippingInfo
                                    ),
                                    _AssortmentUiProductScreenRow
                                    (
                                        Icons.verified_user_outlined,
                                        "Warranty",
                                        widget.product.warrantyInfo
                                    ),
                                    if( widget.product.tags.isNotEmpty ) ...
                                    [
                                        AssortmentUi.kVerticalSpacingLarge,
                                        Wrap
                                        (
                                            spacing: 8,
                                            runSpacing: 8,
                                            children: widget.product.tags.map
                                            (
                                                (tag)=> Chip( label: Text( tag ) )
                                            ).toList()
                                        )
                                    ]
                                ]
                            )
                        )
                    ]
                )
            )
        );
    }
}
class _AssortmentUiProductScreenRow extends StatelessWidget
{
    final IconData icon;
    final String label;
    final String value;

    const _AssortmentUiProductScreenRow( this.icon, this.label, this.value );

    @override Widget build( BuildContext context ) 
    {
        return Padding
        (
            padding: const EdgeInsets.symmetric( vertical: 8 ),
            child: Row
            (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:
                [
                    Icon( icon, size: 18 ),
                    AssortmentUi.kHorizontalSpacingLarge,
                    Expanded
                    (
                        child: Column
                        (
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children:
                            [
                                Text
                                (
                                    label,
                                    style: Theme.of( context ).textTheme.labelMedium
                                ),
                                AssortmentUi.kVerticalSpacingExtraSmall,
                                Text
                                (
                                    value,
                                    style: Theme.of( context ).textTheme.bodyLarge
                                )
                            ]
                        )
                    )
                ]
            )
        );
    }
}