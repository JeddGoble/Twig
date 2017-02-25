//
//  ViewController.swift
//  Twig
//
//  Created by Jedd Goble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var boardView: BoardView!
    
    var gameState = GameState()
    var gameManager = GameManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        boardView.delegate = self
        startNewGame()
    }
    
    func startNewGame() {
        gameState = GameState()
        boardView.gameState = gameState
    }
    
    func createNextTurn(fromTurn lastTurn: Turn) -> Turn? {
        
        let nextTurnNumber = lastTurn.turnNumber + 1
        
        var nextPlayer: Player?
        
        if lastTurn.player.color == gameState.playerOne.color {
            nextPlayer = gameState.playerTwo
        } else if lastTurn.player.color == gameState.playerTwo.color {
            nextPlayer = gameState.playerOne
        }
        
        guard nextPlayer != nil else {
            return nil
        }
        
        let nextTurn = Turn(turnNumber: nextTurnNumber, player: nextPlayer!, action: .incomplete, stone: nil)
        return nextTurn
    }
    
    @IBAction func onNewGameButtonTapped(_ sender: UIButton) {
        
        startNewGame()
    }
    
}

extension ViewController: BoardViewDelegate {
    
    func didTapBoard(atPosition position: Position) {
        
        guard !gameState.board.allPositions.contains(position) else {
            print("Tapped on existing stone")
            return
        }
        
        gameState.currentTurn.stone = Stone(color: gameState.currentTurn.player.color, position: position)
        gameState.currentTurn.action = .play // Placeholder. Later must account for pass, resign, etc
        
        // Log here
        gameState.board.turns.insert(gameState.currentTurn)
        
        // Swap here
        gameState.currentTurn = createNextTurn(fromTurn: gameState.currentTurn)!
        
        // Analyze here
        gameState = gameManager.analyzeBoard(gameState: gameState)
        
        // Display here
        boardView.gameState = gameState
        
    }
    
}
