# Pagination & Filtering

This documentation describes how to retrieve paginated filtrable collections using the SDK.

## Parameters

When a collection you want to retrieve is paginated, you will need to instantiate a generic `PaginatedListParams<T>` object that contains the pagination query informations as well as the sort and search parameters.

For example, to retrieve a list of transactions, you can instantiate the params like so:

```swift
let paginationParams = PaginatedListParams<Transaction>(
    page: 1,
    perPage: 10,
    sortBy: .createdAt,
    sortDirection: .descending
)
```

Where:
- `page` is the page you wish to receive.
- `perPage` is the number of results per page.
- `sortBy` is the sorting field. Available values depend on the requested object.
- `sortDir` is the sorting direction. Available values: `.ascending`, `.descending`

And optionally you can add an exclusive `searchTerm` or `searchTerms`:

- `searchTerm` is a term to search for in ALL of the searchable fields. Conflict with search_terms, only use one of them.
- `searchTerms` is a dictionary of fields to search in.

For example:

```swift
let paginationParams = PaginatedListParams<Transaction>(
    page: 1,
    perPage: 10,
    searchTerms: [.from: "someAddress"],
    sortBy: .createdAt,
    sortDirection: .descending
)
```

## Response

A query to a paginated collection returns the usual `Response<Data>` enum where, in case of success, the Data will be a `JSONPaginatedListResponse<T>` object which contains:

- `data`: an array of the requested object
- `pagination`: a `Pagination` object with the following attributes

  Where:
  - `perPage` is the number of results per page.
  - `currentPage` is the retrieved page.
  - `isFirstPage` is a bool indicating if the page received is the first page
  - `isLastPage` is a bool indicating if the page received is the last page
