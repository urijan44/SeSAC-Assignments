//
//  EpisodeListViewCell.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit
import SwiftUI
import SnapKit
import Kingfisher

class EpisodeListViewCell: UITableViewCell {
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.contentMode = .scaleAspectFit
//    imageView.backgroundColor = .systemTeal
    imageView.image = UIImage(systemName: "film")
    return imageView
  }()
  let episodeTitleLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.font = .systemFont(ofSize: 13, weight: .bold)
    return label
  }()
  
  let dateInfoLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 11, weight: .regular)
    return label
  }()
  
  let descriptionLabel: UILabel = {
    let label = UILabel()
    label.textColor = .lightGray
    label.font = .systemFont(ofSize: 11, weight: .regular)
    label.numberOfLines = 3
    return label
  }()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    backgroundColor = .black
    createView()
  }
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  private func createView() {
    [posterImageView, episodeTitleLabel, dateInfoLabel, descriptionLabel].forEach {
      addSubview($0)
    }
    
    posterImageView.snp.makeConstraints { make in
      make.top.bottom.equalToSuperview().inset(10)
      make.centerY.equalToSuperview()
      make.leading.equalToSuperview().offset(5)
      make.width.equalTo(61)
    }
    
    episodeTitleLabel.snp.makeConstraints { make in
      make.top.equalTo(posterImageView)
      make.leading.equalTo(posterImageView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(8)
    }
    
    dateInfoLabel.snp.makeConstraints { make in
      make.top.equalTo(episodeTitleLabel.snp.bottom).offset(6)
      make.leading.equalTo(posterImageView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(8)
    }
    
    descriptionLabel.snp.makeConstraints { make in
      make.top.equalTo(dateInfoLabel.snp.bottom).offset(6)
      make.leading.equalTo(posterImageView.snp.trailing).offset(8)
      make.trailing.equalToSuperview().inset(8)
      make.bottom.equalTo(posterImageView.snp.bottom)
    }
  }
  
  public func configure(_ episode: Episode) {
    episodeTitleLabel.text = episode.title
    dateInfoLabel.text = episode.subline
    descriptionLabel.text = episode.description
    fetchImage(urlString: episode.imageURL)
  }
  
  private func fetchImage(urlString: String) {
    guard let url = URL(string: urlString) else { return }
    
    posterImageView.kf.setImage(
      with: url,
      placeholder: UIImage(systemName: "film"),
      options: [
        .transition(.fade(0.2)),
        .cacheOriginalImage
      ])
  }
  
  struct RepresentView: UIViewRepresentable {
    typealias UIViewType = EpisodeListViewCell
    func makeUIView(context: UIViewRepresentableContext<RepresentView>) -> EpisodeListViewCell {
      return EpisodeListViewCell()
    }
    
    func updateUIView(_ uiView: EpisodeListViewCell, context: Context) {
      uiView.posterImageView.image = UIImage(named: "MockPoster")
      uiView.episodeTitleLabel.text = "빅뱅 이론 Season 1"
      uiView.dateInfoLabel.text = "2017. 09. 24 | Episode 18"
      uiView.descriptionLabel.text = "겉은 스튜핏, 속은 스마트. 두 천재 과학도의 여심 잡기 개론. 옆집으로 이사 온 금발의 퀸카와 친해지려 하지만 이해할 수 없는 이론으로 실수 연발이다. 사람은 이론이 아닌 감정의 화학작용이라는 걸, 둘은 언제쯤 깨달을 수 있을까"
    }
  }
  
}

struct EpisodeCellPreview: PreviewProvider {
  static var previews: some View {
    EpisodeListViewCell.RepresentView()
      .frame(width: 350, height: 110)
      .previewLayout(.sizeThatFits)
  }
}
