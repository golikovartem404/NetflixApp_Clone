//
//  TitleCollectionViewCell.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit
import SDWebImage

class TitleCollectionViewCell: UICollectionViewCell {

    static let identifier = "TitleCollectionViewCell"

    // MARK: - Outlets

    private lazy var titleImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    // MARK: - Lifecycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    private func setupHierarchy() {
        addSubview(titleImageView)
    }

    private func setupLayout() {
        titleImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }
    }

    public func configure(with model: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else { return }
        titleImageView.sd_setImage(with: url, completed: nil)
    }
}

