//
//  CustomCell.swift
//  CalendarPOC
//
//  Created by Bhargav Vasist on 19/06/18.
//  Copyright © 2018 Bhargav Vasist. All rights reserved.
//

import UIKit
import JTAppleCalendar

class CustomCell: JTAppleCell {

    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var selectedView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
