//
//  CodeView.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import Foundation

protocol CodeView {
    func buildHierarchy()
    func buildConstraints()
    func configure()
    func setupView()
}

extension CodeView {
    func setupView() {
        buildHierarchy()
        buildConstraints()
        configure()
    }
    
    func configure() {}
}
