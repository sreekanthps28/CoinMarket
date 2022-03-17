//
//  Utilities.swift
//  MyCrypto
//
//  Created by SREEKANTH PS on 17/03/2022.
//

import Foundation


/// We can create different helping methods for this application here
class Utilities{
    
    /// This method is using to insert grouping seperator to the double value.
    static func df2so(_ price: Double) -> String{
            let numberFormatter = NumberFormatter()
            numberFormatter.groupingSeparator = ","
            numberFormatter.groupingSize = 3
            numberFormatter.usesGroupingSeparator = true
            numberFormatter.decimalSeparator = "."
            numberFormatter.numberStyle = .decimal
            numberFormatter.maximumFractionDigits = 2
            return numberFormatter.string(from: price as NSNumber)!
        }

}

// MARK: - Extensions

extension Double {
    /// this method is using to Convert Sceientific Notation value to string
    func toString(decimal: Int = 9) -> String {
        let value = decimal < 0 ? 0 : decimal
        var string = String(format: "%.\(value)f", self)

        while string.last == "0" || string.last == "." {
            if string.last == "." { string = String(string.dropLast()); break}
            string = String(string.dropLast())
        }
        return string
    }
}
