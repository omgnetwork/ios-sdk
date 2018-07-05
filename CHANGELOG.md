# Change Log
All notable changes to this project will be documented in this file.
`OmiseGO` adheres to [Semantic Versioning](http://semver.org/).

#### 0.x Betas
- `0.10.x` Betas
  - [0.10.0](#0100)
  - [0.10.1](#0101)
  - [0.10.2](#0102)
  - [0.10.3](#0103)


- `0.9.x` Betas
  - [0.9.11](#0911)

---
## [0.10.3](https://github.com/omisego/ios-sdk/releases/tag/0.10.3)
Released on 2018-7-5. All issues associated with this milestone can be found using this [filter](https://github.com/omisego/ios-sdk/issues?utf8=%E2%9C%93&q=milestone%3A0.10.3).

#### Added
- error parameter for transaction.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#67](https://github.com/omisego/ios-sdk/pull/67)

---
## [0.10.2](https://github.com/omisego/ios-sdk/releases/tag/0.10.2)
Released on 2018-7-5. All issues associated with this milestone can be found using this [filter](https://github.com/omisego/ios-sdk/issues?utf8=%E2%9C%93&q=milestone%3A0.10.2).

#### Fixed
- decoding optional parameters for accounts.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#66](https://github.com/omisego/ios-sdk/pull/66)

---
## [0.10.1](https://github.com/omisego/ios-sdk/releases/tag/0.10.1)
Released on 2018-6-27. All issues associated with this milestone can be found using this [filter](https://github.com/omisego/ios-sdk/issues?utf8=%E2%9C%93&q=milestone%3A0.10.1).

#### Updated
- decoding strategy for BigInt.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#63](https://github.com/omisego/ios-sdk/pull/63)
- format the code using SwiftFormat.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#65](https://github.com/omisego/ios-sdk/pull/65)

#### Added
- Support for server exchange.
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#64](https://github.com/omisego/ios-sdk/pull/64).

---
## [0.10.0](https://github.com/omisego/ios-sdk/releases/tag/0.10.0)
Released on 2018-6-22. All issues associated with this milestone can be found using this [filter](https://github.com/omisego/ios-sdk/issues?utf8=%E2%9C%93&q=milestone%3A0.10.0).

#### Updated
- Refactored network logic.
  - Updated by [Yuzushioh](https://github.com/yuzushioh) in Pull Request [#46](https://github.com/omisego/ios-sdk/pull/46).
- Removed unneeded timestamps.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#47](https://github.com/omisego/ios-sdk/pull/47)
- Renamed Address to Wallet.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#49](https://github.com/omisego/ios-sdk/pull/49)
- Renamed transaction request related methods
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#50](https://github.com/omisego/ios-sdk/pull/50)
- Renamed MintedToken to Token
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#52](https://github.com/omisego/ios-sdk/pull/52)
- Improved initializers by providing default values to optional parameters
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#53](https://github.com/omisego/ios-sdk/pull/53)
- Moved idempotency token from header to body
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#58](https://github.com/omisego/ios-sdk/pull/58)
- Endpoints paths
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#60](https://github.com/omisego/ios-sdk/pull/60)
- Changed Double to BigInt for amounts and subunitToUnit
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#61](https://github.com/omisego/ios-sdk/pull/61)

#### Added
- Ability to enable debug logs.
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#43](https://github.com/omisego/ios-sdk/pull/43).
- Ability to set the maximum consumptions per user in transaction requests.
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#48](https://github.com/omisego/ios-sdk/pull/48).
- Ability to make a transaction to a user.
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#51](https://github.com/omisego/ios-sdk/pull/51).
- Additional attributes to Wallet.
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#54](https://github.com/omisego/ios-sdk/pull/54).
- FormattedId param to transactionRequest and use it for QR representation
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#56](https://github.com/omisego/ios-sdk/pull/56).
- Additional errors
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#57](https://github.com/omisego/ios-sdk/pull/57).

---
## [0.9.11](https://github.com/omisego/ios-sdk/releases/tag/0.9.11)
Released on 2018-4-25. All issues associated with this milestone can be found using this [filter](https://github.com/omisego/ios-sdk/issues?utf8=%E2%9C%93&q=milestone%3A0.9.11).

#### Fixed
- Sync issue with QR code scanner.
  - Fixed by [Mederic](https://github.com/mederic-p) in Pull Request [#28](https://github.com/omisego/ios-sdk/pull/28).
- Can't pass `nil` for amount in `TransactionConsumptionParams`
  - Fixed by [Mederic](https://github.com/mederic-p) in Pull Request [#29](https://github.com/omisego/ios-sdk/pull/29).
- Don't delegate connection error for web sockets when connection is closing properly
  - Fixed by [Mederic](https://github.com/mederic-p) in Pull Request [#30](https://github.com/omisego/ios-sdk/pull/30).

#### Updated
- Web sockets events.
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#27](https://github.com/omisego/ios-sdk/pull/27) and [#32](https://github.com/omisego/ios-sdk/pull/32).
- Initialization of `PaginationParams`
  - Updated by [Mederic](https://github.com/mederic-p) in Pull Request [#36](https://github.com/omisego/ios-sdk/pull/36)

#### Added
- Objects attributes when present
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#33](https://github.com/omisego/ios-sdk/pull/33).
- Timestamps and Metadata when present
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#34](https://github.com/omisego/ios-sdk/pull/34).
- `Equatable` conformance where missing
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#35](https://github.com/omisego/ios-sdk/pull/35).
- Integration with travis
  - Added by [Mederic](https://github.com/mederic-p) in Pull Request [#38](https://github.com/omisego/ios-sdk/pull/38).
