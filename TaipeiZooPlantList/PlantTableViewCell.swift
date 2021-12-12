//
//  PlantTableViewCell.swift
//  TaipeiZooPlantList
//
//  Created by chunyili的Macbook Air on 2021/12/12.
//

import UIKit

class PlantTableViewCell: UITableViewCell {

    @IBOutlet weak var largeImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func handleData(with plant: Plant,_ row: Int,isSelected: Bool){
        self.largeImageView.setupImage(urlStr: plant.imageStr)
        self.titleLabel.text = plant.name
        self.subTitleLabel.text = "學名：\(plant.latinName)"
        self.locationLabel.text = "所在地點：\(plant.location)"
        self.descriptionLabel.text = plant.feature
        
        self.largeImageView.isHidden = !isSelected
        self.descriptionLabel.isHidden = !isSelected
    }
    
}
