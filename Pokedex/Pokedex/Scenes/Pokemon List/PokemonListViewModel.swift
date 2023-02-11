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
    
    var title: String {
        "Pokedex"
    }
    
    var pokemonListCount: Int {
        cellViewModels.count
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onErrorState: Observer<Error>?
    var onPokemonListLoad: (() -> Void)?
    
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
        guard let url = url else {
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
        cellViewModels[indexPath.row]
    }
    
    func getPresentableModel(at indexPath: IndexPath) -> PokemonDetailPresentableModel? {
        cellViewModels[indexPath.row].presentableModel
    }
}
