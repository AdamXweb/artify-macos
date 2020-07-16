//
//  StatusBarViewModel.swift
//  Desktopaint-core
//
//  Created by Nghia Tran on 5/20/18.
//  Copyright © 2018 com.art.Desktopaint.core. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import Cocoa
import Moya
import Action

public protocol StatusBarViewModelType {

    var input: StatusBarViewModelInput { get }
    var output: StatusBarViewModelOutput { get }
}

public protocol StatusBarViewModelInput {

    var getFeatureWallpaperPublisher: PublishSubject<Void> { get }
}

public protocol StatusBarViewModelOutput {

    var menuItems: Variable<[NSMenuItem]> { get }
    var terminalApp: PublishSubject<Void> { get }
    var isLoading: Driver<Bool> { get }
    var openAboutWindow: Driver<Void> { get }
}

public final class StatusBarViewModel: StatusBarViewModelType, StatusBarViewModelInput, StatusBarViewModelOutput {

    public var input: StatusBarViewModelInput { return self }
    public var output: StatusBarViewModelOutput { return self }

    struct Constant {
        static let FetchInterval: RxTimeInterval = 4 * 60 * 60 // 4 hours
    }

    // MARK: - Variable
    private let bag = DisposeBag()
    private let getFeatureAction: Action<Void, Photo>
    private let getRandomAction: Action<Void, Photo>
    private let updater: AppUpdatable
    private let openAboutPublisher = PublishSubject<Void>()
    private let currentPhoto = Variable<Photo?>(nil)
    private var aboutThisArtBtn: NSMenuItem {
        let index = menus.value.index(where: { $0.kind == Menu.Kind.aboutThisPhoto } )!
        return menuItems.value[index]
    }

    // MARK: - Input
    public var getFeatureWallpaperPublisher = PublishSubject<Void>()

    // MARK: - Output
    public let menuItems = Variable<[NSMenuItem]>([])
    public let menus = Variable([Menu(kind: .getFeature, selector: #selector(StatusBarViewModel.getFeatureOnTap(_:)), keyEquivalent: "F"),
                                 Menu(kind: .random, selector: #selector(StatusBarViewModel.getRandomOnTap), keyEquivalent: "R"),
                                        Menu(kind: .separator, selector: nil),
                                        Menu(kind: .aboutThisPhoto, selector: #selector(StatusBarViewModel.aboutThisArt)),
                                         Menu(kind: .separator, selector: nil),
                                         Menu(kind: .launchOnStartup, selector: #selector(StatusBarViewModel.launchOnStartUp(_:)), defaultState: Setting.shared.isLaunchOnStartup ? .on : .off),
                                         Menu(kind: .separator, selector: nil),
                                         Menu(kind: .checkForUpdate, selector: #selector(StatusBarViewModel.checkForUpdate), keyEquivalent: "U"),
                                         Menu(kind: .about, selector: #selector(StatusBarViewModel.about)),
                                         Menu(kind: .separator, selector: nil),
                                         Menu(kind: .quit, selector: #selector(StatusBarViewModel.quitOnTap), keyEquivalent: "Q")])
    public let terminalApp = PublishSubject<Void>()
    public let isLoading: Driver<Bool>
    public let openAboutWindow: Driver<Void>

    // MARK: - Init
    public init(updater: AppUpdatable) {
        self.updater = updater

        // Open About
        openAboutWindow = openAboutPublisher.asObserver().asDriver(onErrorJustReturn: ())

        // Feauture action
        getFeatureAction = Coordinator.default.wallpaperService.setFeaturePhotoAction

        // Random
        getRandomAction = Coordinator.default.wallpaperService.randomizePhotoAction

        // isLoading
        isLoading = Observable.merge([getFeatureAction.enabled, getRandomAction.enabled])
            .map { !$0 }
            .distinctUntilChanged()
            .share()
            .asDriver(onErrorJustReturn: false)

        // Menu
        menus.asObservable()
            .map {[unowned self] in
                $0.map({ (menu) -> NSMenuItem in
                    if menu.kind == Menu.Kind.separator {
                        return NSMenuItem.separator()
                    }
                    let item = NSMenuItem(title: menu.title,
                                          action: menu.selector,
                                          keyEquivalent: menu.keyEquivalent)
                    item.target = self // Override the target
                    item.state = menu.defaultState
                    return item
                })
            }
            .bind(to: menuItems)
            .disposed(by: bag)

        // Get feature
        let getFeature = getFeatureWallpaperPublisher.asObserver()

        // Wake up
        let appWakeup = NSWorkspace.shared.notificationCenter.rx
            .notification(NSWorkspace.didWakeNotification, object: nil)
            .mapToVoid()

        // Interval
        let interval = Observable<Int>.interval(Constant.FetchInterval, scheduler: MainScheduler.instance).mapToVoid()

        // Get feature
        Observable.merge([getFeature, appWakeup, interval])
            .observeOn(MainScheduler.instance)
            .map { _ in self.menus.value.index(where: { $0.kind == Menu.Kind.getFeature } )! }
            .map { self.menuItems.value[$0] }
            .subscribe(onNext: {[weak self] (menu) in
                guard let strongSelf = self else { return }
                strongSelf.getFeatureOnTap(menu)
            })
            .disposed(by: bag)

        // Disable about this art while loading
        isLoading
            .drive(onNext: {[weak self] (isLoading) in
                guard let strongSelf = self else { return }
                strongSelf.aboutThisArtBtn.isEnabled = !isLoading

            })
            .disposed(by: bag)

        // Hook the current feature photo
        getFeatureAction.elements.bind(to: currentPhoto).disposed(by: bag)
        getRandomAction.elements.bind(to: currentPhoto).disposed(by: bag)
    }

    @objc private func getFeatureOnTap(_ menu: NSMenuItem) {
        getFeatureAction.execute(())
    }

    @objc private func getRandomOnTap() {
        getRandomAction.execute(())
    }

    @objc private func launchOnStartUp(_ menu: NSMenuItem) {
        let newState = (menu.state == NSControl.StateValue.on) ? NSControl.StateValue.off : NSControl.StateValue.on
        menu.state = newState

        // Save
        let newValue = newState == .on
        Setting.shared.isLaunchOnStartup = newValue
        LaunchOnStartup.setLaunchAtStartup(newValue)
        TrackingService.default.tracking(.launchOnStartup(LaunchOnStartupParam(isEnable: newValue)))
    }

    @objc private func quitOnTap() {
        TrackingService.default.tracking(.exitApp)
        terminalApp.onNext(())
    }

    @objc private func checkForUpdate() {
        updater.checkForUpdate()
    }

    @objc private func about() {
        openAboutPublisher.onNext(())
    }

    @objc private func aboutThisArt() {
        guard let photo = currentPhoto.value else { return }
        let url = URL(string: photo.originalSource)!
        NSWorkspace.shared.open(url)
    }
}
