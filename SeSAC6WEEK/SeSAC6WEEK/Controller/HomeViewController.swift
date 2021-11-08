//
//  HomeViewController.swift
//  SeSAC6WEEK
//
//  Created by hoseung Lee on 2021/11/01.
//

import UIKit

class HomeViewController: UIViewController {
  
  @IBOutlet weak var contentTableView: UITableView!

  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationBarSetup()
    contentTableView.delegate = self
    contentTableView.dataSource = self
  }
  
  private func navigationBarSetup() {
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.width, height: 44))
    navigationBar.delegate = self
    navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont.mainExtraBold]
    navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationBar.shadowImage = UIImage()
    
    view.addSubview(navigationBar)
    
    let customNavigationItem = UINavigationItem(title: "HOME")
    let addItem: UIBarButtonItem = .init(barButtonSystemItem: .add, target: self, action: #selector(showAddViewController))
    
    customNavigationItem.rightBarButtonItem = addItem
    navigationBar.setItems([customNavigationItem], animated: false)
  }
  
  @objc func showAddViewController() {
    guard let controller = UIStoryboard(name: "Content", bundle: nil)
            .instantiateViewController(withIdentifier: AddViewController.identifier)
            as? AddViewController else { fatalError("AddViewController load failure") }
    
    controller.modalPresentationStyle = .fullScreen
    present(controller, animated: true, completion: nil)
    
  }
}

extension HomeViewController: UINavigationBarDelegate {
  func position(for bar: UIBarPositioning) -> UIBarPosition {
    .topAttached
  }
}


//MARK: - TableView

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    10
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeTableViewCell.identifier, for: indexPath)
            as? HomeTableViewCell else { fatalError("!!!") }
    
    cell.categoryLabel.backgroundColor = .yellow
    cell.contentCollectionView.backgroundColor = .lightGray
    cell.contentCollectionView.delegate = self
    cell.contentCollectionView.dataSource = self
    cell.contentCollectionView.tag = indexPath.row
    if indexPath.row == 0 {
      cell.contentCollectionView.isPagingEnabled = true
    }
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    switch indexPath.row {
    case 1:
      return 300
    default:
      return 170
    }
  }
}


//MARK: - CollectionView

extension HomeViewController: UICollectionViewDelegate {
  
}

extension HomeViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.identifier, for: indexPath)
            as? HomeCollectionViewCell else { return UICollectionViewCell() }
    
    cell.thunmnailImage.backgroundColor = .brown
    
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    20
  }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    if collectionView.tag == 0 {
      return .init(width: UIScreen.main.bounds.width, height: 100)
    } else if collectionView.tag == 1 {
      return .init(width: 150, height: 100)
    } else {
      return .init(width: 150, height: 150)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
    if collectionView.tag == 0 {
      return .init(top: 0, left: 0, bottom: 0, right: 0)
    } else if collectionView.tag == 1{
      return .init(top: 15, left: 20, bottom: 15, right: 0)
    } else {
      return .init(top: 0, left: 20, bottom: 0, right: 0)
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    if collectionView.tag == 0 {
      return 0
    } else {
      return 10
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    10
  }
}
