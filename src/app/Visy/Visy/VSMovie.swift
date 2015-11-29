//
//  VSMovie.swift
//  Visy
//
//  Created by Yoshiyuki Kuga on 2015/11/28.
//  Copyright © 2015年 TK_15. All rights reserved.
//

import UIKit

class VSMovie: NSObject {

    var youtubeId: String
    var title: String
    var thumbnail: UIImage
    var emotion: Dictionary<String, [NSTimeInterval]>
    var person: Dictionary<String, [NSTimeInterval]>

    init(youtubeId: String) {
        self.youtubeId = youtubeId

        let urlString = "https://i.ytimg.com/vi/" + youtubeId + "/mqdefault.jpg"
        let srcUrl = NSURL(string: urlString)
        let data = NSData(contentsOfURL: srcUrl!)
        self.thumbnail = UIImage(data: data!)!

        // TODO: youtubeIdをサーバーに渡して個別のtitle, scene, personを取得するように実装
        self.title = "ラグビー日本vs南アフリカ"

        self.emotion = [
            "exciting": [], // ダミー
            "laughing": [210, 300, 320], // ダミー
        ]

        self.person = [
            // "goroumaru"の出現時間に関するデータは"src/python/extract_goromaru_deeplearning_face.py"の出力結果を用いています。
            "goroumaru": [386, 641, 866, 3041, 3551, 3891, 4421, 4831],
            "yamada": [44, 55, 66], // ダミー
            "tanaka": [4, 15, 26] //ダミー
        ]
    }

}
