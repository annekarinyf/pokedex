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
    
    private let scrollView = UIScrollView()
    
    private lazy var imageBackgroundView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private lazy var numberLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        return label
    }()
    
    private lazy var heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    private lazy var weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()
    
    init(viewModel: PokemonDetailPresentableModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.name
        view.backgroundColor = .systemBackground
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        let mainStackView = UIStackView()
        mainStackView.axis = .vertical
        mainStackView.spacing = 16
        mainStackView.distribution = .fill
        mainStackView.alignment = .center
        
        scrollView.addSubview(mainStackView)
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        mainStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        mainStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        mainStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        mainStackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        
        imageBackgroundView.backgroundColor = viewModel.types.first?.color.withAlphaComponent(0.25)
        imageView.image = viewModel.image
        
        imageBackgroundView.addSubview(imageView)
        mainStackView.addArrangedSubview(imageBackgroundView)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageBackgroundView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor).isActive = true
        imageBackgroundView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor).isActive = true
        
        numberLabel.text = viewModel.number
        mainStackView.addArrangedSubview(numberLabel)
        
        let labels = viewModel.types.map { makeLabel($0.type, with: $0.color ) }
        let typesStackView = UIStackView(arrangedSubviews: labels)
        typesStackView.axis = .horizontal
        typesStackView.spacing = 8
        mainStackView.addArrangedSubview(typesStackView)
        
        let weight = UILabel(frame: .zero)
        weight.text = "WEIGHT"
        weight.font = .systemFont(ofSize: 16)
        weightLabel.text = viewModel.weight
        let weightStackView = UIStackView(arrangedSubviews: [weightLabel, weight])
        weightStackView.axis = .vertical
        weightStackView.spacing = 8
        weightStackView.alignment = .center
        
        let height = UILabel(frame: .zero)
        height.text = "HEIGHT"
        height.font = .systemFont(ofSize: 16)
        heightLabel.text = viewModel.height
        let heightStackView = UIStackView(arrangedSubviews: [heightLabel, height])
        heightStackView.axis = .vertical
        heightStackView.spacing = 8
        heightStackView.alignment = .center
        
        let sizeInfoStackView = UIStackView(arrangedSubviews: [weightStackView, heightStackView])
        sizeInfoStackView.spacing = 24
        mainStackView.addArrangedSubview(sizeInfoStackView)
        
        let baseStats = UILabel(frame: .zero)
        baseStats.text = "Base Stats"
        baseStats.font = .systemFont(ofSize: 24)
        let stats = viewModel.stats.map { makeProgressContentView(text: $0.stat, value: Float($0.value) / 100.0) }
        let statsStackView = UIStackView(arrangedSubviews: stats)
        statsStackView.axis = .vertical
        statsStackView.spacing = 8
        statsStackView.distribution = .fillEqually
        
        mainStackView.addArrangedSubview(statsStackView)
        statsStackView.translatesAutoresizingMaskIntoConstraints = false
        statsStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -8).isActive = true
    }
    
    private func makeLabel(_ text: String, with color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24)
        label.text = text
        label.tintColor = .label
        label.backgroundColor = color.withAlphaComponent(0.1)
        return label
    }
    
    private func makeProgressContentView(text: String, value: Float) -> UIStackView {
        let label = UILabel(frame: .zero)
        label.text = text.uppercased()
        label.font = .systemFont(ofSize: 12)
        
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        progressView.progress = value
        
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        stackView.axis = .horizontal
        stackView.spacing = 16
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 14).isActive = true
        return stackView
    }
}
