//
//  GameState.swift
//  Twig
//
//  Created by Jedd Goble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import UIKit

struct Turn {
    var turnNumber: Int
    var player: Player
    var action: TurnAction
    var stone: Stone?
}

enum TurnAction {
    case play
    case pass
    case resign
    case incomplete
}

struct Player {
    var name: String
    var color: PlayerColor
}

enum PlayerColor {
    case black
    case white
}

struct Board {
    var turns: [Turn]
    var size: Int = 19
    
    var allPositions: [Position] {
        var positions: [Position] = []
        for turn in self.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            positions.append(position)
        }
        return positions
    }
    
    func getTurnForPosition(_ position: Position) -> Turn? {
        
        for turn in turns {
            guard let stone = turn.stone else {
                return nil
            }
            
            if position == stone.position {
                return turn
            }
        }
        
        return nil
    }
    
    init(turns: [Turn], size: Int = 19) {
        self.turns = turns
        self.size = size
    }
}

class GameState: NSCopying {
    
    var currentTurn: Turn
    var board: Board
    var playerOne: Player
    var playerTwo: Player
    
    init(turn: Turn, board: Board, playerOne: Player, playerTwo: Player) {
        self.currentTurn = turn
        self.board = board
        self.playerOne = playerOne
        self.playerTwo = playerTwo
    }
    
    convenience init() {
        let playerOne = Player(name: "", color: .black)
        let playerTwo = Player(name: "", color: .white)
        let board = Board(turns: [])
        let firstTurn = Turn(turnNumber: 0, player: playerOne, action: .incomplete, stone: nil)
        
        self.init(turn: firstTurn, board: board, playerOne: playerOne, playerTwo: playerTwo)
    }
    
    func copy(with zone: NSZone? = nil) -> Any {
        let copy = GameState(turn: currentTurn, board: board, playerOne: playerOne, playerTwo: playerTwo)
        return copy
    }
}

struct Position: Equatable {
    
    var x: Int
    var y: Int
    
    static func ==(lhs: Position, rhs: Position) -> Bool {
        if lhs.x == rhs.x && lhs.y == rhs.y {
            return true
        } else {
            return false
        }
    }
}

struct Stone {
    
    var color: PlayerColor
    var position: Position
    
}

struct Group {
    
    var color: PlayerColor
    var turns: [Turn]
    var liberties: Int?
    
    var allPositions: [Position] {
        var positions: [Position] = []
        for turn in self.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            positions.append(position)
        }
        return positions
    }
}
