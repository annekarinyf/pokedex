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
    private var pokemonListItems = [PokemonListItem]()
    
    var title: String {
        "Pokedex"
    }
    
    var pokemonListCount: Int {
        pokemonListItems.count
    }
    
    var onLoadingStateChange: Observer<Bool>?
    var onErrorState: Observer<Error>?
    var onPokemonListLoad: (() -> Void)?
    
    init(
        loader: PokemonListLoader,
        detailLoader: PokemonDetailLoader,
        imageLoader: ImageDataLoader
    ) {
        self.loader = loader
        self.detailLoader = detailLoader
        self.imageLoader = imageLoader
    }
    
    func loadList() {
        onLoadingStateChange?(true)
        loader.load { [weak self] result in
            self?.onLoadingStateChange?(false)
            switch result {
            case .success(let pokemonListItems):
                self?.pokemonListItems = pokemonListItems
                self?.onPokemonListLoad?()
            case .failure(let error):
                self?.onErrorState?(error)
            }
        }
    }
    
    func getListCellViewModel(at indexPath: IndexPath) -> PokemonListCellViewModel {
        let url = pokemonListItems[indexPath.row].url
        
        return PokemonListCellViewModel(
            loader: detailLoader,
            imageLoader: imageLoader,
            url: url
        )
    }
}
