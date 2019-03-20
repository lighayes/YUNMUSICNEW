//
//  ZViewController.swift
//  YunMusic
//
//  Created by lighayes on 2019/3/16.
//  Copyright © 2019 lighayes. All rights reserved.
//

import UIKit

class ZViewController:UIViewController{
    
    
    private var navStack:[UINavigationController] = []
    
    static let shared = ZViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.backgroundDark
        setupNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    private func setupNavigationBar() {
//        if let navBar = navStack.last?.navigationBar {
//            navBar.isTranslucent = false
//            navBar.tintColor = UIColor.backgroundDark
//            navBar.backgroundColor=UIColor.backgroundDark
//        }
        let backBtn = UIBarButtonItem(image: UIImage(named: "back"), style: .plain, target: self, action: #selector(back))
        self.navigationItem.leftBarButtonItem = backBtn
        backBtn.width = -5
        backBtn.tintColor = UIColor.snow
        
        
    }
    
    @objc func back(){
        self.navigationController?.popViewController(animated: true)
    }
    
//    func dissmiss(_ vc:UIViewController, animated:Bool = true) {
//        if let nav = vc.navigationController {
//            if nav.viewControllers.count > 1 {
//                nav.popViewController(animated: animated)
//            } else {
//                nav.dismiss(animated: animated)
//                if  navStack.count > 1 {
//                    navStack.removeLast()
//                }
//            }
//        } else {
//            vc.dismiss(animated: animated)
//        }
//    }
//
//    func presentPlayViewController(song:String,singer:String){
//        let vc=PlayViewController()
//        navStack.last?.pushViewController(vc, animated: true)
//        vc.song=song
//        vc.singer=singer
//    }
    
}
