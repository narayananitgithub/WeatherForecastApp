//
//  ForecastTableViewCell.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 01/01/24.
//

import UIKit

class ForecastTableViewCell: UITableViewCell {
    
    
    
    @IBOutlet weak var todayLbl: UILabel!
    @IBOutlet weak var tmrwlbl: UILabel!
    @IBOutlet weak var cloudyLbl: UILabel!
    
   
    @IBOutlet weak var degLbl: UILabel!
    @IBOutlet weak var degLbl2: UILabel!
    @IBOutlet weak var degLbl3: UILabel!
    
    @IBOutlet weak var forecastBtn: UIButton!{
        didSet {
                self.forecastBtn.layer.cornerRadius = 10
                self.forecastBtn.layer.masksToBounds = true
            }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    @IBAction func onClickForcastBtn(_ sender: UIButton) {
        
    }
    

    @IBAction func onClickTodaybtn(_ sender: UIButton) {
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
