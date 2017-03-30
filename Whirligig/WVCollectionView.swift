//
//  CollectionView.swift
//  Whirligig
//
//  Created by Gollum on 2017/3/27.
//  Copyright © 2017年 Gollum. All rights reserved.
//

import UIKit
import Kingfisher

class WVCollectionView: UICollectionView {
    
    var numberOfItems: Int = 0
    
    var currentPage: Int = 0 {
        didSet {            
            pagingClosure?(currentPage)
        }
    }
    
    fileprivate var fakeNumberOfItems: Int {
        return numberOfItems <= 1 ? numberOfItems : numberOfItems * 100
    }
    
    var selectItemClosure: WCVChangeItemClosure? = nil
    var fetchItemClosure: WCVFetchItemClosure? = nil
    var pagingClosure: WCVChangeItemClosure? = nil
    var draggingClosure: WCVDraggingClosure? = nil

    // MARK: - Initialization
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        configCollectionView()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }    

    static func defaultCollectionView()-> WVCollectionView {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.scrollDirection = .horizontal
        
        let cv = WVCollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        return cv
    }
}

extension WVCollectionView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func configCollectionView() {
        register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        delegate = self
        dataSource = self
        isPagingEnabled = true
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        backgroundColor = UIColor.white
    }
    
    //MARK: CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectItemClosure?(indexPath.row % numberOfItems)
    }
    
    internal func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = Int(contentOffset.x) / Int(bounds.width)
        scrollToPage(at: page)
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        draggingClosure?(true)
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        draggingClosure?(false)
    }
    
    //MARK: CollectionView DataSource

    override var numberOfSections: Int {
        return 1
    }
    
    internal func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fakeNumberOfItems
    }
    
    internal func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        let idx = indexPath.row % numberOfItems
        if let urlStr = fetchItemClosure?(idx), let url = URL(string: urlStr) {
            cell.imageView.kf.setImage(with: url)
        }
        return cell
    }
    
    internal func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return bounds.size
    }
    
    
    //Timer auto scroll
    internal func autoScrollToPage(at page: Int) {
        guard fakeNumberOfItems > 0 else {
            return
        }
        
        if page >= numberOfItems {
            let p = page + fakeNumberOfItems / 2
            scrollToItem(at: IndexPath(item: p, section: 0), at: .centeredHorizontally, animated: true)
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3, execute: { [weak self] in
                self?.scrollToPage(at: 0)
            })
        } else {
            scrollToPage(at: page, animated: true)
        }
    }
    
    //Fix ScrollPage
    internal func scrollToPage(at page: Int, animated:Bool = false) {
        guard fakeNumberOfItems > 0 else {
            return
        }
        currentPage = page % numberOfItems
        let p = currentPage + fakeNumberOfItems / 2
        DispatchQueue.main.async { [weak self] in
            self?.scrollToItem(at: IndexPath(item: p, section: 0), at: .centeredHorizontally, animated: animated)
        }
    }
 }



class ImageCell: UICollectionViewCell {
    
    let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
   
    //创建UI
    func makeUI() {
        addSubview(imageView)
    }
    
    //渲染UI
    func updateUI() {
        imageView.frame = bounds
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        imageView.frame = bounds
    }
}


