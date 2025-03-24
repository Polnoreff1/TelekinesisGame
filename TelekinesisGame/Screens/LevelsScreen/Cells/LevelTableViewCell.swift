//
//  LevelTableViewCell.swift
//  Maria-Casino iOS
//
//  Created by 1234 on 29.03.2023.
//

import UIKit

final class LevelTableViewCell: UITableViewCell {

    @IBOutlet private weak var levelCellBG: UIImageView!
    @IBOutlet private weak var levelLabel: UILabel!
    @IBOutlet private weak var levelStatusImageView: UIImageView!
    
    @IBOutlet weak var rewardLabel: UILabel!
    @IBOutlet weak var coinImageView: UIImageView!
    @IBOutlet weak var levelRewardBG: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selectionStyle = .none
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

    }

    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    func setup(with viewModel: LevelCellModel) {
        levelStatusImageView.image = viewModel.levelStatusImage
        levelLabel.text = "Level " + viewModel.levelLabelText
        if UserDefaults.standard.bool(forKey: "is\(viewModel.number)GameLevelCompleted") {
            rewardLabel.isHidden = true
            coinImageView.isHidden = true
            levelRewardBG.isHidden = true
        } else {
            rewardLabel.isHidden = false
            coinImageView.isHidden = false
            levelRewardBG.isHidden = false
            rewardLabel.text = "\(viewModel.number)00"
        }
        
        if viewModel.isLocked {
            levelStatusImageView.image = viewModel.levelStatusImage
        } else {
            switch viewModel.type {
            case .normal:
                levelStatusImageView.image = UIImage(named: "normalLevelIcon")
            case .hard:
                levelStatusImageView.image = UIImage(named: "hardLevelIcon")
            }
        }
    }
}
