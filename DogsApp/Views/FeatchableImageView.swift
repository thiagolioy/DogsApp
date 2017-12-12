//
//  FeatchableImageView.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import UIKit
import SnapKit

protocol FetchableImageViewDelegate: class {
    func didStartFetch()
    func didEndFetch()
}

final class FetchableImageView: UIView {
    
    var currentImage: String {
        return imagesPull[currentImageIndex]
    }
    
    var imagesPull: [String] {
        didSet {
            fetchImage(on: currentImageIndex)
        }
    }
    fileprivate(set) var currentImageIndex = 0 {
        didSet {
            fetchImage(on: currentImageIndex)
        }
    }
    
    weak var delegate: FetchableImageViewDelegate?
    var imageFetchable: ImageFetchable?
    
    lazy fileprivate var imageView: UIImageView = {
        let view = UIImageView(frame: .zero)
        view.isUserInteractionEnabled = true
        swipeGestures().forEach {
            view.addGestureRecognizer($0)
        }
        return view
    }()
    
    init(imageFetchable: ImageFetchable = KFImageFetchable(),
         delegate: FetchableImageViewDelegate? = nil,
         imagesPull: [String] = []) {
        self.imageFetchable = imageFetchable
        self.delegate = delegate
        self.imagesPull = imagesPull
        super.init(frame: .zero)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("Not implemented in view code")
    }
    
}

extension FetchableImageView {
    func fetchImage(on currentIndex: Int) {
        let image = imagesPull[currentImageIndex]
        delegate?.didStartFetch()
        imageFetchable?.fetch(imageURL: image, onImage: imageView) {
            self.delegate?.didEndFetch()
        }
    }
}

extension FetchableImageView {
    fileprivate func swipeGestures() -> [UIGestureRecognizer] {
        let swipeRight = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeOnImage(_:))
        )
        swipeRight.direction = .right
        
        let swipeLeft = UISwipeGestureRecognizer(
            target: self,
            action: #selector(swipeOnImage(_:))
        )
        swipeLeft.direction = .left
        
        return [swipeLeft, swipeRight]
    }
    
    @objc
    func swipeOnImage(_ gesture: UIGestureRecognizer) {
        guard let gesture = gesture as? UISwipeGestureRecognizer else {
            return
        }
        var newValue = currentImageIndex
        if gesture.direction == .left {
            newValue = currentImageIndex + 1
        } else if gesture.direction == .right {
            newValue = currentImageIndex - 1
        }
        
        if newValue < 0 || newValue >= imagesPull.count {
            return
        }
        
        currentImageIndex = newValue
    }
}

extension FetchableImageView: CodeView {
    func buildHierarchy() {
        addSubview(imageView)
    }
    
    func buildConstraints() {
        imageView.snp.makeConstraints { make in
            make.edges.equalTo(self)
        }
    }
}
