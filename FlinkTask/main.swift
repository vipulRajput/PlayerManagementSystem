//
//  main.swift
//  FlinkTask
//
//  Copyright © 2018 Vipul. All rights reserved.
//
//: Playground - noun: a place where people can play

import Foundation

print("\t\t***************************************************************")
print("\t\t\tFLINK PLAYER MANAGEMENT SYSTEM")
print("\t\t\t\t\tBy:- Vipul Kumar")
print("\t\t***************************************************************\n")



typealias JSON = [String: Any]

class PlayerModel {
    
    let playerID : Int
    var name : String
    var city : String
    
    init(result : JSON) {
        
        self.playerID = result["playerID"] as! Int
        self.name = result["name"] as! String
        self.city = result["city"] as! String
    }
}

class GameDataModel {
    
    let playerID : Int
    var date : Date
    var score : Int
    var duration : Int
    
    init(result : JSON) {
        
        self.playerID = result["playerID"] as! Int
        self.date = result["date"] as! Date
        self.score = result["score"] as! Int
        self.duration = result["duration"] as! Int
    }
}

var playerModel = [PlayerModel]()
var gameDataModel = [GameDataModel]()

func enterPlayer() {

    var id = 0
    
    print("\nPlease Enter player Id")
    if let playerID = readLine(strippingNewline: true) {
        if let pid = Int(playerID), pid > 0 {
            id = pid
        } else {
            print("\nplease enter any integer > 0 for player ID")
            return
        }
    }
    
    let checkID = playerModel.filter { (player) -> Bool in
        return player.playerID == id
    }
    
    if !checkID.isEmpty {
        print("\nPlayer ID is unique, please enter different ID....")
        return
    }
    
    print("\nPlease Enter player name")
    guard let name = readLine(strippingNewline: true) else {
        return
    }
    
    if name.isEmpty {
        print("\n Please enter valid name")
        return
    }
    
    print("\nPlease Enter player city")
    guard let city = readLine(strippingNewline: true) else {
        return
    }
    
    if city.isEmpty {
        print("\n Please enter valid city")
        return
    }
    
    let json: [String:Any] = ["playerID": id, "name": name, "city": city]
    let play = PlayerModel(result: json)
    playerModel.append(play)
}

func gameDetails(choice: Int) {
    
    var id = 0
    var score = 0
    var duration = 0
    var gameData : GameDataModel
    
    print("\nPlease Enter player Id")
    if let playerID = readLine(strippingNewline: true) {
        if let pid = Int(playerID) {
            id = pid
        } else {
            print("\nplease enter any integer for ID")
            return
        }
    }
    
    let isValid = playerModel.filter { (player) -> Bool in
        return player.playerID == id
    }
    
    if isValid.isEmpty {
        print("\nSORRY!... There is no player of this id")
        return
    }
    
    let playerGameData = gameDataModel.filter({ (game) -> Bool in
        return game.playerID == isValid.first?.playerID
    })
    
    if choice == 2 {
        if !playerGameData.isEmpty {
            print("\nThis player is already having game-data, To Update details go for option 3 ...")
            return
        }
    }
    
    if choice == 3 {
        if playerGameData.isEmpty {
            print("\nThis player does not have game-data, To enter game details go for option 2 ...")
            return
        }
    }
    
    print("\nPlease Enter Game Date (Format:- dd-mm-yyyy)")
    var dateString = ""
    if let date = readLine(strippingNewline: true) {
        dateString = date
    }
    
    guard let playerDate = getFormattedDate(string: dateString) else {
        return
    }
    
    print("\nPlease Enter score")
    if let playerScore = readLine(strippingNewline: true) {
        if let pscoreInt = Int(playerScore) {
            score = pscoreInt
        } else {
            print("\nplease enter any integer for score")
            return
        }
    }
    
    print("\nPlease Enter player duration")
    if let playerDuration = readLine(strippingNewline: true) {
        if let pdurationInt = Int(playerDuration) {
            duration = pdurationInt
        } else {
            print("\nplease enter any integer for duration")
            return
        }
    }
    
    if score < duration {
        print("\nDuration must be less than Score....... (as mentioned in question)")
        return
    }
    
    let json: [String:Any] = ["playerID": id, "date": playerDate, "score": score, "duration": duration]
    
    let play = GameDataModel(result: json)
    
    if choice == 2 {
        gameDataModel.append(play)
    } else {
        gameDataModel = gameDataModel.filter({ (game) -> Bool in
            return game.playerID != id
        })
        gameDataModel.append(play)
    }
}

func getFormattedDate(string: String) -> Date? {
   
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "dd-MM-yyyy"
    guard let formateDate = dateFormatter.date(from: string) else {
        print("\ndate is in incorrected format")
        return nil
    }

    return formateDate
}

func filterPlayerAccordingToDate(choice: Int){
    
    var firstDateString = ""
    var secondDateString = ""
    var intensity = [Double]()
    var enteredId = 0
    
    print("\nPlease Enter start date (Format:- dd-mm-yyyy)")
    if let first = readLine(strippingNewline: true) {
        firstDateString = first
    }
    guard let firstDate = getFormattedDate(string: firstDateString) else {
        return
    }
    
    print("\nPlease Enter end date (Format:- dd-mm-yyyy)")
    if let second = readLine(strippingNewline: true) {
        secondDateString = second
    }
    guard let seconddate = getFormattedDate(string: secondDateString) else {
        return
    }
    
    if firstDate > seconddate {
        print("\nStart date should be smaller than end date")
        return
    }
 
    if choice == 5 {
        print("\nPlease Enter player Id")
        if let playerID = readLine(strippingNewline: true) {
            if let pid = Int(playerID) {
                enteredId = pid
            } else {
                print("\nplease enter any integer for ID")
                return
            }
        }
        
        if enteredId == 0 {
            print("\nPlease enter ant ID > 0, please try again...")
            return
        }
    }
    
    let playerGameData = gameDataModel.filter({ (game) -> Bool in
        return game.date >= firstDate && game.date <= seconddate
    })
    
    if playerGameData.isEmpty {
        print("\nThere is no record in between these dates, please try again...")
        return
    } else {
        
        var finalData = [[String:Any]]()
        
        for player in playerGameData {
            
            intensity.append(Double(player.score / player.duration))
            finalData.append(["id": player.playerID, "intensity": Double(player.score / player.duration)])
        }
        
        print("\n")
        
        intensity = intensity.sorted(by: >)
        
        finalData = finalData.sorted(by: { (first, second) -> Bool in
            return first["intensity"] as! Double > second["intensity"] as! Double
        })
        
        var temp = 0
        for (index,final) in finalData.enumerated() {
            if choice == 4 {
                if index < 10 {
                    
                    let player = playerModel.filter({ (playerData) -> Bool in
                        return playerData.playerID == final["id"] as! Int
                    })
                    print("\n")
                    print("Player ID:-\t", final["id"]!)
                    print("Player Intensity:-\t", final["intensity"]!)
                    if let getPlayer = player.first {
                        print("Player Name:-\t", getPlayer.name)
                        print("Player City:-\t", getPlayer.city)
                    }
                    print("******************************************************\n")
                } else {
                    return
                }
            } else {
                if enteredId == final["id"] as! Int {
                    temp = index + 1
                }
            }
        }
        
        if choice == 5 {
            if temp != 0 {
                print("\nPosition of the player based on the game intensity is:- ", temp)
            } else {
                print("\nThere is no player of that id, plese try again...")
                return
            }
        }
        print("\n")
    }
}


func showUsers() {
    
    print("\n")
    print("To show Details of a player please enter \n1. for any specific player \n2. for all players")
    var ch :Int = 0
    if let choice = readLine(strippingNewline: true) {
        if let choiceInInt = Int(choice) {
            ch = choiceInInt
        } else {
            print("please Enter choice in integer")
            return
        }
    }
    
    
    if ch == 1 {
        
        var enteredId = 0
        print("\nPlease enter player id")
        if let id = readLine(strippingNewline: true) {
            if let idInInt = Int(id) {
                enteredId = idInInt
            } else {
                print("\nplease Enter player id in integer")
                return
            }
        }
        
        let player = playerModel.filter { (player) -> Bool in
            return player.playerID == enteredId
        }
        let playerGameData = gameDataModel.filter({ (game) -> Bool in
            return game.playerID == player.first?.playerID
        })
        
        if player.isEmpty {
            print("\nThere is no player of this ID, plese try again....")
            return
        }
        print("\n")
        print("Player Details:-\n")
        
        guard let getPlayer = player.first else {
            return
        }
            
        print("Player ID:- ", getPlayer.playerID)
        print("Player Name:- ", getPlayer.name)
        print("Player City:- ", getPlayer.city)
        if playerGameData.isEmpty {
            print("Game Data:- N/A")
        } else {
            guard let playerGame = playerGameData.first else {
                return
            }
            print("Date:- ", playerGame.date)
            print("Score:- ", playerGame.score)
            print("Duration:- ", playerGame.duration)
        }
        print("******************************************************")
        print("\n")
    
    } else if ch == 2 {
        
        print("\n")
        print("Player Details:-\n")
        
        for player in playerModel {
            let playerGameData = gameDataModel.filter({ (game) -> Bool in
                return game.playerID == player.playerID
            })
            
            print("Player ID:- ", player.playerID)
            print("Player Name:- ", player.name)
            print("Player City:- ", player.city)
            if playerGameData.isEmpty {
                print("Game Data:- N/A")
            } else {
                guard let playerGame = playerGameData.first else {
                    return
                }
                print("Date:- ", playerGame.date)
                print("Score:- ", playerGame.score)
                print("Duration:- ", playerGame.duration)
            }
            print("******************************************************")
            print("\n")
        }
    }
    
}

var ch :Int = 0
repeat {
    
    print("\nPlease enter your choice :- \n1. To create a new player \n2. To enter details of a player \n3. To update the details \n4. To Print the top 10 players who have the best game intensity \n5. To Check the player position \n6. To show the player details \n7. To Exit")
    if let choice = readLine(strippingNewline: true) {
        if let choiceInInt = Int(choice) {
            ch = choiceInInt
        } else {
            print("\nplease Enter choice in integer")
            ch = 7
        }
    }
    
    switch ch {
        
        case 1:
            enterPlayer()
        
        case 2:
            gameDetails(choice: 2)
        
        case 3:
            gameDetails(choice: 3)
        
        case 4:
            filterPlayerAccordingToDate(choice: 4)
        
        case 5:
            filterPlayerAccordingToDate(choice: 5)
        
        case 6:
            showUsers()
        
        default:
            break
    }
    
} while (ch != 7)





