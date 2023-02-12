//
//  PokemonDetailViewController.swift
//  Pokedex
//
//  Created by Anne Kariny Silva Freitas on 11/02/23.
//

import UIKit

final class PokemonDetailViewController: UIViewController {
    private let scrollView = UIScrollView()
    private let imageBackgroundView = UIView()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let heightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: LayoutConstants.fontSize)
        return label
    }()
    
    private let weightLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: LayoutConstants.fontSize)
        return label
    }()
    
    private var statusBarView: UIView?
    
    private enum LayoutConstants {
        static let fontSize: CGFloat = 16
        static let progressFontSize: CGFloat = 12
        static let spacing: CGFloat = 8
        static let stackSpacing: CGFloat = 24
        static let imageViewSize: CGFloat = 150
        static let imageBackgroundViewSize: CGFloat = 200
        static let labelStatsHeight: CGFloat = 16
    }
    
    private let viewModel: PokemonDetailViewModel
    
    init(viewModel: PokemonDetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = viewModel.title
        view.backgroundColor = .systemBackground
        setupSubviews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavigationController(isAppearing: true)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        setupNavigationController(isAppearing: false)
    }
    
    private func setupNavigationController(isAppearing: Bool) {
        if isAppearing {
            let color = viewModel.backgroundColor
            navigationController?.navigationBar.backgroundColor = color
            
            if let statusBarView = navigationController?.makeStatusBarView(backgroundColor: color) {
                self.statusBarView = statusBarView
                navigationController?.view.addSubview(statusBarView)
            }
        } else {
            navigationController?.navigationBar.backgroundColor = .clear
            statusBarView?.removeFromSuperview()
            statusBarView = nil
        }
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
        typesStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: LayoutConstants.spacing).isActive = true
        
        let sizeInfoStackView = setupSizeInfoStackView()
        mainStackView.addArrangedSubview(sizeInfoStackView)
        sizeInfoStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: LayoutConstants.spacing).isActive = true
        
        let statsStackView = setStatsStackView()
        mainStackView.addArrangedSubview(statsStackView)
        statsStackView.leadingAnchor.constraint(equalTo: mainStackView.leadingAnchor, constant: LayoutConstants.spacing).isActive = true
        statsStackView.trailingAnchor.constraint(equalTo: mainStackView.trailingAnchor, constant: -LayoutConstants.spacing).isActive = true
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
        stackView.spacing = LayoutConstants.stackSpacing
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
        imageBackgroundView.backgroundColor = viewModel.backgroundColor
        imageView.image = viewModel.image
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: imageBackgroundView.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: imageBackgroundView.centerYAnchor).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageViewSize).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: LayoutConstants.imageViewSize).isActive = true
        
        imageBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        imageBackgroundView.heightAnchor.constraint(equalToConstant: LayoutConstants.imageBackgroundViewSize).isActive = true
        imageBackgroundView.leadingAnchor.constraint(equalTo: stackView.leadingAnchor).isActive = true
        imageBackgroundView.trailingAnchor.constraint(equalTo: stackView.trailingAnchor).isActive = true
    }
    
    private func setupTypesStackView() -> UIStackView {
        let labels = viewModel.types.map { makeLabel($0.type, with: $0.color ) }
        let stackView = UIStackView(arrangedSubviews: labels)
        stackView.axis = .horizontal
        stackView.spacing = LayoutConstants.stackSpacing
        return stackView
    }
    
    private func setStatsStackView() -> UIStackView {
        let baseStats = UILabel(frame: .zero)
        baseStats.text = viewModel.baseStats
        baseStats.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        
        var stats = viewModel.stats.map {
            makeProgressContentView(
                text: $0.stat,
                value: $0.value,
                maxValue: viewModel.maxStatValue
            )
        }
        
        let baseExpStat = makeProgressContentView(
            text: viewModel.baseExp,
            value: viewModel.baseExperience,
            maxValue: viewModel.maxExpValue
        )
        
        stats.append(baseExpStat)
        
        let statsStackView = UIStackView(arrangedSubviews: [baseStats] + stats)
        statsStackView.axis = .vertical
        statsStackView.spacing = LayoutConstants.spacing
        statsStackView.distribution = .fillEqually
        return statsStackView
    }
    
    private func makeLabel(_ text: String, with color: UIColor) -> UILabel {
        let label = UILabel()
        label.font = .systemFont(ofSize: LayoutConstants.fontSize)
        label.text = text
        label.tintColor = .label
        label.backgroundColor = color.withAlphaComponent(0.25)
        return label
    }
    
    private func setupSizeInfoStackView() -> UIStackView {
        let weight = UILabel(frame: .zero)
        weight.text = viewModel.weightLabel
        weight.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        weightLabel.text = viewModel.weight
        let weightStackView = UIStackView(arrangedSubviews: [weight, weightLabel])
        weightStackView.axis = .horizontal
        weightStackView.spacing = LayoutConstants.spacing
        weightStackView.alignment = .center
        
        let height = UILabel(frame: .zero)
        height.text = viewModel.heightLabel
        height.font = .boldSystemFont(ofSize: LayoutConstants.fontSize)
        heightLabel.text = viewModel.height
        let heightStackView = UIStackView(arrangedSubviews: [height, heightLabel])
        heightStackView.axis = .horizontal
        heightStackView.spacing = LayoutConstants.spacing
        heightStackView.alignment = .center
        
        let sizeInfoStackView = UIStackView(arrangedSubviews: [weightStackView, heightStackView])
        sizeInfoStackView.spacing = LayoutConstants.spacing
        sizeInfoStackView.axis = .vertical
        return sizeInfoStackView
    }
    
    private func makeProgressContentView(text: String, value: Int, maxValue: Int) -> UIStackView {
        let label = UILabel(frame: .zero)
        label.text = "\(text.uppercased()) (\(value)/\(maxValue))"
        label.font = .systemFont(ofSize: LayoutConstants.progressFontSize)
        
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = UIColor.systemBlue.withAlphaComponent(0.15)
        progressView.tintColor = UIColor.systemBlue.withAlphaComponent(0.5)
        progressView.progress = Float(value) / Float(maxValue)
        
        let stackView = UIStackView(arrangedSubviews: [label, progressView])
        stackView.axis = .horizontal
        stackView.spacing = LayoutConstants.spacing
        stackView.distribution = .fillEqually
        label.translatesAutoresizingMaskIntoConstraints = false
        label.heightAnchor.constraint(equalToConstant: LayoutConstants.labelStatsHeight).isActive = true
        return stackView
    }
}
