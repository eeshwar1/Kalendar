//
//  CalendarView.swift
//  Kalendar
//
//  Created by Venkateswaran Venkatakrishnan on 7/3/20.
//

import Cocoa

enum Size {
    case small
    case normal
    case large
}

class CalendarView: NSView {

    fileprivate var dayNames: [String] = ["Su","Mo","Tu","We","Th","Fr","Sa"]
    
    var width = 300
    var height = 300
    
    var cellWidth = 30
    var cellHeight = 30
    var cellSpacing = 5
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override var intrinsicContentSize: NSSize {
        
        NSSize(width: width, height: height)
    }
    convenience init(size: Size = .normal) {
        
        var width = 0
        var height = 0
        
        switch size {
            case .small:
                width = 150
                height = 150
            case .normal:
                width = 200
                height = 200
            case .large:
                width = 300
                height = 300
        }
        
        self.init(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        self.width = width
        self.height = height
    }
    
    func commonInit() {
      
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.gray.cgColor
        self.layer?.borderWidth = 3
        let currentMonth = CalendarMonth(month: 08, year: 2020)
        
        setConstraints()
        
        var row = 0
        var col = 0
        
        let viewBounds = self.bounds
        let calendarBounds = viewBounds.insetBy(dx: 5, dy: 5)
        cellWidth = Int(calendarBounds.width/7)
        cellHeight = Int(calendarBounds.height/7)
        cellSpacing = Int(calendarBounds.height/50)
        
        // title row
        for day in dayNames {
            let titleView = DateView(frame: NSRect(x: Int(calendarBounds.minX) + col * cellWidth, y: Int(calendarBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight))
            titleView.setTitle(title: day)
            self.addSubview(titleView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
            
        }
        
        var prevMonthIndex = 0
        let prevMonthDatesLastIndex = currentMonth.prevMonthDates.count - 1
        var prevMonthDateIndex = 0
        
        for _ in (0..<currentMonth.firstDayOfMonthWeekDay - 1)
        {
            let dateView = DateView(frame: NSRect(x: Int(calendarBounds.minX) + col * cellWidth, y: Int(calendarBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight))
            
            prevMonthDateIndex = prevMonthDatesLastIndex - (currentMonth.firstDayOfMonthWeekDay -  prevMonthIndex - 2)
            dateView.setDate(date: currentMonth.prevMonthDates[prevMonthDateIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            self.addSubview(dateView)
            
            col = col + 1
            prevMonthIndex = prevMonthIndex + 1
        }
      
        for date in currentMonth.dates {
            
            let dateView = DateView(frame: NSRect(x: Int(calendarBounds.minX) + col * cellWidth, y: Int(calendarBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight))
            
            dateView.setDate(date: date)
            self.addSubview(dateView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
        }
        
        // print("col = \(col)")
        var nextMonthIndex = 0
        while (col < 7) {
            
            let dateView = DateView(frame: NSRect(x: Int(calendarBounds.minX) + col * cellWidth, y: Int(calendarBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight))
            
            dateView.setDate(date: currentMonth.nextMonthDates[nextMonthIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            self.addSubview(dateView)
            col = col + 1
            nextMonthIndex = nextMonthIndex + 1
        }
    }

    func setConstraints() {
 
        self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    
}
