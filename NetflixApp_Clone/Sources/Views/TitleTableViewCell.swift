//
//  TitleTableViewCell.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class TitleTableViewCell: UITableViewCell {

    static let identifier = "TitleTableViewCell"

    // MARK: - Outlets

    private lazy var posterImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        return label
    }()

    private lazy var playButton: UIButton = {
        let button = UIButton()
        let image = UIImage(systemName: "play.circle", withConfiguration: UIImage.SymbolConfiguration(pointSize: 40))
        button.setImage(image, for: .normal)
        button.tintColor = .white
        return button
    }()

    // MARK: - Lifecycle

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupHierarchy()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Setups

    private func setupHierarchy() {
        addSubview(posterImage)
        addSubview(titleLabel)
        addSubview(playButton)
    }

    private func setupLayout() {
        posterImage.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(5)
            make.bottom.equalTo(contentView.snp.bottom).offset(-5)
            make.left.equalTo(self)
            make.width.equalTo(100)
        }

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(posterImage.snp.right).offset(20)
            make.centerY.equalTo(contentView.snp.centerY)
            make.width.equalTo(contentView.snp.width).multipliedBy(0.6)
        }

        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(contentView.snp.centerY)
            make.right.equalTo(self)
        }
    }

    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        posterImage.sd_setImage(with: url, completed: nil)
        titleLabel.text = model.titleName
    }

}
