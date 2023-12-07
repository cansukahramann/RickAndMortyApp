//
//  RMSearchView.swift
//  RickAndMorty
//
//  Created by Cansu Kahraman on 15.11.2023.
//

import UIKit

protocol RMSearchViewDelegate: AnyObject {
    func rmSearchView(_ searchView: RMSearchView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions)
    
    func rmSearchView(_ searchView: RMSearchView, didSelectLocation location: RMLocation)
    func rmSearchView(_ searchView: RMSearchView, didSelectCharacter character: RMCharacter)
    func rmSearchView(_ searchView: RMSearchView, didSelectEpisode episode: RMEpisode)

}

final class RMSearchView: UIView {
    
    weak var delegate: RMSearchViewDelegate?
    
    private let viewModel: RMSearchViewViewModel
    private let searchInputView = RMSearchInputView()
    private let noResultView = RMNoSearchResultsView()
    private let resultsView = RMSearchResultsView()
    
    init(frame: CGRect, viewModel: RMSearchViewViewModel) {
        self.viewModel = viewModel
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .systemBackground
        addSubviews(resultsView, noResultView, searchInputView)
        addConstraints()
        
        searchInputView.configure(with: RMSearchInputViewViewModel(type: viewModel.config.type))
        searchInputView.delegate = self
        
        setUpHandlers(viewModel: viewModel)
        
        resultsView.delegate = self 
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpHandlers(viewModel: RMSearchViewViewModel) {
        viewModel.registerOptionChangeBlock { tuple in
            self.searchInputView.update(option: tuple.0, value: tuple.1 )
        }
        
        viewModel.registerSearchResultHandler { [weak self] result in
            DispatchQueue.main.async {
                self? .resultsView.configure(with: result)
                self?.noResultView.isHidden = true
                self?.resultsView.isHidden = false
            }
        }
        
        viewModel.registernoResultsHandler { [weak self] in
            DispatchQueue.main.async {
                self?.noResultView.isHidden = false
                self?.resultsView.isHidden = true
            }
        }
    }
    
    private func addConstraints() {
        NSLayoutConstraint.activate([
            
            searchInputView.topAnchor.constraint(equalTo: topAnchor),
            searchInputView.leftAnchor.constraint(equalTo: leftAnchor),
            searchInputView.rightAnchor.constraint(equalTo: rightAnchor),
            searchInputView.heightAnchor.constraint(equalToConstant: viewModel.config.type == .episode ? 55 : 110),
            
            resultsView.topAnchor.constraint(equalTo: searchInputView.bottomAnchor),
            resultsView.leftAnchor.constraint(equalTo: leftAnchor),
            resultsView.rightAnchor.constraint(equalTo: rightAnchor),
            resultsView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            noResultView.heightAnchor.constraint(equalToConstant: 150),
            noResultView.widthAnchor.constraint(equalToConstant: 150),
            noResultView.centerXAnchor.constraint(equalTo: centerXAnchor),
            noResultView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func presentKeyboard() {
        searchInputView.presentKeyboard()
    }
    
}

extension RMSearchView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
    
}

extension RMSearchView: RMSearchInputViewDelegate {
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didSelectOption option: RMSearchInputViewViewModel.DynamicOptions) {
        delegate?.rmSearchView(self, didSelectOption: option)
    }
    
    func rmSearchInputView(_ inputView: RMSearchInputView, didChangeSearchText text: String) {
        viewModel.set(query: text)
    }
    
    func rmSearchInputViewDidTapSearchKeybordButton(_ inputView: RMSearchInputView) {
        viewModel.executeSearch()
    }
}

//MARK: -RMSearchResultViewDelegate

extension RMSearchView: RMSearchResultsViewDelegate {
    func rmSearchResultsView(_ resultView: RMSearchResultsView, didTapLocationAt index: Int) {
        guard let locationModel = viewModel.locationSearchResult(at: index) else  {
            return
        }
        delegate?.rmSearchView(self, didSelectLocation: locationModel)
    }
    func rmSearchResultsView(_ resultView: RMSearchResultsView, didTapCharacterAt index: Int) {
        guard let characterModel = viewModel.characterSearchResult(at: index) else  {
            return
        }
        delegate?.rmSearchView(self, didSelectCharacter: characterModel)
    }
    
    func rmSearchResultsView(_ resultView: RMSearchResultsView, didTapEpisodeAt index: Int) {
        guard let episodeModel = viewModel.episodeSearchResult(at: index) else  {
            return
        }
        delegate?.rmSearchView(self, didSelectEpisode: episodeModel)
    }
}
