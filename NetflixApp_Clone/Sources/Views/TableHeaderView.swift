//
//  TableHeaderView.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit
import SnapKit

class TableHeaderView: UIView {

    //MARK: - Outlets

    private lazy var playButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Play", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()

    private lazy var downloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5
        return button
    }()

    private lazy var highImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "dunc")
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
        addSubview(highImageView)
        addGradient()
        addSubview(playButton)
        addSubview(downloadButton)
    }

    private func setupLayout() {
        highImageView.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(self)
        }

        playButton.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX).multipliedBy(0.65)
            make.centerY.equalTo(snp.centerY).multipliedBy(1.7)
            make.width.equalTo(snp.width).multipliedBy(0.25)
        }

        downloadButton.snp.makeConstraints { make in
            make.centerX.equalTo(snp.centerX).multipliedBy(1.35)
            make.centerY.equalTo(snp.centerY).multipliedBy(1.7)
            make.width.equalTo(snp.width).multipliedBy(0.25)
        }
    }

    private func addGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.systemBackground.cgColor
        ]
        gradientLayer.frame = bounds
        layer.addSublayer(gradientLayer)
    }

    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else { return }
        highImageView.sd_setImage(with: url, completed: nil)
    }
}
