//
//  ViewModel.swift
//  Books
//
//  Created by Isabella Sulisufi on 20/08/2024.
//

import Foundation
import SwiftUI

struct HomeViewData {
    let mostDownloadedBook: String
    let downloadTotal: String
}

class ViewModel: ObservableObject {
    @Published var books: [Book] = []
    @Published var viewData: HomeViewData?
    @Published var bookEntered: String = ""
    @Published var message: String = ""
    @Published var emptySearch: String = ""
    
    @EnvironmentObject var router: Router
    
    private let networkRepository = BookRepository()

    // MARK: - Fetch Books from Repository
    
    /// Fetches books from the repository asynchronously
    func fetchBookRepo() async {
        do {
            // Fetch books from the repository
            books = try await networkRepository.fetchBookRepo()
        } catch NetworkError.invalidURL {
            message = "Invalid URL"
        } catch NetworkError.invalidResponse {
            message = "Invalid response"
        } catch NetworkError.decodingError {
            message = "Decoding Error"
        } catch {
            message = "Unexpected error: \(error)"
        }
    }

    // MARK: - Search Functionality
    
    /// Handles search functionality when user enters a book title  (Not currently used in the UI)
    func searchButtonFunctionality() {
        let bookTitles = books.map { $0.title }
        let searchedBooks = books.filter { $0.title.contains(bookEntered) }
        
        if bookTitles.contains(bookEntered) {
            message = "We have your book, yay!"
        } else {
            message = "Sorry, we do not have your book!"
        }
        
        print(searchedBooks.map { $0.title }) // For debugging purposes
    }

    // MARK: - Sorting Functions
    
    /// Sorts books alphabetically (optional, not currently used in the UI)
    func sortBooksAlphabetically() {
        let sortedTitles = books.map { $0.title }.sorted { $0.lowercased() < $1.lowercased() }
        
        // Debugging: Print sorted titles
        sortedTitles.forEach { print($0) }
    }

    /// Returns a list of books ordered by download count (descending)
    func getBooksOrderedByDownloads() -> [Book] {
        let sortedBooks = books.sorted(by: { $0.downloadCount > $1.downloadCount })
        
        // Debugging: Print each book's title and download count
        for book in sortedBooks {
            print("Title: \(book.title), Downloads: \(book.downloadCount)")
        }
        
        return sortedBooks
    }
    
    // MARK: - Most Downloaded Book
    
    /// Updates the view data with the most downloaded book and its download count (Not currently used in the UI)
    func getMostDownloaded() {
        if let book = books.max(by: { $0.downloadCount < $1.downloadCount }) {
            viewData = HomeViewData(mostDownloadedBook: book.title, downloadTotal: "Downloaded: \(book.downloadCount) times")
        }
    }

    // MARK: - Navigation
    
    /// Navigates to the search page using the entered book name (Not currently used in the UI)
    func navigateToSearch() {
        router.navigate(to: .searchedPage(bookEntered))
    }
    
}
