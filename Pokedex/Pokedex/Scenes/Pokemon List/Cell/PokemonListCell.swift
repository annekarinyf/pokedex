//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonListCell: UICollectionViewCell {
    private let viewModel: PokemonListCellViewModel
    
    enum LayoutConstants {
        static let spacing: CGFloat = 12
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    init(viewModel: PokemonListCellViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupSubviews()
        setupBinding()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupSubviews() {
        addSubview(imageView)
        addSubview(title)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: topAnchor, constant: LayoutConstants.spacing).isActive = true
        imageView.bottomAnchor.constraint(equalTo: title.topAnchor, constant: LayoutConstants.spacing).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.spacing).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: LayoutConstants.spacing).isActive = true
        
        title.translatesAutoresizingMaskIntoConstraints = false
        title.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: LayoutConstants.spacing).isActive = true
        title.bottomAnchor.constraint(equalTo: bottomAnchor, constant: LayoutConstants.spacing).isActive = true
        title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: LayoutConstants.spacing).isActive = true
        title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: LayoutConstants.spacing).isActive = true
    }
    
    private func setupBinding() {
        viewModel.onLoadingStateChange = { [weak self] isLoading in
            
        }
        
        viewModel.onPokemonDetailLoad = { [weak self] presentableModel in
            self?.title.text = presentableModel.name
            self?.contentView.backgroundColor = presentableModel.types.first?.color
        }
        
        viewModel.onImageLoad = { [weak self] image in
            self?.imageView.image = image
        }
        
        viewModel.onErrorState = { [weak self] error in
            
        }
    }
}
