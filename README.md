Workarea Browse Option
================================================================================

A Workarea Commerce plugin that enables the display of products by their various options (e.g. color) when browsing them in the Storefront.


Overview
--------------------------------------------------------------------------------

* Allows each product to be "broken out" into multiple representations when browsing in the Storefront, based on a particular product option, such as color
* Allows admins to choose which products "browse by option" and to choose the specific option for each product
* Allows admins to choose a particular representation of the product (e.g. the blue one) when featuring it within a category or search results
* Prevents representations of the same product from appearing in collections of related products (e.g. upsells)

Getting Started
--------------------------------------------------------------------------------

Add the gem to your application's Gemfile:

```ruby
# ...
gem 'workarea-browse_option'
# ...
```

Update your application's bundle.

```bash
cd path/to/application
bundle
```

Features
--------------------------------------------------------------------------------


### Administration of Browse Options

* When editing a product in the Admin (or bulk editing many), an administrator can choose a "browses by" option for that product
* The UI for choosing this option is a select menu, which is populated with the keys of the details for all of the product's variants
* When a value is selected for the browse option, the product is said to "browse by option" and is represented differently in Elasticsearch (see below)
* Each product's attributes card in the Admin displays its browse option (if any)


### Search Indexing & Browsing

* Products that browse by option are stored as multiple documents (one per value of the selected option) within each Storefront search index
* Each option-specific search document is built from only those variants of the product that match the particular option value (e.g. blue for color)
* When browsing (e.g. search results and category listings), such products potentially appear in results multiple times (up to once per search document in that index)
* Each representation of a product uses a relevant product image (if available), such as a blue image for the blue representation of the product
* Clicking through any of the product's browse results takes the customer to the same product details (from Mongo)


### State/Caching in the Storefront

* If a product browses by option, the particular option value is persisted through the `:option` param when clicking through to the product's details
* When a product browses by option and the `:option` param is set, the specific option value is used in the product's cache key, affecting show, summary, and pricing view caches

Workarea Commerce Documentation
--------------------------------------------------------------------------------

See [https://developer.workarea.com](https://developer.workarea.com) for Workarea Commerce documentation.

License
--------------------------------------------------------------------------------

Workarea Browse Option is released under the [Business Software License](LICENSE)
