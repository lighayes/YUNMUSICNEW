//
//  MusicTableViewCell.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/16.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
class MusicTableViewCell: UITableViewCell {
    let songName=UILabel()
    let singerName=UILabel()
    let number=UILabel()
    func setUp(){
        let wid=50
        
        songName.frame=CGRect(x: wid, y: 0, width: Int(CGFloat(UIScreen.main.bounds.width/3*2)), height: wid/3*2)
        singerName.frame=CGRect(x: wid, y: wid/3*2, width: Int(UIScreen.main.bounds.width/3*2), height: wid/3*1)
        number.frame=CGRect(x: 0, y: 0, width: wid, height: wid)
        number.backgroundColor=UIColor.black
        number.textColor=UIColor.snow
        number.text="0"
        number.textAlignment = .center
        self.backgroundColor=UIColor.backgroundDark
        self.addSubview(number)
        self.addSubview(singerName)
        self.addSubview(songName)
    }
}
