//
//  ViewController.swift
//  testRxSwift
//
//  Created by yuki.osu on 2021/02/17.
//

import UIKit
import RxSwift
import RxCocoa

extension ObservableType {
    
    func catchErrorJustComplete() -> Observable<Element> {
            return catchError { _ in
                return Observable.empty()
            }
        }
    
    func asDriverOnErrorJustComplete() -> Driver<Element> {
        return asDriver { error in
            return Driver.empty()
        }
    }
        
    func mapToVoid() -> Observable<Void> {
        return map { _ in }
    }
    
}

enum MyError: Error {
    case error1
}

class ViewController: UIViewController {

    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var label1: UILabel!
    
    let disposeBag = DisposeBag()
    var tapGesture: UITapGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        var count = 1
//        let observable: Observable<Int> = .create { observer in
//            let error = NSError(domain: "Test", code: 400 + count, userInfo: nil)
//            observer.onNext(1)
//            observer.onNext(2)
//            if count < 3 {
//                observer.onError(error)
//                count+=1
//            }
//            observer.onNext(3)
//            observer.onNext(4)
//            observer.onCompleted()
//
//            return Disposables.create()
//        }
        let single: Single<Int> = .create { observer in
            let error = NSError(domain: "Test", code: 400 + count, userInfo: nil)
            if count < 3 {
                observer(.error(error))
                count+=1
                return Disposables.create()
            }
            observer(.success(0))
         
            return Disposables.create()
        }

        single
            .debug()
            .retry(3)
            .subscribe()
            .disposed(by: self.disposeBag)
    }
}
