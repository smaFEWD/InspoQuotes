//
//  QuoteTableViewController.swift
//  InspoQuotes
//
//  Created by Angela Yu on 18/08/2018.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import StoreKit

class QuoteTableViewController: UITableViewController, SKPaymentTransactionObserver {
    let productID = "com.SandiMa.InspoQuotes.PremiumQuotes"
    var quotesToShow = [
        "Our greatest glory is not in never falling, but in rising every time we fall. — Confucius",
        "All our dreams can come true, if we have the courage to pursue them. – Walt Disney",
        "It does not matter how slowly you go as long as you do not stop. – Confucius",
        "Everything you’ve ever wanted is on the other side of fear. — George Addair",
        "Success is not final, failure is not fatal: it is the courage to continue that counts. – Winston Churchill",
        "Hardships often prepare ordinary people for an extraordinary destiny. – C.S. Lewis"
    ]
    
    let premiumQuotes = [
        "Believe in yourself. You are braver than you think, more talented than you know, and capable of more than you imagine. ― Roy T. Bennett",
        "I learned that courage was not the absence of fear, but the triumph over it. The brave man is not he who does not feel afraid, but he who conquers that fear. – Nelson Mandela",
        "There is only one thing that makes a dream impossible to achieve: the fear of failure. ― Paulo Coelho",
        "It’s not whether you get knocked down. It’s whether you get up. – Vince Lombardi",
        "Your true success in life begins only when you make the commitment to become excellent at what you do. — Brian Tracy",
        "Believe in yourself, take on your challenges, dig deep within yourself to conquer fears. Never let anyone bring you down. You got to keep going. – Chantal Sutherland"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        SKPaymentQueue.default().add(self) // when you are adding a new protocol "SKPaymentTransactionObserver" and adding a new delegate method, you have to declare a class as the new delegate--we can set ourselves as the delegate-- any changes--it will contact the QuoteTableViewController -and wil trigger the paymentQueue method
        
        if isPurchased() { // if they have previously purchased then we show them the premiumQuotes immediately
            showPremiumQuotes()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //  return the number of rows
        if isPurchased() {
            return quotesToShow.count
        } else {
            return quotesToShow.count + 1 // adding one more cell to account for "Get More Quote" at the end

        }
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "QuoteCell", for: indexPath)
        // populate/configure the cells to render the existing 6 cells of quotes (index 0--> 5, count = 6)
        if indexPath.row < quotesToShow.count {
            cell.textLabel?.text = quotesToShow[indexPath.row]
            cell.textLabel?.numberOfLines = 0 // prevents the content from being cut off
            cell.textLabel?.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            cell.accessoryType = .none
        } else {
            cell.textLabel?.text = "Get More Quotes" // on quotesToShow.count = 6, this is our BUY button
            cell.textLabel?.textColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            cell.accessoryType = .disclosureIndicator
            
        }
        return cell
    }

     // MARK: - Table view delegate source
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == quotesToShow.count {
            buyPremiumQuotes()
            print("Clicked on Buy More Quotes")
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // MARK: In-App Purchase Methods
    func buyPremiumQuotes() {
        // check to make sure they can make purchases (no parental controls)
        if SKPaymentQueue.canMakePayments() {
        // can make payments
        let paymentRequest = SKMutablePayment()
            paymentRequest.productIdentifier = productID
            SKPaymentQueue.default().add(paymentRequest)
        } else {
        // can't make payments
        print("User can't make payments")
        }
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
            if transaction.transactionState == .purchased {
            //User payment successful
                print("Transaction successful")
                showPremiumQuotes()
                UserDefaults.standard.set(true, forKey: productID)
                SKPaymentQueue.default().finishTransaction(transaction)
            } else if transaction.transactionState == .failed {
                //Payment failed
      
                if let error = transaction.error {
                    let errorDescription = error.localizedDescription
                    print("Transaction failed due to error: \(errorDescription)")
                }
            }
        }
    }
    
    func showPremiumQuotes(){
        quotesToShow.append(contentsOf: premiumQuotes)
        tableView.reloadData()
    }
    
    func isPurchased() -> Bool{
        let purchaseStatus = UserDefaults.standard.bool(forKey: productID)
        if purchaseStatus == true {
            print("Previously puchased")
            return true
        } else {
            print("Never purchased")
            return false
        }
        
    }
    
    @IBAction func restorePressed(_ sender: UIBarButtonItem) {
        
    }


}
