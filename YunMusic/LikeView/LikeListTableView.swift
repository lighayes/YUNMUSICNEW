//
//  LikeListTableView.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/20.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit
import CoreData
class LikeListTableView: MusicTableView {
    
   
    static var trueMusicArry:[Music] = []
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:MusicTableViewCell! = tableView.dequeueReusableCell(withIdentifier: "MusicTableViewCell")as?MusicTableViewCell
        cell.setUp()
        //        cell.songName.text=musicTable[indexPath.row]
        //        cell.number.text="\(indexPath.row)"
        //        cell.singerName.text=singerTable[indexPath.row]
        cell.songName.text=LikeListTableView.trueMusicArry[indexPath.row].song
        cell.number.text="\(indexPath.row)"
        cell.singerName.text=LikeListTableView.trueMusicArry[indexPath.row].singer
        cell.selectedBackgroundView = UIView(frame: cell.bounds)
        cell.selectedBackgroundView?.layer.borderColor = UIColor.rose.cgColor
        cell.selectedBackgroundView?.layer.borderWidth = 7
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return LikeListTableView.trueMusicArry.count
    }
    
    override func backToTable(number: Int) {
        isPlaying = number
        if let temp = self.musicArry[number].row {
        self.selectRow(at: NSIndexPath(row: self.musicArry[number].row!, section: 0) as IndexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
        }
    }
    
    override func setUp()
    {   //musicArry=Music.getMusic()
        for i in LikeListTableView.trueMusicArry{
            print("yyy\(i.musicNum)")
            
        }
        print("\(LikeListTableView.trueMusicArry.count)")
        self.register(MusicTableViewCell.self, forCellReuseIdentifier: "MusicTableViewCell")
        
        
                self.delegate=self
                self.dataSource=self
                
            
        
        
        self.rowHeight=50
        
        
        
    }
    
    
    func getCoreData(){
        let appDelegate = UIApplication.shared.delegate as!AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "MusicNumber")
        //fetchRequest.predicate = NSPredicate(format: "num = \(nowNum)","" )
        var tempArry:[Music] = []
        let asyncFetchRequest = NSAsynchronousFetchRequest(fetchRequest: fetchRequest) {
            (result:NSAsynchronousFetchResult!) in
            let fetchObject = result.finalResult! as! [MusicNumber]
            
            var tempNum = fetchObject.count
            
            for i in fetchObject{
                let temp = Int(i.num - 1)
                tempNum = tempNum - 1
                if  temp >= 0{
                    tempArry.append(self.musicArry[temp])
                    self.musicArry[temp].row = tempNum
                }
            }
            LikeListTableView.trueMusicArry = tempArry.reversed()
            for i in LikeListTableView.trueMusicArry{
                print("zz\(i.musicNum)")
            }
//            for i in tempArry{
//                print("yyyyy\(i.musicNum)")
//            }
//            for i in self.trueMusicArry{
//                print("\(i.musicNum)")
//            }
        }
        do {
            try context.execute(asyncFetchRequest)
        }catch {
            print("error")
        }
        self.reloadData()
        
    }
}
