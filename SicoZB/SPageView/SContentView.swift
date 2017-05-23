

//
//  SContentView.swift
//  SicoZB
//
//  Created by 吴德志 on 2017/5/23.
//  Copyright © 2017年 Sico2Sico. All rights reserved.
//

import UIKit

private let  KContentCellID = "KContentCellId"

protocol SContentViewDelegate :class {
    
    func contentView(_ contentview: SContentView, targetIndex:Int)
    func contentView(_ contentView: SContentView, targetIndex: Int , pargress: CGFloat)
    
}


class SContentView: UIView {
    
    weak var delegate : SContentViewDelegate?

    //是否禁止滚动
    fileprivate var isForbidScroll:Bool  = false
    //滚动开始位置
    fileprivate var startOffsetx: CGFloat =  0

    fileprivate var childVcs :[UIViewController]
    fileprivate var parentvc :UIViewController
    
    fileprivate lazy var collectionView :UICollectionView = {
        let  layout = UICollectionViewFlowLayout()
        layout.itemSize = self.bounds.size
        layout.minimumLineSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectonView = UICollectionView(frame:self.bounds , collectionViewLayout: layout)
        collectonView.dataSource  = self
        collectonView.delegate = self
        collectonView.bounces = false
        collectonView.scrollsToTop = false
        collectonView.showsHorizontalScrollIndicator = false
        collectonView.isPagingEnabled = true
        collectonView.register(UICollectionViewCell.self, forCellWithReuseIdentifier:KContentCellID)

        return collectonView
    }()
    
    init(frame: CGRect ,childVcs:[UIViewController], parentvc:UIViewController) {
        self.childVcs = childVcs
        self.parentvc = parentvc
        super.init(frame:frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK:- setUpUI

extension SContentView{

    fileprivate func setUpUI(){
        
        //1 将所有自控制器添加到父控制器中 
        for childvc in childVcs {
            parentvc.addChildViewController(childvc)
        }
        
        // 2 添加UICollectionVIew 展示类容
        addSubview(collectionView)
    
    }

}


//MARK:- dataSource & delegate
extension SContentView : UICollectionViewDelegate {
 
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        contentEndScroll()
        scrollView.isScrollEnabled = true
    }
    
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            contentEndScroll()
        }else{
            scrollView.isScrollEnabled = false
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isForbidScroll = false
        startOffsetx = scrollView.contentOffset.x
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        //0 判断和开始时的偏移量是否一致
        guard  startOffsetx != scrollView.contentOffset.x,!isForbidScroll else {return}
        
        //1 定义targetIndex／prpgress 
        var  targetIndex = 0
        var  progress : CGFloat = 0
        
        // 2 给targetIndex/progress 赋值
        let  currtentIndex = Int(startOffsetx / scrollView.bounds.width)
        
        // 3  判断左滑 还是 右滑
        if startOffsetx < scrollView.contentOffset.x{ //左
         targetIndex = currtentIndex + 1
            if targetIndex > childVcs.count - 1 {
                targetIndex = childVcs.count - 1
            }
            progress = (scrollView.contentOffset.x - startOffsetx) / scrollView.bounds.width
            
        }else{ //右滑
            targetIndex = currtentIndex - 1
            if targetIndex < 0{
                targetIndex = 0
            }
            progress = (startOffsetx - scrollView.contentOffset.x) / scrollView.bounds.width
        }
        
        // 4 通知代理
        delegate?.contentView(self, targetIndex: targetIndex, pargress: progress)
    }
    
    
    
    private func contentEndScroll(){
        // 0 判断是否是禁止状态
        guard  !isForbidScroll else {return}
        
        // 1 获取滚动到的位置
        let  currentIndex = Int(collectionView.contentOffset.x / collectionView.bounds.width)
        
        //2 通知titleView 进行调整
        
        delegate?.contentView(self, targetIndex: currentIndex)
    }
    

}

extension SContentView : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return childVcs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: KContentCellID, for: indexPath)
    
        for subview in cell.contentView.subviews{
            subview.removeFromSuperview()
        }
        
        let  chidvc = childVcs[indexPath.item]
        chidvc.view.frame = cell.contentView.bounds
        cell.contentView.addSubview(chidvc.view)
        return cell
    }

}


// MARK:-  设置StitleView的代理
extension SContentView: STitleViewDelegate{

    func titleView(_ titlview: STitleView, targetIndex: Int) {
        
        isForbidScroll = true
        let  indexpath = IndexPath(item: targetIndex, section:0)
        
        collectionView.scrollToItem(at: indexpath, at: .left, animated: false)
        
    }

}
