//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailPresentableModel
    weak var coordinator: Coordinator?
    
    init(viewModel: PokemonDetailPresentableModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
    }
}
