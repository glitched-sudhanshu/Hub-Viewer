//
//  ErrorMessage.swift
//  GHfollowers
//
//  Created by Sudhanshu Ranjan on 14/07/24.
//

import Foundation

enum GHError: String, Error {
    case invalidUsername = "This username created an invalid request. Please try again! 🙂‍↕️"
    case unableToComplete = "This username created an invalid request. Please try again! 👏🏻"
    case invalidResponse = "Invalid response from the server. Please try again! 🥲"
    case invalidData = "Data received from the server was invalid. Please try again! 😕"
}
