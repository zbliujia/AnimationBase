//
//  LDATabBarViewController.swift
//  WeiBo
//
//  Created by 李冬骜 on 14/12/5.
//  Copyright © 2014年 Dongao Li. All rights reserved.
//

import UIKit
import AVFoundation

class LDATabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //  调用自定义tabbar
        let ldaTabBar = LDATabBar()
        setValue(ldaTabBar, forKeyPath: "tabBar")
        //  定义闭包
        ldaTabBar.translucent = false;
        ldaTabBar.backgroundColor = UIColor.grayColor()
        ldaTabBar.addButtonClosure = { [weak self] in
            print("我被点了");
        }
        addChildViewController(ViewController1(), title: "控制器1")
        addChildViewController(ViewController2(), title: "控制器2")
        addChildViewController(ViewController3(), title: "控制器3")
        addChildViewController(ViewController4(), title: "控制器4")
    }

    //  MARK: - 添加子控制器
    private func addChildViewController(childController: UIViewController, title: String) {
        //  设置title
        childController.title = title
        //  更改title颜色
        childController.tabBarItem.setTitleTextAttributes([NSForegroundColorAttributeName : UIColor.orangeColor()], forState: .Selected)
        //  tabbar添加子控制器
        addChildViewController(LDANavigationController(rootViewController: childController))
    }

}

class LDANavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.whiteColor()
    }
}

class ViewController1: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
}

class ViewController2: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(backButton)
        view.addSubview(composeButton)
    }
    
    //  MARK: - 懒加载add按钮
    private lazy var composeButton: LDAButton = {
        //  初始化button
        let button = LDAButton()
        //  添加点击事件
        button.addTarget(self, action:#selector(ViewController2.didClickAddButton), forControlEvents:.TouchUpInside)
        //  设置背景图片
        button.setBackgroundImage(UIImage(named: "publish_btn_normal"), forState: .Normal)
        button.setBackgroundImage(UIImage(named: "publish_btn_highlighted"), forState: .Highlighted)
        //  设置大小
        button.frame = CGRect(x: 150, y: 150, width: 100, height: 100)
        
        return button
    }()
    
    private lazy var backButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 150, y: 150, width: 100, height: 100))
        button.addTarget(self, action:#selector(ViewController2.didClickBackButton), forControlEvents: .TouchUpInside)
        button.backgroundColor = UIColor.greenColor()
        return button
    }()
    
    //  点击按钮事件
    @objc private func didClickAddButton() {
        print("button被点了")
    }
    
    @objc private func didClickBackButton() {
        print("背景被点了")
    }

}

class ViewController3: UIViewController {
    
}

class ViewController4: UIViewController {
    
}

class LDAButton: UIButton {
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let center = CGPoint(x: CGRectGetWidth(bounds) * 0.5, y: CGRectGetHeight(bounds) * 0.5)
        return distanceBetweenPoints(point, point2: center) <= frame.size.width * 0.43
    }
    
    /// 计算两点间距离
    func distanceBetweenPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let distance1 = ((point1.x - point2.x) * (point1.x - point2.x) + (point1.y - point2.y) * (point1.y - point2.y))
        let distance2 = abs(distance1)
        return sqrt(distance2);
    }
}
