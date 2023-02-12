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
        static let spacing: CGFloat = 8
        static let titleFontSize: CGFloat = 18
        static let subtitleFontSize: CGFloat = 14
    }
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: LayoutConstants.titleFontSize)
        return label
    }()
    
    private lazy var subtitleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: LayoutConstants.subtitleFontSize)
        return label
    }()
    
    private lazy var activityIndicator = UIActivityIndicatorView(style: .medium)
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupSubviews()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        setRoundedLayout()
    }
    
    private func setupSubviews() {
        let stackView = UIStackView(
            arrangedSubviews: [
                titleLabel,
                imageView,
                subtitleLabel
            ]
        )
        addSubview(stackView)
        
        stackView.spacing = LayoutConstants.spacing
        stackView.alignment = .center
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        stackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        
        setupImageView()
        addSubview(activityIndicator)
        setupActivityIndicator()
    }
    
    private func setupImageView() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func setupActivityIndicator() {
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
        
        viewModel?.onPokemonDetailLoad = { [weak self] in
            self?.titleLabel.text = self?.viewModel?.title
            self?.contentView.backgroundColor = self?.viewModel?.backgroundColor
            self?.subtitleLabel.text = self?.viewModel?.subtitle
        }
        
        viewModel?.onImageLoad = { [weak self] image in
            self?.imageView.image = image
        }
        
        viewModel?.onErrorState = { [weak self] error in
            self?.titleLabel.text = error.localizedDescription
        }
    }
    
    func clean() {
        titleLabel.text = nil
        imageView.image = nil
        contentView.backgroundColor = .clear
    }
}
