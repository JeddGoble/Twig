//
//  GameState.swift
//  Twig
//
//  Created by Jedd Goble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import UIKit

struct Turn: Hashable, Equatable {
    var turnNumber: Int
    var player: Player
    var action: TurnAction
    var stone: Stone?
    
    var hashValue: Int {
        return turnNumber.hashValue
    }
    
    static func ==(lhs: Turn, rhs: Turn) -> Bool {
        return lhs.turnNumber == rhs.turnNumber
    }
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
    var turns: Set<Turn>
    var size: Int = 19
    
    var allPositions: Set<Position> {
        var positions: Set<Position> = []
        for turn in self.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            positions.insert(position)
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
    
    init(turns: Set<Turn>, size: Int = 19) {
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

struct Position: Hashable, Equatable {
    
    var x: Int
    var y: Int
    
    var hashValue: Int {
        return "\(x),\(y)".hashValue
    }
    
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

struct Group: Hashable, Equatable {
    
    var color: PlayerColor
    var turns: Set<Turn>
    var liberties: Int?
    
    var allPositions: Set<Position> {
        var positions: Set<Position> = []
        for turn in self.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            positions.insert(position)
        }
        return positions
    }
    
    var hashValue: Int {
        return turns.hashValue
    }
    
    static func ==(lhs: Group, rhs: Group) -> Bool {
        for turn in lhs.turns {
            if !rhs.turns.contains(turn) {
                return false
            }
        }
        return true
    }
    
}
