//
//  CustomCollectionView.swift
//  internalCollectionViewDelegate-example
//
//  Created by Mees Kern on 16.11.2022.
//

import Foundation
import UIKit

fileprivate class UICollectionViewDelegateInternal: NSObject, UICollectionViewDelegate {
    var userDelegate: UICollectionViewDelegate?
    
    override func responds(to aSelector: Selector!) -> Bool {
        return super.responds(to: aSelector) || userDelegate?.responds(to: aSelector) == true
    }
    
    override func forwardingTarget(for aSelector: Selector!) -> Any? {
        if userDelegate?.responds(to: aSelector) == true {
            return userDelegate
        }
        return super.forwardingTarget(for: aSelector)
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        let collection = collectionView as! CustomCollectionView
        collection.didEnd(item: indexPath.item)
        userDelegate?.collectionView?(collectionView, didEndDisplaying: cell, forItemAt: indexPath)
    }
}

class CustomCollectionView: UICollectionView {
    private let internalDelegate: UICollectionViewDelegateInternal = UICollectionViewDelegateInternal()
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        super.delegate = internalDelegate
    }
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        super.delegate = internalDelegate
    }

    
    
    func didEnd(item: Int) {
        print("internal - didEndDisplaying: \(item)")
    }
    
    
    override var delegate: UICollectionViewDelegate? {
        get {
            return internalDelegate.userDelegate
        }
        set {
            self.internalDelegate.userDelegate = newValue
            super.delegate = nil
            super.delegate = self.internalDelegate
        }
    }
}

