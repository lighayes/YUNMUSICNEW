//
//  Music.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/17.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
import AVFoundation
//import MediaPlayer

class Music:NSObject{
    var song:String?
    var singer:String?
    var musicURL:URL?
    var musicIMG:String?
    var musicNum:Int?
    var row:Int?
    //var songLyrics:
    
    
    //unknown sentence
    private static var musicArry:Array<Music>? = nil
    
    static func getMusic()->Array<Music>{
        if musicArry == nil {
//            let thing = MPMediaQuery()
//            let mediaItems = thing.items
            var tempArr = Array<Music>()
            var num=0
            var songName:[String] = ["粒粒皆辛苦","宝贝对不起","冷暖风铃","令我倾心只有你","无声胜有声","相思河畔","千千阙歌","富士山下","好久不见"]
            var singerName:[String] = ["阿细","草蜢","陈百强","陈百强","陈百强","陈百强","陈慧娴","陈奕迅","陈奕迅"]
//            for song in mediaItems!{
//                let tempModel = Music()
//
//                tempModel.song = song.value(forProperty: MPMediaItemPropertyTitle) as! String
//                tempModel.singer=song.value(forProperty: MPMediaItemPropertyArtist) as! String
//                tempModel.musicURL=song.value(forProperty: MPMediaItemPropertyAssetURL) as! URL
////                tempModel.musicIMG=song.value(forProperty: MPMediaItemPropertyArtwork) as! Data
//                tempModel.musicNum=num
//                num = num+1
//                tempArr.append(tempModel)
//            }
            
            for i in 0 ... (songName.count-1) {
                let tempModel = Music()
                tempModel.song = songName[i]
                tempModel.singer = singerName[i]
                let path = Bundle.main.path(forResource: "\(singerName[i])-\(songName[i])", ofType: "mp3")
                tempModel.musicURL = URL(fileURLWithPath: path!)
                tempModel.musicNum = i
                tempModel.musicIMG = Bundle.main.path(forResource: "\(i)", ofType: "jpg")
                tempArr.append(tempModel)
                
            }
            musicArry = tempArr
            return musicArry!
        }
        else{
            return musicArry!
        }
    }
}
