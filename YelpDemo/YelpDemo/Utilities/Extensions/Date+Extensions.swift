//
//  Date+Extensions.swift
//  YelpAppDemo
//
//  Created by Trick Gorospe on 8/13/21.
//

import Foundation

extension Date {
    func dayNumberOfWeek() -> Int? {
        return Calendar.current.dateComponents([.weekday], from: self).weekday
    }
}
