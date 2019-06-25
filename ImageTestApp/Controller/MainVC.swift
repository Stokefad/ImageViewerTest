//
//  ViewController.swift
//  ImageTestApp
//
//  Created by Igor-Macbook Pro on 24/06/2019.
//  Copyright © 2019 Igor-Macbook Pro. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class MainVC : UIViewController {
    
    let dBag = DisposeBag()

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var networkStatusBar: UINavigationItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        checkForError()
        configureNetworkStatusLabel()
        ImageVM.shared.startImageFetching()
        configureTableView()
        driveTableView()
        cellWasSelected()
    }
    
    private func configureNetworkStatusLabel() {
        ImageVM.shared.networkRelay.asObservable().subscribe { [unowned self] (value) in
            guard let element = value.element else {
                return
            }
            self.networkStatusBar.title = element ? "Online" : "Offline"
        }
            .disposed(by: dBag)
    }
    
    private func checkForError() {
        ImageVM.shared.successRelay.asObservable().subscribe { [unowned self] (value) in
            if value.element == false {
                let controller = UIAlertController(title: "Error", message: "You don't have both network connection and local images", preferredStyle: .alert)
                controller.addAction(UIAlertAction(title: "Retry", style: .default, handler: { (action) in
                    ImageVM.shared.startImageFetching()
                }))
                
                self.present(controller, animated: true, completion: nil)
            }
        }
            .disposed(by: dBag)
    }
}

// Rx tableView

extension MainVC {
    private func driveTableView() {
        ImageVM.shared.imagesRelay.asDriver().drive(tableView.rx.items(cellIdentifier: "ImageCell", cellType: ImageCell.self)) { row, model, cell in
            cell.configureUI(imageModel: model)
        }
            .disposed(by: dBag)
    }
    
    private func cellWasSelected() {
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            let fullView = FullScreenFactory.returnFullScreen(imageModel: ImageVM.shared.imagesRelay.value[indexPath.row], sender: self)
            UIView.transition(with: self.view, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
            self.view.addSubview(fullView)
        }).disposed(by: dBag)
    }

}

// Delegate tableView

extension MainVC : UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(ImageSizer.sizeImageViewHeight(model: ImageVM.shared.imagesRelay.value[indexPath.row], view: tableView)) + 100
    }
 
    private func configureTableView() {
        
        self.tableView.delegate = self
        
        self.tableView.register(ImageCell.self, forCellReuseIdentifier: "ImageCell")
    }
}
