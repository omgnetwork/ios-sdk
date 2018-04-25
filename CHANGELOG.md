# Change Log
All notable changes to this project will be documented in this file.
`OmiseGO` adheres to [Semantic Versioning](http://semver.org/).

#### 0.x Betas
- `0.9.x` Betas - [0.9.11](#0911)

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
