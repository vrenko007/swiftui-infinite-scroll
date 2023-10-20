//
//  GruppedScroll.swift
//  Example
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import SwiftUI
import InfiniteScroll

struct GruppedScroll: View {
  var body: some View {
    InfiniteScrollView.groupped(
      pageInfo: PageInfo.default
    ) { pageInfo in
      (
        items: [PreviewItem(id: UUID().uuidString)],
        next: PageInfo.next(from: pageInfo, hasNextPage: true)
      )
    } groupView: { ungrupped, itemView in
      Group {
        ForEach(ungrupped) { item in
          itemView(item)
        }
      }
    } itemView: { item in
      Text(item.id)
    }
  }
}

#Preview {
  GruppedScroll()
}
