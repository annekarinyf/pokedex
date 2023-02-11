//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonListViewController: UIViewController {
    private enum LayouContants {
        static let cellInset: CGFloat = 30
        static let cellSize: CGFloat = 150
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: LayouContants.cellInset,
            left: LayouContants.cellInset,
            bottom: LayouContants.cellInset,
            right: LayouContants.cellInset
        )
        layout.itemSize = CGSize(
            width: LayouContants.cellSize,
            height: LayouContants.cellSize
        )
        let collectionView = UICollectionView(
            frame: .zero,
            collectionViewLayout: layout
        )
        collectionView.register(PokemonListCell.self)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        return collectionView
    }()
    
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return refreshControl
    }()
    
    private lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private let viewModel: PokemonListViewModel
    var coordinator: PokemonListCoordinator?
    
    init(viewModel: PokemonListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .systemBackground
        
        setupSubviews()
        setupBinding()
        viewModel.loadList()
    }
    
    private func setupSubviews() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        collectionView.addSubview(refreshControl)
    }
    
    @objc private func refresh() {
        viewModel.loadList()
    }
    
    private func setupBinding() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.refreshControl.beginRefreshing()
            } else {
                self?.refreshControl.endRefreshing()
            }
        }
        
        viewModel.onPokemonListLoad = { [weak self] in
            self?.collectionView.reloadData()
        }
        
        viewModel.onErrorState = { [weak self] error in
            self?.errorLabel.text = error.localizedDescription
        }
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.pokemonListCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PokemonListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.viewModel = viewModel.getListCellViewModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel.getPresentableModel(at: indexPath) else {
            return
        }
        coordinator?.openPokemonDetailViewController(with: model)
    }
}
