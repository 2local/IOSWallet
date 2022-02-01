//
//  OnBoardingViewController.swift
//  2local
//
//  Created by Hasan Sedaghat on 12/29/19.
//  Copyright © 2019 2local Inc. All rights reserved.
//

import UIKit

class OnBoardingViewController: BaseVC, UIScrollViewDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var pageControl: TLPageControl!
    @IBOutlet var nextBTN: UIButton!
    var currentPage = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {

    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        switch scrollView.contentOffset.x {
        case 0..<(self.view.frame.width):
            currentPage = 0
        case (self.view.frame.width)..<(self.view.frame.width * 2):
            currentPage = 1
        case (self.view.frame.width * 2)...(self.view.frame.width * 3):
            currentPage = 2

        default:
            currentPage = 0
        }
        self.pageControl.currentPage = self.currentPage
        if currentPage == 2 {
            UIView.transition(with: self.nextBTN, duration: 0.1, options: [], animations: {
                self.nextBTN.setTitle("Continue", for: .normal)
            }, completion: nil)
        } else {
            UIView.transition(with: self.nextBTN, duration: 0.1, options: [], animations: {
                self.nextBTN.setTitle("Next", for: .normal)
            }, completion: nil)
        }
    }

    fileprivate func goToLogin() {
//        let vc = UIStoryboard.authentication.instantiate(viewController: CreatePasswordVC.self)
        let vc = UIStoryboard.authentication.instantiate(viewController: LoginViewController.self)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: false)
    }

    @IBAction func skip(_ sender: Any) {
        goToLogin()
    }

    @IBAction func next(_ sender: Any) {
        if currentPage < 2 {
            currentPage += 1
            DispatchQueue.main.async {
                let xSize = Int(self.view.frame.width) * self.currentPage
                self.scrollView.setContentOffset(CGPoint.init(x: xSize, y: 0), animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.pageControl.currentPage = self.currentPage
            }
            if currentPage == 2 {
                UIView.transition(with: self.nextBTN, duration: 0.1, options: [], animations: {
                    self.nextBTN.setTitle("Continue", for: .normal)
                }, completion: nil)
            }
        } else {
            skip(true)
        }
    }

}
