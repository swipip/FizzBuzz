//
//  StatCell.swift
//  FizzBuzz
//
//  Created by Gautier Billard on 01/09/2021.
//

import UIKit

class StatCell: UICollectionViewCell, Reusable {
    static var reuseId = "StatCell"
    
    @IBOutlet weak var formName: UILabel!
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var gaugeWidth: NSLayoutConstraint!
    
    private (set) var form: Form?
    
    /**
     Setter for the **form** parameter along with its ranked and the highest ranking.
     Highest ranking is used to compute the gauge width
     - Parameter form: The **Form** object
     - Parameter hits: The current form ranking
     - Parameter maxHits: The highest ranking of the forms
     */
    func setForm(_ form: Form, hits: Int, maxHits: Int) {
        self.form = form
        formName.text = form.name
        rankLabel.text = "\(hits)"
        gaugeWidth.constant = frame.width * CGFloat(hits) / CGFloat(maxHits) * 0.9
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.systemGray5.cgColor
    }
}
