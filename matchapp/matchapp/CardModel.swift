//
//  CardModel.swift
//  matchapp
//
//  Created by user on 1/3/18.
//  Copyright © 2018 user. All rights reserved.
//

import Foundation
import GameplayKit

class CardModel {
    var randomArray = [Card]()
    
    func randomizeArr() -> [Card] {
        let randInt = arc4random_uniform(13) + 1
        
        for i in 1...13 {
            if (i == randInt) {
                continue
            }
            else {
                let cardOne = Card()
                cardOne.cardName = "card\(i)"
                randomArray.append(cardOne)
                let cardTwo = Card()
                cardTwo.cardName = "card\(i)"
                randomArray.append(cardTwo)
            }
        }
//        put code to sort the Array
        
        let shuffle = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: randomArray)
        
        randomArray = shuffle as! [Card]
        
        return randomArray
    }
}
