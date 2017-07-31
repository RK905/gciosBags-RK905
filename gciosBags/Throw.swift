//
//  Throw.swift
//  gciosBags
//
//  Created by Eduardo Arenas on 2/8/17.
//  Copyright © 2017 GameChanger. All rights reserved.
//

import Foundation

enum Throw: Int {
  case out = 0
  case board = 1
  case hole = 3

  var points: Int {
    return self.rawValue
  }
}
