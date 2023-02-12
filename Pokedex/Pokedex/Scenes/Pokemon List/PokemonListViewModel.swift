//
//  PokemonListViewModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit
import PokedexCore

final class PokemonListViewModel {
    private let loader: PokemonListLoader
    private var detailLoader: PokemonDetailLoader
    private let imageLoader: ImageDataLoader
    private var url: URL?
    private var cellViewModels = [PokemonListCellViewModel]()
    
    private var filterType: PokemonType? {
        didSet {
            filteredCellViewModels = cellViewModels.filter { $0.presentableModel?.types.first?.type == filterType?.rawValue }
        }
    }
    private var filteredCellViewModels = [PokemonListCellViewModel]()
    private var isFiltering: Bool {
        filterType != nil
    }
    
    var title: String {
        "Pokedex"
    }
    
    var barButtonImage: UIImage? {
        UIImage(systemName: "line.3.horizontal.decrease.circle")
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onErrorState: Observer<Error>?
    var onPokemonListLoad: (() -> Void)?
    var onPokemonFilter: (() -> Void)?
    
    init(
        url: URL,
        loader: PokemonListLoader,
        detailLoader: PokemonDetailLoader,
        imageLoader: ImageDataLoader
    ) {
        self.url = url
        self.loader = loader
        self.detailLoader = detailLoader
        self.imageLoader = imageLoader
    }
    
    func loadList() {
        guard let url = url, !isFiltering else {
            return
        }
        onLoadingStateChange?(true)
        loader.load(from: url) { [weak self] result in
            self?.onLoadingStateChange?(false)
            switch result {
            case .success(let pokemonList):
                self?.url = pokemonList.nextURL
                let pokemonItems = pokemonList.items.compactMap { self?.makeListCellViewModel(for: $0) }
                self?.cellViewModels.append(contentsOf: pokemonItems)
                self?.onPokemonListLoad?()
            case .failure(let error):
                self?.onErrorState?(error)
            }
        }
    }
    
    private func makeListCellViewModel(for item: PokemonListItem) -> PokemonListCellViewModel {
        PokemonListCellViewModel(
            loader: detailLoader,
            imageLoader: imageLoader,
            url: item.url
        )
    }
    
    func getListCellViewModel(at indexPath: IndexPath) -> PokemonListCellViewModel {
        getCellViewModels()[indexPath.row]
    }
    
    func getPresentableModel(at indexPath: IndexPath) -> PokemonDetailPresentableModel? {
        getCellViewModels()[indexPath.row].presentableModel
    }
    
    func getListCellViewModelCount() -> Int {
        getCellViewModels().count
    }
    
    func getTypes() -> [String] {
        PokemonType.allCases.map { $0.rawValue }
    }
    
    func getCellViewModels() -> [PokemonListCellViewModel] {
        if isFiltering {
            return filteredCellViewModels
        } else {
            return cellViewModels
        }
    }
    
    func filter(with type: String) {
        filterType = PokemonType(rawValue: type) ?? .unknown
        onPokemonFilter?()
    }
    
    func cancelFilter() {
        filterType = nil
        onPokemonFilter?()
    }
}
