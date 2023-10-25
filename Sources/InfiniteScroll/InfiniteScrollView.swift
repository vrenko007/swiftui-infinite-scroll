/// InfiniteScrollView.swift
///
/// This file contains the InfiniteScrollView struct, which is a SwiftUI View that provides an infinite scrolling list.
/// The list is populated with data of type T, which must conform to the Identifiable and Hashable protocols.
/// The list is divided into groups, each represented by a GroupView, and each item within a group is represented by an ItemView.
/// The InfiniteScrollView uses an InfiniteScrollViewModel to manage the loading and presentation of data.
///
/// The InfiniteScrollView also provides two public extensions for creating grouped and ungrouped lists.
/// The grouped list uses a custom GroupView, while the ungrouped list uses a ForEach view as the GroupView.
///
/// The InfiniteScrollView handles different states of data loading, including initial loading, loading of additional pages, and error states.
/// It provides a default UI for these states, but these can be customized as needed.

import SwiftUI
import IdentifiedCollections

public struct InfiniteScrollView<
  T: Identifiable & Hashable,
  GroupView: View,
  ItemView: View
>: View {
  @StateObject var model: InfiniteScrollViewModel<T>

  var groupView: (IdentifiedArrayOf<T>, @escaping (T) -> InfiniteScrollGroupContent<T, ItemView>) -> GroupView
  var itemView: (T) -> ItemView

  public init(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) async throws -> (items: [T], next: PageInfo),
    groupView: @escaping (IdentifiedArrayOf<T>, @escaping (T) -> InfiniteScrollGroupContent<T, ItemView>) -> GroupView,
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
              InfiniteScrollGroupContent(item: item, itemView: itemView, loadMore: model.onItemAppear)
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
  /// This function groups the items in the infinite scroll view.
  /// - Parameters:
  ///   - pageInfo: The information about the page. Default is `PageInfo.default`.
  ///   - loadPage: A closure that loads the page. It returns a tuple containing the items and the next page info.
  ///   - groupView: A closure that groups the items in the view. It takes an array of identified items and a closure that returns the content of the infinite scroll group.
  ///   - itemView: A closure that returns the item view.
  /// - Returns: An instance of `InfiniteScrollView`.
  static func groupped(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) -> (items: [T], next: PageInfo),
    groupView: @escaping (IdentifiedArrayOf<T>, @escaping (T) -> InfiniteScrollGroupContent<T, ItemView>) -> GroupView,
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

public extension InfiniteScrollView where GroupView == ForEach<[T], T.ID, InfiniteScrollGroupContent<T, ItemView>> {
  /// This function creates an instance of InfiniteScrollView with the provided parameters.
  /// - Parameters:
  ///   - pageInfo: The information about the page. Default value is PageInfo.default.
  ///   - loadPage: A closure that loads the page asynchronously. It throws an error if the loading fails.
  ///   - itemView: A closure that returns the view for each item.
  /// - Returns: An instance of InfiniteScrollView.
  static func ungroupped(
    pageInfo: PageInfo = PageInfo.default,
    loadPage: @Sendable @escaping (PageInfo) async throws -> (items: [T], next: PageInfo),
    itemView: @escaping (T) -> ItemView
  ) -> InfiniteScrollView {
    InfiniteScrollView(
      pageInfo: pageInfo,
      loadPage: loadPage,
      groupView: { ungrupped, itemView in
        ForEach(ungrupped.elements) { item in
          itemView(item)
        }
      },
      itemView: itemView
    )
  }
}
