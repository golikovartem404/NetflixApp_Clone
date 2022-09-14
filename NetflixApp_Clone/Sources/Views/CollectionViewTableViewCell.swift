//
//  CollectionViewTableViewCell.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTappedCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {

    static let identifier = "CollectionViewTableViewCell"

    private var titles: [Title] = [Title]()

    weak var delegate: CollectionViewTableViewCellDelegate?

    // MARK: - Outlets

    private lazy var collection: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collection.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        collection.delegate = self
        collection.dataSource = self
        return collection
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemCyan
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


    // MARK: - Setups

    private func setupHierarchy() {
        addSubview(collection)
    }

    private func setupLayout() {
        collection.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }

    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collection.reloadData()
        }
    }

    private func downloadingTitleAt(indexPath: IndexPath) {
        print("Download \(titles[indexPath.row].original_title ?? "")")
    }
}

// MARK: - Extensions

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collection.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else { return UICollectionViewCell() }
        guard let model = titles[indexPath.row].poster_path else { return UICollectionViewCell() }
        cell.configure(with: model)
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 140, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getYouTubeMovie(with: titleName + " trailer") { [weak self] result in
            switch result {
            case .success(let videoElement):
                let title = self?.titles[indexPath.row]
                let viewModel = TitlePreviewViewModel(title: titleName,
                                                      youtubeView: videoElement,
                                                      titleOverview: title?.overview ?? "")
                guard let strongSelf = self else { return }
                self?.delegate?.collectionViewTableViewCellDidTappedCell(strongSelf, model: viewModel)
            case .failure(let errors):
                print(errors.localizedDescription)
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        let config = UIContextMenuConfiguration(identifier: nil,
                                                previewProvider: nil) { [weak self] _ in
            let downloadAction = UIAction(title: "Download",
                                          subtitle: nil,
                                          image: nil,
                                          identifier: nil,
                                          discoverabilityTitle: nil,
                                          state: .off) { _ in
                self?.downloadingTitleAt(indexPath: indexPath)
            }
            return UIMenu(title: "",
                          image: nil,
                          identifier: nil,
                          options: .displayInline,
                          children: [downloadAction])
        }
        return config
    }
}
