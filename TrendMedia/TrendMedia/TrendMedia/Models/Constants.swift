//
//  Models.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/15.
//

enum Constants {
  static let searchButtonImage = "magnifyingglass"
  static let pushSearchViewController = "PushSearchViewController"
  static let showDetailMediaViewController = "ShowDetailMediaViewController"
  
  struct Cells {
    static let mainTableViewTopCell = "MainTableViewTopCell"
    static let mediaTableViewCell = "MediaTableViewCell"
    static let actorTableViewCell = "ActorTableViewCell"
    static let movieSearchTableViewCell = "MovieSearchTableViewCell"
    static let detailMediaStorylineTableViewCell = "DetailMediaStorylineTableViewCell"
    static let bookListCollectionViewCell = "BookListCollectionViewCell"
    static let boxOfficeCell = "BoxOfficeCell"
  }
  
  struct ViewController {
    static let bookListViewController = "BookListViewController"
  }
  
  struct Headers {
    static let actorTableViewHeaderView = "ActorTableViewHeaderView"
  }
  
  struct VerticalPoster {
    static let aTaleDarkGrimm = "v_a_tale_dark_grimm"
    static let aliceInBorderland = "v_alice_in_borderland"
    static let greysAnatomy = "v_greys_anatomy"
    static let hometownChaChaCha = "v_hometown_cha_cha_cha"
  }
  
  struct URLs {
    static let tmdbImageBaseURL = "https://www.themoviedb.org/t/p/original"
    static let youtubeBaseURL = "https://www.youtube.com/watch"
  }
}
