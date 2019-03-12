//
//  LoadingView.swift
//  Weather Forecast
//
//  Created by Guilherme Nunes Ferreira on 3/12/19.
//  Copyright © 2019 Guilherme Nunes Ferreira. All rights reserved.
//

import UIKit

class LoadingView: UIView {

    // MARK: - Variables and Constants

    private static var loadingView: LoadingView? = LoadingView()

    private var dialogViewHeight: Int {
        return sunImageViewTopSpace
            + sunImageViewSize
            + sunImageViewBottomSpace
    }
    private var dialogViewWidth: Int {
        return    sunImageViewLeadingSpace
            + sunImageViewSize
            + sunImageViewTrailingSpace
    }
    private let sunImageViewTopSpace = 20
    private let sunImageViewBottomSpace = 20
    private let sunImageViewLeadingSpace = 20
    private let sunImageViewTrailingSpace = 20
    private let sunImageViewSize = 60

    private var dialogView = UIView()
    private var sunImageView = UIImageView(image: UIImage(named: "medium clear"))

    // MARK: - Init

    convenience init() {
        self.init(frame: UIScreen.main.bounds)
        initialize()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initialize() {

        loadDialogView()
        addSubview(dialogView)

        loadSunImageView()
        dialogView.addSubview(sunImageView)
    }

    // MARK: - Lifecyle
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        dialogView.center  = center
    }

    // MARK: - Layout methods

    private func loadDialogView() {

        dialogView.clipsToBounds = true
        dialogView.frame.size = CGSize(width: dialogViewWidth, height: dialogViewHeight)
        dialogView.backgroundColor = .white
        dialogView.layer.cornerRadius = 8
    }

    private func loadSunImageView() {
        sunImageView.frame.origin = originForSunImageView()
        sunImageView.frame.size = CGSize(width: sunImageViewSize, height: sunImageViewSize)
    }

    // MARK: - Positioning methods

    private func originForSunImageView() -> CGPoint {

        let yPosition = sunImageViewTopSpace
        let xPosition = sunImageViewLeadingSpace

        return CGPoint(x: xPosition, y: yPosition)
    }

    // MARK: - Presentation methods

    static func show() {

        print("[LoadingView.show] Showing loading view")

        loadingView = LoadingView()
        guard let currentLoadingView = loadingView else { return }

        let currentWindow = UIApplication.shared.keyWindow
        currentWindow?.addSubview(currentLoadingView)

        UIView.animate(withDuration: 0.3) {
            currentLoadingView.alpha = 1
            currentLoadingView.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }

        UIView.animate(withDuration: 1.0, delay: 0, options: [.repeat, .autoreverse, .curveEaseInOut], animations: {
            currentLoadingView.sunImageView.transform = CGAffineTransform(rotationAngle: .pi)
        }, completion: nil)
    }

    static func dismiss() {

        print("[LoadingView.show] Dismissing loading view")

        UIView.animate(withDuration: 0.3, animations: {
            loadingView?.alpha = 0.0
        }, completion: { (_) in
            loadingView?.removeFromSuperview()
            loadingView = nil
        })
    }
}

