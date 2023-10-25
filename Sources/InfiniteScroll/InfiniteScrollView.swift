import SwiftUI

public struct InfiniteScrollView<
  T: Identifiable & Hashable,
  GroupView: View,
  ItemView: View
>: View {


  var pageInfo: PageInfo
  let loadPage: @Sendable (PageInfo) -> (items: [T], next: PageInfo)
  let groupView: ([T], @escaping (T) -> ItemView) -> GroupView
  let itemView: (T) -> ItemView

  public init(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) -> (items: [T], next: PageInfo),
    groupView: @escaping ([T], @escaping (T) -> ItemView) -> GroupView,
    itemView: @escaping (T) -> ItemView
  ) {
    self.groupView = groupView
    self.itemView = itemView
    self.pageInfo = pageInfo
    self.loadPage = loadPage
  }

  public var body: some View {
    Text("Infinite Scroll View")
  }
}

public extension InfiniteScrollView {
  static func groupped(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) -> (items: [T], next: PageInfo),
    groupView: @escaping ([T], @escaping (T) -> ItemView) -> GroupView,
    itemView: @escaping (T) -> ItemView
  ) -> InfiniteScrollView {
    InfiniteScrollView(
      pageInfo: pageInfo,
      loadPage: loadPage,
      groupView: groupView,
      itemView: itemView
    )
  }
}

public extension InfiniteScrollView where GroupView == ForEach<[T], T.ID, ItemView> {
  static func ungroupped(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) -> (items: [T], next: PageInfo),
    itemView: @escaping (T) -> ItemView
  ) -> InfiniteScrollView {
    InfiniteScrollView(
      pageInfo: pageInfo,
      loadPage: loadPage,
      groupView: { ungrupped, itemView in
        ForEach(ungrupped) { item in
          itemView(item)
        }
      },
      itemView: itemView
    )
  }
}
