//
//  CardCollectionViewCell.swift
//  matchapp
//
//  Created by user on 1/3/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
 
    var card:Card?
    
    func setCard(_ card:Card) {
        self.card = card
        
        frontImageView.image = UIImage(named: card.cardName)
        
//        Check for match
        
        if card.isMatched == true {
            backImageView.alpha = 0
            frontImageView.alpha = 0
        }
        else {
            backImageView.alpha = 1
            frontImageView.alpha = 1
        }
        
        if (card.isFlipped == false) {
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        }
        else if (card.isFlipped == true) {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromTop, .showHideTransitionViews], completion: nil)
        }
    }
    
    func flip(_ card:Card) {
        
        if (card.isFlipped == false) {
            UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
            card.isFlipped = true
        }
    }
    
    func flipBack(_ card:Card) {
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5, execute: {
                UIView.transition(from: self.frontImageView, to: self.backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
            })
            
            card.isFlipped = false
            
    }
    
    func remove() {
        
        self.backImageView.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0.5, options: .curveEaseOut, animations: {
            self.frontImageView.alpha = 0
        }, completion: nil)
        
    }
    
}
