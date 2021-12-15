//
//  ViewController.swift
//  CarrotUI
//
//  Created by hoseung Lee on 2021/12/16.
//

import UIKit
import SnapKit

class HomeCell: UITableViewCell {
  
  var thumbnailImageView = UIImageView()
  var titleLabel = UILabel()
  var placementLabel = UILabel()
  var priceLabel = UILabel()
  
  var tumbnailImage = UIImage() {
    didSet {
      thumbnailImageView.image = tumbnailImage
    }
  }
  
  var title = "" {
    didSet {
      titleLabel.text = title
    }
  }
  
  var placement = "" {
    didSet {
      placementLabel.text = placement
    }
  }
  
  var price = 0 {
    didSet {
      let formatter = NumberFormatter()
      formatter.numberStyle = .decimal
      priceLabel.text = formatter.string(from: price as NSNumber)! + "원"
    }
  }
  
  static let reuseIdentifier = "HomeCell"
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    layoutConfigure()
  }
  
  override func awakeFromNib() {
    super.awakeFromNib()
    print(#function)
  }
  
  func configure(title: String, placement: String, price: Int, image: UIImage) {
    self.title = title
    self.placement = placement
    self.price = price
    self.tumbnailImage = image
  }
  
  func layoutConfigure() {
    addSubview(thumbnailImageView)
    addSubview(titleLabel)
    addSubview(placementLabel)
    addSubview(priceLabel)
    
    thumbnailImageView.layer.cornerRadius = 4
    thumbnailImageView.backgroundColor = .systemBrown
    thumbnailImageView.clipsToBounds = true
    thumbnailImageView.contentMode = .scaleAspectFit
    
    thumbnailImageView.snp.makeConstraints { make in
      make.leading.equalTo(snp.leading).inset(16)
      make.top.equalTo(snp.top).inset(16)
      make.bottom.equalTo(snp.bottom).inset(16)
      make.width.height.equalTo(100)
      make.centerY.equalToSuperview()
    }
    
    titleLabel.font = .systemFont(ofSize: 16, weight: .regular)
    placementLabel.font = .systemFont(ofSize: 12, weight: .regular)
    placementLabel.textColor = .secondaryLabel
    priceLabel.font = .systemFont(ofSize: 16, weight: .bold)
    
    titleLabel.snp.makeConstraints { make in
      make.top.equalTo(snp.top).offset(16)
      make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
      make.trailing.equalTo(snp.trailing).inset(8)
    }
    
    placementLabel.snp.makeConstraints { make in
      make.top.equalTo(titleLabel.snp.bottom).offset(5)
      make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
      make.trailing.equalTo(snp.trailing).inset(8)
    }
    
    priceLabel.snp.makeConstraints { make in
      make.top.equalTo(placementLabel.snp.bottom).offset(5)
      make.leading.equalTo(thumbnailImageView.snp.trailing).offset(16)
      make.trailing.equalTo(snp.trailing).inset(8)
    }
  }
  
}

class NewButton: UIButton {
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    backgroundColor = .systemOrange
    
    let plus = UIImageView(image: .init(systemName: "plus")?.withTintColor(.white))
    addSubview(plus)
    tintColor = .white
    plus.snp.makeConstraints { make in
      make.centerX.centerY.equalToSuperview()
      make.width.height.equalTo(snp.width).multipliedBy(0.5)
    }
  }

}

class HomeViewController: UIViewController {
  
  let tableView = UITableView()
  
  var items: [String] = [
    "마더스베이비 발판",
    "영등포 더파크 스파랜드 OPEN!",
    "발마사지",
    "미니골드 화이트골드 통 금귀걸이(14k)",
    "[네일샵] 첫손님]",
    "전기기사 기출문제집",
  ]
  
  let plusButton = NewButton()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableViewConfigure()
    navigationBarConfigure()
    view.backgroundColor = .white
    
    
    view.addSubview(plusButton)
    plusButton.snp.makeConstraints { make in
      make.width.height.equalTo(55)
      make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(8)
      make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
    }
    plusButton.layer.cornerRadius = 27.5
    plusButton.clipsToBounds = true
  }
  
  private func navigationBarConfigure() {
    
    let search = UIButton(frame: .init(x: 0, y: 0, width: 33, height: 33))
    search.setImage(.init(systemName: "magnifyingglass"), for: .normal)
    
    let ham = UIButton()
    ham.setImage(.init(systemName: "square.stack.3d.up"), for: .normal)
    
    let bell = UIButton()
    bell.setImage(.init(systemName: "bell"), for: .normal)
    
    let searchBar = UIBarButtonItem(customView: search)
    let hamBar = UIBarButtonItem(customView: ham)
    let bellBar = UIBarButtonItem(customView: bell)
    
    let naviItem = UINavigationItem()
    naviItem.rightBarButtonItems = [bellBar, hamBar, searchBar]
    
    naviItem.rightBarButtonItems?.forEach({ button in
      button.customView!.snp.makeConstraints { make in
        make.width.height.equalTo(33)
      }
    })
    
    
    let place = UIButton()
    place.setImage(.init(systemName: "chevron.down"), for: .normal)
    place.setTitle("문래동", for: .normal)
    
    var buttonConfigure = UIButton.Configuration.plain()
    buttonConfigure.imagePlacement = .trailing
    place.configuration = buttonConfigure
    buttonConfigure.imagePadding = 15
    
    place.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
    place.setTitleColor(.black, for: .normal)
    let placeSelect = UIBarButtonItem(customView: place)
    
    naviItem.leftBarButtonItem = placeSelect
    
    let navBarAppearce = UINavigationBarAppearance()
    navBarAppearce.backgroundColor = .white
    
    let navigationBar = UINavigationBar(frame: .init(x: 0, y: 44, width: view.frame.size.width, height: 44))
    
    navigationBar.tintColor = .black
    navigationBar.standardAppearance = navBarAppearce
    navigationBar.scrollEdgeAppearance = navBarAppearce
    navigationBar.isHidden = false
    navigationBar.items = [naviItem]
    view.addSubview(navigationBar)
    
  }
  
  private func tableViewConfigure() {
    view.addSubview(tableView)
    tableView.snp.makeConstraints { make in
      make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide).inset(8)
    }
    tableView.dataSource = self
    tableView.delegate = self
    tableView.register(HomeCell.self, forCellReuseIdentifier: HomeCell.reuseIdentifier)
  }


}

extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return 6
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: HomeCell.reuseIdentifier, for: indexPath)
            as? HomeCell else { fatalError() }
    
    cell.configure(title: items[indexPath.row], placement: "A동", price: indexPath.row * 10000, image: UIImage())
    
    return cell
  }
}

extension HomeViewController: UITableViewDelegate {
  
}
