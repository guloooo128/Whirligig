//
//  Whirligig.swift
//  Whirligig
//
//  Created by Gollum on 2017/3/27.
//  Copyright © 2017年 Gollum. All rights reserved.
//

import UIKit

public typealias WCVFetchItemClosure = (_ idx: Int)-> String
public typealias WCVChangeItemClosure = (_ idx: Int)-> Void
public typealias WCVDraggingClosure = (_ isDragging: Bool)->Void

public class WhirligigView: UIView {
    
    private let collectionView: WVCollectionView!
    
    private var timer: Timer? = nil
    
    var duration: TimeInterval = 0 {
        didSet {
            if duration > 0 {
                collectionViewDraggingAction()
                timer = Timer.scheduledTimer(timeInterval: duration, target: self, selector: #selector(timerHandler(_:)), userInfo: nil, repeats: true)
            } else {
                timer?.invalidate()
                timer = nil
            }
        }
    }
    
    override init(frame: CGRect) {
        collectionView = WVCollectionView.defaultCollectionView()
        
        super.init(frame: frame)
        makeUI()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        collectionView = WVCollectionView.defaultCollectionView()
        
        super.init(coder: aDecoder)
        makeUI()
    }
    
    override public func layoutSubviews() {
        collectionView.reloadData()
        super.layoutSubviews()
        collectionView.scrollToPage(at: collectionView.currentPage)
    }
    
    public func setItem(count: Int, withDuration duration: TimeInterval,
                        fetchItem handler:@escaping WCVFetchItemClosure) {
        setItem(count: count)
        self.duration = duration
        fetchItem(handler)
    }
    
    public func setItem(count: Int) {
        collectionView.numberOfItems = count
    }
    
    public func fetchItem(_ handler: @escaping WCVFetchItemClosure) {
        collectionView.fetchItemClosure = handler
    }
    
    public func selectedItem(_ handler: @escaping WCVChangeItemClosure) {
        collectionView.selectItemClosure = handler
    }
    
    public func scrollToPage(_ handler: @escaping WCVChangeItemClosure) {
        collectionView.pagingClosure = handler
    }
    
    
    private func makeUI() {
        insertSubview(collectionView, at: 0)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let left = NSLayoutConstraint(item: collectionView,
                                      attribute: .leading,
                                      relatedBy: .equal,
                                      toItem: self,
                                      attribute: .leading,
                                      multiplier: 1,
                                      constant: 0)
        
        let right = NSLayoutConstraint(item: collectionView,
                                       attribute: .trailing,
                                       relatedBy: .equal,
                                       toItem: self,
                                       attribute: .trailing,
                                       multiplier: 1,
                                       constant: 0)
        
        let bottom = NSLayoutConstraint(item: collectionView,
                                        attribute: .bottom,
                                        relatedBy: .equal,
                                        toItem: self,
                                        attribute: .bottom,
                                        multiplier: 1,
                                        constant: 0)
        
        let top = NSLayoutConstraint(item: collectionView,
                                     attribute: .top,
                                     relatedBy: .equal,
                                     toItem: self,
                                     attribute: .top,
                                     multiplier: 1,
                                     constant: 0)
       
        self.addConstraints([top, left, bottom, right])
    }
    
    private func collectionViewDraggingAction() {
        collectionView.draggingClosure = {
            [weak self] isDragging in
            if isDragging {
                self?.timer?.fireDate = Date.distantFuture
            } else {
                self?.timer?.fireDate = Date(timeIntervalSinceNow: (self?.duration)!)
            }
        }
    }
    
    @objc private func timerHandler(_ sender: Timer) {
        collectionView.autoScrollToPage(at: self.collectionView.currentPage + 1)
    }
    
    override public func removeFromSuperview() {
        super.removeFromSuperview()
        timer?.invalidate()
    }
    
    deinit {
        timer = nil
    }
}

