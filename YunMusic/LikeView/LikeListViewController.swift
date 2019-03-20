//
//  LikeListViewController.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/19.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit

class LikeListViewController: ZViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundDark
        setUp()
        // Do any additional setup after loading the view.
    }
    
    private func setUp(){
        self.navigationItem.title = "LIKE"
        
    }
}
