//
//  PokemonListViewController.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonListViewController: UIViewController {
    private enum LayoutConstants {
        static let cellInset: CGFloat = 10
        static let cellSize: CGFloat = 170
    }
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(
            top: LayoutConstants.cellInset,
            left: LayoutConstants.cellInset,
            bottom: LayoutConstants.cellInset,
            right: LayoutConstants.cellInset
        )
        layout.itemSize = CGSize(
            width: getCellSize(),
            height: getCellSize()
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.prefersLargeTitles = true
        title = viewModel.title
        view.backgroundColor = .systemBackground
        
        setupNavigationButton()
        setupSubviews()
        setupBinding()
        viewModel.loadList()
    }
    
    private func setupNavigationButton() {
        let rightBarButtonItem = UIBarButtonItem(
            image: viewModel.barButtonImage,
            style: .done,
            target: self,
            action: #selector(openFilterOptions)
        )
        navigationItem.rightBarButtonItem = rightBarButtonItem
        
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
    
    @objc private func openFilterOptions() {
        let alertController = UIAlertController(
            title: "Filter",
            message: "You can filter Pokémon by type",
            preferredStyle: .actionSheet
        )
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        let noFilterAction = UIAlertAction(title: "No filter", style: .destructive) { [weak self] _ in
            self?.viewModel.cancelFilter()
        }
        alertController.addAction(noFilterAction)
        
        let type = viewModel.getTypes()
        let actions = type.map { makeAlertAction(with: $0) }
        actions.forEach { action in
            alertController.addAction(action)
        }
        
        present(alertController, animated: true)
    }
    
    private func makeAlertAction(with title: String) -> UIAlertAction {
        let action = UIAlertAction(title: title, style: .default) { [weak self] _ in
            self?.viewModel.filter(with: title)
        }
        return action
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
        
        viewModel.onPokemonFilter = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    private func getCellSize() -> CGFloat {
        (view.frame.width/2) - (2*LayoutConstants.cellInset)
    }
}

extension PokemonListViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.getListCellViewModelCount()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PokemonListCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.clean()
        cell.viewModel = viewModel.getListCellViewModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let model = viewModel.getPresentableModel(at: indexPath) else {
            return
        }
        coordinator?.openPokemonDetailViewController(with: model)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == viewModel.getListCellViewModelCount() - 1 {
            viewModel.loadList()
        }
    }
}
