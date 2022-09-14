//
//  TitlePreviewViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit
import WebKit

class TitlePreviewViewController: UIViewController {

    // MARK: - Outlets

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 22, weight: .bold)
        label.text = "Harry Potter"
        return label
    }()

    private lazy var overviewLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        label.text = "This is the best movie ever I've seen"
        return label
    }()

    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .red
        button.setTitle("Download", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.layer.cornerRadius = 15
        button.clipsToBounds = true
        return button
    }()

    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        return webView
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
        view.addSubview(webView)
        view.addSubview(titleLabel)
        view.addSubview(overviewLabel)
        view.addSubview(downloadButton)
    }

    private func setupLayout() {
        webView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(50)
            make.left.equalTo(view.snp.left)
            make.right.equalTo(view.snp.right)
            make.height.equalTo(250)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(webView.snp.bottom).offset(20)
            make.left.equalTo(view.snp.left).offset(20)
        }

        overviewLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.equalTo(view.snp.left).offset(20)
            make.right.equalTo(view.snp.right)
        }

        downloadButton.snp.makeConstraints { make in
            make.top.equalTo(overviewLabel.snp.bottom).offset(25)
            make.centerX.equalTo(view.snp.centerX)
            make.width.equalTo(120)
            make.height.equalTo(40)
        }
    }

    func configure(with model: TitlePreviewViewModel) {
        titleLabel.text = model.title
        overviewLabel.text = model.titleOverview
        guard let url = URL(string: "https://www.youtube.com/embed/\(model.youtubeView.id.videoId)") else { return }
        webView.load(URLRequest(url: url))
    }
}
