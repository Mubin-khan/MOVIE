//
//  GenreModel.swift
//  MOVIE
//
//  Created by Mubin Khan on 5/6/24.
//

import Foundation

struct GenreModel : Codable {
    var genres : [SingleGenre]
}

struct SingleGenre: Codable {
    let id: Int
    let name: String
}
