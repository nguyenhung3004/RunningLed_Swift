//
//  ViewController.swift
//  13_RunningLed
//
//  Created by Bui Duy Hien on 8/16/16.
//  Copyright © 2016 buiduyhien. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var textFiled: UITextField!
    
    var margin: CGFloat = 30 // le
    var lastOnLed = -1
    
    // 4 bien danh dau 4 goc cua ma tran
    var ihang: Int = 0
    var icot: Int = 0
    var nhang: Int = 0
    var ncot: Int = 0
    
    // i,j la bien chay, hg la huong tiep theo cua qua bong
    var hg: Int = 0
    var i: Int = 0
    var j: Int = 0
    
    var count: Int = 0
    
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textFiled.delegate = self
        
    }
    
    // Chay tu trai qua phai
    func runningLed() -> Void {
        let n = Int(textFiled.text!)
        
        if lastOnLed != -1 { // dang chay
            turnOffLed()
        }
        if lastOnLed != n!-1 {
            lastOnLed += 1
        }
        else if lastOnLed == n!-1 { // cuoi bien
            lastOnLed = 0
        }
        
        turnOnLed()
    }
    
    // Chay den Led hinh xoan oc
    func runningLedOfMatrix() -> Void {
        let n = Int(textFiled.text!)
        
        if lastOnLed == -1 { // chay lan dau tien
            lastOnLed += 1
            turnOnLed()
            return
        }
        
        count += 1
        if count == n!*n! - 1 + n!/2 {
            timer.invalidate() // dung Timer
            
        }
        
        if lastOnLed != -1 {
            turnOffLed()
        }
        if hg == 1 { // sang phai
            if j % n! == ncot-1 {
                hg = 2 // di xuong
                ncot -= 1
            }
            else {
                j += 1
                lastOnLed += 1
            }
        }
        if hg == 2 { // di xuong
            if i % n! == nhang-1 {
                hg = 3 // sang trai
                nhang -= 1
            }
            else {
                i += 1
                lastOnLed += n!
            }
        }
        if hg == 3 { // sang trai
            if j == icot {
                hg = 0 // di len
                icot += 1
            }
            else {
                j -= 1
                lastOnLed -= 1
            }
        }
        if hg == 0 { // di len
            if i == ihang+1 {
                hg = 1 // sang phai
                ihang += 1
            }
            else {
                i -= 1
                lastOnLed -= n!
            }
        }
        
        turnOnLed()
    }
    
    func turnOnLed() -> Void {
        if let ball = self.view.viewWithTag(100+lastOnLed) as? UIImageView {
            ball.image = UIImage(named: "ball_blue.png")
        }
    }
    
    func turnOffLed() -> Void {
        if let ball = self.view.viewWithTag(100+lastOnLed) as? UIImageView {
            ball.image = UIImage(named: "ball_green.png")
        }
    }
    
    // return de ket thuc keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func action_NhapSoLuongBall(_ sender: UIButton) {
        
        nhang = Int(textFiled.text!)!
        ncot = Int(textFiled.text!)!
        
        hg = 1
        
        // Xoa bong cu
        removeBallOld()
        // Ve bong moi
        drawRowOfBall() // chay den Led tu trai qua phai
        //drawRowOfBal2l() // chay den Led tu phai qua trai
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(runningLedOfMatrix), userInfo: nil, repeats: true)
    }
    
    // chay den Led tu trai qua phai
    func drawRowOfBall() -> Void {
        let n = Int(textFiled.text!)
        var dem = 0
        
        for j in 0...n!-1 {
            for i in 0...n!-1 {
                let image = UIImage(named: "ball_green.png")
                let ball = UIImageView(image: image)
                // 60 la khoang cach cua o textField
                ball.center = CGPoint(x: margin + CGFloat(i) * spaceBetweenOfBall_Column(), y: margin + 60 + CGFloat(j) * spaceBetweenOfBall_Row())
                ball.tag = 100 + dem
                print(ball.tag)
                dem += 1
                self.view.addSubview(ball)
            }
            
        }
    }
    
    // chay den Led tu phai qua trai
    func drawRowOfBal2l() -> Void {
        let n = Int(textFiled.text!)
        var i: Int
        var dem = 0
        
        for j in 0...n!-1 {
            for (i=n!-1; i>=0; i -= 1) {
                let image = UIImage(named: "ball_green.png")
                let ball = UIImageView(image: image)
                // 60 la khoang cach cua o textField
                ball.center = CGPoint(x: margin + CGFloat(i) * spaceBetweenOfBall_Column(), y: margin + 60 + CGFloat(j) * spaceBetweenOfBall_Row())
                ball.tag = 100 + dem
                print(ball.tag)
                dem += 1
                self.view.addSubview(ball)
            }
        }
    }
    
    // Xoa cac qua bong cu khi cac qua bong moi xuat hien
    func removeBallOld() -> Void {
        for view in self.view.subviews {
            if view is UIImageView {
                view.removeFromSuperview()
            }
        }
    }
    
    // khoang cach giua cac cot
    func spaceBetweenOfBall_Column() -> CGFloat {
        let n = Int(textFiled.text!)
        return (self.view.bounds.width - 2 * margin) / (CGFloat(n!)-1)
    }
    
    // khoang cach giua cac hang
    func spaceBetweenOfBall_Row() -> CGFloat {
        // 60 la khoang cach cua o textField
        let n = Int(textFiled.text!)
        return (self.view.bounds.height - 60 - 2 * margin) / (CGFloat(n!)-1)
    }
    
}
