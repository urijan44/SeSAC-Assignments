//
//  BeerDescriptionView.swift
//  BeerBrew
//
//  Created by hoseung Lee on 2021/12/20.
//

import UIKit
import SnapKit

class BeerDescriptionViewCell: UITableViewCell {
  
  static let reuseIdentifier = "BeerDescriptionViewCell"
  
  var moreHandler: (() -> ())?
  
  private let descriptionView: UIView = {
    let uiView = UIView()
    uiView.layer.cornerRadius = 8
    uiView.backgroundColor = .white
    return uiView
  }()
  
  private var isExpended = false
  
  private let titlelabel = UILabel()
  private let originLabel = UILabel()
  private let descriptionLabel = UILabel()
  
  private let moreButton: UIButton = {
    let button = UIButton()
    button.addTarget(self, action: #selector(descriptionExpend), for: .touchUpInside)
    button.titleLabel?.font = .systemFont(ofSize: 14, weight: .bold)
    button.setTitleColor(.black, for: .normal)
    return button
  }()
  
  private let stackView: UIStackView = {
    let stackView = UIStackView()
    stackView.axis = .vertical
    stackView.spacing = 16
    stackView.alignment = .fill
    stackView.distribution = .equalSpacing
    return stackView
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    descriptionViewConfigure()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
  }
  
  public func beerConfigure(beer: Beer) {
    titlelabel.text = beer.name
    originLabel.text = beer.origin
    descriptionLabel.text = beer.description
  }
  
  private func descriptionViewConfigure() {
    addSubview(descriptionView)
    descriptionView.layer.shadowRadius = 2
    descriptionView.layer.shadowOffset = .init(width: 1, height: 1)
    descriptionView.layer.shadowOpacity = 0.4
    
    descriptionView.addSubview(stackView)
    stackView.addArrangedSubview(titlelabel)
    stackView.addArrangedSubview(originLabel)
    stackView.addArrangedSubview(descriptionLabel)
    stackView.addArrangedSubview(moreButton)
    
    descriptionView.snp.makeConstraints { make in
      make.width.equalToSuperview().multipliedBy(0.9)
      make.centerX.equalToSuperview()
      make.top.equalToSuperview().offset(-80)
      make.bottom.equalToSuperview()
    }

    moreButton.setTitle("more", for: .normal)
    
    stackView.snp.makeConstraints {
        $0.top.equalTo(20)
        $0.leading.equalTo(20)
        $0.trailing.equalTo(-20)
        $0.bottom.equalTo(-10)
    }
    
    titlelabel.textAlignment = .center
    titlelabel.font = .systemFont(ofSize: 22, weight: .bold)
    titlelabel.textColor = .black



    originLabel.textAlignment = .center
    originLabel.font = .systemFont(ofSize: 14)
  
    descriptionLabel.font = .systemFont(ofSize: 15)
    descriptionLabel.numberOfLines = 4
  }
  
  @objc private func descriptionExpend(_ sender: UIButton) {
    isExpended.toggle()
    self.descriptionLabel.numberOfLines = self.isExpended ? 0 : 4
    

    moreHandler?()
  }
}

#if DEBUG
import SwiftUI
struct BeerDescriptionViewRepresentable: UIViewRepresentable {
  typealias UIViewType = BeerDescriptionViewCell
  
  func makeUIView(context: UIViewRepresentableContext<BeerDescriptionViewRepresentable>) ->  BeerDescriptionViewCell {
    BeerDescriptionViewCell()
  }
  
  func updateUIView(_ uiView: BeerDescriptionViewCell, context: Context) {
    uiView.beerConfigure(beer: Beer(name: "맥주", origin: "원산지", description: "맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주맥주"))
  }
  
}

struct BeerDescriptionViewPreview: PreviewProvider {
  static var previews: some View {
    BeerDescriptionViewRepresentable()
      .frame(width: 340, height: 340)
      .previewLayout(.sizeThatFits)
  }
}
#endif
