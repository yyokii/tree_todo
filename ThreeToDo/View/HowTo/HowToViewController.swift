//
//  HowToViewController.swift
//  ThreeToDo
//
//  Created by Yoki Higashihara on 2019/03/22.
//  Copyright © 2019 Yoki Higashihara. All rights reserved.
//

import UIKit

enum Presentation{
    case normal
    case closeButton
}

class HowToViewController: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    var slides:[SlideItem] = []
    var presentationCase = Presentation.normal
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.delegate = self
        
        setUpView()
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
    }
    
    private func setUpView() {
        switch presentationCase {
        case .normal:
            closeButton.isHidden = true
            startButton.isHidden = true
        case .closeButton:
            closeButton.isHidden = false
            startButton.isHidden = true
        }
    }
    
    func createSlides() -> [SlideItem] {
        
        let slide1 = Bundle.main.loadNibNamed("SlideItem", owner: self, options: nil)?.first as! SlideItem
        slide1.imageView.image = UIImage(named: "how_to_three_todo")
        slide1.titleLabel.text = "3 TODO"
        slide1.descriptionLabel.text = "ダウンロードしていただきありがとうございます！\n3TODOは絶対に達成できるTODOアプリです！"
        
        let slide2 = Bundle.main.loadNibNamed("SlideItem", owner: self, options: nil)?.first as! SlideItem
        slide2.imageView.image = UIImage(named: "how_to_list")
        slide2.titleLabel.text = "TODOは3つまで"
        slide2.descriptionLabel.text = "１度に設定できるTODOは3つまで"
        
        let slide3 = Bundle.main.loadNibNamed("SlideItem", owner: self, options: nil)?.first as! SlideItem
        slide3.imageView.image = UIImage(named: "how_to_set_todo")
        slide3.titleLabel.text = "TODOを設定しよう"
        slide3.descriptionLabel.text = "優先度の高いものを考え、TODOを設定していきましょう！"
        
        let slide4 = Bundle.main.loadNibNamed("SlideItem", owner: self, options: nil)?.first as! SlideItem
        slide4.imageView.image = UIImage(named: "how_to_do_todo")
        slide4.titleLabel.text = "TODOを達成しよう"
        slide4.descriptionLabel.text = "現在のTODOが終わるまで次のTODOは見ることができません"
        
        let slide5 = Bundle.main.loadNibNamed("SlideItem", owner: self, options: nil)?.first as! SlideItem
        slide5.imageView.image = UIImage(named: "how_to_lets_start")
        slide5.titleLabel.text = "たったこれだけです"
        slide5.descriptionLabel.text = "TODOを３つに絞り、１つのTODOにだけ集中する。\nこれだけで達成率が変わります。\nえ、信じられない？　データは嘘をつきません。科学的なTODOを今すぐ試してみましょう！"
        
        return [slide1, slide2, slide3, slide4, slide5]
    }
    
    func setupSlideScrollView(slides : [SlideItem]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    func showStartButton(pageIndex: Int) {
        switch presentationCase {
        case .normal:
            if pageIndex == 4 {
                switch presentationCase {
                case .normal:
                    startButton.isHidden = false
                case .closeButton:
                    startButton.isHidden = true
                }
            } else {
                startButton.isHidden = true
            }
        case .closeButton:
            break
        }
    }
    
    @IBAction func tapCloseButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func tapStartButton(_ sender: Any) {
        let todoListVC = UIStoryboard(name: "TodoList", bundle: nil).instantiateInitialViewController() as! TodoListVC
        let model = TodoListModel()
        let presenter = TodoListPresenter(view: todoListVC, model: model)
        todoListVC.inject(presenter: presenter)

        present(todoListVC, animated: true, completion: nil)
    }
}

extension HowToViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        showStartButton(pageIndex: Int(pageIndex))

        // horizontal
        /// コンテンツオフセットが取りうるx座標の最大値
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        /// x座標が全体の何パーセント進んでいるか
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        /// y座標が全体の何パーセント進んでいるか（固定）
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
                
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        let percentOffset = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        
        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
            // １ページ目〜2ページ目表示まで
            
            // (0.25-percentOffset.x)/0.25: 進み具合に応じて小さくなる値
            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
            // percentOffset.x/0.25: 進み具合に応じて大きくなる値
            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
        }  else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        }
    }
}
