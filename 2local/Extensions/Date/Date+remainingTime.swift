//
//  Date+remainingTime.swift
//  2local
//
//  Created by Ebrahim Hosseini on 5/30/21.
//  Copyright © 2021 2local Inc. All rights reserved.
//

import Foundation

extension Date {
    
    func timeAgoSinceNow() -> String {
        
        // From Time
        let fromDate = self
        
        // To Time
        let toDate = Date()
        
        // Estimation
        // Year
        if let interval = Calendar.current.dateComponents([.year], from: fromDate, to: toDate).year, interval > 0  {
            if interval == 1 {
                return "\(interval)\("year")"
            } else {
                return "\(interval)\("years")"
            }
        }
        
        // Month
        if let interval = Calendar.current.dateComponents([.month], from: fromDate, to: toDate).month, interval > 0  {
            if interval == 1 {
                return "\(interval)\("month")"
            } else {
                return "\(interval)\("months")"
            }
        }
        
        // Day
        if let interval = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day, interval > 0  {
            return "\(interval)d"
        }
        
        // Hours
        if let interval = Calendar.current.dateComponents([.hour], from: fromDate, to: toDate).hour, interval > 0 {
            return interval == 1 ? "\(interval) hour" : "\(interval) hours"
        }

        // Minute
        if let interval = Calendar.current.dateComponents([.minute], from: fromDate, to: toDate).minute, interval > 0 {
            return interval == 1 ? "\(interval) minute" : "\(interval) minutes"
        }
        
        return "Today"
    }
    
}
