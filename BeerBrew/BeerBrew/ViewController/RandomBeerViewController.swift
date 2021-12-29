//
//  ViewController.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import Kingfisher

class RandomBeerViewController: UIViewController {
    
  let mainView = RandomBeerMainView()
  let viewModel = BeerViewModel()
  
  override func loadView() {
    view = mainView
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mainView.header.containerView.moreHandler = moreHandler
    mainView.bottomTabBar.refreshButtonHandler = fetchBeer
    tableViewConfigure()
    moreHandler(false)
    
    viewModel.beer.bind { beer in
      self.mainView.header.containerView.beerConfigure(beer: beer)
      self.mainView.tableView.reloadData()
    }
    fetchBeer()
    
  }
  
  private func fetchBeer() {
    viewModel.fetchBeer { url, state in
      self.mainView.header.imageView.kf.setImage(
        with: url,
        placeholder: UIImage(named: "Bundarberg"),
        options: [
          .transition(.fade(1)),
          .cacheOriginalImage])
    }
  }
  
  private func tableViewConfigure() {
    mainView.tableView.delegate = self
    mainView.tableView.dataSource = self
    mainView.tableView.register(BeerTableViewCell.self, forCellReuseIdentifier: BeerTableViewCell.reuseIdentifier)
  }
  
  @objc private func moreHandler(_ isExpended: Bool) {
    UIView.transition(with: mainView.tableView, duration: 0.2, options: .transitionCrossDissolve) {
      self.mainView.header.snp.updateConstraints { make in
        make.centerX.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(self.mainView.headerHeight + (isExpended ? 200 : 0))
      }
    } completion: { _ in
      self.mainView.tableView.reloadData()
    }
  }
}

extension RandomBeerViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.foodPairingCount
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: BeerTableViewCell.reuseIdentifier, for: indexPath)
    as! BeerTableViewCell
    
    cell.title = viewModel.foodPairing[indexPath.row]
    
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
    mainView.header.scrollViewDidScroll(scrollView: scrollView)
    let offset = scrollView.contentOffset.y
    if offset < 0 {
      mainView.header.snp.updateConstraints { make in
        make.centerX.equalToSuperview()
        make.width.equalToSuperview()
        make.height.equalTo(mainView.headerHeight - offset)
      }
      self.mainView.tableView.reloadData()
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
