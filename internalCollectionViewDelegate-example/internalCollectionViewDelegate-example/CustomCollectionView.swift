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
	
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		let collection = collectionView as! CustomCollectionView
		collection.didSel(p: indexPath)
		userDelegate?.collectionView?(collectionView, didSelectItemAt: indexPath)
	}
	
}

// DonMag - conform to UICollectionViewDelegate
class CustomCollectionView: UICollectionView, UICollectionViewDelegate {
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
	
	func didSel(p: IndexPath) {
		print("internal - didSelectItemAt", p)
	}
	
	// DonMag - these will NEVER be called,
	//  whether or not they're implemented in
	//  UICollectionViewDelegateInternal and/or ViewController
	// but, when implemented here,
	//  it allows (enables?) them to be called in UICollectionViewDelegateInternal
	func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
		print("CustomCollectionView - didEndDisplaying", indexPath)
	}
	func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
		print("CustomCollectionView - didSelectItemAt", indexPath)
	}
	
	override var delegate: UICollectionViewDelegate? {
		get {
			// DonMag - return self instead of internalDelegate.userDelegate
			return self
			//return internalDelegate.userDelegate
		}
		set {
			self.internalDelegate.userDelegate = newValue
			super.delegate = nil
			super.delegate = self.internalDelegate
		}
	}
}

