//
//  ReturnValue.swift
//  Miki
//
//  Created by 柴田健作 on 2022/09/26.
//

import Foundation

class Result{
    var message: String?
    var result_cd: Bool?
    
    init(message: String!, result_cd: Bool!){
        self.message = message
        self.result_cd = result_cd
    }
}
