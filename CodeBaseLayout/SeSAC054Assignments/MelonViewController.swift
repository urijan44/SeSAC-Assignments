//
//  MelonViewController.swift
//  SeSAC054Assignments
//
//  Created by hoseung Lee on 2021/12/14.
//

import UIKit
import SnapKit

extension UIColor {
  static var secondaryWhiteColor: UIColor {
    UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1)
  }
}

class FavoriteButton: UIButton {
  
  private var numberFormatter: NumberFormatter = {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    return formatter
  }()
  
  public var favoriteCount: Int = 0 {
    didSet {
      countLabel.text = numberFormatter.string(from: favoriteCount as NSNumber)
    }
  }
  
  public var selectState = false {
    didSet {
      heartImage.image = selectState ? UIImage(systemName: "heart.fill")?.withTintColor(.secondaryWhiteColor) : UIImage(systemName: "heart")?.withTintColor(.secondaryWhiteColor)
    }
  }
  
  private var heartImage: UIImageView = {
    let imageView = UIImageView()
    imageView.image = UIImage(systemName: "heart", withConfiguration: UIImage.SymbolConfiguration(pointSize: 22, weight: .regular))?.withTintColor(.secondaryWhiteColor)
    imageView.isUserInteractionEnabled = false
    return imageView
  }()
  
  private var countLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryWhiteColor
    label.font = .systemFont(ofSize: 16, weight: .bold)
    label.isUserInteractionEnabled = false
    return label
  }()
  
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(heartImage)
    heartImage.snp.makeConstraints { make in
      make.leading.equalTo(snp.leading)
      make.width.equalTo(snp.height).multipliedBy(0.5)
      make.height.equalTo(snp.height).multipliedBy(0.45)
      make.centerY.equalTo(snp.centerY)
    }
    
    addSubview(countLabel)
    countLabel.snp.makeConstraints { make in
      make.centerY.equalTo(snp.centerY)
      make.leading.equalTo(heartImage.snp.trailing).offset(8)
    }
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
  }
  
  override func sendAction(_ action: UIAction) {
    super.sendAction(action)
  }
  
  
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
  }
  
}

class RunningView: UIView {
  
  enum Repeat {
    case none
    case all
    case one
  }
  
  var repeatStatus: Repeat = .none {
    didSet {
      
    }
  }
  
  var progress: Float = 0 {
    didSet {
      progresView.progress = progress
    }
  }
  
  private var repeatButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "repeat"), for: .normal)
    button.tintColor = .secondaryWhiteColor
    return button
  }()
  
  private var shuffleButton: UIButton = {
    let button = UIButton()
    button.setImage(UIImage(systemName: "shuffle"), for: .normal)
    button.tintColor = .secondaryWhiteColor
    return button
  }()
  
  private var progresView: UIProgressView = {
    let progress = UIProgressView()
    progress.tintColor = .systemGreen
    return progress
  }()
  
  private var currentTimeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .systemGreen
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.text = "0:00"
    return label
  }()
  
  private var wholeTimeLabel: UILabel = {
    let label = UILabel()
    label.textColor = .secondaryWhiteColor
    label.font = .systemFont(ofSize: 14, weight: .bold)
    label.text = "7:77"
    return label
  }()
  
  
  required init?(coder: NSCoder) {
    fatalError()
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    layoutConfigure()
  }
  
  private func layoutConfigure() {
    [repeatButton, shuffleButton, progresView, currentTimeLabel, wholeTimeLabel].forEach {
      addSubview($0)
    }
    
    repeatButton.snp.makeConstraints { make in
      make.leading.equalTo(snp.leading)
      make.width.height.equalTo(33)
      make.top.equalToSuperview()
    }
    
    shuffleButton.snp.makeConstraints { make in
      make.trailing.equalTo(snp.trailing)
      make.width.height.equalTo(33)
      make.top.equalToSuperview()
    }
    
    progresView.snp.makeConstraints { make in
      make.top.equalTo(snp.top).offset(6)
      make.leading.equalTo(repeatButton.snp.trailing).offset(4)
      make.trailing.equalTo(shuffleButton.snp.leading).offset(-4)
    }
    
    currentTimeLabel.snp.makeConstraints { make in
      make.leading.equalTo(progresView.snp.leading)
      make.top.equalTo(progresView.snp.bottom).offset(6)
    }
    
    wholeTimeLabel.snp.makeConstraints { make in
      make.trailing.equalTo(progresView.snp.trailing)
      make.top.equalTo(progresView.snp.bottom).offset(6)
    }
  }
}

class MelonViewController: UIViewController {
  
  let songInfoView = UIView()

  var heartButtonState = false
  
  let viewDismissButton: UIButton = {
    let button = UIButton()
    button.tintColor = .secondaryWhiteColor
    
    let imageConfigure = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold)
    let image = UIImage(systemName: "chevron.down", withConfiguration: imageConfigure)
    button.setImage(image, for: .normal)
    
    return button
  }()
  
  let detailButton: UIButton = {
    let button = UIButton()
    let imageConfigure = UIImage.SymbolConfiguration(pointSize: 19, weight: .bold)
    let image = UIImage(systemName: "ellipsis", withConfiguration: imageConfigure)
    button.tintColor = .secondaryWhiteColor
    button.setImage(image, for: .normal)
    button.transform = .init(rotationAngle: .pi / 2)
    return button
  }()
  
  let albumCover: UIImageView = {
    let image = UIImageView()
    image.layer.cornerRadius = 8
    image.clipsToBounds = true
    return image
  }()
     
  let metaBar = UIView()
  
  let favoriteButton = FavoriteButton()
  
  var lyricView = UITextView()
  
  var progressView = RunningView()
  
  let lyric = """
달이 익어가니 서둘러 젊은 피야
민들레 한 송이 들고
사랑이 어지러이 떠다니는 밤이야
날아가 사뿐히 이루렴

팽팽한 어둠 사이로
떠오르는 기분
이 거대한 무중력에 혹 휘청해도
두렵진 않을 거야

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
나에게 너를 맡겨볼래 eh-oh

바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh

다시 마주하기 어려운 행운이야
온몸에 심장이 뛰어
Oh 오히려 기꺼이 헤매고픈 밤이야
너와 길 잃을 수 있다면

맞잡은 서로의 손으로
출입구를 허문
이 무한함의 끝과 끝 또 위아래로
비행을 떠날 거야

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
나에게 너를 맡겨볼래 eh-oh
바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh

놀라워 이보다
꿈같은 순간이 또 있을까 (더 있을까)
아마도 우리가 처음 발견한
오늘 이 밤의 모든 것, 그 위로 날아

푸르른 우리 위로
커다란 strawberry moon 한 스쿱
세상을 가져보니 어때 eh-oh
바람을 세로질러
날아오르는 기분 so cool
삶이 어떻게 더 완벽해 ooh
"""
  
  override func viewDidLoad() {
    super.viewDidLoad()
    title = "melon"
    
    view.backgroundColor = .black
    viewConfigure()
    
    favoriteButton.favoriteCount = 100000
    lyricView.text = lyric
    progressView.progress = 0.3
    navigationController?.isNavigationBarHidden = true
    
    let tap = UITapGestureRecognizer(target: self, action: #selector(hiddenNav))
    view.addGestureRecognizer(tap)
    view.isUserInteractionEnabled = true
  }
  
  @objc func hiddenNav() {
    navigationController?.isNavigationBarHidden.toggle()
    
  }
  private func viewConfigure() {
    songInfoViewConfigure()
    albumCoverConfigure()
    metaBarViewConfigure()
    lyricViewLayout()
    runningViewLayout()
  }
  
  private func songInfoViewConfigure() {
    view.addSubview(songInfoView)
    songInfoView.snp.makeConstraints { make in
      make.top.equalTo(view.snp.top).offset(44)
      make.leading.equalToSuperview().offset(16)
      make.trailing.equalToSuperview().offset(-16)
      make.height.equalTo(66)
    }
    
    let title = UILabel()
    let writer = UILabel()
    songInfoView.addSubview(title)
    songInfoView.addSubview(writer)
    
    let titleAttr = NSMutableAttributedString(string: "strawberry moon")
    let titleAttech = NSTextAttachment(image: UIImage(systemName: "music.note")!.withTintColor(.secondaryWhiteColor))
    titleAttech.bounds = CGRect(x: 0, y: 0, width: 16, height: 16)
    
    titleAttr.insert(NSAttributedString(attachment: titleAttech), at: 0)
      
    title.attributedText = titleAttr
    
    title.textColor = .white
    title.font = UIFont.systemFont(ofSize: 19, weight: .semibold)
    title.textAlignment = .center
    
    title.snp.makeConstraints { make in
      make.top.equalToSuperview().offset(8)
      make.centerX.equalToSuperview()
      
    }
    
    writer.text = "아이유"
    writer.textColor = .lightGray
    writer.font = UIFont.systemFont(ofSize: 14, weight: .medium)
    writer.textAlignment = .center
    
    writer.snp.makeConstraints { make in
      make.top.equalTo(title.snp.bottom).offset(8)
      make.centerX.equalToSuperview()
    }
    
    view.addSubview(viewDismissButton)
    viewDismissButton.snp.makeConstraints { make in
      make.centerY.equalTo(title.snp.centerY)
      make.trailing.equalTo(view.snp.trailing).offset(-16)
    }
    
    view.addSubview(detailButton)
    detailButton.snp.makeConstraints { make in
      make.centerX.equalTo(viewDismissButton)
      make.top.equalTo(viewDismissButton.snp.bottom).offset(10)
    }
  }
  
  private func albumCoverConfigure() {
    view.addSubview(albumCover)
    albumCover.image = UIImage(named: "melon")
    albumCover.snp.makeConstraints { make in
      make.top.equalTo(songInfoView.snp.bottom).offset(66)
      make.centerX.equalToSuperview()
      make.width.equalTo(view.snp.width).multipliedBy(0.9)
      make.height.equalTo(albumCover.snp.width)
    }
  }
  
  private func metaBarViewConfigure() {
    view.addSubview(metaBar)
    metaBar.snp.makeConstraints { make in
      make.top.equalTo(albumCover.snp.bottom).offset(4)
      make.centerX.equalToSuperview()
      make.width.equalTo(albumCover.snp.width)
      make.height.equalTo(66)
    }
    
    metaBar.addSubview(favoriteButton)
    favoriteButton.tintColor = .secondaryWhiteColor
    favoriteButton.addTarget(self, action: #selector(addFavoriteSong(_:)), for: .touchUpInside)
    favoriteButton.snp.makeConstraints { make in
      make.centerY.equalToSuperview()
      make.height.equalToSuperview()
      make.leading.equalTo(metaBar.snp.leading).offset(8)
    }
    
    let goInstButton = UIView()
    goInstButton.backgroundColor = .systemCyan
    metaBar.addSubview(goInstButton)
    goInstButton.snp.makeConstraints { make in
      make.width.equalTo(33)
      make.height.equalTo(33)
      make.trailing.equalTo(metaBar.snp.trailing)
      make.centerY.equalToSuperview()
    }
    
    
    let symicalSongButton = UIButton()
    symicalSongButton.setTitle("유사곡", for: .normal)
    symicalSongButton.setTitleColor(.secondaryWhiteColor, for: .normal)
    symicalSongButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
    symicalSongButton.layer.borderWidth = 2
    symicalSongButton.layer.borderColor = UIColor.darkGray.cgColor
    symicalSongButton.layer.cornerRadius = 5
    
    metaBar.addSubview(symicalSongButton)
    symicalSongButton.snp.makeConstraints { make in
      make.width.equalTo(66)
      make.height.equalTo(33)
      make.centerY.equalToSuperview()
      make.trailing.equalTo(goInstButton.snp.leading).offset(-16)
    }
  }
  
  private func lyricViewLayout() {
    view.addSubview(lyricView)
    lyricView.backgroundColor = .clear
    lyricView.textAlignment = .center
    
    lyricView.isEditable = false
    lyricView.showsVerticalScrollIndicator = false
   
    let style = NSMutableParagraphStyle()
    style.lineSpacing = 4
    style.alignment = .center
    let attr = [NSAttributedString.Key.paragraphStyle: style,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 17, weight: .semibold),
                NSAttributedString.Key.foregroundColor: UIColor.secondaryWhiteColor]
    
    lyricView.attributedText = NSAttributedString(string: lyric, attributes: attr)
    
    let arrLy = lyric.components(separatedBy: "\n").filter{!$0.isEmpty}
    let range = (lyric as NSString).range(of: arrLy[0])
    lyricView.scrollRangeToVisible(range)
    lyricView.snp.makeConstraints { make in
      make.centerX.equalToSuperview()
      make.top.equalTo(metaBar.snp.bottom).offset(33)
      make.width.equalTo(view.snp.width).multipliedBy(0.7)
      make.height.equalTo(48)
    }
  }

  private func runningViewLayout() {
    view.addSubview(progressView)
    
    progressView.snp.makeConstraints { make in
      make.leading.equalTo(view.snp.leading).offset(6)
      make.trailing.equalTo(view.snp.trailing).offset(-6)
      make.top.equalTo(lyricView.snp.bottom).offset(12)
      make.height.equalTo(33)
    }
    
  }
  
  @IBAction func addFavoriteSong(_ sender: FavoriteButton) {
    sender.selectState.toggle()
  }
}
