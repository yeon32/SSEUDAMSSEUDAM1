//
//  mainData.swift
//  SSEUDAMSSEUDAM
//
//  Created by 김정연 on 2022/10/26.
//

import Foundation
import UIKit

class userMainData {
    static let shared = userMainData()
    //var walkMealArray = Array<WalkMeal>()
    var userName : String?
    var profileImage : UIImage?
    var userType : String?
   
    var loginUser : String?
    var walkTimer : String?
    var currentDate : String?
    private init(){}
}
