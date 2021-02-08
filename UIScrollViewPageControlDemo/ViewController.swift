//
//  ViewController.swift
//  UIScrollViewPageControlDemo
//
//  Created by Trista on 2021/2/8.
//

import UIKit

//UIScrollView 設置委任對象self：ViewController,所以為ViewController加上委任需要的協定 來實作委任方法
class ViewController: UIViewController, UIScrollViewDelegate {

    //建立三個屬性
    var myScrollView: UIScrollView!
    var mypageControl: UIPageControl!
    var fullSize :CGSize!
    
    //UIScrollView 設置委任對象self：ViewController來實作委任方法
    //滑動結束時
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //左右滑動到新頁時,更新UIPageControl 顯示的頁數
        //scrollView.contentOffset.x 則是目前滑動的水平距離
        //scroll view 設為分頁模式(isPagingEnabled 為 true)，當 scroll view 滑動結束時，它一定剛好停在某個分頁
        //當 func scrollViewDidEndDecelerating 被呼叫時，scrollView.contentOffset.x 將為分頁寬度的倍數
        let page = Int(scrollView.contentOffset.x / scrollView.frame.size.width)
        mypageControl.currentPage = page
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //取得螢幕的尺寸
        fullSize = UIScreen.main.bounds.size
        
        
        //建立 UIScrollView
        myScrollView = UIScrollView()

        //設置尺寸 也就是可見視圖範圍
        myScrollView.frame = CGRect(
          x: 0, y: 20,
          width: fullSize.width, height: fullSize.height - 20)

        //實際視圖範圍 是 整個頁面為 5 個螢幕尺寸大小
        myScrollView.contentSize = CGSize(
          width: fullSize.width * 5, height: fullSize.height - 20)

        //不顯示滑動條
        myScrollView.showsHorizontalScrollIndicator = false
        myScrollView.showsVerticalScrollIndicator = false

        //滑動超過範圍時使用彈回效果
        myScrollView.bounces = true

        //UIScrollView 設置委任對象self：ViewController來實作委任方法
        //設置委任對象
        myScrollView.delegate = self

        //以一頁為單位滑動
        myScrollView.isPagingEnabled = true

        //加入到畫面中
        self.view.addSubview(myScrollView)
        
        
        //建立用來顯示頁數的 UIPageControl
        //建立 UIPageControl 設置位置及尺寸
        mypageControl = UIPageControl(frame: CGRect(
          x: 0, y: 0, width: fullSize.width * 0.85, height: 50))
        mypageControl.center = CGPoint(
          x: fullSize.width * 0.5, y: fullSize.height * 0.85)

        //有幾頁 就是有幾個點
        mypageControl.numberOfPages = 5

        //起始預設的頁數
        mypageControl.currentPage = 0

        //目前所在頁數的點點顏色
        mypageControl.currentPageIndicatorTintColor =
            UIColor.black

        //其餘頁數的點點顏色
        mypageControl.pageIndicatorTintColor = UIColor.lightGray

        //增加一個值改變時的事件
        mypageControl.addTarget(
            self,action: #selector(ViewController.pageChanged),
            for: .valueChanged)

        //加入到基底的視圖中 (不是加到 UIScrollView 裡)
        //因為比較後面加入 所以會蓋在 UIScrollView 上面
        self.view.addSubview(mypageControl)
        
        
        //建立 5 個 UILabel 來顯示每個頁面內容
        var myLabel = UILabel()
        for i in 0...4 {
            myLabel = UILabel(frame: CGRect(
              x: 0, y: 0, width: fullSize.width, height: 40))
            myLabel.center = CGPoint(
              x: fullSize.width * (0.5 + CGFloat(i)),
              y: fullSize.height * 0.2)
            myLabel.font = UIFont(name: "Helvetica-Light", size: 48.0)
            myLabel.textAlignment = .center
            myLabel.text = "\(i + 1)"
            
            myScrollView.addSubview(myLabel)
        }
        
    }
    
    
    //點擊點點換頁
    @objc func pageChanged(sender: UIPageControl) {
        
        //依照目前圓點在的頁數算出位置
        var frame = myScrollView.frame
        frame.origin.x =
          frame.size.width * CGFloat(sender.currentPage)
        frame.origin.y = 0

        //再將 UIScrollView 滑動到該點
        myScrollView.scrollRectToVisible(frame, animated:true)
        
        /*
        //依據 page control 的 currentPage 計算 scroll view 要移動到的 offset
        let point = CGPoint(x: myScrollView.bounds.width * CGFloat(sender.currentPage), y: 0)
        myScrollView.setContentOffset(point, animated: true)
        */
        //iOS 14 version required or higher 開啟 page control 的拖曳功能
        mypageControl.allowsContinuousInteraction = true
        
    }


}

