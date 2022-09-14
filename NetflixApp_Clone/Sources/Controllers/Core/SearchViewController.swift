//
//  SearchViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit

class SearchViewController: UIViewController {

    private var titles: [Title] = [Title]()

    private lazy var discoverTable: UITableView = {
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        table.dataSource = self
        table.delegate = self
        return table
    }()

    private lazy var searchController: UISearchController = {
        let controller = UISearchController(searchResultsController: SearchResultsViewController())
        controller.searchBar.placeholder = "Search for a Movie or TV show"
        controller.searchBar.searchBarStyle = .minimal
        return controller
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Search"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        navigationItem.searchController = searchController
        navigationController?.navigationBar.tintColor = .white
        searchController.searchResultsUpdater = self
        setupHierarchy()
        setupLayout()
        fetchDiscoverMovies()
    }

    private func setupHierarchy() {
        view.addSubview(discoverTable)
    }

    private func setupLayout() {
        discoverTable.snp.makeConstraints { make in
            make.top.left.right.bottom.equalTo(view)
        }
    }

    private func fetchDiscoverMovies() {
        APICaller.shared.getDiscoverMovies { [weak self] results in
            switch results {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.discoverTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {return UITableViewCell()}
        let title = titles[indexPath.row]
        let model = TitleViewModel(titleName: title.original_title ?? title.original_name ?? "Unknown", posterURL: title.poster_path ?? "")
        cell.configure(with: model)
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

extension SearchViewController: UISearchResultsUpdating, SearchResultsViewControllerDelegate {

    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 3,
              let resultsController = searchController.searchResultsController as? SearchResultsViewController else {return}
        resultsController.delegate = self
        APICaller.shared.search(with: query) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let titles):
                    resultsController.titles = titles
                    resultsController.searchResultsCollection.reloadData()
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }

    func searchResultsViewControllerDidTapped(_ viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = TitlePreviewViewController()
            viewController.configure(with: viewModel)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
