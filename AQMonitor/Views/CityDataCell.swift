//
//  CityDataCell.swift
//  AQMonitor
//

import UIKit

class CityDataCell: UITableViewCell {

    @IBOutlet var lblCity: UILabel?
    @IBOutlet var lblAQI: UILabel?
    @IBOutlet var lblStatus: UILabel?
    @IBOutlet var lblLastUpdated: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        lblAQI?.layer.cornerRadius = 5
        lblAQI?.layer.masksToBounds = true
    }

    var cityData: CityDataModelData? {
        didSet {
            guard let cityData = cityData else { return }
            lblCity?.text = cityData.city
            
            if let aqi = cityData.history.last?.value {
                lblAQI?.text = String(format: "%.2f", aqi)
            }
            
            if let aqi = cityData.history.last?.value {
                let index = AQIndexClassifier.classifyAQIndex(aqi: aqi)
                lblAQI?.backgroundColor = AQIndexColorClassifier.color(index: index)
                lblStatus?.text = AQIndexClassifier.getAQLevel(index: index)
            }
            
            if let date = cityData.history.last?.date {
                if date.timeAgo() == "0 seconds" {
                    lblLastUpdated?.text = "just now"
                } else {
                    lblLastUpdated?.text = date.timeAgo() + " ago"
                }                
            }
            
            self.accessibilityLabel = cityData.city
            self.accessibilityIdentifier = cityData.city
            self.accessibilityTraits = [.button]
        }
    }
}

extension Date {
    func timeAgo() -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .full
        formatter.allowedUnits = [.year, .month, .day, .hour, .minute, .second]
        formatter.zeroFormattingBehavior = .dropAll
        formatter.maximumUnitCount = 1
        return String(format: formatter.string(from: self, to: Date()) ?? "", locale: .current)
    }
}
