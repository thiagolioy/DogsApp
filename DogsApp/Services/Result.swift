//
//  Result.swift
//  DogsApp
//
//  Created by Thiago Lioy on 12/12/17.
//  Copyright © 2017 Thiago Lioy. All rights reserved.
//

import Foundation

enum Result<T, E: Error> {
    case success(T)
    case error(E)
}
