//
//  ViewController.swift
//  RxSwift-Practice
//
//  Created by 김수연 on 2022/03/31.
//

import UIKit

import SnapKit
import RxSwift
import RxCocoa
import BonMot

var disposeBagContext: UInt8 = 0

class ViewController: UIViewController {

    var disposeBag: DisposeBag {
        if let disposeBag = objc_getAssociatedObject(self, &disposeBagContext) as? DisposeBag {
            return disposeBag
        } else {
            let disposeBag = DisposeBag()
            objc_setAssociatedObject(self, &disposeBagContext, disposeBag, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN)
            return disposeBag
        }
    }

    let button: UIButton = {
        let btn = UIButton()
        let config = UIImage.SymbolConfiguration(
            pointSize: 70, weight: .light, scale: .default)
        let image = UIImage(systemName: "hand.tap", withConfiguration: config)
        btn.setImage(image?.tintedImage(color: UIColor.black), for: .normal)
        btn.setImage(image?.tintedImage(color: UIColor.red), for: .highlighted)
        btn.imageView?.contentMode = .scaleAspectFill

        return btn
    }()

    let buttonTitle: UILabel = {
        let label = UILabel()
        label.text = "TOUCH"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        return label
    }()

    let debugLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.font = .systemFont(ofSize: 20, weight: .light)
        label.textAlignment = .center
        label.textColor = .red
        return label
    }()

    var touchCount = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(button)
        button.snp.makeConstraints { (make) in
            make.height.width.equalTo(100)
            make.centerY.centerX.equalToSuperview()
        }

        view.addSubview(buttonTitle)
        buttonTitle.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(button.snp.bottom).offset(10)
        }

        view.addSubview(debugLabel)
        debugLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.top.equalTo(buttonTitle.snp.bottom).offset(10)
        }

        configureStream()
    }

    func configureStream() {
        button.rx.tap.asDriver()
            .do(onNext: {
                self.touchCount += 1
            })
                .debounce(.seconds(3))
            //.throttle(.seconds(3), latest: true)
            .drive(onNext: { _ in
                print("***** :: \(self.touchCount) ")
                self.debugLabel.text! += "→ \(self.touchCount) "
            }).disposed(by: disposeBag)
    }
}

