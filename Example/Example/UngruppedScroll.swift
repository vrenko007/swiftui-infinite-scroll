//
//  UngruppedScroll.swift
//  Example
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import SwiftUI
import InfiniteScroll

struct UngruppedScroll: View {
  var body: some View {
    InfiniteScrollView.ungroupped(
      pageInfo: PageInfo.default
    ) { pageInfo in
      (
        items: [PreviewItem(id: UUID().uuidString)],
        next: PageInfo.next(from: pageInfo, hasNextPage: true)
      )
    } itemView: { item in
      Text(item.id)
    }.tag(0)
  }
}

#Preview {
  UngruppedScroll()
}
