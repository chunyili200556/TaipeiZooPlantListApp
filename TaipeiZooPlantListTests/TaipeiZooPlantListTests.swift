//
//  TaipeiZooPlantListTests.swift
//  TaipeiZooPlantListTests
//
//  Created by chunyili的Macbook Air on 2021/12/10.
//

import XCTest
@testable import TaipeiZooPlantList
import Combine

class TaipeiZooPlantListTests: XCTestCase {
    var viewModel: PlantsViewModel!
    private var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        self.viewModel = PlantsViewModel()
        self.viewModel.requestPlantsInfo()
    }
    
    func testZooPlantAPIAvailable(){
        let expectation = self.expectation(description: "testZooPlantAPIAvailable")
        viewModel.$plantList
            .receive(on: DispatchQueue.main)
            .sink { plants in
                if plants.isEmpty && self.viewModel.plantList.isEmpty{
                    return
                }
                expectation.fulfill()
                XCTAssertTrue(plants.count > 0)
            }.store(in: &cancellables)
        self.waitForExpectations(timeout:20)
    }
    
    func testResultCountIsEqual(){
        let expectation = self.expectation(description: "testResultCountIsEqual")
        
        self.viewModel.$plantList
            .receive(on: DispatchQueue.main)
            .sink { plants in
                defer{
                    if !plants.isEmpty && plants.count == self.viewModel.totalPlantsCount{
                        expectation.fulfill()
                        XCTAssertEqual(self.viewModel.plantList.count, self.viewModel.totalPlantsCount)
                    }
                }
                
                if plants.isEmpty && self.viewModel.plantList.isEmpty{
                    return
                }
                self.viewModel.requestPlantsInfo()
            }.store(in: &cancellables)
        
        self.waitForExpectations(timeout:100)
    }

}
