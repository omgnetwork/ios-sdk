//
//  QRReader.swift
//  OmiseGO
//
//  Created by Mederic Petit on 8/2/2018.
//  Copyright © 2017-2019 Omise Go Pte. Ltd. All rights reserved.
//

import AVFoundation
import UIKit

protocol QRReaderDelegate: AnyObject {
    func onDecodedData(decodedData: String)
    func onUserPermissionChoice(granted: Bool)
}

class QRReader: NSObject {
    let session = AVCaptureSession()
    weak var delegate: QRReaderDelegate?
    lazy var previewLayer: AVCaptureVideoPreviewLayer = {
        AVCaptureVideoPreviewLayer(session: self.session)
    }()

    private let sessionQueue: DispatchQueue = DispatchQueue(label: "serial queue")

    init(delegate: QRReaderDelegate?) {
        self.delegate = delegate
        super.init()
        self.sessionQueue.async {
            self.configureReader()
        }
    }

    private func configureReader() {
        let metadataOutput = AVCaptureMetadataOutput()
        for output in self.session.outputs { self.session.removeOutput(output) }
        for input in self.session.inputs { self.session.removeInput(input) }
        if let videoCaptireDevice = AVCaptureDevice.default(for: .video) {
            try? self.session.addInput(AVCaptureDeviceInput(device: videoCaptireDevice))
        }
        self.session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        if metadataOutput.availableMetadataObjectTypes.contains(.qr) { metadataOutput.metadataObjectTypes = [.qr] }
        self.previewLayer.videoGravity = .resizeAspectFill
        self.session.commitConfiguration()
    }

    func startScanning(onStart: (() -> Void)? = nil) {
        self.sessionQueue.async {
            guard !self.session.isRunning else {
                onStart?()
                return
            }
            self.session.startRunning()
            onStart?()
        }
    }

    func stopScanning(onStop: (() -> Void)? = nil) {
        self.sessionQueue.async {
            guard self.session.isRunning else {
                onStop?()
                return
            }
            self.session.stopRunning()
            onStop?()
        }
    }

    func isAvailable() -> Bool {
        guard AVCaptureDevice.default(for: .video) != nil else { return false }
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        switch status {
        case .authorized:
            return true
        case .restricted, .denied:
            return false
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { [weak self] granted in
                guard let self = self else { return }
                DispatchQueue.main.async {
                    self.delegate?.onUserPermissionChoice(granted: granted)
                }
            })
            return true
        @unknown default:
            return false
        }
    }
}

extension QRReader: AVCaptureMetadataOutputObjectsDelegate {
    func metadataOutput(_: AVCaptureMetadataOutput,
                        didOutput metadataObjects: [AVMetadataObject],
                        from _: AVCaptureConnection) {
        self.sessionQueue.async { [weak self] in
            guard let self = self else { return }
            guard !metadataObjects.isEmpty,
                let metadataObject = metadataObjects[0] as? AVMetadataMachineReadableCodeObject,
                metadataObject.type == AVMetadataObject.ObjectType.qr,
                let decodedData = metadataObject.stringValue
            else { return }
            DispatchQueue.main.async {
                self.delegate?.onDecodedData(decodedData: decodedData)
            }
        }
    }
}
