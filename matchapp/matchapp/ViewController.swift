//
//  ViewController.swift
//  matchapp
//
//  Created by user on 1/3/18.
//  Copyright © 2018 user. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var cards = CardModel()
    var randomizedArray = [Card]()
    var firstFlippedCard:IndexPath?
    var timer:Timer?
    var milliseconds:Double = 60 * 1000
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var timerLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        randomizedArray = cards.randomizeArr()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        //Create a Timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(elapsedTimer), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //  MARK: - Timer Methods
    
    @objc func elapsedTimer(){
        //Method that updates the view label
        milliseconds -= 1
        
        //Convert it to a String for the label
//        let timeStr = String(milliseconds / 1000)
//        timerLabel.text = "Time Remaining: \(timeStr)"

        let seconds = String.init(format: "%.2f", milliseconds / 1000)
        timerLabel.text = "Time Remaining: \(seconds)"
        
        //Will stop at zero
        
        if milliseconds <= 0 {
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
        }
        // Check if game has ended
        
        checkIfGameEnded()
    }
    
    //    MARK: - UIViewCollection Protocol Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return randomizedArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        let card = randomizedArray[indexPath.row]
        
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if milliseconds <= 0 {
            return
        }
        
        let card = randomizedArray[indexPath.row]
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        if card.isFlipped == false {
            cell.flip(card)
            if firstFlippedCard == nil {
                firstFlippedCard = indexPath
            }
            else {
                
    //      run match logic
            
            checkForMatches(indexPath)
                
            }
        }
    } // end of didSelectItemAt
    
        //        MARK: - Game logic methods
        func checkForMatches(_ secondFlippedCard:IndexPath) {
            
//            get cells and cards
            let cellOne = collectionView.cellForItem(at: firstFlippedCard!) as? CardCollectionViewCell
            let cellTwo = collectionView.cellForItem(at: secondFlippedCard) as? CardCollectionViewCell
            let cardOne = randomizedArray[firstFlippedCard!.row]
            let cardTwo = randomizedArray[secondFlippedCard.row]
            
//            Card comparison
            
            if cardOne.cardName == cardTwo.cardName {
                
                cardOne.isMatched = true
                cardTwo.isMatched = true
                
                cellOne?.remove()
                cellTwo?.remove()
                
                // Run logic to check if game has been won
                
                checkIfGameEnded()
                
            }
            else {
                
                cardOne.isFlipped = false
                cardTwo.isFlipped = false
                cellOne?.flipBack(cardOne)
                cellTwo?.flipBack(cardTwo)
                
            }
            
//            Check if card is out of view and recycled
            if cellOne == nil {
                collectionView.reloadItems(at: [firstFlippedCard!])
            }
            
            firstFlippedCard = nil
        }
    
    func checkIfGameEnded(){
        
        var isWon:Bool = true
        var header = ""
        var message = ""
        
        for card in randomizedArray {
            
            if card.isMatched == false {
                
                isWon = false
                
                if milliseconds > 0 {
                    return
                }
                else {
                    header = "Game Over!"
                    message = "You have lost"
                }
                
            }
        }
        if isWon == true {
                
            if milliseconds > 0 {
                timer?.invalidate()
                timerLabel.textColor = UIColor.green
                header = "Winner x2 Chicken Dinner!"
                message = "You have won!"
            }
            else {
                header = "Game Over!"
                message = "You have lost"
            }
        }
            
            // insert messaging to show to the user
            
            alertUser(header, message)
            
        }
        
        func alertUser(_ header:String, _ message:String) {
            
            let alert = UIAlertController(title: header, message: message, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
//            let retryAction = UIAlertAction(title: "Try Again", style: .default) { (retryAction) in
//
//            }
            
            alert.addAction(alertAction)
//            alert.addAction(retryAction)
            present(alert, animated: true, completion: nil)
        }
}

