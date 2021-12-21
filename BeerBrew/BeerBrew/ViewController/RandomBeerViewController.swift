//
//  ViewController.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import Kingfisher

class RandomBeerViewController: UIViewController {
    
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
    return tableView
  }()
  
  
  private var bottomTabBar: BottomTabBar = {
    let bar = BottomTabBar()
    bar.backgroundColor = .white
    return bar
  }()
  
  let header = StretchyTableHeaderView()
  var beer: Beer?
  var headerHeight: CGFloat = UIScreen.main.bounds.width
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    createView()
    tableViewConfigure()
    bottomTabBarLayoutConfigure()
    fetchBeer()
    moreHandler(false)
  }
  
  private func fetchBeer() {
    BeerManager.shared.fetchBeer { beer in
      self.beer = beer
      DispatchQueue.main.async {
        if let beer = beer {
          self.header.containerView.beerConfigure(beer: beer)
        }
        let url = URL(string: beer!.imageURL ?? "")
        self.header.imageView.kf.setImage(
          with: url,
          placeholder: UIImage(named: "Bundarberg"),
          options: [
            .transition(.fade(1)),
            .cacheOriginalImage])
        self.tableView.reloadData()
      }
    }
  }
  
  private func createView() {
    view.addSubview(tableView)
    view.addSubview(bottomTabBar)
  }
  
  private func bottomTabBarLayoutConfigure() {
    bottomTabBar.snp.makeConstraints { make in
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
      make.leading.trailing.equalToSuperview().inset(8)
      make.height.equalTo(66)
    }
    
    bottomTabBar.refreshButtonHandler = fetchBeer
  }
  
  private func tableViewConfigure() {
    tableView.delegate = self
    tableView.dataSource = self
    tableView.frame = view.bounds
    tableView.snp.makeConstraints { make in
      make.top.leading.trailing.equalToSuperview()
      make.bottom.equalTo(bottomTabBar.snp.top)
    }
    tableView.separatorStyle = .none
    header.frame = .init(x: view.bounds.midX, y: 0, width: view.bounds.width, height: headerHeight)
    header.containerView.moreHandler = moreHandler
    tableView.tableHeaderView = header

  }
  
  @objc private func moreHandler(_ isExpended: Bool) {
    UIView.transition(with: tableView, duration: 0.2, options: .transitionCrossDissolve) {
      self.header.snp.updateConstraints { make in
        make.centerX.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(self.headerHeight + (isExpended ? 200 : 0))
      }
    } completion: { _ in
      self.tableView.reloadData()
    }
  }
}

extension RandomBeerViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    beer?.foodPairingCount ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.reuseIdentifier, for: indexPath)
    as! BeerTableViewCell
    
    cell.title = beer?.foodPairing[indexPath.row]
    
    return cell
  }
  
  func tableView(_ tableView: UITableView, selectionFollowsFocusForRowAt indexPath: IndexPath) -> Bool {
    return false
  }
}

extension RandomBeerViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let header = ParingHeaderView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 66))
    header.title = "Food - Paring"
    return header
  }
  
  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return 66
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 44
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
  }
}

extension RandomBeerViewController: UIScrollViewDelegate {
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    header.scrollViewDidScroll(scrollView: scrollView)
    let offset = scrollView.contentOffset.y
    if offset < 0 {
      header.snp.updateConstraints { make in
        make.centerX.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(headerHeight - offset)
      }
      self.tableView.reloadData()
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
  }
}

struct RandomBeerViewControllerPreview: PreviewProvider {
  static var previews: some View {
    RandomBeerViewControllerRepresentable()
  }
}
#endif
