//
//  LevelsViewModel.swift
//  Maria-Casino
//
//  Created by 1234 on 29.03.2023.
//
//

import UIKit

struct LevelsViewModel {
    let cellModels: [LevelCellModel]
}

struct LevelCellModel {
    let number: Int
    let isLocked: Bool
    let levelLabelText: String
    let levelStatusImage: UIImage?
    let alignment: Alignment
    let type: LevelType
    let isCompleted: Bool
}

enum Alignment {
    case left, right
}

enum LevelType {
    case normal, hard
}
