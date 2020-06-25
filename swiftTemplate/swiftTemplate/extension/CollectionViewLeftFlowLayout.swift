//
//  CollectionViewLeftFlowLayout.swift
//  swiftTemplate
//
//  Created by tomcat on 2020/6/16.
//  Copyright © 2020 SwiftKt-王波. All rights reserved.
//

import UIKit

class CollectionViewLeftFlowLayout:  UICollectionViewFlowLayout {
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        guard let attrsArry = super.layoutAttributesForElements(in: rect) else {
            return nil
        }
        for i in 0..<attrsArry.count {
            if i != attrsArry.count-1 {
                let curAttr = attrsArry[i] //当前attr
                let nextAttr = attrsArry[i+1]  //下一个attr
                //如果下一个在同一行则调整，不在同一行则跳过
                if curAttr.frame.minY == nextAttr.frame.minY {
                    if nextAttr.frame.minX - curAttr.frame.maxX > minimumInteritemSpacing{
                        var frame = nextAttr.frame
                        let x = curAttr.frame.maxX + minimumInteritemSpacing
                        frame = CGRect(x: x, y: frame.minY, width: frame.width, height: frame.height)
                        nextAttr.frame = frame
                    }
                }
            }
        }
        return attrsArry
    }
    
}
