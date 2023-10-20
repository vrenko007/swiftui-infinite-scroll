//
//  GruppedScroll.swift
//  Example
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import SwiftUI
import IdentifiedCollections
import InfiniteScroll

class PreviewSection: Identifiable {
  let id: String
  var items: IdentifiedArrayOf<PreviewItem> = []

  init(id: String) {
    self.id = id
  }
}

struct GruppedScroll: View {
  private func group(_ items: IdentifiedArrayOf<PreviewItem>) -> [PreviewSection] {
    var sections: [PreviewSection] = [PreviewSection(id: "Group 0")]

    for item in items {
      if (sections.last!.items.count > 10) {
        sections.append(PreviewSection(id: "Group \(sections.count)"))
      }
      sections.last!.items.append(item)
    }
    return sections
  }

  var body: some View {
    InfiniteScrollView.groupped(
      pageInfo: PageInfo(hasNextPage: true, limit: 1, offset: 0)
    ) { pageInfo in
      (
        items: [PreviewItem(id: UUID().uuidString)],
        next: PageInfo.next(from: pageInfo, hasNextPage: true)
      )
    } groupView: { ungroupped, itemView -> AnyView in
      let sections = group(ungroupped)
      return AnyView(Group {
        ForEach(sections) { section in
          Section(section.id) {
            ForEach(section.items) { item in
              AnyView(itemView(item))
            }
          }
        }
      })
    } itemView: { item in
      Text(item.id)
    }
  }
}

#Preview {
  GruppedScroll()
}
