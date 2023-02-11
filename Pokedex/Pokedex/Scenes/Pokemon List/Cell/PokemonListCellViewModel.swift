//
//  PokemonListCellViewModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit
import PokedexCore

final class PokemonListCellViewModel {
    private let loader: PokemonDetailLoader
    private let imageLoader: ImageDataLoader
    private let url: URL
    
    var onLoadingStateChange: Observer<Bool>?
    var onImageLoad: Observer<UIImage?>?
    var onErrorState: Observer<Error>?
    var onPokemonDetailLoad: Observer<PokemonDetailPresentableModel>?
    var presentableModel: PokemonDetailPresentableModel?
    
    init(
        loader: PokemonDetailLoader,
        imageLoader: ImageDataLoader,
        url: URL
    ) {
        self.loader = loader
        self.imageLoader = imageLoader
        self.url = url
    }
    
    func loadDetail() {
        onLoadingStateChange?(true)
        loader.load(from: url) { [weak self] result in
            self?.onLoadingStateChange?(false)
            switch result {
            case .success(let pokemonDetail):
                let model = pokemonDetail.toPresentableModel()
                self?.presentableModel = model
                self?.onPokemonDetailLoad?(model)
                self?.loadImage(with: pokemonDetail.spriteURL)
            case .failure(let error):
                self?.onErrorState?(error)
            }
        }
    }
    
    private func loadImage(with url: URL) {
        imageLoader.loadImageData(from: url) { [weak self] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            self?.onImageLoad?(image)
        }
    }
}
