//
//  VaaKitUITests.swift
//  VaaKitUITests
//
//  Created by Abc Abc on 25.11.2025.
//

import XCTest

final class VaaKitUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUp() {
        super.setUp()
        continueAfterFailure = false
        
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDown() {
        super.tearDown()

        let tables = app.tables
        while tables.cells.count > 0 {
            tables.cells.element(boundBy: 0).swipeLeft()
            tables.buttons["Delete"].tap()
        }
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testNavigateToAddItemView() {
        // Oletus: plus-painikkeen label on "Add Item"
        app.buttons["Add Item"].tap()
        
        // Varmistetaan, että AddItemView avautui
        XCTAssertTrue(app.navigationBars["Add Item"].exists, "AddItemView ei avautunut")
    }
    
    func testAddingValidItemShowsInList() {
        app.buttons["Add Item"].tap()
        
        let heightField = app.textFields["Height (cm)"]
        let weightField = app.textFields["Weight (kg)"]
        
        XCTAssertTrue(heightField.exists)
        XCTAssertTrue(weightField.exists)
        
        heightField.tap()
        heightField.clearAndType("180")

        
        weightField.tap()

        weightField.clearAndType("75")

        app.buttons["Save"].tap()
        
        // Uuden itemin pitäisi ilmestyä listaan
        XCTAssertTrue(app.staticTexts["75.0 kg, BMI: 23.1"].waitForExistence(timeout: 2),
                      "Lisätty item ei ilmestynyt listaan")
    }
    
    func testInvalidValuesShowError() {
        app.buttons["Add Item"].tap()
        
        let heightField = app.textFields["Height (cm)"]
        let weightField = app.textFields["Weight (kg)"]
        
        heightField.tap()
        heightField.typeText("abc")      // virheellinen syöte
        
        weightField.tap()
        weightField.typeText("def")      // virheellinen syöte
        
        app.buttons["Save"].tap()
        
        // Varmistetaan virheilmoitus
        XCTAssertTrue(app.staticTexts.containing(NSPredicate(format: "label CONTAINS[c] %@", "Syötä kelvollinen")).firstMatch.exists,
                      "Virheilmoituksen pitäisi näkyä virheellisistä syötteistä")
    }
    
    
    @MainActor
    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}

extension XCUIElement {
    func clearAndType(_ text: String) {
        tap()
        if let stringValue = self.value as? String {
            let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
            typeText(deleteString)
        }
        typeText(text)
    }
}



