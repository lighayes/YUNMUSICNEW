//
//  LikeListViewController.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/19.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit


class LikeListViewController: ViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        
        
        //table.getCoreData()

        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let table=LikeListTableView()
        table.getCoreData()
        table.setUp()
        table.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        table.backgroundColor=UIColor.backgroundDark
        self.view.addSubview(table)
        print("\(LikeListTableView.trueMusicArry.count)11")
        setupBar()
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func setupBar(){
        self.navigationItem.title = "LIKE"
    }
    
    
}
