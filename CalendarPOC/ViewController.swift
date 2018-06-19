//
//  ViewController.swift
//  CalendarPOC
//
//  Created by Bhargav Vasist on 19/06/18.
//  Copyright © 2018 Bhargav Vasist. All rights reserved.
//

import UIKit
import JTAppleCalendar

class ViewController: UIViewController {
    
    
    @IBOutlet var daysStackView: [UILabel]!
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    
    var selectedMonthColor = UIColor(colorWithHexValue: 0x550252)
    var monthColor = UIColor(colorWithHexValue: 0x000000)
    var outsideMonthColor = UIColor(colorWithHexValue: 0x555555)
    var calendarDatesBackgroundColor = UIColor(colorWithHexValue: 0xECEAED)
    var calendarDaysBackgroundColor = UIColor(colorWithHexValue: 0x567BFF)
    var monthLabelColor = UIColor(colorWithHexValue: 0xECEAED)
    var yearLabelColor = UIColor(colorWithHexValue: 0xECEAED)
    var rangeSelectedDates: [Date] = []
    var testCalendar = Calendar.current
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCalendarView()
    }
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.allowsMultipleSelection = true
        calendarView.isRangeSelectionUsed = true
        calendarView.minimumInteritemSpacing = 0
        let panGensture = UILongPressGestureRecognizer(target: self, action: #selector(didStartRangeSelecting(gesture:)))
        panGensture.minimumPressDuration = 0.5
        calendarView.addGestureRecognizer(panGensture)
        calendarView.backgroundColor = calendarDatesBackgroundColor
    }
    func handleCellTextColor(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else { return }
        if cellState.isSelected{
            validCell.dateLabel.textColor = selectedMonthColor
        }
        else {
            if cellState.dateBelongsTo == .thisMonth {
                validCell.dateLabel.textColor = monthColor
                validCell.backgroundColor = UIColor(colorWithHexValue: 0x567BFF)
            } else {
                validCell.dateLabel.textColor = outsideMonthColor
                validCell.backgroundColor = UIColor(colorWithHexValue: 0x567BFF)
            }
        }
    }
    func handleCellSelection(cell: JTAppleCell?, cellState: CellState){
        guard let validCell = cell as? CustomCell else {return}
        switch cellState.selectedPosition() {
        case .full, .left, .right, .middle:
            validCell.selectedView.isHidden = false
            validCell.selectedView.backgroundColor = UIColor.yellow
            
        default:
            validCell.selectedView.isHidden = true
            validCell.selectedView.backgroundColor = nil
        }
    }
    @objc func didStartRangeSelecting(gesture: UILongPressGestureRecognizer) {
        let point = gesture.location(in: gesture.view!)
        rangeSelectedDates = calendarView.selectedDates
        if let cellState = calendarView.cellStatus(at: point) {
            let date = cellState.date
            if !rangeSelectedDates.contains(date) {
                let dateRange = calendarView.generateDateRange(from: rangeSelectedDates.first ?? date, to: date)
                for aDate in dateRange {
                    if !rangeSelectedDates.contains(aDate) {
                        rangeSelectedDates.append(aDate)
                    }
                }
                calendarView.selectDates(from: rangeSelectedDates.first!, to: date, keepSelectionIfMultiSelectionAllowed: true)
            } else {
                let indexOfNewlySelectedDate = rangeSelectedDates.index(of: date)! + 1
                let lastIndex = rangeSelectedDates.endIndex
                let followingDay = testCalendar.date(byAdding: .day, value: 1, to: date)!
                calendarView.selectDates(from: followingDay, to: rangeSelectedDates.last!, keepSelectionIfMultiSelectionAllowed: false)
                rangeSelectedDates.removeSubrange(indexOfNewlySelectedDate..<lastIndex)
            }
        }
        
        if gesture.state == .ended {
            rangeSelectedDates.removeAll()
        }
    }
}

extension ViewController: JTAppleCalendarViewDataSource {
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        
    }
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let formatter = DateFormatter()
        formatter.timeZone = Calendar.current.timeZone
        formatter.locale = Calendar.current.locale
        formatter.dateFormat = "dd MM yyyy"
        let startDate = formatter.date(from: "16 06 2018")!
        let endDate = formatter.date(from: "31 12 2018")!
        let parameters =  ConfigurationParameters(startDate: startDate, endDate: endDate, calendar: testCalendar)
        return parameters
    }
}

extension ViewController: JTAppleCalendarViewDelegate {
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell =  calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        cell.dateLabel.text = cellState.text
        handleCellSelection(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
        return cell
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        handleCellSelection(cell: cell, cellState: cellState)
        handleCellTextColor(cell: cell, cellState: cellState)
    }
}

extension UIColor {
    convenience init(colorWithHexValue value: Int, alpha:CGFloat = 1.0){
        self.init(
            red: CGFloat((value & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((value & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(value & 0x0000FF) / 255.0,
            alpha: alpha
        )
    }
}


