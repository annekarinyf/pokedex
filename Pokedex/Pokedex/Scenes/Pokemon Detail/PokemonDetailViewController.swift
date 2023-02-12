//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    private let viewModel: PokemonDetailPresentableModel
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
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "\(viewModel.number) - \(viewModel.name)"
        view.backgroundColor = .systemBackground
        setupSubviews()
    }
    
    private func setupSubviews() {
        view.addSubview(scrollView)
        setupScrollView()
        
        let mainStackView = UIStackView()
        scrollView.addSubview(mainStackView)
        setupMainStackView(mainStackView)
        
        imageBackgroundView.addSubview(imageView)
        mainStackView.addArrangedSubview(imageBackgroundView)
        setupImageBackground(on: mainStackView)

        let typesStackView = setupTypesStackView()
        mainStackView.addArrangedSubview(typesStackView)
        typesStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8).isActive = true
        
        let sizeInfoStackView = setupSizeInfoStackView()
        mainStackView.addArrangedSubview(sizeInfoStackView)
        sizeInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8).isActive = true
        
        let statsStackView = setStatsStackView()
        mainStackView.addArrangedSubview(statsStackView)
        statsStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: 8).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -8).isActive = true
    }
    
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
    }
    
    private func setupMainStackView(_ stackView: UIStackView) {
        stackView.axis = .vertical
        stackView.spacing = 24
        stackView.distribution = .fill
        stackView.alignment = .leading
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        stackView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
    }
    
    private func setupImageBackground(on stackView: UIStackView) {
        let color = viewModel.types.first?.color.withAlphaComponent(0.25)
        navigationController?.navigationBar.backgroundColor = color
        imageBackgroundView.backgroundColor = color
        imageView.image = viewModel.image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.heightAnchor.constraint(equalToConstant: 200).isActive = true
        imageBackgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        imageBackgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    private func setupTypesStackView() -> UIStackView {
        let labels = viewModel.types.map { makeLabel($0.type, with: $0.color ) }
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.spacing = 12
        return stackView
    }
    
    private func setStatsStackView() -> UIStackView {
        let baseStats = UILabel(frame: .zero)
        baseStats.text = "Base Stats"
        baseStats.font = .boldSystemFont(ofSize: 18)
        
        var stats = viewModel.stats.map { makeProgressContentView(text: $0.stat, value: $0.value, maxValue: 300) }
        
        let baseExpStat = makeProgressContentView(text: "exp", value: viewModel.baseExperience, maxValue: 1000)
        stats.append(baseExpStat)
        
        let statsStackView = UIStackView(arrangedSubviews: [baseStats] + stats)
        statsStackView.axis = .vertical
        statsStackView.spacing = 12
        statsStackView.distribution = .fillEqually
        return statsStackView
    }
    
    private func makeLabel(_ text: String, with color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: 20)
        label.text = text
        label.tintColor = .label
        label.backgroundColor = color.withAlphaComponent(0.25)
        return label
    }
    
    private func setupSizeInfoStackView() -> UIStackView {
        let weight = UILabel(frame: .zero)
        weight.text = "WEIGHT: "
        weight.font = .boldSystemFont(ofSize: 16)
        weightLabel.text = viewModel.weight
        let weightStackView = UIStackView(arrangedSubviews: [weight, weightLabel])
        weightStackView.axis = .horizontal
        weightStackView.spacing = 8
        weightStackView.alignment = .center
        
        let height = UILabel(frame: .zero)
        height.text = "HEIGHT: "
        height.font = .boldSystemFont(ofSize: 16)
        heightLabel.text = viewModel.height
        let heightStackView = UIStackView(arrangedSubviews: [height, heightLabel])
        heightStackView.axis = .horizontal
        heightStackView.spacing = 8
        heightStackView.alignment = .center
        
        let sizeInfoStackView = UIStackView(arrangedSubviews: [weightStackView, heightStackView])
        sizeInfoStackView.spacing = 8
        sizeInfoStackView.axis = .vertical
        return sizeInfoStackView
    }
    
    private func makeProgressContentView(text: String, value: Int, maxValue: Int) -> UIStackView {
        let label = UILabel(frame: .zero)
        label.text = "\(text.uppercased()) (\(value)/\(maxValue))"
        label.font = .systemFont(ofSize: 12)
        
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.backgroundColor = UIColor.systemGray.withAlphaComponent(0.5)
        progressView.progress = Float(value) / Float(maxValue)
        
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.distribution = .fillEqually
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: 16).isActive = true
        return stackView
    }
}
