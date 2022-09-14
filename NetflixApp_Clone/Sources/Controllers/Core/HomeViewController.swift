//
//  HomeViewController.swift
//  NetflixApp_Clone
//
//  Created by User on 14.09.2022.
//

import UIKit
import SnapKit

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTV = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController {

    private var randomTrendingMovie: Title?
    private var headerView: TableHeaderView?

    private let sectionTitles: [String] = ["Trending movies", "Trending tv", "Popular", "Upcoming movies", "Top rated"]

    private lazy var homeScreenTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        headerView = TableHeaderView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 450))
        table.tableHeaderView = headerView
        table.dataSource = self
        table.delegate = self
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupHierarchy()
        setupLayout()
        configureNavBar()
        configureTableHeaderView()
    }

    private func setupHierarchy() {
        view.addSubview(homeScreenTable)
    }

    private func setupLayout() {
        homeScreenTable.snp.makeConstraints { make in
            make.top.equalTo(view)
            make.left.right.equalTo(view)
            make.bottom.equalTo(view)
        }
    }

    private func configureNavBar() {
        lazy var image = UIImage(named: "netflix")
        image = image?.withRenderingMode(.alwaysOriginal)
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .done,
                                                           target: self,
                                                           action: nil)
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        navigationController?.navigationBar.tintColor = .white
    }

    private func configureTableHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                self?.randomTrendingMovie = selectedTitle
                self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "",
                                                                 posterURL: selectedTitle?.poster_path ?? ""))
            case .failure(let errors):
                print(errors.localizedDescription)
            }
        }
    }
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {return UITableViewCell()}
        cell.delegate = self
        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let errors):
                    print(errors.localizedDescription)
                }
            }
        case Sections.TrendingTV.rawValue:
            APICaller.shared.getTrendingTV { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let errors):
                    print(errors.localizedDescription)
                }
            }
        case Sections.Popular.rawValue:
            APICaller.shared.getPopularMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let errors):
                    print(errors.localizedDescription)
                }
            }
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let errors):
                    print(errors.localizedDescription)
                }
            }
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRatedMovies { result in
                switch result {
                case .success(let titles):
                    cell.configure(with: titles)
                case .failure(let errors):
                    print(errors.localizedDescription)
                }
            }
        default:
            return UITableViewCell()
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let headerView = view as? UITableViewHeaderFooterView else { return }
        headerView.textLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        headerView.textLabel?.frame = CGRect(x: headerView.bounds.origin.x + 20,
                                             y: headerView.bounds.origin.y,
                                             width: 100,
                                             height: headerView.bounds.height)
        headerView.textLabel?.textColor = .white
        headerView.textLabel?.text = headerView.textLabel?.text?.capitalizeFirstLetter()
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }

}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTappedCell(_ cell: CollectionViewTableViewCell, model: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let viewController = TitlePreviewViewController()
            viewController.configure(with: model)
            self?.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
