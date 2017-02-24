//
//  GameManager.swift
//  Twig
//
//  Created by Jedd Goble on 2/23/17.
//  Copyright © 2017 Bells & Missiles. All rights reserved.
//

import Foundation

class GameManager {
    
    func analyzeBoard(gameState: GameState) -> GameState {
        
        var groups: Set<Group> = []
        
        // Create groups based on board
        for turn in gameState.board.turns {
            groups = checkForGroupsWithTurn(thisTurn: turn, gameState: gameState, groups: &groups)
        }
        
        var newGroups: Set<Group> = []
        // Check groups for liberties & captures
        for group in groups {
            let liberties = calculateLibertiesForGroup(group: group, gameState: gameState)
            if liberties == 0 {
                print("found capture")
            } else {
                newGroups.insert(group)
            }
        }
        
        // Update the board's turns from the updated groups
        gameState.board.turns = createTurnsFromGroups(groups: newGroups)
        
        return gameState
    }
    
    
    
    private func calculateLibertiesForGroup(group: Group, gameState: GameState) -> Int {
        
        var liberties: Set<Position> = []
        
        for turn in group.turns {
            guard let position = turn.stone?.position else {
                continue
            }
            let adjacentPositions = getAdjacentPositions(forPosition: position, withGameState: gameState)
            
            for adjacentPosition in adjacentPositions {
                
                if !gameState.board.allPositions.contains(adjacentPosition) && !liberties.contains(adjacentPosition) {
                    liberties.insert(adjacentPosition)
                }
            }
        }
        
        return liberties.count
    }
    
    private func getAdjacentPositions(forPosition position: Position, withGameState gameState: GameState) -> Set<Position> {
        var adjacentPositions: Set<Position> = []
        
        // Left
        if position.x > 0 {
            adjacentPositions.insert(Position(x: position.x - 1, y: position.y))
        }
        
        // Right
        if position.x < gameState.board.size {
            adjacentPositions.insert(Position(x: position.x + 1, y: position.y))
        }
        
        // Above
        if position.y > 0 {
            adjacentPositions.insert(Position(x: position.x, y: position.y - 1))
        }
        
        // Below
        if position.y < gameState.board.size {
            adjacentPositions.insert(Position(x: position.x, y: position.y + 1))
        }
        
        return adjacentPositions
    }
    
    private func checkForGroupsWithTurn(thisTurn: Turn, gameState: GameState, groups: inout Set<Group>) -> Set<Group> {
        
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
        
        var newGroups: Set<Group> = groups // Must create new Set since Sets cannot be mutated while iterating
        
        // Iterate through adjacent positions
        for adjacentPosition in adjacentPositions {
            
            // Iterate through the current board's turns
            for gameTurn in gameState.board.turns {
                guard let gameStone = gameTurn.stone, let thisStone = thisTurn.stone else {
                    continue
                }
                
                // Check to see if we found a stone in the adjacent position and same color
                if gameStone.position == adjacentPosition && gameStone.color == thisStone.color {
                    
                    // Found stone of same color, so check to make sure it's not already in a group
                    for group in groups {
                        if group.allPositions.contains(thisStone.position) {
                            // Stone is alraedy in a group. Simply return so we can move on.
                            return groups
                        }
                    }
                    
                    // Did not find stone in existing group. So find which group it should belong to.
                    var foundGroup = false
                    for group in groups {
                        var newGroup: Group = group
                        if group.allPositions.contains(adjacentPosition) {
                            if gameState.board.getTurnForPosition(adjacentPosition)?.stone?.color == thisStone.color {
                                newGroup.turns.insert(thisTurn)
                                foundGroup = true
                            }
                        }
                        newGroups.insert(newGroup)
                    }
                    
                    if foundGroup {
                        return newGroups
                    }
                }
            }
            
            // Still haven't found a home for this stone. So create a new Group for this stone.
            if let color = thisTurn.stone?.color {
                groups.insert(Group(color: color, turns: [thisTurn], liberties: nil))
            }
            
            return groups
        }
        
        return groups
    }
    
    private func createTurnsFromGroups(groups: Set<Group>) -> Set<Turn> {
        
        var turns: Set<Turn> = []
        
        for group in groups {
            for turn in group.turns {
                turns.insert(turn)
            }
        }
        
        return turns
    }
}
