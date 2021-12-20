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
  
  var mock: [String] = []
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
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
    header.delegate = self
    header.imageView.image = UIImage(named: "Bundarberg")
    header.beer = Beer(name: "Clown King", origin: "US Style Barley Wine", description: "A titillating, neurotic, peroxide punk of a Pale Ale. Combining attitude, style, substance, and a little bit of low self esteem for good measure; what would your mother say? The seductive lure of the sassy passion fruit hop proves too much to resist. All that is even before we get onto the fact that there are no additives, preservatives, pasteurization or strings attached. All wrapped up with the customary BrewDog bite and imaginative twist")


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
      let cell = UITableViewCell()
      cell.selectionStyle = .none
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
      
      return header
    }
    
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    if section == 0 {
      return headerHeight
    } else {
      return 66
    }
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if indexPath.section == 0 {
      return 300
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
    header.imageView.snp.updateConstraints { make in
      make.height.equalTo(header.containerView.snp.height).multipliedBy(0.5).offset(-scrollView.contentOffset.y)
    }
  }
}

extension RandomBeerViewController: StretchyTableHeaderViewDelegate {
  func stretchyTableHeaderView(_ view: StretchyTableHeaderView, expandedView: Bool) {
    if expandedView {
      mock = []
      headerHeight = view.frame.width + 300
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
        self.tableView.reloadData()
        self.view.layoutIfNeeded()
      }
    } else {
      mock = []
      headerHeight = view.frame.width
      UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
        self.tableView.reloadData()
        
        self.view.layoutIfNeeded()
      }
    }
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
