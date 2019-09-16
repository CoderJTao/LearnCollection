//
//  CustomCollectionViewLayout.swift
//  CollectionView
//
//  Created by 江涛 on 2019/8/14.
//  Copyright © 2019 江涛. All rights reserved.
//

import Foundation
import UIKit

class CustomCollectionViewLayout: UICollectionViewLayout {
    private var itemWidth: CGFloat = 0
    private var itemHeight: CGFloat = 0

    private var currentX: CGFloat = 0
    private var currentY: CGFloat = 0

    private var attrubutesArray = [UICollectionViewLayoutAttributes]()

    // 提供滚动范围
    override var collectionViewContentSize: CGSize {
        return CGSize(width: UIScreen.main.bounds.size.width, height: currentY + 20)
    }


    // 提供布局对象
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return attrubutesArray
    }

    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        // 获取宽度
        let contentWidth = self.collectionView!.frame.size.width

        // 通过 indexpath 创建一个 item 属性
        let temp = UICollectionViewLayoutAttributes(forCellWith: indexPath)
        
        // 计算 item 的宽高
        let typeOne: (Int) -> () = { index in
            self.itemWidth = contentWidth / 2
            self.itemHeight = self.itemWidth
            
            temp.frame = CGRect(x: self.currentX, y: self.currentY, width: self.itemWidth, height: self.itemHeight)
            
            if index == 0 {
                self.currentX += self.itemWidth
            } else {
                self.currentX += self.itemWidth
                self.currentY += self.itemHeight
            }
        }
        
        let typeTwo: (Int) -> () = { index in
            if index == 2 {
                self.itemWidth = (contentWidth * 2) / 3.0
                self.itemHeight = (self.itemWidth * 2) / 3.0
                
                temp.frame = CGRect(x: self.currentX, y: self.currentY, width: self.itemWidth, height: self.itemHeight)
                
                self.currentX += self.itemWidth
            } else {
                self.itemWidth = contentWidth / 3.0
                self.itemHeight = (self.itemWidth * 2) / 3.0
                
                temp.frame = CGRect(x: self.currentX, y: self.currentY, width: self.itemWidth, height: self.itemHeight)
                
                self.currentY += self.itemHeight
                if index == 4 {
                    self.currentX = 0
                }
            }
        }
        
        let typeThree: (Int) -> () = { index in
            if index == 7 {
                self.itemWidth = (contentWidth * 2) / 3.0
                self.itemHeight = (self.itemWidth * 2) / 3.0
                
                temp.frame = CGRect(x: self.currentX, y: self.currentY, width: self.itemWidth, height: self.itemHeight)
                
                self.currentX += self.itemWidth
                self.currentY += self.itemHeight
            } else {
                self.itemWidth = contentWidth / 3.0
                self.itemHeight = (self.itemWidth * 2) / 3.0
                
                temp.frame = CGRect(x: self.currentX, y: self.currentY, width: self.itemWidth, height: self.itemHeight)
                
                if index == 5 {
                    self.currentY += self.itemHeight
                } else {
                    self.currentX += self.itemWidth
                    self.currentY -= self.itemHeight
                }
            }
        }
        
        
        let judgeNum = indexPath.row % 8
        
        switch judgeNum {
        case 0, 1:
            typeOne(judgeNum)
        case 2, 3, 4:
            typeTwo(judgeNum)
        case 5, 6, 7:
            typeThree(judgeNum)
        default:
            break
        }
        
        if currentX >= contentWidth {
            currentX = 0
        }

        return temp
    }

    // 布局相关准备工作
    // 为每个 invalidateLayout 调用
    // 缓存 UICollectionViewLayoutAttributes
    // 计算 collectionViewContentSize
    override func prepare() {
        super.prepare()

        guard let count = self.collectionView?.numberOfItems(inSection: 0) else { return }
        // 得到每个 item 的属性并存储
        for i in 0..<count {
            let indexPath = IndexPath(row: i, section: 0)

            guard let attributes = self.layoutAttributesForItem(at: indexPath) else { break }
            attrubutesArray.append(attributes)
        }
    }

    // 处理自定义布局中的边界修改
    // 返回 true 使集合视图重新查询几何信息的布局
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return false
    }
}
