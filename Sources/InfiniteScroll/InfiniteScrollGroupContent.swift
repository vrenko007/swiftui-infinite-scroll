//
//  InfiniteScrollGroupContent.swift
//  
//
//  Created by Matic Vrenko on 25. 10. 23.
//

import SwiftUI

public struct InfiniteScrollGroupContent<T: Identifiable & Hashable, Content: View>: View {
  let item: T
  let itemView: (T) -> Content
  let loadMore: (T.ID) -> Void

  public var body: some View {
    itemView(item)
      .onAppear {
        loadMore(item.id)
      }
  }
}
