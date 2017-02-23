//
//  GameManager.swift
//  Twig
//
//  Created by JeddGoble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import Foundation

class GameManager {
    
    func analyzeBoard(gameState: GameState) -> GameState {
        
        var groups: [Group] = []
        
        // Create groups based on board
        for turn in gameState.board.turns {
            groups = checkForGroupsWithTurn(thisTurn: turn, gameState: gameState, groups: &groups)
        }
        
        var newGroups: [Group] = []
        // Check groups for liberties & captures
        for group in groups {
            let liberties = calculateLibertiesForGroup(group: group, gameState: gameState)
            if liberties == 0 {
                print("found capture")
            } else {
                newGroups.append(group)
            }
        }
        
        // Update the board's turns from the updated groups
        gameState.board.turns = createTurnsFromGroups(groups: newGroups)
        
        return gameState
    }
    
    
    
    private func calculateLibertiesForGroup(group: Group, gameState: GameState) -> Int {
        
        var liberties: [Position] = []
        
        for turn in group.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            let adjacentPositions = getAdjacentPositions(forPosition: position, withGameState: gameState)
            
            for adjacentPosition in adjacentPositions {
                
                if !gameState.board.allPositions.contains(adjacentPosition) && !liberties.contains(adjacentPosition) {
                    liberties.append(adjacentPosition)
                }
            }
        }
        
        return liberties.count
    }
    
    private func getAdjacentPositions(forPosition position: Position, withGameState gameState: GameState) -> [Position] {
        var adjacentPositions: [Position] = []
        
        // Left
        if position.x > 0 {
            adjacentPositions.append(Position(x: position.x - 1, y: position.y))
        }
        
        // Right
        if position.x < gameState.board.size {
            adjacentPositions.append(Position(x: position.x + 1, y: position.y))
        }
        
        // Above
        if position.y > 0 {
            adjacentPositions.append(Position(x: position.x, y: position.y - 1))
        }
        
        // Below
        if position.y < gameState.board.size {
            adjacentPositions.append(Position(x: position.x, y: position.y + 1))
        }
        
        return adjacentPositions
    }
    
    private func checkForGroupsWithTurn(thisTurn: Turn, gameState: GameState, groups: inout [Group]) -> [Group] {
        
        guard let position = thisTurn.stone?.position else {
            return groups
        }
        
        // Check to make sure the turn position isn't already in a group
        for group in groups {
            if group.allPositions.contains(where: { $0 == position }) {
                return groups
            }
        }
        
        // Get the spaces adjacent to the turn's position
        let adjacentPositions = getAdjacentPositions(forPosition: position, withGameState: gameState)
        
        // Iterate through adjacent positions
        for adjacentPosition in adjacentPositions {
            
            // Iterate through the current board's turns
            for gameTurn in gameState.board.turns {
                guard let gameStone = gameTurn.stone else {
                    continue
                }
                
                // Check to see if we found a stone in the adjacent position and same color
                if gameStone.position == adjacentPosition && gameStone.color == thisTurn.stone?.color {
                    
                    // Found stone of same color, so check to make sure it's not already in a group
                    for i in 0..<groups.count {
                        if groups[i].allPositions.contains(where: { $0 == thisTurn.stone?.position }) {
                            // Stone is alraedy in a group. Simply return so we can move on.
                            return groups
                        }
                    }
                    
                    // Did not find stone in existing group. So find which group it should belong to.
                    for i in 0..<groups.count {
                        if groups[i].allPositions.contains(where: { $0 == adjacentPosition }) {
                            groups[i].turns.append(thisTurn)
                            return groups
                        }
                    }
                }
            }
            
            // Still haven't found a home for this stone. So create a new Group for this stone.
            if let color = thisTurn.stone?.color {
                groups.append(Group(color: color, turns: [thisTurn], liberties: nil))
            }
            
            return groups
        }
        
        return groups
    }
    
    private func createTurnsFromGroups(groups: [Group]) -> [Turn] {
        
        var turns: [Turn] = []
        
        for group in groups {
            for turn in group.turns {
                turns.append(turn)
            }
        }
        
        return turns
    }
}
