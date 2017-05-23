//
//  ViewController.swift
//  SicoZB
//
//  Created by 吴德志 on 2017/5/23.
//  Copyright © 2017年 Sico2Sico. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
       view.backgroundColor = UIColor.white
        let titles = ["游戏", "娱乐", "趣玩", "美女", "颜值","游戏哇看到", "娱乐等我", "趣dw玩", "美打我女", "颜等我值"]
        let style = STitleStyle()
        style.isScrollEnable = true
        style.isShowSCrollLine = true
        
        var childVcs = [UIViewController]()
        for _ in 0..<titles.count {
            let vc = UIViewController()
            vc.view.backgroundColor = UIColor.randomColor()
            childVcs.append(vc)
        }
        
        let  spageView = SPageView(frame: CGRect(x: 0, y: 64, width:UIScreen.main.bounds.width, height: UIScreen.main.bounds.height-64)  , titles:titles, childVcs: childVcs, prentvc: self, style: style)
        view.addSubview(spageView)
    }

    
    
    

}

