//
//  LayoutViewController.swift
//  CollectionView
//
//  Created by 江涛 on 2019/8/19.
//  Copyright © 2019 江涛. All rights reserved.
//

import UIKit

class LayoutViewController: UIViewController {
    private var vcType = DemoType.basic
    
    private var isChanged = false

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
        let view = UICollectionView(frame: self.view.bounds, collectionViewLayout: layout)
        return view
    }()

    private lazy var dataSource: [String] = {
        var arr: [String] = []
        for name in 1..<14 {
            arr.append("\(name)")
        }
        return arr
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        switch vcType {
        case .basic:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
            self.collectionView.collectionViewLayout = layout
        case .custom:
            let layout = CustomCollectionViewLayout()
            self.collectionView.collectionViewLayout = layout
        case .change:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
            
            self.collectionView.collectionViewLayout = layout
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeLayout))
        case .dragAndDrop:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .horizontal
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: (UIScreen.main.bounds.size.width - 20) / 3)
            self.collectionView.collectionViewLayout = layout
        }
        
        self.collectionView.backgroundColor = UIColor.white
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "ImageCell")
        self.view.addSubview(self.collectionView)
    }
    
    func setType(_ type: DemoType) {
        self.vcType = type
    }
    
    @objc func changeLayout() {
        isChanged = !isChanged
        if isChanged {
            let layout = CustomCollectionViewLayout()
            self.collectionView.collectionViewLayout = layout
        } else {
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)
            self.collectionView.collectionViewLayout = layout
        }
    }
}

extension LayoutViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 14
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        
        let random = Int(arc4random()%14) + 1
        
        cell.showImage.image = UIImage(named: "\(random)")

        return cell
    }
}




enum DemoType {
    case basic
    case custom
    case change
    case dragAndDrop
}


