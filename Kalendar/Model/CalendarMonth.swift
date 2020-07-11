//
//  CalendarMonth.swift
//  Temporal2
//
//  Created by Venky Venkatakrishnan on 6/25/18.
//  Copyright © 2018 Venky UL. All rights reserved.
//

import Cocoa

class CalendarMonth: NSObject {
    
    fileprivate let weekdayNames = ["Su","Mo","Tu","We","Th","Fr","Sa"]
    
    var month: Int?
    var year: Int?
    
    var monthAndYear: String = ""
    
    var firstDateOfMonth: Date = Date()
    var lastDateOfMonth: Date = Date()
    var dates: [Int] = []
    var prevMonthDates: [Int] = []
    var nextMonthDates: [Int] = []
    var lastDayOfMonth: Int = 31
    var firstDayOfMonthWeekDay: Int = 1
    var lastDayOfMonthWeekDay: Int = 1
    
    required override init()
    {
        super.init()
        let date = Date()
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let year = calendar.component(.year, from: date)
        self.setMonthAndYear(month: month, year: year)
        
    
        
    }
        
    required init(month: Int, year: Int) {        
        
        super.init()
        
        self.setMonthAndYear(month: month, year: year)
        
        self.fillCalendar()
        
    }
    
    func setMonthAndYear(month: Int, year: Int)
    {
        self.month = month
        self.year = year

       
        self.fillCalendar()
    }
    
    func fillCalendar()
    {
        let calendar = Calendar.current
        
        var dateComponents: DateComponents = DateComponents()
        
        dateComponents.day = 1
        dateComponents.month = self.month
        dateComponents.year = self.year
        
        // print("month = \(String(describing: self.month))")
        
        self.firstDateOfMonth = calendar.date(from: dateComponents)!
        
        dateComponents.month! = self.month!  + 1
        
        dateComponents.day = 0
        
        self.lastDateOfMonth = calendar.date(from: dateComponents)!
        
        self.lastDayOfMonth = calendar.component(.day,
                                                 from: self.lastDateOfMonth)
        
        self.dates = Array(1...self.lastDayOfMonth)
        
        dateComponents.month! = self.month! + 2
        
        let lastDateOfNextMonth = calendar.date(from: dateComponents)!
        
        let lastDayOfNextMonth = calendar.component(.day, from: lastDateOfNextMonth)
        
        // print("Month: \(String(describing: self.month))")
        
        // print("Next Month \(lastDateOfNextMonth) \(lastDayOfNextMonth)")
        
        
        self.nextMonthDates = Array(1...lastDayOfNextMonth)
        
        
        dateComponents.day = 0
        
        dateComponents.month! = self.month!
        
        let lastDateOfPrevMonth = calendar.date(from: dateComponents)!
        
        let lastDayOfPrevMonth = calendar.component(.day, from: lastDateOfPrevMonth)
        
        // print("Prev Month \(lastDateOfPrevMonth) \(lastDayOfPrevMonth)")
        
        self.prevMonthDates = Array(1...lastDayOfPrevMonth)
        
        self.firstDayOfMonthWeekDay = calendar.component(.weekday, from: self.firstDateOfMonth)
        
        self.lastDayOfMonthWeekDay = calendar.component(.weekday, from: self.lastDateOfMonth)
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMMM yyyy"
        
        self.monthAndYear = dateFormatter.string(from: self.firstDateOfMonth)
    }
    func printCalendar()
    {
        
        let titleStr = self.monthAndYear
        
        print(titleStr)
        
        
        var str = ""
        for day in 0..<weekdayNames.count
        {
            str = str + weekdayNames[day] + " "
        }
        
        print(str)
        
        
        var dateStr = ""
        
        for _ in 1..<self.firstDayOfMonthWeekDay
        {
            dateStr = dateStr + "   "
        }
        
        var dayStr = ""
        
        var dayNum = 1
        
        for day in self.firstDayOfMonthWeekDay...7
        {
            
            if day < 10
            {
                dayStr = " " + String(describing: dayNum)
            }
            else
            {
                dayStr = String(describing: dayNum)
            }
            dateStr = dateStr + dayStr + " "
            dayNum += 1
        }
        
        print(dateStr)
        
        dateStr = ""
        var dayCount = 0
        while dayNum <= self.lastDayOfMonth {
            
            if dayNum < 10
            {
                dayStr = " " + String(describing: dayNum)
            }
            else
            {
                dayStr = String(describing: dayNum)
            }
            dateStr = dateStr + dayStr + " "
            
            dayCount = dayCount + 1
            if dayCount == 7
            {
                print(dateStr)
                dayCount = 0
                dateStr = ""
            }
            dayNum = dayNum + 1
            
            
        }
        print(dateStr)

    }
    


}
