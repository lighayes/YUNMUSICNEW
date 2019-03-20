//
//  File.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/16.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
protocol backDelegate {
    func backToTable(number:Int)
}
class MusicTableView: UITableView,UITableViewDelegate,UITableViewDataSource,backDelegate {
    
    
    var musicTable:[String]=["111","goodday","win","haoyunlai"]
    var singerTable:[String]=["a","bbbbbbb.bbb","dkjfskdjf","jiaozijie"]
    var musicArry:Array<Music>?
    var isPlaying:Int?
    
    func backToTable(number: Int) {
        isPlaying = number
        self.selectRow(at: NSIndexPath(row: isPlaying!, section: 0) as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (musicArry?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MusicTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell")as?MusicTableViewCell
        cell.setUp()
//        cell.songName.text=musicTable[indexPath.row]
//        cell.number.text="\(indexPath.row)"
//        cell.singerName.text=singerTable[indexPath.row]
        cell.songName.text=musicArry?[indexPath.row].song
        cell.number.text="\(indexPath.row)"
        cell.singerName.text=musicArry?[indexPath.row].singer
        cell.selectedBackgroundView = UIView(frame: cell.bounds)
        cell.selectedBackgroundView?.layer.borderColor = UIColor.rose.cgColor
        cell.selectedBackgroundView?.layer.borderWidth = 7
        return cell
        
    }
    
    
    
    func nextresponsder(viewself:UIView)->UIViewController{
        var vc:UIResponder = viewself
        
        while vc.isKind(of: UIViewController.self) != true {
            vc = vc.next!
        }
        return vc as! UIViewController
    }
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        ZViewController.shared.presentPlayViewController(song: musicTable[indexPath.row], singer: singerTable[indexPath.row])
//        HomeViewController().navigationController?.pushViewController(PlayViewController(), animated: true)
//    var window = UIApplication.shared.keyWindow
//        let root = window?.rootViewController
        let root = nextresponsder(viewself: self)
        let vc=PlayViewController()
        root.navigationController?.pushViewController(vc, animated: true)
        if indexPath.row == isPlaying {
            vc.isPlaying = false
        }
        vc.nowNum = indexPath.row
        vc.delegate = self
        self.deselectRow(at: indexPath, animated: true)
        
        print("ok")
    }
    
    func setUp()
    {   musicArry=Music.getMusic()
       self.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
        self.delegate=self
        self.dataSource=self
        self.rowHeight=50
        
    }
}
