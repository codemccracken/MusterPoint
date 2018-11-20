//
//  modelCellTableViewCell.swift
//  MusterPoint
//
//  Created by Eric McCracken on 11/10/18.
//  Copyright © 2018 Eric McCracken. All rights reserved.
//

import UIKit

class modelCellTableViewCell: UITableViewCell {
    @IBOutlet weak var modelImage: UIImageView!
    @IBOutlet weak var modelNickname: UILabel!
    @IBOutlet weak var modelName: UILabel!
    @IBOutlet weak var codexName: UILabel!
    @IBOutlet weak var modelOption1: UILabel!
    @IBOutlet weak var modelOption2: UILabel!
    @IBOutlet weak var modelOption3: UILabel!
    @IBOutlet weak var modelOption4: UILabel!
    
    var models = [Model]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
