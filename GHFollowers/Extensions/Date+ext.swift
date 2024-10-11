//
//  Date+ext.swift
//  GHFollowers
//
//  Created by Adarsh Singh on 06/10/24.
//

import UIKit

extension Date{
    
//    func convertToMonthYear() -> String{
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMM d, yyyy"
//       
//        return dateFormatter.string(from: self)
//    }
    
    func convertToMonthYear() -> String{
       
        return formatted(.dateTime.day().month().year())
    }
}
