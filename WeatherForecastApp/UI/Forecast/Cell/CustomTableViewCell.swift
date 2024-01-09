//
//  CustomTableViewCell.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 02/01/24.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var tempdegreeLbl: UILabel!
    
  
    @IBOutlet weak var hazeLbl: UILabel!
    
    @IBOutlet weak var airqualitybtn: UIButton!{
        didSet{
            self.airqualitybtn.layer.cornerRadius = 10
            self.airqualitybtn.layer.masksToBounds = true
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
