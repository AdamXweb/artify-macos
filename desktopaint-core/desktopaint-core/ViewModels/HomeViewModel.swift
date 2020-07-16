//
//  HomeViewModel.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/16/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation

protocol HomeViewModelType {

    var input: HomeViewModelInput { get }
    var output: HomeViewModelOutput { get }
}

protocol HomeViewModelInput {

}

protocol HomeViewModelOutput {

}

final class HomeViewModel: HomeViewModelType, HomeViewModelInput, HomeViewModelOutput {

    var input: HomeViewModelInput { return self }
    var output: HomeViewModelOutput { return self }

    // MARK: - Init
    init() {

    }
}
