//
//  MovieModel.swift
//  TrendMedia
//
//  Created by hoseung Lee on 2021/10/26.
//

struct MovieModel: Decodable {
  let title: String
  let subtitle: String
  let director: String
  let actor: String
  let pubData: String
  let image: String
  let userRating: String
}
