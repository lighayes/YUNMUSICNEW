//
//  MusicPlayer.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/17.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer

final class MusicPlayer: NSObject {
    private static var instance:AVAudioPlayer? = nil
    private static var nowMusic:Music? = nil
    private var delegate:AVAudioPlayerDelegate?
    static func create(model:Music) -> Bool{
        
        do{
            try instance = AVAudioPlayer(contentsOf: model.musicURL!)
            
            
        }catch{
            instance=nil
            print("error")
            return false
        }
        instance?.play()
        nowMusic=model
        return true
    }
    
    static func isPlaying() -> Bool{
        return (instance?.isPlaying)!
    }
    
    static func stop(){
        instance?.stop()
    }
    
    static func play()->Bool{
        if(instance?.isPlaying)!{
            instance?.pause()
            return false
        }
        else{
            instance?.play()
            return true
        }
    }
    
    static func pause(){
        instance?.pause()
    }
    
    static func progress()->Double{
        return (instance?.currentTime)!/(instance?.duration)!
    }
    
    static func duration()->String{
        return self.translate(inBox: (instance?.duration)!)
    }
    
    static func currentTime()->String{
        return self.translate(inBox: (instance?.currentTime)!)
    }
    
    static func doubleDuration()->Double{
        return (instance?.duration)!
    }
    
    static func setCurrent(time:Double){
        instance?.currentTime = time
    
    }
    
    
    static func translate(inBox:Double) -> String{
        var text:String = ""
        let all:Int = Int(inBox)
        let sec = all%60
        let min = all/60
        if sec < 10{
            text+="0\(min):0\(sec)"
        }
        else{
            text+="0\(min):\(sec)"
        }
        return text
    }
}
