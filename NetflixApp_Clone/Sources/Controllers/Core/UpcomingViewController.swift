//
//  UpcomingViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class UpcomingViewController: UIViewController {

    private var titles: [Title] = [Title]()

    private lazy var upcomingTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        setupHierarchy()
        setupLayout()
        fetchUpcoming()
    }

    private func setupHierarchy() {
        view.addSubview(upcomingTable)
    }

    private func setupLayout() {
        upcomingTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }

    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterURL: title.poster_path ?? ""))
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let title = titles[indexPath.row]
        guard let titleName = title.original_title ?? title.original_name else { return }
        APICaller.shared.getYouTubeMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement  ):
                DispatchQueue.main.async {
                    let viewController = TitlePreviewViewController()
                    viewController.configure(with: TitlePreviewViewModel(title: titleName,
                                                                         youtubeView: videoElement,
                                                                         titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(viewController, animated: true)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
