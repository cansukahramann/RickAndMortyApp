//
//  RMSearchViewController.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 30.10.2023.
//

import UIKit
///Configurable controller to search
class RMSearchViewController: UIViewController {
    
    ///Configuration for search session
    struct Config {
        enum `Type` {
            case character // name | status | gender
            case episode  // name
            case location // name | type
            
            var endpoint: RMEndpoint {
                switch self {
                case.character: return .character
                case.episode: return.episode
                case.location: return.location
                }
            }
            
            var title: String {
                switch self {
                case .character:
                    return "Search Characters"
                case.location:
                    return "Search Locations"
                case.episode:
                    return "Search Episode"
                }
            }
        }
        let type: `Type`
    }
    
    private let viewModel: RMSearchViewViewModel
    
    private let searchView: RMSearchView
    
    init(config: Config){
        let viewModel = RMSearchViewViewModel(config: config)
        self.viewModel = viewModel
        self.searchView = RMSearchView(frame: .zero, viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Unsupported")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.config.type.title
        view.backgroundColor = .systemBackground
        view.addSubviews(searchView)
        addConstraints()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Search",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTabExecuteSearch))
        searchView.delegate = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidDisappear(true)
        searchView.presentKeyboard()
    }
    
    @objc
    private func didTabExecuteSearch() {
        viewModel.executeSearch()
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            searchView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor),
            searchView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor),
            searchView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
            
        ])
    }
}

extension RMSearchViewController: RMSearchViewDelegate {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        let vc = RMSearchOptionViewController(option: option) { [weak self] selection in
            DispatchQueue.main.async {
                self?.viewModel.set(value: selection, for: option)
            }
        }
        vc.sheetPresentationController?.detents = [.medium()]
        vc.sheetPresentationController?.prefersGrabberVisible = true
        present(vc, animated: true)

    }
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation) {
        let vc = RMLocationDetailViewController(location: location)
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
}
