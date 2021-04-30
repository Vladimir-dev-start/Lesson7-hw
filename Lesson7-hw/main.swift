//
//  main.swift
//  Lesson7-hw
//
//  Created by Владимир on 29.04.2021.
//

import Foundation

enum ParkingError: String, Error {
    case unsuitableHeight = "Высота машины не подходит для въезда на парковку"
    case parkingLotIsClosed = "Стоянка закрыта"
    case noParkingSpacesAvailable = "Свободных парковочных мест нет"
}

protocol HeightProtocol: class {
    var height: Double { get set }
}

class Car: HeightProtocol {
    var height: Double
    
    init(height: Double) {
        self.height = height
    }
}

class ParkingLots {
    let parkingSpace: UInt = 50
    let openingHours = 7...23
    let heightRestriction = 1.8
    var busyParkingSpace: UInt
    
    var freeParkingSpace: UInt {
        return parkingSpace - busyParkingSpace
    }
    
    init(busyParkingSpace: UInt) {
        self.busyParkingSpace = busyParkingSpace
    }
    
    func getParkingTicket(car: Car) -> (Bool?, ParkingError?) {
        
        guard car.height < heightRestriction else {
            return (nil, .unsuitableHeight)
        }
        
        guard freeParkingSpace > 0 else {
            return (nil, .noParkingSpacesAvailable)
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
        case openingHours:
            break
        default:
            return (nil, .parkingLotIsClosed)
        }
        
        return (true, nil)
    }
}

var myCar = Car(height: 1.4)
var someParkLots = ParkingLots(busyParkingSpace: 48)

//---получить парковочный талон

let results = someParkLots.getParkingTicket(car: myCar)

if let _ = results.0 {
    print("Парковочный талон выдан")
} else if let resultError = results.1 {
    print(resultError.rawValue)
}

extension ParkingLots {
    
    func getsParkingTicket(car: Car) throws -> Bool {
        
        guard car.height < heightRestriction else {
            throw ParkingError.unsuitableHeight
        }
        
        guard freeParkingSpace > 0 else {
            throw ParkingError.noParkingSpacesAvailable
        }
        
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        
        switch hour {
        case openingHours:
            break
        default:
            throw ParkingError.parkingLotIsClosed
        }
        
        return true
    }
}

//---получить парковочный талон

do {
    _ = try someParkLots.getsParkingTicket(car: myCar)
    print("Парковочный талон выдан")
} catch ParkingError.unsuitableHeight {
    print(ParkingError.unsuitableHeight.rawValue)
} catch ParkingError.noParkingSpacesAvailable {
    print(ParkingError.noParkingSpacesAvailable.rawValue)
} catch ParkingError.parkingLotIsClosed {
    print(ParkingError.parkingLotIsClosed.rawValue)
} catch {
    print("Неизвестная ошибка терминала")
}
