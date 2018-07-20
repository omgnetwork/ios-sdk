# Change Log

## [0.10.3](https://github.com/omisego/ios-sdk/tree/0.10.3) (2018-07-05)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.10.2...0.10.3)

**Merged pull requests:**

- Add APIError object to transaction [\#67](https://github.com/omisego/ios-sdk/pull/67) ([mederic-p](https://github.com/mederic-p))

## [0.10.2](https://github.com/omisego/ios-sdk/tree/0.10.2) (2018-07-05)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.10.1...0.10.2)

**Merged pull requests:**

- Add errors to transaction [\#66](https://github.com/omisego/ios-sdk/pull/66) ([mederic-p](https://github.com/mederic-p))

## [0.10.1](https://github.com/omisego/ios-sdk/tree/0.10.1) (2018-07-03)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.10.0...0.10.1)

**Implemented enhancements:**

- Add swiftformat [\#65](https://github.com/omisego/ios-sdk/pull/65) ([mederic-p](https://github.com/mederic-p))
- Prepare for exchange support [\#64](https://github.com/omisego/ios-sdk/pull/64) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- T140 refactor [\#63](https://github.com/omisego/ios-sdk/pull/63) ([mederic-p](https://github.com/mederic-p))

## [0.10.0](https://github.com/omisego/ios-sdk/tree/0.10.0) (2018-06-22)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.11...0.10.0)

**Implemented enhancements:**

- Add more attributes to Wallet [\#54](https://github.com/omisego/ios-sdk/pull/54) ([mederic-p](https://github.com/mederic-p))
- T307 me.transfer [\#51](https://github.com/omisego/ios-sdk/pull/51) ([mederic-p](https://github.com/mederic-p))
- Refactor RequestBuilder and Endpoint [\#46](https://github.com/omisego/ios-sdk/pull/46) ([yuzushioh](https://github.com/yuzushioh))
- T259 improve log [\#43](https://github.com/omisego/ios-sdk/pull/43) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- Update CHANGELOG [\#62](https://github.com/omisego/ios-sdk/pull/62) ([mederic-p](https://github.com/mederic-p))
- T415 bigint [\#61](https://github.com/omisego/ios-sdk/pull/61) ([mederic-p](https://github.com/mederic-p))
- Update endpoint paths [\#60](https://github.com/omisego/ios-sdk/pull/60) ([mederic-p](https://github.com/mederic-p))
- Update contribution links [\#59](https://github.com/omisego/ios-sdk/pull/59) ([mederic-p](https://github.com/mederic-p))
- Remove idempotency token from header \(put it in params\) [\#58](https://github.com/omisego/ios-sdk/pull/58) ([mederic-p](https://github.com/mederic-p))
- Add db:inserted\_transaction\_could\_not\_be\_loaded error [\#57](https://github.com/omisego/ios-sdk/pull/57) ([mederic-p](https://github.com/mederic-p))
- Add formattedId to transactionRequest and use it for QR representation [\#56](https://github.com/omisego/ios-sdk/pull/56) ([mederic-p](https://github.com/mederic-p))
- Fix typo [\#55](https://github.com/omisego/ios-sdk/pull/55) ([mederic-p](https://github.com/mederic-p))
- Provide default values to init [\#53](https://github.com/omisego/ios-sdk/pull/53) ([mederic-p](https://github.com/mederic-p))
- T310 renaming [\#52](https://github.com/omisego/ios-sdk/pull/52) ([mederic-p](https://github.com/mederic-p))
- Rename TransactionRequest methods for more consistency [\#50](https://github.com/omisego/ios-sdk/pull/50) ([mederic-p](https://github.com/mederic-p))
- Rename Address model to Wallet [\#49](https://github.com/omisego/ios-sdk/pull/49) ([mederic-p](https://github.com/mederic-p))
- T281 max consumption per user [\#48](https://github.com/omisego/ios-sdk/pull/48) ([mederic-p](https://github.com/mederic-p))
- Remove updatedAt from transactions [\#47](https://github.com/omisego/ios-sdk/pull/47) ([mederic-p](https://github.com/mederic-p))

## [0.9.11](https://github.com/omisego/ios-sdk/tree/0.9.11) (2018-04-25)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.10...0.9.11)

**Implemented enhancements:**

- T59 - Add changelog file \(changes since 0.9.10\) [\#40](https://github.com/omisego/ios-sdk/pull/40) ([mederic-p](https://github.com/mederic-p))
- T109 Add badges to README [\#39](https://github.com/omisego/ios-sdk/pull/39) ([mederic-p](https://github.com/mederic-p))
- Add travis integration [\#38](https://github.com/omisego/ios-sdk/pull/38) ([mederic-p](https://github.com/mederic-p))
- T149 add missing attributes [\#34](https://github.com/omisego/ios-sdk/pull/34) ([mederic-p](https://github.com/mederic-p))
- T214 add object attribute [\#33](https://github.com/omisego/ios-sdk/pull/33) ([mederic-p](https://github.com/mederic-p))
- T212 update socket events [\#32](https://github.com/omisego/ios-sdk/pull/32) ([mederic-p](https://github.com/mederic-p))

**Fixed bugs:**

- Fix test randomly failing [\#42](https://github.com/omisego/ios-sdk/pull/42) ([mederic-p](https://github.com/mederic-p))
- Fix don't delegate error when closing connection properly [\#30](https://github.com/omisego/ios-sdk/pull/30) ([mederic-p](https://github.com/mederic-p))
- Fix can't pass nil for amount in consumption params [\#29](https://github.com/omisego/ios-sdk/pull/29) ([mederic-p](https://github.com/mederic-p))
- Fix sync issue with qr code scanner [\#28](https://github.com/omisego/ios-sdk/pull/28) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- Add xcpretty for prettier log files in travis [\#41](https://github.com/omisego/ios-sdk/pull/41) ([mederic-p](https://github.com/mederic-p))
- Add missing permission note in README [\#37](https://github.com/omisego/ios-sdk/pull/37) ([mederic-p](https://github.com/mederic-p))
- T160 update pagination params [\#36](https://github.com/omisego/ios-sdk/pull/36) ([mederic-p](https://github.com/mederic-p))
- Add missing equatable [\#35](https://github.com/omisego/ios-sdk/pull/35) ([mederic-p](https://github.com/mederic-p))
- T209 update transaction request and consumption params [\#31](https://github.com/omisego/ios-sdk/pull/31) ([mederic-p](https://github.com/mederic-p))
- T196 Add transaction consumption events on transaction request listener [\#27](https://github.com/omisego/ios-sdk/pull/27) ([mederic-p](https://github.com/mederic-p))

## [0.9.10](https://github.com/omisego/ios-sdk/tree/0.9.10) (2018-04-02)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.8...0.9.10)

**Implemented enhancements:**

- Naming consistency [\#26](https://github.com/omisego/ios-sdk/pull/26) ([mederic-p](https://github.com/mederic-p))
- Remove unused universal scheme [\#25](https://github.com/omisego/ios-sdk/pull/25) ([mederic-p](https://github.com/mederic-p))
- Swift4.1 [\#24](https://github.com/omisego/ios-sdk/pull/24) ([mederic-p](https://github.com/mederic-p))
- Web sockets implementation to allow confirmable transaction requests [\#23](https://github.com/omisego/ios-sdk/pull/23) ([mederic-p](https://github.com/mederic-p))
- Improve linter config [\#22](https://github.com/omisego/ios-sdk/pull/22) ([mederic-p](https://github.com/mederic-p))
- Improve tests [\#20](https://github.com/omisego/ios-sdk/pull/20) ([mederic-p](https://github.com/mederic-p))
- Improve swiftlint usage [\#19](https://github.com/omisego/ios-sdk/pull/19) ([mederic-p](https://github.com/mederic-p))
- Support Carthage installation [\#17](https://github.com/omisego/ios-sdk/pull/17) ([yuzushioh](https://github.com/yuzushioh))
- Add metadata to transaction [\#16](https://github.com/omisego/ios-sdk/pull/16) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- Update copyright info [\#21](https://github.com/omisego/ios-sdk/pull/21) ([mederic-p](https://github.com/mederic-p))

## [0.9.8](https://github.com/omisego/ios-sdk/tree/0.9.8) (2018-02-28)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.7...0.9.8)

**Merged pull requests:**

- Update podspec homepage [\#15](https://github.com/omisego/ios-sdk/pull/15) ([mederic-p](https://github.com/mederic-p))

## [0.9.7](https://github.com/omisego/ios-sdk/tree/0.9.7) (2018-02-28)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.6...0.9.7)

**Implemented enhancements:**

- Setup Cocoapods [\#12](https://github.com/omisego/ios-sdk/pull/12) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- Update README.md [\#14](https://github.com/omisego/ios-sdk/pull/14) ([mederic-p](https://github.com/mederic-p))
- Update CONTRIBUTING.md [\#13](https://github.com/omisego/ios-sdk/pull/13) ([mederic-p](https://github.com/mederic-p))

## [0.9.6](https://github.com/omisego/ios-sdk/tree/0.9.6) (2018-02-27)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.3...0.9.6)

**Implemented enhancements:**

- Update transaction list format [\#11](https://github.com/omisego/ios-sdk/pull/11) ([mederic-p](https://github.com/mederic-p))
- Update license and contribution files [\#10](https://github.com/omisego/ios-sdk/pull/10) ([mederic-p](https://github.com/mederic-p))
- Improve live tests [\#9](https://github.com/omisego/ios-sdk/pull/9) ([mederic-p](https://github.com/mederic-p))
- Update dates from buddhist to Gregorian [\#7](https://github.com/omisego/ios-sdk/pull/7) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- T820 list transactions [\#8](https://github.com/omisego/ios-sdk/pull/8) ([mederic-p](https://github.com/mederic-p))

## [0.9.3](https://github.com/omisego/ios-sdk/tree/0.9.3) (2018-02-22)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.2...0.9.3)

**Implemented enhancements:**

- Add missing api error [\#6](https://github.com/omisego/ios-sdk/pull/6) ([mederic-p](https://github.com/mederic-p))
- Code cleanup [\#5](https://github.com/omisego/ios-sdk/pull/5) ([mederic-p](https://github.com/mederic-p))

## [0.9.2](https://github.com/omisego/ios-sdk/tree/0.9.2) (2018-02-19)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.1...0.9.2)

**Merged pull requests:**

- T674 - T675 transaction request create and consume // QR Codes [\#4](https://github.com/omisego/ios-sdk/pull/4) ([mederic-p](https://github.com/mederic-p))

## [0.9.1](https://github.com/omisego/ios-sdk/tree/0.9.1) (2018-02-14)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.9.0...0.9.1)

**Implemented enhancements:**

- Update readme pod URL to github [\#1](https://github.com/omisego/ios-sdk/pull/1) ([mederic-p](https://github.com/mederic-p))

**Merged pull requests:**

- Fix source url [\#3](https://github.com/omisego/ios-sdk/pull/3) ([mederic-p](https://github.com/mederic-p))

## [0.9.0](https://github.com/omisego/ios-sdk/tree/0.9.0) (2017-12-15)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.8.4...0.9.0)

## [0.8.4](https://github.com/omisego/ios-sdk/tree/0.8.4) (2017-12-06)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.8.2...0.8.4)

## [0.8.2](https://github.com/omisego/ios-sdk/tree/0.8.2) (2017-11-20)
[Full Changelog](https://github.com/omisego/ios-sdk/compare/0.8.1...0.8.2)

## [0.8.1](https://github.com/omisego/ios-sdk/tree/0.8.1) (2017-11-16)


\* *This Change Log was automatically generated by [github_changelog_generator](https://github.com/skywinder/Github-Changelog-Generator)*