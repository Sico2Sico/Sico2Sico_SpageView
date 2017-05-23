
//
//  STitleView.swift
//  SicoZB
//
//  Created by 吴德志 on 2017/5/23.
//  Copyright © 2017年 Sico2Sico. All rights reserved.
//

import UIKit

protocol STitleViewDelegate: class {

    func titleView(_ titlview : STitleView, targetIndex: Int)
}

class STitleView: UIView {
    
    weak var deleagte : STitleViewDelegate?
    
    fileprivate var titles :[String]
    fileprivate var style : STitleStyle
    fileprivate lazy var  currentIndex : Int = 0
    
    fileprivate lazy var titleLabels : [UILabel] = [UILabel]()
    fileprivate lazy var  scrollview :UIScrollView = {
        
        let  scrollView = UIScrollView(frame:self.bounds)
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        return scrollView
    }()
    

    init(frame: CGRect  ,titles:[String] ,style:STitleStyle) {
        self.titles = titles
        self.style = style
        super.init(frame: frame)
        setUpUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}



// MARK:- U设置
extension STitleView {
    
    fileprivate func setUpUI(){
        //1  将UISCrollView 添加到TitleVIew中
        addSubview(scrollview)
        
        //2 将titelLLabel添加到UISCrollView 中
        setUpTitelLabels()
        
        //3 设置titleLabel的frame
        setuptitleLabelsFrame()
    
    }
    
    
    private func setUpTitelLabels(){
        for (i,title) in titles.enumerated() {
            
            let  titleLabel = UILabel()
            titleLabel.text = title
            titleLabel.tag = i
            titleLabel.textAlignment = .center
            titleLabel.textColor = i==0 ? style.selectColor:style.normalColor
            titleLabel.font = UIFont.systemFont(ofSize: style.fontSize)
            
//            titleLabel.layer.borderColor = UIColor.orange.cgColor
//            titleLabel.layer.borderWidth = 1.0
//            titleLabel.layer.cornerRadius = 2.0
//            titleLabel.layer.masksToBounds = true
//            titleLabel.backgroundColor = UIColor.gray
            
            scrollview.addSubview(titleLabel)
            titleLabels.append(titleLabel)
        
            let  tapCes = UITapGestureRecognizer(target: self, action: #selector(titleLabelClick(_:)))
            titleLabel.addGestureRecognizer(tapCes)
            titleLabel.isUserInteractionEnabled = true
        }
    }
    
    private func setuptitleLabelsFrame(){
        
        let  count = titles.count
        
        let h :CGFloat = bounds.height
        let y :CGFloat = 0
        
        for (i, label) in titleLabels.enumerated() {
            
            var w:CGFloat = 0
            var x:CGFloat = 0
            if style.isScrollEnable {//可以滚动的布局
                w = (titles[i] as NSString).boundingRect(with:CGSize(width: CGFloat(MAXFLOAT), height: 0) , options: .usesLineFragmentOrigin, attributes: [NSFontAttributeName: label.font], context: nil).width
                
                if i == 0 {
                    x = style.itemMargin * 0.5
                    
                    if style.isShowSCrollLine {
                        
                    }
                }else{
                
                    let preLabel = titleLabels[i-1]
                    x = preLabel.frame.maxX + style.itemMargin
                }
            }else{//不能滚动布局
                w = bounds.width/CGFloat(count)
                x = w*CGFloat(i)
            }
            
            label.frame = CGRect(x:x,y: y, width: w, height: h)
        }
        
        scrollview.contentSize = style.isScrollEnable ? CGSize(width: titleLabels.last!.frame.maxX + style.itemMargin*0.5, height: 0):CGSize.zero
        
    }
    
    
}



// MARK:- 点击事件
extension STitleView{
    
    @objc fileprivate func titleLabelClick(_ tagGes:UITapGestureRecognizer){
        
        // 1  取出用户点击的View
        let  targetLabel = tagGes.view as! UILabel
        
        //2 调整title
        adjustTitleLabel(targetIndex: targetLabel.tag)
        
        //3  通知代理  
        deleagte?.titleView(self, targetIndex: targetLabel.tag)
    
        
    }
    
    
    fileprivate func adjustTitleLabel(targetIndex : Int){
    
        // 1 判断是否点击当前选中的UILabel
        if targetIndex == currentIndex {return}
        
        // 2 取出Label
        let taegetLabel = titleLabels[targetIndex]
        let sourceLabel = titleLabels[currentIndex]
        
        // 3 切换颜色
        taegetLabel.textColor = style.selectColor
        sourceLabel.textColor = style.normalColor
        
        // 4 记录下标值
        currentIndex = targetIndex
        
        // 5 调整位置
        if style.isScrollEnable {
            
            var offSetx = taegetLabel.center.x - scrollview.bounds.width*0.5
            if offSetx < 0{
                offSetx = 0
            }
            
            if offSetx > (scrollview.contentSize.width - scrollview.bounds.width) {
                offSetx = scrollview.contentSize.width - scrollview.bounds.width
            }
            scrollview.setContentOffset( CGPoint(x: offSetx, y: 0), animated: false)
            
        }
    }

}


// MARK:- SContentViewDelegate
extension STitleView : SContentViewDelegate{

    func contentView(_ contentview: SContentView, targetIndex: Int) {
        adjustTitleLabel(targetIndex: targetIndex)
    }
    
    func contentView(_ contentView: SContentView, targetIndex: Int, pargress: CGFloat) {
        
        // 1 取出Label
        let  targetLabel = titleLabels[targetIndex]
        let  sourceLabel = titleLabels[currentIndex]
        
        //2颜色渐变
        let  deltaRGB = UIColor.getRGBDelta(firstColor: style.selectColor, seccondColor: style.normalColor)
        let  selectRGB = style.selectColor.getRGB()
        let  normalRGB = style.normalColor.getRGB()
        targetLabel.textColor = UIColor(r: normalRGB.0 + deltaRGB.0*pargress, g: normalRGB.1 + deltaRGB.1*pargress, b: normalRGB.2 + deltaRGB.2*pargress)
        sourceLabel.textColor = UIColor(r: selectRGB.0 - deltaRGB.0*pargress, g: selectRGB.1 - deltaRGB.1*pargress, b: selectRGB.2 - deltaRGB.2*pargress)

        
        
    }
}





