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
        for name in 1..<15 {
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
        case .dragAndDrop:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.minimumLineSpacing = 10
            layout.minimumInteritemSpacing = 10
            layout.itemSize = CGSize(width: (UIScreen.main.bounds.size.width - 20) / 3, height: (UIScreen.main.bounds.size.width - 20) / 3)
            self.collectionView.collectionViewLayout = layout

            // 开启拖放手势，设置代理。
            self.collectionView.dragInteractionEnabled = true
            self.collectionView.dragDelegate = self
            self.collectionView.dropDelegate = self

        case .custom:
            let layout = CustomCollectionViewLayout()
            self.collectionView.collectionViewLayout = layout
        case .change:
            let layout = UICollectionViewFlowLayout()
            layout.scrollDirection = .vertical
            layout.itemSize = CGSize(width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.width)

            self.collectionView.collectionViewLayout = layout
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Change", style: .plain, target: self, action: #selector(changeLayout))
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
        
        let random = dataSource[indexPath.row]
        
        cell.showImage.image = UIImage(named: "\(random)")

        return cell
    }
}


extension LayoutViewController: UICollectionViewDragDelegate {
    func collectionView(_ collectionView: UICollectionView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {

        let imageName = self.dataSource[indexPath.row]

        let image = UIImage(named: imageName)!

        let provider = NSItemProvider(object: image)

        let dragItem = UIDragItem(itemProvider: provider)

        return [dragItem]
    }

    /*
        自定义拖动过程中 cell 外观。返回 nil 则以 cell 原样式呈现。
     */
    func collectionView(_ collectionView: UICollectionView, dragPreviewParametersForItemAt indexPath: IndexPath) -> UIDragPreviewParameters? {
        return nil
    }
}

extension LayoutViewController: UICollectionViewDropDelegate {
    func collectionView(_ collectionView: UICollectionView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UICollectionViewDropProposal {
        if session.localDragSession != nil {
            return UICollectionViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        } else {
            return UICollectionViewDropProposal(operation: .copy, intent: .insertAtDestinationIndexPath)
        }
    }

    /*
        当手指离开屏幕时，UICollectionView 会调用。必须实现该方法以接收拖动的数据。
     */
    func collectionView(_ collectionView: UICollectionView, performDropWith coordinator: UICollectionViewDropCoordinator) {
        let destinationIndexPath = coordinator.destinationIndexPath ?? IndexPath(item: 0, section: 0)

        switch coordinator.proposal.operation {
        case .move:
            let items = coordinator.items

            if items.contains(where: { $0.sourceIndexPath != nil }) {
                if items.count == 1, let item = items.first {

                    let temp = dataSource[item.sourceIndexPath!.row]

                    dataSource.remove(at: item.sourceIndexPath!.row)
                    dataSource.insert(temp, at: destinationIndexPath.row)

                    // Reordering a single item from this collection view.
                    collectionView.performBatchUpdates({
                        collectionView.deleteItems(at: [item.sourceIndexPath!])
                        collectionView.insertItems(at: [destinationIndexPath])
                    })

                    coordinator.drop(item.dragItem, toItemAt: destinationIndexPath)
                }
            }
        default:
            return
        }

    }
}





enum DemoType {
    case basic
    case custom
    case change
    case dragAndDrop
}


