//
//  AQIndexClassification.swift
//  AQMonitorTests
//

import UIKit

enum AQIndexClassification {
    case good
    case satisfactory
    case moderate
    case poor
    case veryPoor
    case severe
    case outOfRange
}

class AQIndexClassifier {
    static func classifyAQIndex(aqi: Float) -> AQIndexClassification {
        switch aqi {
        
        case 0...50:
            return .good
        
        case 51...100:
            return .satisfactory
        
        case 101...200:
            return .moderate
        
        case 201...300:
            return .poor
        
        case 301...400:
            return .veryPoor
        
        case 401...500:
            return .severe
        
        default:
            return .outOfRange
        }
    }
    
    static func getAQLevel(index: AQIndexClassification) -> String {
        switch index {
        case .good:
            return "Good"
        case .satisfactory:
            return "Satisfactory"
        case .moderate:
            return "Moderate"
        case .poor:
            return "Poor"
        case .veryPoor:
            return "Very Poor"
        case .severe:
            return "Severe"
        case .outOfRange:
            return "Out Of Range"
        }
    }

}

struct AQIndexColorClassifier {
    static func color(index: AQIndexClassification) -> UIColor {
        switch index {
       
        case .good:
            return UIColor(hexString: "#55A84F")
            
        case .satisfactory:
            return UIColor(hexString: "#A3C853")
            
        case .moderate:
            return UIColor(hexString: "#FCF834")
            
        case .poor:
            return UIColor(hexString: "#EE9A32")
            
        case .veryPoor:
            return UIColor(hexString: "#DE3B30")
            
        case .severe:
            return UIColor(hexString: "#A72B22")
            
        case .outOfRange:
            return UIColor(hexString: "#A72B22")
            
        }
    }
}

extension UIColor {
    convenience init(hexString: String, alpha: CGFloat = 1.0) {
        let hexString: String = hexString.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)

        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }

        var color: UInt32 = 0
        scanner.scanHexInt32(&color)

        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask

        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0

        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
}
