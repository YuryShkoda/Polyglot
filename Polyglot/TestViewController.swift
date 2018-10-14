//
//  TestViewController.swift
//  Polyglot
//
//  Created by Yury on 10/14/18.
//  Copyright © 2018 Yury Shkoda. All rights reserved.
//

import UIKit
import GameplayKit

class TestViewController: UIViewController {
    
    var words: [String]!
    var questionCounter = 0
    var showingQuestion = true

    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var prompt: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .fastForward, target: self, action: #selector(nextTapped))
        
        words = GKRandomSource.sharedRandom().arrayByShufflingObjects(in: words) as? [String]
        
        title = "TEST"
        
        stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        stackView.alpha     = 0
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        askQuestion()
    }
    
    @objc func nextTapped() {
        showingQuestion = !showingQuestion
        
        if showingQuestion {
            prepareForNextQuestion()
        } else {
            prompt.text = words[questionCounter].components(separatedBy: "::")[0]
            prompt.textColor = UIColor(red: 0, green: 0.7, blue: 0, alpha: 1)
        }
    }
    
    func askQuestion() {
        questionCounter += 1
        
        if questionCounter == words.count { questionCounter = 0 }
        
        prompt.text = words[questionCounter].components(separatedBy: "::")[1]
        
        let animation = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 0.5) { [unowned self] in
            self.stackView.alpha = 1
            self.stackView.transform = CGAffineTransform.identity
        }
        animation.startAnimation()
    }
    
    func prepareForNextQuestion() {
        let animation = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut) { [unowned self] in
            self.stackView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            self.stackView.alpha     = 0
        }
        animation.addCompletion { position in
            self.prompt.textColor = UIColor.black
            self.askQuestion()
        }
        animation.startAnimation()
    }
}
