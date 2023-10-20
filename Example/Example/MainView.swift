//
//  MainView.swift
//  Example
//
//  Created by Matic Vrenko on 20. 10. 23.
//

import SwiftUI
import InfiniteScroll

struct MainView: View {
  @State var tab = 0
  var body: some View {
    TabView(selection: $tab) {
      UngruppedScroll()
        .tag(0)
        .tabItem {
          Label {
            Text("Ungroupped")
          } icon: {
            Image(systemName: "person")
          }
        }
      GruppedScroll()
        .tag(1)
        .tabItem {
          Label {
            Text("Groupped")
          } icon: {
            Image(systemName: "person.3")
          }
        }
      ParametrizedScroll()
        .tag(2)
        .tabItem {
          Label {
            Text("Parametrized")
          } icon: {
            Image(systemName: "option")
          }
        }
    }
  }
}

struct PreviewItem: Identifiable, Hashable {
  let id: String
}

#Preview {
  MainView()
}

