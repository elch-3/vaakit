//
//  Entry.swift
//  VaaKit
//
//  Created by Abc Abc on 3.12.2025.
//
import Foundation

struct Entry : Identifiable {
    let id = UUID()
    let date: Date
    let weight: Double
    let bmi: Double?   // sallii puuttumisen
}
