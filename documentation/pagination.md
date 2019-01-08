# Pagination & Filtering

This documentation describes how to retrieve paginated filtrable collections using the SDK.

## Parameters

When a collection you want to retrieve is paginated, you will need to instantiate a generic `PaginatedListParams<T>` object that contains the pagination, sorting and filtering informations.

A helper initializer is provided for the supported models so you can instantiate the params like so (example for `Transaction`):

```swift
Transaction.paginatedListParams(page: 1,
                                perPage: 20,
                                sortBy: .id,
                                sortDirection: .ascending)
)
```

Where:
- `page` is the page you wish to receive.
- `perPage` is the number of results per page.
- `sortBy` is the sorting field. Available values depend on the requested object.
- `sortDir` is the sorting direction. Available values: `.ascending`, `.descending`

Optionally you can add a `filters` params which provides customizable way to filter the results.

## Filters

Read full specifications [in our advanced filtering guide](https://github.com/omisego/ewallet/blob/master/docs/guides/advanced_filtering.md)

### Basic filtering

In order to filter a collection, you will need to instantiate a `FilterParams<F>` object that contains 2 optionals parameters: `matchAll` and `matchAny` that are an array of `Filter<F>` objects.

A `Filter<F>` contains a `field` to filter, a `comparator` and a `value`.

The `field` depends on the collection to filter and a list of simple supported fields is available directly in the SDK.

The `comparator` is an enum with defined values depending on the type of the `value` (`Bool`, `Int` or `String`)

For example a `Bool` value can only use the `equal` and `notEqual` comparators, but a `String` value can use `equal`, `contains` or `startsWith` comparators.

A helper initializer is provided for the supported models so you can instantiate a `Filter<F>` like so (example for `Transaction`):

```swift
let filter = Transaction.filter(field: .errorDescription,
                                comparator: .equal,
                                value: "some error")
```

You can then combine these filters into the `matchAll` or `matchAny` params of the `FilterParams<F>` object to filter the results:

```swift
let errorFilter = Transaction.filter(field: .errorDescription,
                                     comparator: .equal,
                                     value: "some error")
let idFilter = Transaction.filter(field: .id,
                                  comparator: .startsWith,
                                  value: "txn_01")
let filters = FilterParams(matchAny: [errorFilter, idFilter])
```

This example will filter transactions with an `errorDescription` matching `some error` OR an `id` starting with `txn_01`.

The `FilterParams<F>` can then be included when initializing the `PaginatedListParams<T>`, for example:

```swift
Transaction.paginatedListParams(page: 1,
                                perPage: 20,
                                filters: filters,
                                sortBy: .id,
                                sortDirection: .ascending)
```

### Advanced relation filtering

In addition to the provided `fields` you can perform more advanced field filtering on child objects by providing a path of relations separated with a `.`.

For example you can create a filter for a transaction `fromToken` `symbol` like so:

```swift
let filter = Transaction.filter(field: "from_token.symbol",
                                comparator: .equal,
                                value: "OMG")
```

This will filter transactions that have a sender token symbol equal to OMG.

Note however that the `field` path attributes are snake cased as they match the JSON response object.

## Response

A query to a paginated collection returns the usual `Response<Data>` enum where, in case of success, the Data will be a `JSONPaginatedListResponse<T>` object which contains:

- `data`: an array of the requested object
- `pagination`: a `Pagination` object with the following attributes

  Where:
  - `perPage` is the number of results per page.
  - `currentPage` is the retrieved page.
  - `isFirstPage` is a bool indicating if the page received is the first page
  - `isLastPage` is a bool indicating if the page received is the last page
