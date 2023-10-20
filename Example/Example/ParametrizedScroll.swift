//
//  ParametrizedScroll.swift
//  Example
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import SwiftUI
import InfiniteScroll

struct ParametrizedScroll: View {
  @State var parameter = "Group"
  var body: some View {
    VStack {
      Picker("Grouping", selection: $parameter) {
        Text("Group").tag("Group")
        Text("Team").tag("Team")
      }.pickerStyle(SegmentedPickerStyle())
      InfiniteScrollView.ungroupped(pageInfo: PageInfo.default) { pageInfo in
        (
          items: [PreviewItem(id: "\(parameter) \(UUID().uuidString)")],
          next: PageInfo.next(from: pageInfo, hasNextPage: true)
        )
      } itemView: { item in
        Text(item.id)
      }

    }
  }
}

#Preview {
  ParametrizedScroll()
}
