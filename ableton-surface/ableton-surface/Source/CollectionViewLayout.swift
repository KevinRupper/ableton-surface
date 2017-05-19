//
//  CollectionViewLayout.swift
//  ios-ableton-controller
//
//  Created by Kevin Rupper on 22/2/17.
//  Copyright © 2017 Guerrilla Dev. All rights reserved.
//

import UIKit

class CollectionViewLayout: UICollectionViewLayout {
    
    // Constants
    let kMargin:CGFloat = 1
    let kCellWidth:CGFloat = 93
    let kCellHeight:CGFloat = 59
    
    var cache = [IndexPath : NSValue]()
    var collectionContentSize:CGSize?
    var columns: Int = 0
    var items: Int = 0
    
    override func prepare() {
        super.prepare()
        
        // Cell position
        var xOffset:CGFloat = 0.0
        var yOffset:CGFloat = 0.0
        var frame:CGRect
        
        // Index in the collection view
        var item:Int = 0
    
        // Calculate items frame
        for _ in 0..<columns {
            for index in 0..<items {
                yOffset = CGFloat(index) * (kCellHeight + kMargin)
                frame = CGRect(x: xOffset, y: yOffset, width: kCellWidth, height: kCellHeight)
                cache[IndexPath(item: item, section: 0)] = (NSValue(cgRect: frame))
                item += 1
            }
            
            xOffset += kCellWidth + kMargin
            yOffset = 0
        }
        
        collectionContentSize = CGSize(width: xOffset, height: CGFloat(items) * (kCellHeight + kMargin))
    }
    
    // Represents the width and height of all the content
    override var collectionViewContentSize: CGSize {
        return collectionContentSize!
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        if cache.isEmpty {
            self.prepare()
        }
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        
        for indexPath in cache.keys {
            if cache[indexPath]!.cgRectValue.intersects(rect) {
                layoutAttributes.append(self.layoutAttributesForItem(at: indexPath)!)
            }
        }
    
        return layoutAttributes
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let layoutAttributes:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        let value:NSValue = cache[indexPath]!
        layoutAttributes.frame = value.cgRectValue
        
        return layoutAttributes
    }
    
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}
