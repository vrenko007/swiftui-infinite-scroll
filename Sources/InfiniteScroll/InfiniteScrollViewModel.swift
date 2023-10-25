//
//  InfiniteScrollViewModel.swift
//
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import Foundation
import IdentifiedCollections

public class InfiniteScrollViewModel<T: Hashable & Identifiable>: ObservableObject {
  @Published private(set) var items: IdentifiedArrayOf<T> = []
  @Published private(set) var state = PagingState.loadingFirstPage
  @Published var loadPage: @Sendable (PageInfo) async throws -> (items: [T], next: PageInfo)
  private let treshold: Int = 2
  private(set) var pageInfo: PageInfo

  public init(
    pageInfo: PageInfo = .default,
    loadPage: @escaping @Sendable (PageInfo) async throws -> (items: [T], next: PageInfo)
  ) {
    self.loadPage = loadPage
    self.pageInfo = pageInfo
  }

  private var currentTask: Task<Void, Never>? {
    willSet {
      if let task = currentTask {
        if task.isCancelled { return }
        task.cancel()
        // Setting a new task cancelling the current task
      }
    }
  }

  private var canLoadMorePages: Bool { pageInfo.hasNextPage }

  public func firstLoad() {
    state = .loadingFirstPage
    currentTask = Task {
      await loadMoreItems()
    }
  }

  public func reloadMore() {
    // (1) loadMore: No more pages
    if !canLoadMorePages {
      return
    }

    // (2) loadMore: not in error state
    if state != .moreError {
      return
    }

    // (3) loadMore: Load next page
    state = .loadingNextPage
    currentTask = Task {
      await loadMoreItems()
    }
  }

  public func onItemAppear(_ modelId: T.ID) {
    // (1) appeared: No more pages
    if !canLoadMorePages {
      return
    }

    // (2) appeared: Already loading
    if state == .loadingNextPage || state == .loadingFirstPage {
      return
    }

    // (3) No index
    guard let index = items.index(id: modelId) else {
      return
    }

    // (4) appeared: Threshold not reached
    let tresholdIndex = pageInfo.offset - treshold
    if index < tresholdIndex {
      return
    }

    // (5) appeared: Load next page
    state = .loadingNextPage
    currentTask = Task {
      await loadMoreItems()
    }
  }

  func loadMoreItems() async {
    do {
      // (1) Ask the source for a page
      let rsp = try await loadPage(pageInfo)

      // (2) Task has been cancelled
      if Task.isCancelled { return }

      // (3) Set the items as the initial set if we are loading the first page else append to the existing set of items
      let models = IdentifiedArray(uniqueElements: rsp.items)
      let allItems = state == .loadingFirstPage ? models : items + models

      pageInfo = rsp.next

      // (4) Publish our changes to SwiftUI by setting our items and state
      await MainActor.run { [weak self] in
        guard let self = self else { return }

        if allItems.isEmpty {
          self.state = .empty
          return
        }

        self.state = .loaded
        self.items = allItems
      }
    } catch {
      // (5) Publish our error to SwiftUI
      await MainActor.run { [weak self] in
        guard let self = self else { return }
        if self.state == .loadingFirstPage {
          self.state = .error(error: error)
        } else {
          self.state = .moreError
        }
      }
    }
  }
}
