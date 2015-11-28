//
//  VSMovieListCell.swift
//  Visy
//
//  Created by Yoshiyuki Kuga on 2015/11/28.
//  Copyright © 2015年 TK_15. All rights reserved.
//

import UIKit

class VSMovieListCell: UITableViewCell {

    @IBOutlet weak var movieImageView: UIImageView!
    @IBOutlet weak var movieTitleLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    class func cellHeight() -> CGFloat {
        return 240
    }
    
}
