//
//  firstTableViewCell.swift
//  Teclado
//
//  Created by MCB-Air-036 on 11/04/20.
//  Copyright © 2020 IDmission. All rights reserved.
//

import UIKit

class firstTableViewCell: UITableViewCell {
    
    @IBOutlet weak var topLabel : UILabel!
    @IBOutlet weak var amountLabel : UILabel!
    @IBOutlet weak var beneficieryLabel : UILabel!
    @IBOutlet weak var dateLabel : UILabel!
    @IBOutlet weak var benficieryLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setData(history:History, status:Bool) -> firstTableViewCell{
        let font = UIFont(name: "SantanderText-Regular", size: 21.0)
        benficieryLabelHeight.constant = AppUtility.heightForView(text: history.beneficiary, font: font ?? UIFont.init(), width: beneficieryLabel.frame.size.width)
        
        if status {
            self.topLabel.text = "Último movimiento"
            self.topLabel.isHidden = false
        }else{
            self.topLabel.isHidden = true
        }
        
        self.amountLabel.text = "$" + history.amount.shownAmount()
        self.beneficieryLabel.text = history.beneficiary
        self.dateLabel.text = AppUtility.formatDate(mainDate: history.date, showDateFormat: "dd/MMMM/yy")
        return self
    }
    
}
