//
//  PagingState.swift
//
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import Foundation

enum PagingState: Equatable {
  case loadingFirstPage
  case loaded
  case loadingNextPage
  case empty
  case moreError
  case error(error: Error)

  static func == (lhs: PagingState, rhs: PagingState) -> Bool {
    switch (lhs, rhs) {
    case
      (.loadingFirstPage, .loadingFirstPage),
      (.loadingNextPage, .loadingNextPage),
      (.moreError, .moreError),
      (.loaded, .loaded),
      (.empty, .empty):
      return true
    case let (.error(lhsE), .error(rhsE)):
      return lhsE.localizedDescription == rhsE.localizedDescription
    default:
      return false
    }
  }
}
