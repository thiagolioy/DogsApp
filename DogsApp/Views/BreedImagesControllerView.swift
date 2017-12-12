//
//  BreedImagesControllerView.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
import SnapKit

protocol BreedImagesControllerViewDelegate: class {
    func didFavorite(image: String)
}

final class BreedImagesControllerView: UIView {
    lazy fileprivate var imageView: FetchableImageView = {
        let view = FetchableImageView(delegate: self)
        return view
    }()
    
    lazy fileprivate var loadingContainer: UIView = {
        let view = UIView(frame: .zero)
        return view
    }()
    
    lazy fileprivate var loading: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(frame: .zero)
        view.hidesWhenStopped = true
        view.activityIndicatorViewStyle = .gray
        return view
    }()
    
    lazy fileprivate var button: UIView = {
        let view = UIButton(frame: .zero)
        view.backgroundColor = .blue
        view.setTitle("favoritar", for: .normal)
        view.addTarget(self, action: #selector(didClickButton),
                       for: .touchUpInside)
        return view
    }()
    
    enum UIState {
        case initial
        case error
        case loading
        case ready([String])
    }
    
    var state: UIState = .initial {
        didSet {
            switch state {
            case .initial, .error:
                loading.stopAnimating()
            case .loading:
                loading.startAnimating()
            case .ready(let images):
                loading.stopAnimating()
                imageView.imagesPull = images
            }
        }
    }
    
    weak var delegate: BreedImagesControllerViewDelegate?
    
    init() {
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension BreedImagesControllerView: FetchableImageViewDelegate {
    func didStartFetch() {
        state = .loading
    }
    
    func didEndFetch() {
        state = .initial
    }
}

extension BreedImagesControllerView {
    @objc
    fileprivate func didClickButton() {
        let image = imageView.currentImage
        delegate?.didFavorite(image: image)
    }
}

extension BreedImagesControllerView: CodeView {
    func buildHierarchy() {
        addSubview(imageView)
        loadingContainer.addSubview(loading)
        addSubview(loadingContainer)
        addSubview(button)
    }
    
    func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.topMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(350)
        }
        
        loadingContainer.snp.makeConstraints { make in
            make.left.right.equalTo(self)
            make.top.equalTo(imageView.snp.bottom)
            make.bottom.equalTo(button.snp.top)
        }
        
        loading.snp.makeConstraints { make in
            make.height.width.equalTo(20)
            make.center.equalTo(loadingContainer)
        }
        
        button.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottomMargin)
            make.left.right.equalTo(self)
            make.height.equalTo(44)
        }
        
        
        
    }
    
    func configure() {
        backgroundColor = .white
    }
}
