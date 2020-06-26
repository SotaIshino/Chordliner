//
//  TableViewCell.swift
//  Chordliner
//
//  Created on 2020/06/19.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    public var chordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String!) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        chordLabel = UILabel()
        chordLabel.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height / 2)
        chordLabel.textAlignment = .center
        self.accessoryView = chordLabel
    }

}
