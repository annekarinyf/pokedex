//
//  PokemonListCellViewModel.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit
import PokedexCore

struct PokemonDetailPresentableModel {
    let name: String
    let number: String
    let types: [(type: String, color: UIColor)]
    let stats: [(stat: String, value: Int)]
    let height: String
    let weight: String
}

final class PokemonListCellViewModel {
    private let loader: PokemonDetailLoader
    private let imageLoader: ImageDataLoader
    
    var onLoadingStateChange: Observer<Bool>?
    var onImageLoad: Observer<UIImage?>?
    var onErrorState: Observer<Error>?
    var onPokemonDetailLoad: Observer<PokemonDetailPresentableModel>?
    
    init(
        loader: PokemonDetailLoader,
        imageLoader: ImageDataLoader
    ) {
        self.loader = loader
        self.imageLoader = imageLoader
    }
    
    func loadDetail() {
        onLoadingStateChange?(true)
        loader.load { [weak self] result in
            self?.onLoadingStateChange?(false)
            switch result {
            case .success(let pokemonDetail):
                self?.onPokemonDetailLoad?(pokemonDetail.toPresentableModel())
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

extension PokemonDetail {
    func toPresentableModel() -> PokemonDetailPresentableModel {
        PokemonDetailPresentableModel(
            name: name,
            number: "#\(id)",
            types: types.map { (type: $0.rawValue, color: $0.color) },
            stats: stats.map { (stat: $0.name, value: $0.baseStat) },
            height: height.toMetersFormatted(),
            weight: weight.toKilogramsFormatted()
        )
    }
}
