//
//  ViewController.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/16.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit

class ViewController: ZViewController {
    
    

    override func viewDidAppear(_ animated: Bool) {
//        let table=MusicTableView()
//        table.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
//        table.backgroundColor=UIColor.backgroundDark
//        table.setUp()
//        self.view.addSubview(table)
//        setupBar()

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let table=MusicTableView()
        table.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        table.backgroundColor=UIColor.backgroundDark
        table.setUp()
        self.view.addSubview(table)
        setupBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func setupBar(){
        self.navigationItem.title="YunMusic"
        
        let addBtn = UIBarButtonItem(title: "play", style: .done, target: self, action: #selector(play))
        addBtn.width = -10
        addBtn.tintColor=UIColor.snow
        self.navigationItem.rightBarButtonItem = addBtn
        let loveBtn = UIBarButtonItem(image: UIImage(named: "storehouse"), style: .done, target: self, action: #selector(love))
        let playlist = UIBarButtonItem(title:"LIST",style: .done,target:self,action:#selector(list))
        playlist.tintColor=UIColor.snow
        loveBtn.tintColor=UIColor.snow//tintcolor是item的风格color 会帮你自动p图
        
        loveBtn.width = -5
        let gap = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil,
                                  action: nil)
        gap.width = 10;
        self.navigationItem.leftBarButtonItems = [loveBtn,gap,playlist]
    }
    
    @objc func play(){
        
    }
    
    @objc func list(){
        
    }
    
    @objc func love(){
        presentLikeListViewController()
    }
    
    func presentLikeListViewController() {
        let vc=LikeListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    


}

