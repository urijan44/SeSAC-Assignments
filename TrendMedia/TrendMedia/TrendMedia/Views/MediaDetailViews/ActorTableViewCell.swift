//
//  ActorTableViewCell.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/18.
//

import UIKit

class ActorTableViewCell: UITableViewCell {
  
  @IBOutlet weak var actorImageView: UIImageView! {
    didSet {
      actorImageView.layer.cornerRadius = 8
    }
  }
  @IBOutlet weak var actorNameLabel: UILabel!
  @IBOutlet weak var actorCharacterLabel: UILabel!
   
  override func awakeFromNib() {
    super.awakeFromNib()
    
    setup()
  }
  
  func configure(with actor: Cast) {
    actorNameLabel.text = actor.name
    actorCharacterLabel.text = actor.character == nil ? "출연 정보 없음" : actor.character
    actorImageView.image = UIImage(named: actor.image ?? "") ?? UIImage(named: "DummyActor")
  }
  
  private func setup() {
    selectionStyle = .none
  }
  
}
