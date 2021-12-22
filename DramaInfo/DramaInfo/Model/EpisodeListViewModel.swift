//
//  EpisodeListViewModel.swift
//  DramaInfo
//
//  Created by hoseung Lee on 2021/12/22.
//

import UIKit

struct EpisodeListViewModel {
  var tvShow: TVShow?
  var episodeList: [Episode] = []
  var count: Int {
    episodeList.count
  }
  var title: String {
    tvShow?.name ?? ""
  }
  
  var cellHeight: CGFloat = 110
}
