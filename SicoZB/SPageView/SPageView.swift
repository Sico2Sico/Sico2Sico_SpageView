
//
//  SPageView.swift
//  SicoZB
//
//  Created by 吴德志 on 2017/5/23.
//  Copyright © 2017年 Sico2Sico. All rights reserved.
//

import UIKit

class SPageView: UIView {
    
    fileprivate var  titles: [String]
    fileprivate var  childVcs :[UIViewController]
    fileprivate var  parentVc : UIViewController
    fileprivate var  style : STitleStyle
    fileprivate var  titleView : STitleView!
    

    init(frame: CGRect ,titles:[String] ,childVcs:[UIViewController] , prentvc: UIViewController , style:STitleStyle) {
    
        self.titles = titles
        self.childVcs = childVcs
        self.parentVc = prentvc
        self.style = style
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}



// MARK:- 设置UI

extension SPageView{

    fileprivate func setupUI(){
    
        parentVc.automaticallyAdjustsScrollViewInsets = false
        // 设置 titleView
        setupTitleView()
        
        // 设置 ContentView
        setUpContentView()
               
    }
    
    fileprivate func setupTitleView(){
    let titleFrame = CGRect(x: 0, y: 0, width: bounds.width, height: style.titleHeight)
    titleView = STitleView(frame: titleFrame, titles: titles, style: style)
    addSubview(titleView)
    titleView.backgroundColor = UIColor.purple
    }
    
    fileprivate func setUpContentView(){
    
        let  scontentViewFrame = CGRect(x: 0, y:style.titleHeight , width:bounds.width, height:bounds.height-style.titleHeight)
        let scontentview = SContentView(frame: scontentViewFrame, childVcs: childVcs, parentvc: parentVc)
        titleView.deleagte = scontentview
        scontentview.delegate = titleView
        addSubview(scontentview)
    }

}



