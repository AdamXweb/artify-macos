//
//  DownloadService.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/20/18.
//  Copyright © 2020 com.topre.Desktopaint.core. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import RxNuke
import Nuke

protocol DownloadServiceType {

    func downloadFeaturePhoto() -> Observable<DownloadPayload>
    func downloadRandomPhoto() -> Observable<DownloadPayload>
}

final class DownloadService: DownloadServiceType {

    // MARK: - Variable
    private let network: NetworkingServiceType
    private let fileHandler: FileHandler
    private let imagePipline: ImagePipeline
    private let bag = DisposeBag()

    // MARK: - Init
    init(network: NetworkingServiceType, fileHandler: FileHandler) {
        self.network = network
        self.fileHandler = fileHandler

        // Nuke Config
        var config = ImagePipeline.Configuration()
        config.enableExperimentalAggressiveDiskCaching { $0.toBase64() }
        self.imagePipline = ImagePipeline(configuration: config)
    }

    // MARK: - Public
    func downloadFeaturePhoto() -> Observable<DownloadPayload> {
        return self
            .network
            .fetchFeaturePhoto()
            .flatMapLatest { self.downloadAndSavePhoto($0) }
    }

    func downloadRandomPhoto() -> Observable<DownloadPayload> {
        return self
            .network
            .fetchRandomPhoto()
            .flatMapLatest { self.downloadAndSavePhoto($0) }
    }

    private func downloadAndSavePhoto(_ photo: Photo) -> Observable<DownloadPayload> {
        return Observable.just(photo)
            .flatMapLatest {[unowned self] (photo) -> Single<FilePayload> in
                let imageRequest = ImageRequest(url: URL(string: photo.imageURL)!)
                return self.imagePipline
                    .loadImage(with: imageRequest)
                    .map { FilePayload(image: $0.image, photo: photo) }
            }
            .flatMapLatest {[unowned self] (payload) -> Observable<DownloadPayload> in
                return self.fileHandler
                    .rx_saveImageIfNeed(payload)
                    .map { DownloadPayload(photo: payload.photo, fileUrl: $0) }
        }
    }
}
