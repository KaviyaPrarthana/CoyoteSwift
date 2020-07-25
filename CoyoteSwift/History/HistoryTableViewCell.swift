//
//  HistoryTableViewCell.swift
//  CoyoteSwift
//
//  Created by Kaviya Prarthana on 21/08/19.
//  Copyright © 2019 Kaviya Prarthana. All rights reserved.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {

    @IBOutlet var drivelbl: UILabel!
    @IBOutlet var exceededspeed: UILabel!
 
    @IBOutlet var location: UILabel!
    
    @IBOutlet var datetime: UILabel!
    
    @IBOutlet var speedlimit: UILabel!
    
    @IBOutlet var limitlbl: UILabel!
    
   //et responsponseShared = responseData.responseShared
    let shared = CommonClass.shared
   
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
       
}
