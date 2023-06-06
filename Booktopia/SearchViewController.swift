//
//  DetailViewController.swift
//  Book Finder
//
//  Created by Şahin Yürek on 4/2/23.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!

    var books: [BookItem] = []
    var currentPage = 0
    var totalNumberOfPages = 0
    var currentQuery = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: "BookTableViewCell", bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: "BookTableViewCell")
    }

    func searchBooks(query: String, page: Int = 0) {
        // Create a URL request with the search query
        // let apikey = ""
        let startIndex = page * 10
        guard let url = URL(string: "https://www.googleapis.com/books/v1/volumes?q=\(query)&startIndex=\(startIndex)&maxResults=10") else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }

            guard let data = data else {
                print("No data received")
                return
            }

            do {
                let result = try JSONDecoder().decode(SearchResult.self, from: data)
                self.totalNumberOfPages = result.totalItems / 10 // Assuming 10 results per page
                self.currentQuery = query

                self.books.append(contentsOf: result.items)

                DispatchQueue.main.async {
                    let indexPaths = (self.books.count - result.items.count ..< self.books.count).map { IndexPath(row: $0, section: 0) }

                    // Insert the new cells into the table view
                    self.tableView.insertRows(at: indexPaths, with: .automatic)
                }
            } catch {
                print("Error decoding search results: \(error.localizedDescription)")
            }
        }

        task.resume()
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        if let query = searchBar.text {
            searchBooks(query: query)
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        books.removeAll()
        tableView.reloadData()
    }
}

extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookTableViewCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        cell.titleLabel.text = book.volumeInfo.title
        cell.authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        if let thumbnailURL = book.volumeInfo.imageLinks?.thumbnail, let url = URL(string: thumbnailURL) {
            let task = URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data {
                    DispatchQueue.main.async {
                        cell.thumbnailImageView.image = UIImage(data: data)
                    }
                }
            }
            task.resume()
        } else {
            cell.thumbnailImageView.image = UIImage(systemName: "book")
        }
        return cell
    }
}

extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let book = books[indexPath.row]
        let detailViewController = DetailViewController(book: book)
        performSegue(withIdentifier: "goToDetail", sender: self)
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
        if indexPath.row == lastRowIndex {
            // Check if additional results are available
            if currentPage < totalNumberOfPages {
                currentPage += 1
                searchBooks(query: currentQuery, page: currentPage)
            }
        }
    }
}
