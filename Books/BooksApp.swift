//
//  BooksApp.swift
//  Books
//
//  Created by Isabella Sulisufi on 16/08/2024.
//

import SwiftUI

@main
struct BooksApp: App {
    @ObservedObject var router = Router()
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.navPath) {
                ContentView(viewModel: ViewModel())
                    .navigationDestination(for: Router.Destination.self) { destination in
                        switch destination {
                        case let .searchedPage(bookId):
                            SearchPageView()
                        }
                    }
            }
            .environmentObject(router)

        }
    }
}
