# Twig

Twig is a lightweight Go / Weiqi / Baduk player made entirely in Swift for iOS. As of February 23, 2017, it is still very much a work in progress, with captures only half-working, taps not registering quite right, and groups barely being recognized. But hey, gotta start somewhere. :)

UI is created using CoreGraphics.

Structs and classes to keep track of game state are in GameState.swift, and utilize Sets / Hashable / Equatable for performance reasons.

GameManager.swift manages captures and updates the board. It can certainly be improved upon both in terms of its current bugginess and its performance analyzing the board and the groups that are created by stones.

Feedback is welcome, keeping in mind that I have only devoted a few spare hours to putting this together.

![Twig running in simulator](http://i.imgur.com/5CKS9AM.png "For the curious, this is the start of game 1 of AlphaGo vs Lee Sedol")

