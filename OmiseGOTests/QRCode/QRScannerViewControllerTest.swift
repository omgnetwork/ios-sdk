//
//  QRScannerViewControllerTest.swift
//  OmiseGOTests
//
//  Created by Mederic Petit on 12/2/2018 BE.
//  Copyright © 2018 OmiseGO. All rights reserved.
//

import XCTest
@testable import OmiseGO

class QRScannerViewControllerTest: FixtureTestCase {

    //swiftlint:disable:next weak_delegate
    var mockDelegate: MockQRVCDelegate!
    var mockViewModel: MockQRViewModel!
    var stub: QRScannerViewController!

    override func setUp() {
        self.mockDelegate = MockQRVCDelegate()
        self.mockViewModel = MockQRViewModel()
        self.stub = QRScannerViewController(delegate: self.mockDelegate,
                                            client: self.testCustomClient,
                                            cancelButtonTitle: "",
                                            viewModel: self.mockViewModel)!
    }

    func testFailsWhenNotInitializedWithDesignedInit() {
        XCTAssertNil(QRScannerViewController(coder: NSCoder()))
    }

    func testShowLoadingViewWhenLoading() {
        self.mockViewModel.onLoadingStateChange?(true)
        XCTAssert(stub.loadingView.loadingSpinner.isAnimating)
    }

    func testHideLoadingViewWhenLoading() {
        self.mockViewModel.onLoadingStateChange?(true)
        XCTAssert(stub.loadingView.loadingSpinner.isAnimating)
        self.mockViewModel.onLoadingStateChange?(false)
        XCTAssert(!stub.loadingView.loadingSpinner.isAnimating)
    }

    func testCallsDelegateWithTransactionRequest() {
        let mockedTR = TransactionRequest(id: "123",
                                          type: .receive,
                                          mintedToken: StubGenerator.mintedToken(),
                                          amount: nil, address: "",
                                          correlationId: "",
                                          status: .valid)
        self.mockViewModel.onGetTransactionRequest?(mockedTR)
        XCTAssertEqual(self.mockDelegate.transactionRequest, mockedTR)
    }

    func testCallsDelegateWithError() {
        let error = OmiseGOError.unexpected(message: "Test")
        self.mockViewModel.onError?(error)
        XCTAssertNotNil(self.mockDelegate.error)
    }

}
