//
//  Game.swift
//  gciosBags
//
//  Created by Eduardo Arenas on 2/8/17.
//  Copyright © 2017 GameChanger. All rights reserved.
//

import Foundation

/// Possible teams in a game
enum Team {
  case red
  case blue

  var name: String {
    switch self {
    case .red: return "Red"
    case .blue: return "Blue"
    }
  }
}

/// States a game can
///
/// - roundInProgress: The game's `currentRound` is in progress
/// - roundOver: The game's `currentRound` is over (each team has four throws)
/// - gameOver: One of the teams has scored more than 21 points and leads by more than 2 points
enum GameState {
  case roundInProgress
  case roundOver
  case gameOver
}

/// Represents a single game of cornhole. Contains the data
/// and domain logic to score a cornhole game.
class Game {

  private var rounds: [Round]

  var currentRoundNumber: Int {
    return self.rounds.count
  }

  var currentRound: Round {
    return self.rounds.last!
  }

  var gameState: GameState {
    return self.currentGameState()
  }

  var nextTeamToThrow: Team? {
    return self.rounds.last?.nextTeamToThrow
  }

  var winner: Team? {
    guard self.gameState == .gameOver else {
      return nil
    }
    return self.score(for: .red) > self.score(for: .blue) ? Team.red : .blue
  }

  init() {
    self.rounds = [Round(startingTeam: .red)]
  }

  func addThrow(_ newThrow: Throw) {
    self.currentRound.addThrow(newThrow)
  }

  func clearCurrentRound() {
    self.currentRound.clear()
  }

  func startNewRound() {
    guard self.gameState == .roundOver else {
      return
    }

    let lastRound = self.currentRound
    switch lastRound.result {
    case .winner(let team, _):
      self.rounds.append(Round(startingTeam: team))
    case .tie:
      self.rounds.append(Round(startingTeam: lastRound.startingTeam))
    default:
      break
    }
  }

  func score(for team: Team) -> Int {
    var gameScore = 0

    for round in self.rounds {
      switch round.result {
      case .winner(let winner, let roundScore) where winner == team:
        gameScore += roundScore
      default: continue
      }
    }

    return gameScore
  }

  private func currentGameState() -> GameState {
    if self.isGameOver() {
      return .gameOver
    } else if self.currentRound.isRoundOver {
      return .roundOver
    } else {
      return .roundInProgress
    }
  }

  private func isGameOver() -> Bool {
    let redScore = self.score(for: .red)
    let blueScore = self.score(for: .blue)

    let reachedWinningScore = redScore >= 21 || blueScore >= 21
    let hasDifferenceOfTwo = abs(redScore - blueScore) >= 2

    return reachedWinningScore && hasDifferenceOfTwo
  }
}
