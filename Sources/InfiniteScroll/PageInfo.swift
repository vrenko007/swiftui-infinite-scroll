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
