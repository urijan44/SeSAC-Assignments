//
//  BookListViewController.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/20.
//

import UIKit

class BookListViewController: UIViewController {
  
  let mediaList = MediaManager.shared.mediaList
  
  @IBOutlet weak var bookListCollectionView: UICollectionView! {
    didSet {
      bookListCollectionView.delegate = self
      bookListCollectionView.dataSource = self
      
      let layout = UICollectionViewFlowLayout()
      let spacing: CGFloat = 15
      let showItemCount = 2
      let width = UIScreen.main.bounds.width - spacing * CGFloat(showItemCount + 1)
      layout.scrollDirection = .vertical
      layout.minimumLineSpacing = spacing
      layout.minimumInteritemSpacing = spacing
      layout.sectionInset = .init(top: spacing, left: spacing, bottom: 0, right: spacing)
      let itemSize = width / CGFloat(showItemCount)
      layout.itemSize = .init(width: itemSize, height: itemSize * 1.15)
      bookListCollectionView.collectionViewLayout = layout
      
      //register
      bookListCollectionView.register(UINib(nibName: Constants.Cells.bookListCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: Constants.Cells.bookListCollectionViewCell)
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
  }
  
}

//MARK: - CollectionViewDelegate
extension BookListViewController: UICollectionViewDelegate {
  
}

//MARK: - CollectionViewDataSource
extension BookListViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    mediaList.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Constants.Cells.bookListCollectionViewCell, for: indexPath)
            as? BookListCollectionViewCell else { fatalError("\(BookListCollectionViewCell.self) load failure")}
    
    let media = mediaList[indexPath.item]
    cell.configure(with: media)
    
    
    return cell
  }
  
  
}
