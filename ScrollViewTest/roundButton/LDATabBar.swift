//
//  LDATabBar.swift
//  WeiBo
//
//  Created by 李冬骜 on 14/12/5.
//  Copyright © 2014年 Dongao Li. All rights reserved.
//

import UIKit

class LDATabBar: UITabBar {

    var addButtonClosure: (()->())?
    
    //  MARK: - 设置UI
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //  设置UI
    private func setupUI() {
        addSubview(composeButton)
    }

    //  MARK: - 懒加载add按钮
    private lazy var composeButton: UIButton = {
        //  初始化button
        let button = UIButton()
        //  添加点击事件
        button.addTarget(self, action:#selector(LDATabBar.didClickAddButton), forControlEvents:.TouchUpInside)
        //  设置背景图片
        button.setBackgroundImage(UIImage(named: "publish_btn_normal"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "publish_btn_highlighted"), forState: .Highlighted)
        //  设置大小
        button.frame.size = CGSizeMake(80, 80)
        
        return button
    }()
    
    //  点击按钮事件
    @objc private func didClickAddButton() {
        addButtonClosure?()
    }
    
    //  布局
    override func layoutSubviews() {
        super.layoutSubviews()
        //  设置compose按钮的中心
        composeButton.center = CGPoint(x: bounds.width * 0.5, y: bounds.height * 0.3)
        //  用于记录循环次数
        var count = CGFloat()
        //  计算宽度
        let itemWidth = bounds.width / 5
        //  遍历subview
        for item in subviews {
            //  判断
        if item.isKindOfClass(NSClassFromString("UITabBarButton")!) {
                //  计算x值
                let x = count * itemWidth
                //  设置frame
                item.frame = CGRect(x: x, y: 0, width: itemWidth, height: bounds.height)
                //  除了2, 每次循环计数加1
                count++
                if count == 2 {
                    count = 3
                }
            }
        }
    }
    
}
