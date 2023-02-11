//
//  PokemonListCell.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonListCell: UICollectionViewCell {
    var viewModel: PokemonListCellViewModel? {
        didSet {
            setupBinding()
            viewModel?.loadDetail()
        }
    }
    
    enum LayoutConstants {
        static let spacing: CGFloat = 12
        static let fontSize: CGFloat = 20
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var title: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: LayoutConstants.fontSize)
        return label
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedLayout()
    }
    
    private func setupSubviews() {
        let stackView = UIStackView(arrangedSubviews: [imageView, title])
        stackView.spacing = LayoutConstants.spacing
        stackView.alignment = .center
        stackView.axis = .vertical
        
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(activityIndicator)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupBinding() {
        viewModel?.onLoadingStateChange = { [weak self] isLoading in
            if isLoading {
                self?.activityIndicator.startAnimating()
            } else {
                self?.activityIndicator.stopAnimating()
            }
        }
        
        viewModel?.onPokemonDetailLoad = { [weak self] presentableModel in
            self?.title.text = presentableModel.name
            self?.contentView.backgroundColor = presentableModel.types.first?.color.withAlphaComponent(0.25)
        }
        
        viewModel?.onImageLoad = { [weak self] image in
            self?.imageView.image = image
        }
        
        viewModel?.onErrorState = { [weak self] error in
            self?.title.text = error.localizedDescription
        }
    }
    
    func clean() {
        title.text = nil
        imageView.image = nil
        contentView.backgroundColor = .clear
    }
}
