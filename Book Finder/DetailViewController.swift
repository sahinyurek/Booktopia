//
//  DetailViewController.swift
//  Book Finder
//
//  Created by Şahin Yürek on 4/2/23.
//

import SDWebImage
import UIKit

class DetailViewController: UIViewController {
    let book: BookItem

    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var authorLabel: UILabel!
    @IBOutlet var descriptionTextView: UITextView!

    init(book: BookItem) {
        self.book = book
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        thumbnailImageView.sd_setImage(with: URL(string: book.volumeInfo.imageLinks?.thumbnail ?? ""), placeholderImage: UIImage(named: "book-placeholder"))
        titleLabel.text = book.volumeInfo.title
        authorLabel.text = book.volumeInfo.authors?.joined(separator: ", ")
        descriptionTextView.text = book.volumeInfo.description
    }
}
