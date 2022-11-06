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
    
    var userName : String?
    var profileImage : UIImage?
    var userType : String?
    var ploggingImage : UIImage?
   
    var loginUser : String?
    var walkTimer : String?
    var currentDate : String?
    private init(){}
}
