import SwiftUI
import IdentifiedCollections

public struct InfiniteScrollView<
  T: Identifiable & Hashable,
  GroupView: View,
  ItemView: View
>: View {
  public typealias Content = any View

  @StateObject var model: InfiniteScrollViewModel<T>

  var groupView: (IdentifiedArrayOf<T>, @escaping (T) -> Content) -> GroupView
  var itemView: (T) -> ItemView

  public init(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) async throws -> (items: [T], next: PageInfo),
    groupView: @escaping (IdentifiedArrayOf<T>, @escaping (T) -> Content) -> GroupView,
    itemView: @escaping (T) -> ItemView
  ) {
    self.groupView = groupView
    self.itemView = itemView
    self._model = StateObject(
      wrappedValue: InfiniteScrollViewModel(
        pageInfo: pageInfo,
        loadPage: loadPage
      )
    )
  }

  @ViewBuilder
  public var body: some View {
    VStack {
      switch model.state {
      case .loadingFirstPage:
        Text("Loading")
      case let .error(error: error):
        Text("Error: \(error.localizedDescription)")
      case .empty:
        Text("EmptyView")
      default:
        ScrollView {
          LazyVStack {
            groupView(model.items) { item in
              itemView(item)
                .onAppear {
                  model.onItemAppear(item.id)
                }
            }
            if model.state == .loadingNextPage {
              ProgressView()
            }
            if model.state == .moreError {
              Text("MoreError")
              Button("retry") {
                model.reloadMore()
              }
            }
          }
        }
      }
    }.onFirstAppear {
      model.firstLoad()
    }
  }
}

public extension InfiniteScrollView {
  static func groupped(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) -> (items: [T], next: PageInfo),
    groupView: @escaping (IdentifiedArrayOf<T>, @escaping (T) -> Content) -> GroupView,
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
    loadPage: @Sendable @escaping (PageInfo) async throws -> (items: [T], next: PageInfo),
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
