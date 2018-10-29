# Switcheo Swift SDK

Useful functions for Switcheo Exchange written in Swift.

## Usage example
New switcheo exchange with testnet or mainnet 
```swift
 let swthTestnet = Switcheo(net: .Test)!
 //or
  let swthMainnet = Switcheo(net: .Main)!
```
#### [Contracts](https://docs.switcheo.network/#contracts)
Retrieve updated contract hashes deployed by Switcheo.
choose a contract hash (dictionary value) and send to another functions required 
```swift
      let swthTestnet = Switcheo(net: .Test)!
      swthTestnet.contracts { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                // response dictionary [String : Any]
                print(response as Any)
            }
        }
```

#### [Pairs](https://docs.switcheo.network/#pairs)
Retrieve available currency pairs on Switcheo Exchange filtered by the base parameter. Defaults to all pairs.
The valid base currencies are currently: NEO, GAS, SWTH.
choose a pair (dictionary value) and send to another functions required
```swift
      let swthTestnet = Switcheo(net: .Test)!
      swthTestnet.exchangePairs(bases: [], completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                exp.fulfill()
                print(response as Any)
            }
        })
```

#### [Tokens](https://docs.switcheo.network/#tokens)
Retrieve a list of supported tokens on Switcheo.
```swift
      let swthTestnet = Switcheo(net: .Test)!
      swthTestnet.exchangeTokens { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                // response dictionary [String : Any]
                print(response as Any)
            }
        }
```

#### [Candlesticks](https://docs.switcheo.network/#candlesticks)
Returns candlestick chart object array filtered by request object.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let request  = RequestCandlesticks(pair: "<pair>",
                                          interval: 1,
                                          startTime: 1531213200,
                                          endTime: 1531220400)!
        
        swthTestnet.tickersCandlesticks(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        }
```

#### [Last 24 hours](https://docs.switcheo.network/#last-24-hours)
Returns 24-hour object array for all pairs and markets.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        swthTestnet.tickersLast24hours { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        }
```

#### [Last Price](https://docs.switcheo.network/#last-price)
Returns last price of given symbol(s). Defaults to all symbols.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        swthTestnet.tickersLastPrice { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        }
```

#### [List Offers](https://docs.switcheo.network/#list-offers)
Retrieves the best 70 offers (per side) on the offer book.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let request = RequestOffer(blockchain: "neo",
                                  pair: "<pair>",
                                  contractHash: "<contract_hash>")!
        swthTestnet.offers(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        }
```

#### [List Trades](https://docs.switcheo.network/#list-trades)
Retrieves trades that have already occurred on Switcheo Exchange filtered by the request object.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let request = RequestTrade(blockchain: "neo",
                                        pair: "<pair>",
                                        limit: 3,
                                        from: nil,
                                        to: nil,
                                        contractHash: "<contract_hash>")!
        swthTestnet.trades(request: request) { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        }
```

#### [Deposit](https://docs.switcheo.network/#deposits)
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let tx =  RequestTransaction(blockchain: "neo",
                                          assetID: "<supported_token_name>",
                                          amount: 10,
                                          contractHash: "<contract_hash>")!
        
        let account = Account(wif: "<WIF>",
                                   switcheo: swthTestnet )!
        
        account.createDeposit(requestTransaction: tx, completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteDeposit(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        print(rsp as Any)
                    }
                })
            }
        })
```

#### [Withdrawal](https://docs.switcheo.network/#withdrawals)
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let tx =  RequestTransaction(blockchain: "neo",
                                          assetID: "<supported_token_name>",
                                          amount: 10,
                                          contractHash: "<contract_hash>")!
        let account = Account(wif: "<WIF>",
                                   switcheo: swthTestnet )!
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
                        print(rsp as Any)
                    }
                })
            }
        })
        
```

#### [Orders](https://docs.switcheo.network/#list-orders)
Retrieves orders from a specific account
```swift
       let swthTestnet = Switcheo(net: .Test)!
       let account = Account(wif: "<WIF>",
                                   switcheo: swthTestnet )!
        account.orders(contractHash: "<contract_hash>", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                print(response as Any)
            }
        })
        
```

#### [Create Order](https://docs.switcheo.network/#create-order)
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let order = RequestOrder(pair: "<pair>",
                               blockchain: "neo",
                               side: "buy",
                               price: 0.0001,
                               wantAmount: 100.1,
                               useNativeTokens: true,
                               orderType: "limit",
                               contractHash: "<contract_hash>")!
        
        let account = Account(wif: "<WIF>",
                                   switcheo: swthTestnet )!
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
                    }
                })
            }
        })
        
```

#### [Cancel Order](https://docs.switcheo.network/#create-cancellation)
```swift
       let swthTestnet = Switcheo(net: .Test)!
       let account = Account(wif: "<WIF>",
                                   switcheo: swthTestnet )!
        account.createCancellation(orderID: "<orderID>", completion: { (result) in
            switch result {
            case .failure(let error):
                print(error as Any)
            case .success(let response):
                account.exececuteCancellation(createdResponse: response, completion: { (rsl) in
                    switch rsl {
                    case .failure(let err):
                        print(err as Any)
                    case .success(let rsp):
                        print(rsp as Any)
                    }
                })
            }
        })
        
```

#### [List balances](https://docs.switcheo.network/#list-balances)
List contract balances of the given address and contract.
```swift
        let swthTestnet = Switcheo(net: .Test)!
        let addresses = ["<WIF>","<WIF>"]
        let contractHashs = ["<contractHashs>","<contractHashs>"]
        swthTestnet.balances(addresses: addresses,
                                 contractHashs: contractHashs ,
                                 completion: { (result) in
                                    switch result {
                                    case .failure(let error):
                                        print(error as Any)
                                    case .success(let response):
                                        print(response as Any)
                                    }
        })
        
```
