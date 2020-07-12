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
    
    var width: CGFloat = 0
    var height: CGFloat = 0
    var titleAreaHeight: CGFloat = 0
    
    var cellWidth = 30
    var cellHeight = 30
    var cellSpacing = 5
    
    var fontSize: CGFloat = 8
    
    var size: Size = .normal
    var buttonStackWidth: CGFloat = 50
    var buttonStackHeight: CGFloat = 30
    var titleStackHeight: CGFloat = 30
    var titleStackWidth: CGFloat = 100
    
    var titleBuffer: CGFloat = 20
    
    var calendarMonth: CalendarMonth = CalendarMonth()
    
    var todayDay: Int = 0
    var todayMonth: Int = 0
    var todayYear: Int = 0
    
    var displayMonth: Int = 0
    var displayYear: Int = 0
    
    var datesArea: NSView = NSView()
    
    var stackView: NSStackView = NSStackView()
    
    let monthLabel = NSTextField(labelWithString: "")
    
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
        
        var width: CGFloat = 0
        var height: CGFloat = 0
        var offset: CGFloat = 10
        
        switch size {
            case .small:
                width = 160
                offset = 12
            case .normal:
                width = 200
                offset = 14
            case .large:
                width = 250
                offset = 20
               
        }
        
        height = width + offset
        self.init(frame: NSRect(origin: CGPoint.zero, size: CGSize(width: width, height: height)))
        self.size = size
        
       
       
    }
    
    func commonInit() {
      
       
        self.width = self.bounds.width
        self.height = self.bounds.height
        
        self.wantsLayer = true
        self.layer?.borderColor = NSColor.gray.cgColor
        self.layer?.borderWidth = 3
        self.layer?.cornerRadius = 5
        
        
        setConstraints()
        
        setupCalendar()
        setupTitleArea()
        
        datesArea.frame =
        CGRect(origin: CGPoint(x: 0,y: 0), size: CGSize(width: self.bounds.width, height: self.bounds.height - titleAreaHeight - titleBuffer))
        stackView.addArrangedSubview(datesArea)
    
    }
    
    override func viewWillDraw() {
        
        displayCalendar()
        
    }
        
    func setupTitleArea() {
        
        switch size {
            case .small:
                fontSize = 9
                buttonStackWidth = 50
                buttonStackHeight = 12
                titleStackHeight = 12
                titleBuffer = 12
            case .normal:
                fontSize = 11
                buttonStackWidth = 60
                buttonStackHeight = 14
                titleStackHeight = 20
                titleBuffer = 20
            case .large:
                fontSize = 14
                buttonStackWidth = 60
                buttonStackHeight = 20
                titleStackHeight = 25
                titleBuffer = 20
        }

    
        let buttonNextMonth = VUButton(buttonType: .forwardArrow, size: self.size, toolTip: "Next Month")
        let buttonPrevMonth = VUButton(buttonType: .backwardArrow, size: self.size, toolTip: "Previous Month")
        let buttonToday = VUButton(buttonType: .circle, size: self.size, toolTip: "Today")
        let buttonNextYear = VUButton(buttonType: .forwardDoubleArrow, size: self.size, toolTip: "Next Year")
        let buttonPrevYear = VUButton(buttonType: .backwardDoubleArrow, size: self.size, toolTip: "Prev Year")
        
        
        buttonPrevYear.target = self
        buttonPrevYear.action = #selector(showPrevYear)
        
        buttonPrevMonth.target = self
        buttonPrevMonth.action = #selector(showPrevMonth)
        
        buttonToday.target = self
        buttonToday.action = #selector(showToday)
        
        buttonNextMonth.target = self
        buttonNextMonth.action = #selector(showNextMonth)
        
        
        buttonNextYear.target = self
        buttonNextYear.action = #selector(showNextYear)
        
        let titleStack = NSStackView()
        titleStack.orientation = .horizontal
        titleStack.alignment = .centerY
        titleStack.distribution = .equalSpacing
        titleStack.spacing = 5
    
        titleStack.addArrangedSubview(monthLabel)
    
        let buttonStack = NSStackView()
        buttonStack.orientation = .horizontal
        buttonStack.alignment = .centerY
        buttonStack.distribution = .equalSpacing
        buttonStack.spacing = 1
  
        
        buttonStack.addArrangedSubview(buttonPrevYear)
        buttonStack.addArrangedSubview(buttonPrevMonth)
        buttonStack.addArrangedSubview(buttonToday)
        buttonStack.addArrangedSubview(buttonNextMonth)
        buttonStack.addArrangedSubview(buttonNextYear)
        
        titleStack.addArrangedSubview(buttonStack)
        
        buttonStack.heightAnchor.constraint(equalToConstant: buttonStackHeight).isActive = true
        buttonStack.widthAnchor.constraint(lessThanOrEqualToConstant: buttonStackWidth).isActive = true
        buttonStack.trailingAnchor.constraint(equalTo: buttonStack.superview!.trailingAnchor, constant: 0).isActive = true
    
        stackView.orientation = .vertical
        stackView.distribution = .equalSpacing
        stackView.alignment = .centerX
        stackView.spacing = 5
        
        self.addSubview(stackView)
        stackViewConstraints()
        
        stackView.addArrangedSubview(titleStack)
        
        titleStack.translatesAutoresizingMaskIntoConstraints = false
        titleStack.heightAnchor.constraint(equalToConstant: titleStackHeight).isActive = true
        titleStack.widthAnchor.constraint(greaterThanOrEqualToConstant: titleStackWidth).isActive = true
        
        titleStack.topAnchor.constraint(equalTo: titleStack.superview!.topAnchor, constant: 2).isActive = true
    
        titleStack.leftAnchor.constraint(equalTo: titleStack.superview!.leftAnchor, constant: 5).isActive = true
        
        titleStack.rightAnchor.constraint(equalTo: titleStack.superview!.rightAnchor, constant: -10).isActive = true
          
        
    }
    
    func displayCalendar()
    {
        
        self.setToday()
        
        self.calendarMonth.setMonthAndYear(month: self.displayMonth,year: self.displayYear)
    
        self.monthLabel.stringValue = self.calendarMonth.monthAndYear

        setupDateViews()
        
    }
    
    func setupDateViews() {
    
        datesArea.subviews.removeAll()
        let datesBounds = datesArea.bounds
        
        // dates area constraints
        cellWidth = Int(datesBounds.width/7)
        cellHeight = Int(datesBounds.height/7)
        cellSpacing = Int(datesBounds.height/70)
        
        // title row
        var row = 0
        var col = 0
        for day in dayNames {
            let titleView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            titleView.setTitle(title: day)
            datesArea.addSubview(titleView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
            
        }
        
        var prevMonthIndex = 0
        let prevMonthDatesLastIndex = calendarMonth.prevMonthDates.count - 1
        var prevMonthDateIndex = 0
        
        for _ in (0..<calendarMonth.firstDayOfMonthWeekDay - 1)
        {
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            prevMonthDateIndex = prevMonthDatesLastIndex - (calendarMonth.firstDayOfMonthWeekDay -  prevMonthIndex - 2)
            dateView.setDate(date: calendarMonth.prevMonthDates[prevMonthDateIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            datesArea.addSubview(dateView)
            
            col = col + 1
            prevMonthIndex = prevMonthIndex + 1
        }
      
        for date in calendarMonth.dates {
            
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            dateView.setDate(date: date)
            
            if date == self.todayDay &&
                displayMonth == self.todayMonth &&
                displayYear == self.todayYear {
                dateView.isToday = true
            }
            datesArea.addSubview(dateView)
            col = col + 1
            if col >= 7 {
                col = 0
                row = row + 1
            }
        }
      
        var nextMonthIndex = 0
        while (col < 7) {
            
            let dateView = DateView(frame: NSRect(x: Int(datesBounds.minX) + col * cellWidth, y: Int(datesBounds.maxY) - (cellHeight + cellSpacing + row * cellHeight), width: cellWidth, height: cellHeight), size: self.size)
            
            dateView.setDate(date: calendarMonth.nextMonthDates[nextMonthIndex], isOtherMonth: true)
            dateView.isOtherMonth = true
            datesArea.addSubview(dateView)
            col = col + 1
            nextMonthIndex = nextMonthIndex + 1
        }
    }
    
    func setConstraints() {
 
        self.translatesAutoresizingMaskIntoConstraints = true
        
    }
    
    func stackViewConstraints() {
    
            
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.topAnchor.constraint(equalTo: stackView.superview!.topAnchor, constant: 1).isActive = true
        
        stackView.bottomAnchor.constraint(equalTo: stackView.superview!.bottomAnchor, constant: -1).isActive = true
        stackView.leftAnchor.constraint(equalTo: stackView.superview!.leftAnchor, constant: 2).isActive = true
        stackView.rightAnchor.constraint(equalTo: stackView.superview!.rightAnchor, constant: 2).isActive = true
   
    
    }
 
    // MARK:-  Actions
    
    @IBAction func showNextMonth(sender: NSButton) {
        
        var dateComponents = DateComponents()
        dateComponents.month = self.calendarMonth.month
        dateComponents.year = self.calendarMonth.year
        dateComponents.day  = 1
        
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        dateComponents.month = 1
        dateComponents.day = 0
        dateComponents.year = 0
        
        let nextMonthDate = calendar.date(byAdding: dateComponents, to: date)!
        
        let nextMonthDateMonth = calendar.component(.month, from: nextMonthDate)
        let nextMonthDateYear = calendar.component(.year, from: nextMonthDate)
        
        self.displayMonth = nextMonthDateMonth
        self.displayYear = nextMonthDateYear
        
        self.displayCalendar()
        
    }
    
    @IBAction func showPrevMonth(sender: NSButton) {
        
        var dateComponents = DateComponents()
        dateComponents.month = self.calendarMonth.month
        dateComponents.year = self.calendarMonth.year
        dateComponents.day  = 1
        
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        dateComponents.month = -1
        dateComponents.day = 0
        dateComponents.year = 0
        
        let prevMonthDate = calendar.date(byAdding: dateComponents, to: date)!
        
        let prevMonthDateMonth = calendar.component(.month, from: prevMonthDate)
        let prevMonthDateYear = calendar.component(.year, from: prevMonthDate)
        
        self.displayMonth = prevMonthDateMonth
        self.displayYear = prevMonthDateYear
        
        self.displayCalendar()
        
    }
    
    @IBAction func showPrevYear(sender: NSButton) {
        
        var dateComponents = DateComponents()
        dateComponents.month = self.calendarMonth.month
        dateComponents.year = self.calendarMonth.year
        dateComponents.day  = 1
        
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        dateComponents.month = 0
        dateComponents.day = 0
        dateComponents.year = -1
        
        let prevYearDate = calendar.date(byAdding: dateComponents, to: date)!
        
        let prevYearDateMonth = calendar.component(.month, from: prevYearDate)
        let prevYearDateYear = calendar.component(.year, from: prevYearDate)
        
        self.displayMonth = prevYearDateMonth
        self.displayYear = prevYearDateYear
        
        self.displayCalendar()
    }
    
    @IBAction func showNextYear(sender: NSButton) {
        
        var dateComponents = DateComponents()
        dateComponents.month = self.calendarMonth.month
        dateComponents.year = self.calendarMonth.year
        dateComponents.day  = 1
        
        let calendar = Calendar.current
        
        let date = calendar.date(from: dateComponents)!
        
        dateComponents.month = 0
        dateComponents.day = 0
        dateComponents.year = 1
        
        let nextYearDate = calendar.date(byAdding: dateComponents, to: date)!
        
        let nextYearDateMonth = calendar.component(.month,
                                                   from: nextYearDate)
        let nextYearDateYear = calendar.component(.year,
                                                  from: nextYearDate)
        
        self.displayMonth = nextYearDateMonth
        self.displayYear = nextYearDateYear
        
        self.displayCalendar()
    }
    @IBAction func showToday(sender: NSButton) {
        
        self.displayMonth = self.todayMonth
        self.displayYear = self.todayYear
        
        self.displayCalendar()
        
    }
    
    // MARK: - Calendar Functions
    
    func setupCalendar() {
        
        setToday()
        
        self.displayYear = self.todayYear
        self.displayMonth = self.todayMonth
        
        self.calendarMonth.setMonthAndYear(month: self.displayMonth,year: self.displayYear)
    }
    
    func setToday()
    {
        
         let today = Date()
         let calendar = Calendar.current
        
         let todayMonth = calendar.component(.month, from: today)
         let todayYear =  calendar.component(.year, from: today)
         let todayDay =  calendar.component(.day, from: today)
         
         self.todayMonth = todayMonth
         self.todayYear = todayYear
         self.todayDay = todayDay
         
    }
    
    
}
