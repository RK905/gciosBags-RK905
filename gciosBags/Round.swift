//
//  Round.swift
//  gciosBags
//
//  Created by Eduardo Arenas on 2/8/17.
//  Copyright © 2017 GameChanger. All rights reserved.
//

import Foundation

enum RoundResult {
  case tie
  case winner(winner: Team, pointDiff: Int)
  case inProgress
}

/// Represents a round in a cornhole game. A round is over when both teams 
/// have made 4 throws.
class Round {

  let startingTeam: Team

  private var redThrows = [Throw]()
  private var blueThrows = [Throw]()

  var isRoundOver: Bool {
    return redThrows.count == 4 && blueThrows.count == 4
  }

  var result: RoundResult {
    guard self.isRoundOver else { return .inProgress }

    let redTeamPoints = self.score(for: .red)
    let blueTeamPoints = self.score(for: .blue)

    if redTeamPoints == blueTeamPoints {
      return .tie
    } else if redTeamPoints > blueTeamPoints {
      return .winner(winner: .red, pointDiff: redTeamPoints - blueTeamPoints)
    } else {
      return .winner(winner: .blue, pointDiff: blueTeamPoints - redTeamPoints)
    }
  }

  var nextTeamToThrow: Team? {
    guard !self.isRoundOver else {
      return nil
    }

    let secondTeam = self.startingTeam == .red ? Team.blue : .red

    if self.redThrows.count == self.blueThrows.count {
      return self.startingTeam
    } else {
      return secondTeam
    }
  }

  var isNew: Bool {
    return redThrows.isEmpty && blueThrows.isEmpty
  }

  init(startingTeam: Team) {
    self.startingTeam = startingTeam
  }

  func addThrow(_ newThrow: Throw) {
    guard let nextTeamToThrow = self.nextTeamToThrow else { return }
    switch nextTeamToThrow {
    case .red:
      self.redThrows.append(newThrow)
    case .blue:
      self.blueThrows.append(newThrow)
    }
  }

  func score(for team: Team) -> Int {
    return self.roundThrows(for: team).reduce(0) { $0 + $1.points }
  }

  func roundThrows(for team: Team) -> [Throw] {
    switch team {
    case .red: return self.redThrows
    case .blue: return self.blueThrows
    }
  }

  func clear() {
    self.redThrows.removeAll()
    self.blueThrows.removeAll()
  }
}
