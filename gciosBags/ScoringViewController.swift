//
//  ViewController.swift
//  gciosBags
//
//  Created by Eduardo Arenas on 2/8/17.
//  Copyright © 2017 GameChanger. All rights reserved.
//

import UIKit

class ScoringViewController: UIViewController ,WeatherApiDelegate{
   
    
    func didGetWeather(weather: Weather) {
        DispatchQueue.global(qos: .background).async {
            DispatchQueue.main.async {
                if (weather.mainWeather == "Rain"){
                    self.weatherBG.image = UIImage(named:"rainBG")
                }else if (weather.mainWeather == "Cloudy"){
                    self.weatherBG.image = UIImage(named:"cloudyBG")
                }else {
                    self.weatherBG.image = UIImage(named:"sunBG")
                }
                
            }
        }
    }
    
    func didNotGetWeather(error: NSError) {
        print("API Error")
    }
    

  private static let redColor = UIColor(red: 0.75, green: 0.16, blue: 0.16, alpha: 1.00)
  private static let blueColor = UIColor(red:0.20, green:0.50, blue:0.81, alpha:1.00)

  private var game = Game()
  private var bagViews = [BagView]()
  private var canThrow = true
  private var holePath = UIBezierPath()
  private var boardPath = UIBezierPath()

    @IBOutlet weak var weatherBG: UIImageView!
    @IBOutlet weak var boardImageView: UIImageView!
  @IBOutlet weak var roundLabel: UILabel!
  @IBOutlet weak var playView: UIView!

  @IBOutlet weak var redGameScoreLabel: UILabel!
  @IBOutlet weak var blueGameScoreLabel: UILabel!
  @IBOutlet weak var redRoundScoreLabel: UILabel!
  @IBOutlet weak var blueRoundScoreLabel: UILabel!
  @IBOutlet weak var redThrowIndicatorView: UIImageView!
  @IBOutlet weak var blueThrowIndicatorView: UIImageView!
  @IBOutlet weak var redBagCountContainerStackView: UIStackView!
  @IBOutlet weak var blueBagCountContainerStackView: UIStackView!

  var weather: WeatherApi!
    
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    NotificationCenter.default.addObserver(self, selector: #selector(regenerateAllThrowsInRound), name: .bagViewMoved, object: nil)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    weather = WeatherApi(delegate: self)
    self.refreshViews()
    self.redBagCountContainerStackView.arrangedSubviews.forEach({ self.configureBagCountIndicator($0, color: ScoringViewController.redColor) })
    self.blueBagCountContainerStackView.arrangedSubviews.forEach({ self.configureBagCountIndicator($0, color: ScoringViewController.blueColor) })
    self.boardImageView.layer.zPosition = 2
    
    //
    let weatherString = weather.getGPSWeather(lat: "40.714628", long: "-74.007315")
    
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    self.recalculatePaths()
  }

  private func configureBagCountIndicator(_ countView: UIView, color: UIColor) {
    countView.layer.cornerRadius = 2
    countView.layer.borderWidth = 1
    countView.layer.borderColor = color.cgColor
  }

  private func handleTap(in point: CGPoint) {
    guard let nextTeam = self.game.nextTeamToThrow,
      self.game.gameState == .roundInProgress else {
      return
    }

    let newBag = BagView(color: BagColor.color(for: nextTeam))
    self.playView.addSubview(newBag)
    newBag.center = point

    self.addThrowForBag(bag: newBag)
    self.bagViews.append(newBag)
    self.refreshViews()
  }

  private func addThrowForBag(bag: BagView) {
    let newThrow = self.newThrow(in: bag.center)
    self.game.addThrow(newThrow)

    if newThrow == .hole {
      bag.layer.zPosition = 1
    } else {
      bag.layer.zPosition = 3
    }

    switch self.game.gameState {
    case .roundOver:
      self.presentRoundOverAlert()
    case .gameOver:
      self.presentGameOverAlert()
    default:
      break
    }
  }

  private func newThrow(in point: CGPoint) -> Throw {
    if self.holePath.contains(point) {
      return .hole
    } else if self.boardPath.contains(point) {
      return .board
    } else {
      return .out
    }
  }

  private func presentRoundOverAlert() {
    let startNextRoundAction = UIAlertAction(title: "Start Next Round", style: .default) { _ in
      self.clearBoard()
      self.game.startNewRound()
      self.refreshViews()
    }

    let title: String
    let message: String
    switch self.game.currentRound.result {
    case .tie:
      title = "Round \(self.game.currentRoundNumber) is a tie!"
      message = "No point will be added to either team"
    case .winner(let team, let points):
      title = "\(team.name) Team wins round \(self.game.currentRoundNumber)!"
      message = "\(points) \(points == 1 ? "point" : "points") added to their total score"
    case .inProgress:
      fatalError("Can't call presentRoundOverAlert when round is inProgress")
    }

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(startNextRoundAction)

    self.present(alertController, animated: true, completion: nil)
  }

  private func presentGameOverAlert() {
    guard let winner = self.game.winner else {
      fatalError("There must be a winner before attempting to present the game over alert")
    }

    let startNewGameAction = UIAlertAction(title: "Start New Game", style: .default) { _ in
      self.clearBoard()
      self.game = Game()
      self.refreshViews()
    }

    let title = "\(winner.name) Team Wins!"
    let message = "Final score:\n" +
      "\(Team.red.name) Team: \(self.game.score(for: .red)), " +
      "\(Team.blue.name) Team: \(self.game.score(for: .blue))"

    let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alertController.addAction(startNewGameAction)

    self.present(alertController, animated: true, completion: nil)
  }
  
  private func clearBoard() {
    self.bagViews.forEach({ $0.removeFromSuperview() })
    self.bagViews.removeAll()
  }

  // For simplicity when users drag and drop a bag we regenerate all the
  // throws in the round
  @objc private func regenerateAllThrowsInRound() {
    self.game.clearCurrentRound()
    self.bagViews.forEach({ self.addThrowForBag(bag: $0) })
    self.refreshViews()
  }

  private func refreshViews() {
    self.roundLabel.text = "Round \(self.game.currentRoundNumber)"
    self.redGameScoreLabel.text = "\(self.game.score(for: .red))"
    self.blueGameScoreLabel.text = "\(self.game.score(for: .blue))"
    self.redRoundScoreLabel.text = "\(self.game.currentRound.score(for: .red))"
    self.blueRoundScoreLabel.text = "\(self.game.currentRound.score(for: .blue))"
    self.redThrowIndicatorView.isHidden = self.game.nextTeamToThrow != .red
    self.blueThrowIndicatorView.isHidden = self.game.nextTeamToThrow != .blue
    self.upateBagCountView(self.redBagCountContainerStackView, for: .red)
    self.upateBagCountView(self.blueBagCountContainerStackView, for: .blue)
  }

  /// Updates the bag indicators that show app below the round's score
  private func upateBagCountView(_ bagCountView: UIStackView, for team: Team) {
    let throwCount = team == .red ? self.game.currentRound.roundThrows(for: .red).count : self.game.currentRound.roundThrows(for: .blue).count
    let color = team == .red ? ScoringViewController.redColor : ScoringViewController.blueColor
    let remainingThrows = 4 - throwCount

    bagCountView.arrangedSubviews.enumerated().forEach { index, view in
      if remainingThrows > index {
        view.backgroundColor = color
      } else {
        view.backgroundColor = .clear
      }
    }
  }

  // These paths are based on where the shapes and sizes of the board and the whole in the 
  // original assets

  private func recalculatePaths() {
    self.recalculateHolePath()
    self.recalculateBoardPath()
  }

  private func recalculateBoardPath() {
    self.boardPath = UIBezierPath(rect: CGRect(x: self.boardImageView.frame.minX + 23,
                                               y: self.boardImageView.frame.minY + 16,
                                               width: 204,
                                               height: 408))
  }

  private func recalculateHolePath() {
    let enclosingRect = CGRect(x: self.boardImageView.frame.minX + 97,
                               y: self.boardImageView.frame.minY + 68,
                               width: 56,
                               height: 56)

    self.holePath = UIBezierPath(ovalIn: enclosingRect)
  }

  // MARK: Actions

  @IBAction func tapAction(_ sender: UITapGestureRecognizer) {
    if sender.state == .ended {
      self.handleTap(in: sender.location(in: self.playView))
    }
  }
}

