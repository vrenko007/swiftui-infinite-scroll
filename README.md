# SwiftUI Infinite Scroll View
A library of SwiftUIView that handles infinite scrool pagination.

## Motivation
In the modern world where data is abundant,
displaying large lists of information in a mobile application can be a challenge.
Traditional methods of loading all data at once can result in performance issues,
leading to a poor user experience. 

Additionally, many applications require similar functionality in displaying long lists,
leading to repeated boilerplate code.
This has an impact on the efficiency of the development process,
as well as the maintainability of the codebase.

To address these issues, we decided to create a modular infinite scroll view.
The main motivation behind this project is to provide a reusable,
efficient and user-friendly way to handle large sets of data.
By making this a modular component, we hope to streamline the development process,
reduce code duplication, and ultimately improve performance and usability for end users.

## Usage

1. Add library via SPM

2. Using the `InfiniteScrollView` library is simple and straightforward. We support two ways of implementing the infinite scroll view:
- **Ungroupped**
```swift
InfiniteScrollView.ungroupped(
  pageInfo: PageInfo(hasNextPage: true, limit: 1, offset: 0)
) { pageInfo in
  // Fetch Data
  return (
    items: //page data,
    next: PageInfo.next(from: pageInfo, hasNextPage: true) //Next Page
  )
} itemView: { item in
  // Item View
}
```

- **Groupped**
```swift
InfiniteScrollView.groupped(
  pageInfo: PageInfo(hasNextPage: true, limit: 1, offset: 0)
) { pageInfo in
  // Fetch Data
  return (
    items: //page data,
    next: PageInfo.next(from: pageInfo, hasNextPage: true) //Next Page
  )
} groupView: { ungroupped, itemView in
  // Group Data and construct Section View
} itemView: { item in
  // Item View
}
```

## License

All modules are released under the MIT license. See [LICENSE](LICENSE) for details.
