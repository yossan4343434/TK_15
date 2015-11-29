//
//  VSSound.swift
//  Visy
//
//  Created by Yoshiyuki Kuga on 2015/11/28.
//  Copyright © 2015年 TK_15. All rights reserved.
//

import Foundation
import SwiftyJSON

class VSSound {

    var time: Double
    var item: String
    var type: String


    init(time: Double, item: String, type:String) {
        self.time = time
        self.item = item
        self.type = type
    }

}
