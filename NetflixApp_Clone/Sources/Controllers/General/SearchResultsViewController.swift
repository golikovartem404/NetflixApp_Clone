//
//  SearchResultsViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

protocol SearchResultsViewControllerDelegate {
    func searchResultsViewControllerDidTapped(_ viewModel: TitlePreviewViewModel)
}

class SearchResultsViewController: UIViewController {

    public var titles: [Title] = [Title]()

    public var delegate: SearchResultsViewControllerDelegate?

    // MARK: - Outlets

    public lazy var searchResultsCollection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width / 3 - 10, height: 200)
        layout.minimumInteritemSpacing = 0
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collection.dataSource = self
        collection.delegate = self
        return collection
    }()

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
    }

    // MARK: - Setups

    private func setupHierarchy() {
        view.addSubview(searchResultsCollection)
    }

    private func setupLayout() {
        searchResultsCollection.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }

}

    // MARK: - Extensions

extension SearchResultsViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {return UICollectionViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "")
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? ""
        APICaller.shared.getYouTubeMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement  ):
                self?.delegate?.searchResultsViewControllerDidTapped(TitlePreviewViewModel(title: titleName,
                                                                                           youtubeView: videoElement,
                                                                                           titleOverview: title.overview ?? ""))
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
