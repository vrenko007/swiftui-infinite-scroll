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
      pageInfo: PageInfo(hasNextPage: true, limit: 1, offset: 0)
    ) { pageInfo in
      (
        items: [PreviewItem(id: UUID().uuidString)],
        next: PageInfo.next(from: pageInfo, hasNextPage: true)
      )
    } itemView: { item in
      Text(item.id)
    }
  }
}

#Preview {
  UngruppedScroll()
}
