//
//  PageInfo.swift
//
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import Foundation

public struct PageInfo: Equatable, Codable {
  public let hasNextPage: Bool
  public let limit: Int
  public let offset: Int
  public static let `default`: PageInfo = PageInfo(hasNextPage: true, limit: 20, offset: 0)

  /// Initializer for PageInfo
  ///
  /// - Parameters:
  ///   - hasNextPage: A boolean indicating if there is a next page
  ///   - limit: The maximum number of items to be returned in the result set
  ///   - offset: The number of items to skip before starting to collect the result set
  public init(hasNextPage: Bool, limit: Int, offset: Int) {
    self.hasNextPage = hasNextPage
    self.limit = limit
    self.offset = offset
  }

  /// This function is used to get the next page information.
  /// - Parameters:
  ///   - from: The current page information
  ///   - hasNextPage: A boolean indicating if there is a next page
  /// - Returns: The next page information
  public static func next(
    from pageInfo: PageInfo,
    hasNextPage: Bool = true
  ) -> PageInfo {
    PageInfo(
      hasNextPage: hasNextPage,
      limit: pageInfo.limit,
      offset: pageInfo.offset + pageInfo.limit
    )
  }
}
