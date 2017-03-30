//
//  ViewController.swift
//  Examples
//
//  Created by Gollum on 2017/3/30.
//  Copyright © 2017年 Gollum. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var wv: WhirligigView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urls = ["https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1491300454&di=7fce0a035fede3b96d67b804933a852d&imgtype=jpg&er=1&src=http%3A%2F%2Fa4.att.hudong.com%2F38%2F47%2F19300001391844134804474917734_950.png", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490779772693&di=a1e512e6ba1f9eff7325ae3ae329b3fe&imgtype=0&src=http%3A%2F%2Fimg5.poco.cn%2Fmypoco%2Fmyphoto%2F20080406%2F2985655120080406185234071.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490779773021&di=819c65ddce5bbbbd44b2325d8964d8e2&imgtype=0&src=http%3A%2F%2Fimage.ajunews.com%2Fcontent%2Fimage%2F2014%2F09%2F17%2F20140917102600112243.jpg", "https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1490779773022&di=de9a78b459c0084d5c42194e8c4fa508&imgtype=0&src=http%3A%2F%2Fimgsrc.baidu.com%2Fforum%2Fw%253D580%2Fsign%3Deb4ecc6249fbfbeddc59367748f1f78e%2F36cd4b2309f7905229c31a630ef3d7ca7acbd57c.jpg"]
        
        let titles = ["1234567890", "ABCDEFGHIJK", "000000123ABC456DEF", "AAAAA123ABC456DEF"]
        
//        pageControl.numberOfPages = urls.count
        wv.setItem(count: urls.count, withDuration: 3) { (idx) -> String in
            return urls[idx]
        }
        
        wv.selectedItem { (idx) in
            print("did Select Row at \(idx)")
        }
        
        wv.scrollToPage { [unowned self] (idx) in
            print("滚动到第\(idx)")
//            self.pageControl.currentPage = idx
//            self.pageTitleLabel.text = titles[idx]
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

