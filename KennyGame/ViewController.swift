//
//  ViewController.swift
//  KennyGame
//
//  Created by Esra Arı on 23.03.2025.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var highscoreLabel: UILabel!
    
    @IBOutlet weak var kenny: UIImageView!
    
    

    var timer = Timer()// geri sayım için
    var gameTimer = Timer()// kenny nin hareketi için
    var counter = 0
    var score = 0
    var highscore = 0
    var gameActive = false // oyun bitince hareketi durduracak
    
    
  
    override func viewDidLoad() {
        super.viewDidLoad()
        gestureImg()
        highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscoreLabel.text = "Highscore: \(highscore)"
        startCountdown()
      
    }
    // tıklama hareketini kennye ekledik
    func gestureImg(){
        let tapGesture = UITapGestureRecognizer(target:self, action: #selector(imgTapped))
        kenny.isUserInteractionEnabled = true
        kenny.addGestureRecognizer(tapGesture)
        
    }
    // kennye tıklayınca skoru artırdık
    @objc func imgTapped(){
        if gameActive {
            score += 1
            scoreLabel.text = "Score: \(score)"
        }
        moveKenny()
    }
    
    func startCountdown(){
        counter = 10
        gameActive = true
        timeLabel.text = "\(counter)"
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeFunc), userInfo: nil, repeats: true)
        gameTimer = Timer.scheduledTimer(timeInterval: 0.8, target: self, selector: #selector(moveKenny), userInfo: nil, repeats: true)
    }
    @objc func timeFunc(){
        timeLabel.text = "Time: \(counter)"
        counter -= 1
        
        if counter == 0 {
            gameActive = false
            timer.invalidate()
            timeLabel.text = "0"
            gameTimer.invalidate()
           
            if score>highscore{
                highscore = score
                UserDefaults.standard.set(highscore, forKey: "highscore")// highscore u kaydet
                highscoreLabel.text = "Highscore: \(highscore)"
            }
            alertFunc()
        }
    }

    @objc func moveKenny() {
            if !gameActive { return }  // Oyun bittiyse hareket etmesin
            
            let maxX = view.bounds.width - kenny.frame.width - 20 // 20 px mesafe bırakıyoruz
            let maxY = view.bounds.height - kenny.frame.height - 100 // 100 px alt kenar boşluğu

            // Kenny'nin konumunu 20px uzaklıkla random yerleştiriyoruz
            let randomX = CGFloat.random(in: 20...maxX)
            let randomY = CGFloat.random(in: 100...maxY)
            
            UIView.animate(withDuration: 0.3) {
                self.kenny.frame.origin = CGPoint(x: randomX, y: randomY)
            }
        }
    
    func alertFunc(){
        let alert = UIAlertController(title: "Time's Up", message: "Do you want to play again?", preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel)
        let replayButton = UIAlertAction(title: "Replay", style: UIAlertAction.Style.default) {
            (UIAlertAction) in
            self.score = 0
            self.counter = 10
            self.scoreLabel.text = "Score: \(self.score)"
            self.timeLabel.text = String(self.counter)
            self.startCountdown()
            self.moveKenny()
            
        }
        self.present(alert, animated: true, completion: nil)
        alert.addAction(okButton)
        alert.addAction(replayButton)
    }
  
}
