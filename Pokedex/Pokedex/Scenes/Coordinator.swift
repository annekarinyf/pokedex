//
//  Coordinator.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import PokedexCore
import UIKit

protocol Coordinator: AnyObject {
    var navigationController: UINavigationController { get set }
    
    func start()
}

final class MainCoordinator: Coordinator {
    var navigationController: UINavigationController
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/")!
        let httpClient = URLSessionHTTPClient(
            session: URLSession(configuration: .ephemeral)
        )
        let listLoader = RemotePokemonListLoader(
            client: httpClient,
            url: url
        )
        let detailLoader = RemotePokemonDetailLoader(
            client: httpClient
        )
        let imageLoader = ImageLoader(client: httpClient)
        let viewModel = PokemonListViewModel(
            loader: MainQueueDispatchDecorator(decoratee: listLoader),
            detailLoader: MainQueueDispatchDecorator(decoratee: detailLoader),
            imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)
        )
        let viewController = PokemonListViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: false)
    }
}
