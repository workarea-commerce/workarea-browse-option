Workarea Browse Option 2.1.8 (2019-10-30)
--------------------------------------------------------------------------------

*   Update cache_key.decorator

    Base on what I'm reading here: https://github.com/workarea-commerce/workarea-browse-option/blob/master/app/models/workarea/search/storefront/product_option.rb

    and some experimentation in a shell:
    ```
    irb(main):021:0> p.options['option']
    => "Dusty Blue"
    irb(main):022:0> p.browse
    p.browse_link_options   p.browse_option         p.browse_options        p.browse_swatch_option  p.browser_title
    irb(main):022:0> p.browse_option
    => "color"
    irb(main):023:0> p.options[p.browse_option]
    => nil
    ```

    This looks like it needs to be updated
    Jesse McPherson



Workarea Browse Option 2.1.7 (2019-10-01)
--------------------------------------------------------------------------------

*   try to fix build

    Tom Scott

*   Fix Deleted Featured Products

    Prevent an error in admin when browsing a category with a featured
    product that has since been deleted. Ensure that no `nil` records are
    returned by the `#featured_products` method in the view model(s).

    Fixes #1
    Tom Scott



Workarea Browse Option 2.1.6 (2019-08-21)
--------------------------------------------------------------------------------

*   Open Source!



Workarea Browse Option 2.1.5 (2019-08-06)
--------------------------------------------------------------------------------

*   Omit Optionless Images From Primary Image Lookup

    When looking up a primary image based on the browse option, omit any
    images that have no option set. This prevents an error where
    `.optionize` gets called on a `nil` object.

    Discovered by **Ryan Tulino** of Syatt. Thanks Ryan!

    WLBBOPTION-33
    Tom Scott



Workarea Browse Option 2.1.4 (2019-07-23)
--------------------------------------------------------------------------------

*   Fix Inconsistency When Products Are Packaged

    Products that browse by option can be packaged into `package` or
    `family` products, which query for a set of product IDs. These are not
    necessarily the same IDs that you would get out of MongoDB, in the
    browse-by-option world, they include the option for which you are
    indexing in search. Because of this, browse option products which are
    part of a larger package product are not visible in some areas of the
    storefront and admin. This has now been fixed by redefining the
    `#packaged_products` method to query for the base ID of each product in
    Mongo, and then fill in the correct option based on the product's
    `browse_option` value. While this won't enforce that option in the
    package or family product, it will pre-select the option on the
    storefront so that it will display properly and consistently with what
    the admin picked out when creating the product.

    WLBBOPTION-30
    Tom Scott

*   Bulk Delete Product Options Before Reindexing

    Revert to the bulk action instead of using delete_by_query to avert
    performance problems when used on a large scale.

    WLBBOPTION-32
    Tom Scott

*   Fix Faceting of Product Options

    When browse-by-option products are indexed, a lot of data was previously
    lost due to the way each variant details hash was merged with another.
    The arrays that make up each detail did not concatenate the way one might
    expect when merging hashes together, so the `#variant_facets` method has
    been updated to iterate over each variant's details hash and safely
    combine all fields into an Array of values. This successfully groups
    together the facets for a particular browse-option, so for example, a
    product with multiple sizes assigned to the same color will have all of
    those sizes indexed as facet values in search.

    WLBBOPTION-29
    Tom Scott

*   Use latest released Workarea version

    Tom Scott



Workarea Browse Option 2.1.3 (2019-05-28)
--------------------------------------------------------------------------------

*   Use Browse Option IDs in Categorizations

    When browse option products are manually categorized from the product
    page, it is assumed that all options of the product should be featured
    in the category. Workarea now decorates the
    `Admin::CategorizationsController` to iterate over all browse option IDs
    and add them to the category's featured products instead of the ID of
    the main product, which may not actually exist in the index.

    WLBBOPTION-24
    Tom Scott

*   Fix Removing Featured Browse Option Products

    Featured Browse Option Products appeared to not remove properly because
    their response was rendering back the first option rather than the one
    that was selected. As a result, the products stayed in featured product
    IDs, but we still showed a message indicating they had been removed.
    The view model used to render the product back once it's been
    added/removed from featured products has been changed to
    `Admin::FeaturedBrowseOptionProductViewModel`, and the controller passes
    in the current product's browse option if it is configured to browse by
    option.

    WLBBOPTION-24
    Tom Scott



Workarea Browse Option 2.1.2 (2019-04-02)
--------------------------------------------------------------------------------

*   Handle indexing changes to categories with browse option product ids

    WLBBOPTION-28
    Matt Duffy

*   Update for workarea v3.4 compatibility

    WLBBOPTION-27
    Matt Duffy



Workarea Browse Option 2.1.1 (2019-01-22)
--------------------------------------------------------------------------------

*   Improve readme

    WLBBOPTION-26
    ECOMMERCE-6523
    Chris Cressman



Workarea Browse Option 2.1.0 (2018-10-16)
--------------------------------------------------------------------------------

*   Allow each occurance of browse option product to be featured separately

    WLBBOPTION-23
    Matt Duffy



Workarea Browse Option 2.0.0 (2018-05-24)
--------------------------------------------------------------------------------

*   Update tests to work with bulk action changes

    WLBBOPTION-21
    Matt Duffy

*   Leverage Workarea Changelog task

    ECOMMERCE-5355
    Curt Howard

*   Fix search results upper limit when bulk-indexing

    When bulk-indexing products, set the `:size` option to the total amount
    of entries in the index, not to the total amount of products. This is
    because browse_option products typically have an entry per variant, and
    thus there are more results than allowed back using the Elasticsearch
    query. We're now finding the total amount of entries in the index for
    these products and setting the `:size` param to that instead.

    WLBBOPTION-20
    Tom Scott

*   Account for SKUs with spaces in them

    When SKUs have spaces in them, some of our queries that split lists of
    product IDs on a space character (for deleting and reindexing each
    browse-option for a single parent product) don't behave very well.
    Instead of making a bare query with each ID separated by a space, run a
    `terms` query for the collection of `catalog_ids` as an Array. This
    ensures that each `catalog_id` is treated in isolation.

    WLBBOPTION-19
    Tom Scott

*   Correct recommended product IDs

    Product IDs coming through for recommendations were not correct, because
    they were using the base product ID without each variant's browse option
    value, due to the wrong search model being used in the
    `Search::RelatedProducts` query. Map over all products as well as their
    options using the `ProductOption` search model if the product is browsed
    by option.

    WLBBOPTION-18
    Tom Scott

*   Fixes for headless Chrome

    Ben Crouse



Workarea Browse by Option 1.2.5 (2018-02-20)
--------------------------------------------------------------------------------

*   Find image for browse option products in search

    The search model for browse-by-option products didn't include an
    override for `#primary_image` that finds the correct image by its
    option. If an image cannot be found, the product's original
    `primary_image` is used as a default.

    WLBBOPTION-10
    Tom Scott


Workarea Browse by Option 1.2.4 (2018-01-09)
--------------------------------------------------------------------------------

*   Rework id escaping for product indexing for compatibility with workarea v3.2

    WLBBOPTION-17
    Matt Duffy


Workarea Browse by Option 1.2.3 (2017-11-14)
--------------------------------------------------------------------------------

*   Add regex to escape irregular product ids during reindexing

    WLBBOPTION-15
    Matt Duffy

*   Add regex to escape irregular product ids during reindexing

    WLBBOPTION-15
    Matt Duffy


Workarea Browse by Option 1.2.2 (2017-10-31)
--------------------------------------------------------------------------------

*   Move configuration into initializers

    WLBBOPTION-16
    Matt Duffy


Workarea Browse by Option 1.2.1 (2017-09-26)
--------------------------------------------------------------------------------

*   Don't show browse by option product if all variants are inactive

    WLBBOPTION-12
    Brian Berg


Workarea Browse by Option 1.2.0 (2017-09-22)
--------------------------------------------------------------------------------

*   Update for compatibility with workarea v3.1

    WLBBOPTION-11
    Matt Duffy

    
Workarea Browse by Option 1.1.2 (2017-09-26)
--------------------------------------------------------------------------------

*   Don't show browse by option product if all variants are inactive

    WLBBOPTION-12
    Brian Berg


Workarea Browse by Option 1.1.1 (2017-09-22)
--------------------------------------------------------------------------------

*   Fix workarea dependency to < 3.1.0

    WLBBOPTION-13
    Curt Howard


Workarea Browse by Option 1.1.0 (2017-09-15)
--------------------------------------------------------------------------------

*   Handle products that do not have browse option set

    WLBBOPTION-9
    Matt Duffy

*   Add partial to render browse option field for storefront api products

    WLBBOPTION-9
    Matt Duffy


Workarea Browse by Option 1.0.0 (2017-05-17)
--------------------------------------------------------------------------------

*   Ensure selecting no browse option on product bulk editing clears the field

    WLBBOPTION-7
    Matt Duffy

*   Fix param value of browse option for bulk action product edit, add test

    WLBBOPTION-7
    Matt Duffy

*   Fix issues with bulk editing browse options

    WLBBOPTION-7
    Matt Duffy

*   Update for compatibility with workarea 3

    WLBBOPTION-5
    Matt Duffy
