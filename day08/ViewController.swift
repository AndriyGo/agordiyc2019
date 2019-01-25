//
//  ViewController.swift
//  day08
//
//  Created by Andriy GORDIYCHUK on 1/25/19.
//  Copyright © 2019 Andriy GORDIYCHUK. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let articles = ArticleManager.shared.getAllArticles()
        var i = articles.count * 3
        print("Articles at launch:\n \(articles)")
        ArticleManager.shared.newArticle(title: "test\(i)", content: "test\(i+1)", language: "test\(i+2)", image: nil)
        print("Articles after addition:\n \(ArticleManager.shared.getAllArticles())")
        print("test\(i): \(ArticleManager.shared.getArticles(containString: "test\(i)"))")
        print("test\(i+1): \(ArticleManager.shared.getArticles(containString: "test\(i+1)"))")
        print("test\(i+2): \(ArticleManager.shared.getArticles(containString: "test\(i+2)"))")
        print("test lang: \(ArticleManager.shared.getArticles(withLang: "test\(i+2)"))")
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

