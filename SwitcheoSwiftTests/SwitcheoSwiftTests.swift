//
//  SwitcheoSwiftTests.swift
//  SwitcheoSwiftTests
//
//  Created by Rataphon Chitnorm on 8/15/18.
//  Copyright © 2018 O3 Labs Inc. All rights reserved.
//

import XCTest
@testable import SwitcheoSwift

class SwitcheoSwiftTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testContracts() {
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.contracts { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testTickersCandlesticks(){
        let exp = expectation(description: "Wait for response")
        
        let request  = RequestCandlesticks(pair: "SWTH_NEO",
                                          interval: 1,
                                          startTime: 1531213200,
                                          endTime: 1531220400)!
        
        Switcheo(net: .Test)?.tickersCandlesticks(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTickersLast24hours(){
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.tickersLast24hours { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
                print(type(of: response))
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTickersLastPrice(){
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.tickersLastPrice(symbols: [], completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testOffers(){
        let exp = expectation(description: "Wait for response")
        let request = RequestOffer(blockchain: "neo",
                                  pair: "SWTH_NEO",
                                  contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        Switcheo(net: .Test)?.offers(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTrades(){
        let exp = expectation(description: "Wait for response")
        let request = RequestTrade(blockchain: "neo",
                                        pair: "SWTH_NEO",
                                        limit: 3,
                                        from: nil,
                                        to: nil,
                                        contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!

        Switcheo(net: .Test)?.trades(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 7, handler: nil)
    }
    
    func testDeposit(){
        let exp = expectation(description: "Wait for response")
  
        let tx = RequestTransaction(blockchain: "neo", assetID: "SWTH", amount: 10, contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        
        account.createDeposit(requestTransaction: tx, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteDeposit(createdResponse: response, completion: { (result) in
                    switch result {
                    case .failure(let error):
                        print(error as Any)
                    case .success(let response):
                        exp.fulfill()
                        print(response as Any)
                    }
                })
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testWithdrawal(){
        
        let exp = expectation(description: "Wait for response")
        
        let tx =  RequestTransaction(blockchain: "neo",
                                          assetID: "SWTH",
                                          amount: 10,
                                          contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        account.createWithdrawal(requestTransaction: tx, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteWithdrawal(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        exp.fulfill()
                        print(rsp as Any)
                    }
                    
                })
            }
        })
        
        
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    
    func testBalances(){
        let exp = expectation(description: "Wait for response")
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        let addresses = [account.wif,"KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq"]
        let contractHashs = ["a195c1549e7da61b8da315765a790ac7e7633b82"]
        Switcheo(net: .Test)?.balances(addresses: addresses ,
                                 contractHashs: contractHashs ,
                                 completion: { (result) in
                                    switch result {
                                    case .failure(let error):
                                        print(error as Any)
                                    case .success(let response):
                                        print(response)
                                        exp.fulfill()
                                        print(response as Any)
                                    }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testPairs() {
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.exchangePairs(bases: ["SWTH"], completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTokens() {
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.exchangeTokens { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
  
                print(response as Any)
                
                let decoder = JSONDecoder()
                let responseData = try? JSONSerialization.data(withJSONObject: response["NEO"] as Any, options: .prettyPrinted)
                let detail = try? decoder.decode(TokenDetail.self, from: responseData!)
                if (detail == nil) {
                    print("null null")
                    return
                }
                print(detail as Any)
                
                exp.fulfill()

            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testTimestampe() {
        let exp = expectation(description: "Wait for response")
        Switcheo(net: .Test)?.exchangeTimestamp { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print("_____________________________________________________")
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testOrders(){
        let exp = expectation(description: "Wait for response")
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        account.orders(contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print("_____________________________________________________")
                print(response as Any)
                
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testMakeOrder(){
        let exp = expectation(description: "Wait for response")
//        let order = Order(pair: "SWTH_NEO", blockchain: "neo", side: "sell", price: 0.0007111, wantAmount: 0.1, useNativeTokens: true, orderType: "limit", contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        let order = RequestOrder(pair: "SWTH_NEO",
                               blockchain: "neo",
                               side: "buy",
                               price: 0.0007,
                               wantAmount: 100,
                               useNativeTokens: true,
                               orderType: "limit",
                               contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82",
                               otcAddress:"")!
        
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        
        account.createOrder(requestOrder: order, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteOrder(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        print(rsp as Any)
                        exp.fulfill()
                    }
                })
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeOtcBuyOrder(){
        let exp = expectation(description: "Wait for response")
        let order = RequestOrder(pair: "SWTH_NEO",
                                 blockchain: "neo",
                                 side: "buy",
                                 price: 0.0008,
                                 wantAmount: 100,
                                 useNativeTokens: true,
                                 orderType: "otc",
                                 contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82",
                                 otcAddress:"ANoW2zD8HmhbWJAjL4yKJWCZcF2WFb1ire")!
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                              switcheo: Switcheo(net: .Test)! )!
//            otcAddress:"ANovQs3YXipL4HxRmj4D62YLCLEGsK7iDG")!
//        let account = Account(wif: "L2MiBiwnmh9UUfNHSUNgN6Xh37ifsaLYAbUMHGRsxXQJe2VnAF83",
//                              switcheo: Switcheo(net: .Test)! )!
        
        account.createOrder(requestOrder: order, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteOrder(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        print(rsp as Any)
                        exp.fulfill()
                    }
                })
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testMakeOtcSaleOrder(){
        let exp = expectation(description: "Wait for response")
        let order = RequestOrder(pair: "SWTH_NEO",
                                 blockchain: "neo",
                                 side: "sell",
                                 price: 0.0008,
                                 wantAmount: 0.08,
                                 useNativeTokens: true,
                                 orderType: "otc",
                                 contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82",
                                 otcAddress:"ANovQs3YXipL4HxRmj4D62YLCLEGsK7iDG")!
        let account = Account(wif: "L2MiBiwnmh9UUfNHSUNgN6Xh37ifsaLYAbUMHGRsxXQJe2VnAF83",
                              switcheo: Switcheo(net: .Test)! )!
//                                             otcAddress:"ANoW2zD8HmhbWJAjL4yKJWCZcF2WFb1ire")!
//                    let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
//                                          switcheo: Switcheo(net: .Test)! )!
        
        account.createOrder(requestOrder: order, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteOrder(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        print(rsp as Any)
                        exp.fulfill()
                    }
                })
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    

    func testOrderCancellation(){
        let exp = expectation(description: "Wait for response")
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                                   switcheo: Switcheo(net: .Test)! )!
        account.createCancellation(orderID: "d462fbc3-baf3-47ea-a291-3e5f4048789a", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteCancellation(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        exp.fulfill()
                        print(rsp as Any)
                    }
                })
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
    
        func testToFixed(){
            let d = 0.1
            print(d.toFixed(8)) // 0.10000000
//            print(d.toAssetAmount("NEO")) //10000000
    }
    
    func testWrappedDeposit(){
        let exp = expectation(description: "Wait for response")
        
        let tx = RequestTransaction(blockchain: "neo", assetID: "NEO", amount: 500, contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        
        let account = Account(wif: "L2MiBiwnmh9UUfNHSUNgN6Xh37ifsaLYAbUMHGRsxXQJe2VnAF83",
                              switcheo: Switcheo(net: .Test)! )!
        
        account.deposit(requestTransaction: tx) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testWrappedWithdrawal(){
        
        let exp = expectation(description: "Wait for response")
        
        let tx =  RequestTransaction(blockchain: "neo",
                                     assetID: "GAS",
                                     amount: 1,
                                     contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        let account = Account(wif: "L2MiBiwnmh9UUfNHSUNgN6Xh37ifsaLYAbUMHGRsxXQJe2VnAF83",
                              switcheo: Switcheo(net: .Test)! )!
      
        account.withdrawal(requestTransaction: tx, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        })

        waitForExpectations(timeout: 15, handler: nil)
    }
    
    func testWrappedOrder(){
        let exp = expectation(description: "Wait for response")
        //        let order = Order(pair: "SWTH_NEO", blockchain: "neo", side: "sell", price: 0.0007111, wantAmount: 0.1, useNativeTokens: true, orderType: "limit", contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82")!
        let order = RequestOrder(pair: "SWTH_NEO",
                                 blockchain: "neo",
                                 side: "buy",
                                 price: 0.0001234567891,
                                 wantAmount: 200.5,
                                 useNativeTokens: true,
                                 orderType: "limit",
                                 contractHash: "a195c1549e7da61b8da315765a790ac7e7633b82",
                                 otcAddress:"")!
        
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                              switcheo: Switcheo(net: .Test)! )!
        
        account.order(requestOrder: order, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
                exp.fulfill()
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }


    func testWrappedCancellation(){
        let exp = expectation(description: "Wait for response")
        let account = Account(wif: "KyUcGnbZdercSzgyNEoNbYMTEwrWehzepf5Q4Ry4CGhswDoQHHNq",
                              switcheo: Switcheo(net: .Test)! )!
        account.createCancellation(orderID: "d4c45125-b6d5-4b1d-a4f2-eed41a8efc01", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        })
        waitForExpectations(timeout: 5, handler: nil)
    }
}

