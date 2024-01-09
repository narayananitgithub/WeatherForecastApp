//
//  RoundedView.swift
//  WeatherForecastApp
//
//  Created by Narayanasamy on 09/01/24.
//

import Foundation
import UIKit


class CircularView : UIView{
    
    // MARK: - layoutSubviews
    override func layoutSubviews() {
        super.layoutSubviews()
        // Make the view circular
        layer.cornerRadius = bounds.width / 2
        layer.masksToBounds = true
    }
}
