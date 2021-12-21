//
//  ViewController.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit

class RandomBeerViewController: UIViewController {
  
  var dummy: [String] = [
  "apple",
  "banana",
  "cola",
  "dream",
  "Echo",
  "Fox",
  "Golf",
  "Hotel",
  "India",
  "July",
  "Korea",
  "Lambada"
  ]
  
  var mock: [String] = ["mock"]
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
    tableView.register(BeerDescriptionViewCell.self, forCellReuseIdentifier: BeerDescriptionViewCell.reuseIdentifier)
    return tableView
  }()
  
  private var descriptionView: UIView = {
    let uiview = UIView()
    uiview.backgroundColor = .systemRed
    return uiview
  }()
  
  let header = StretchyTableHeaderView()
  
  var headerHeight: CGFloat = 0
  
  override func viewDidLoad() {
    super.viewDidLoad()
    headerHeight = view.frame.width
    tableViewConfigure()
  }
  
  private func tableViewConfigure() {
    view.addSubview(tableView)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    tableView.separatorStyle = .none
    header.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.width)
    header.imageView.image = UIImage(named: "Bundarberg")
    tableView.tableHeaderView = header
    header.layer.zPosition = -2
  }
  
  @objc private func moreHandler() {
    tableView.reloadData()
    tableView.reloadRows(at: [.init(row: 0, section: 0)], with: .fade)
  }
}

extension RandomBeerViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    2
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if section == 0 {
      return mock.count
    } else {
      return dummy.count
    }
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    if indexPath.section == 1 {
      let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.reuseIdentifier, for: indexPath)
      as! BeerTableViewCell
      
      cell.title = dummy[indexPath.row]
          
      return cell
    } else {
      let cell = tableView.dequeueReusableCell(withIdentifier: BeerDescriptionViewCell.reuseIdentifier, for: indexPath)
      as! BeerDescriptionViewCell
      cell.clipsToBounds = false
      cell.contentView.clipsToBounds = false
      cell.contentView.isUserInteractionEnabled = false
      cell.selectionStyle = .none
      cell.beerConfigure(beer: Beer(name: "맥주", origin: "원산지", description: "아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨아쥬 오래됨"))
      cell.moreHandler = moreHandler
      return cell
    }
  }
  
  func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}

extension RandomBeerViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    if section == 1 {
      let header = ParingHeaderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 66))
      header.title = "Food - Paring"
      return header
    } else {
      return UIView(frame: .zero)
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return 0
    } else {
      return 66
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return UITableView.automaticDimension
    } else {
      return 44
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension RandomBeerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    header.scrollViewDidScroll(scrollView: scrollView)
  }
}

#if DEBUG
import SwiftUI
struct RandomBeerViewControllerRepresentable: UIViewControllerRepresentable {
  typealias UIViewControllerType = RandomBeerViewController
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<RandomBeerViewControllerRepresentable>) -> RandomBeerViewController {
    RandomBeerViewController()
  }
  
  func updateUIViewController(_ uiViewController: RandomBeerViewController, context: Context) {
    uiViewController.dummy = ["apple",
                              "banana",
                              "cola",
                              "dream",
                              "Echo",
                              "Fox",
                              "Golf",
                              "Hotel",
                              "India"]
  }
}

struct RandomBeerViewControllerPreview: PreviewProvider {
  static var previews: some View {
    RandomBeerViewControllerRepresentable()
  }
}
#endif
