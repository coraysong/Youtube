//
//  VideoLauncher.swift
//  Youtube
//
//  Created by 宋超 on 2019/8/31.
//  Copyright © 2019 宋超. All rights reserved.
//

import UIKit
import AVFoundation

protocol PlayerVCDelegate {
    
    func tap()
    func didMinimize()
}


class VideoPlayerView: UIView {
    
    var delegate: PlayerVCDelegate?
    
    let activityIndicatorView: UIActivityIndicatorView = {
        
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.translatesAutoresizingMaskIntoConstraints = false
        aiv.startAnimating()
        return aiv
    }()
    
    let pausePlayButton: UIButton = {
        let button = UIButton()
        let image = UIImage(named: "pause")
        button.setImage(image, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.tintColor = .white
        button.addTarget(self, action: #selector(handlePause), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    var isPlaying = false
    
    let currentTimelabel: UILabel = {
        
        let label = UILabel()
        label.text = "00:00"
        label.textColor = .white
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoLengthlabel: UILabel = {
        
        let label = UILabel()
        label.text = "00:00"
        label.textAlignment = .right
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let videoSlider: UISlider = {
        let slider = UISlider()
        slider.translatesAutoresizingMaskIntoConstraints = false
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .white
        slider.setThumbImage(UIImage(named: "circle"), for: .normal)
        
        slider.addTarget(self, action: #selector(handleSliderChange), for: .valueChanged)
        return slider
    }()
    
    @objc func handleSliderChange() {
        print(videoSlider.value)
        
        if let duration = player?.currentItem?.duration {
            let seconds = CMTimeGetSeconds(duration)
            let value = seconds * Float64(videoSlider.value)
            let seekTime = CMTime(value: Int64(value), timescale: 1)
            
            player?.seek(to: seekTime, completionHandler: { (complatedSeek) in
            })
        }
        
    }
    
    
    @objc func handlePause() {
        
        if isPlaying {
            player?.pause()
            pausePlayButton.setImage(UIImage(named: "play"), for: .normal)
        }else {
            player?.play()
            pausePlayButton.setImage(UIImage(named: "pause"), for: .normal)
        }
        
        isPlaying = !isPlaying
    }
    
    let controlsContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(white: 0, alpha: 1)
        
        return view
    }()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupPlayerView()
        
        setupGradientLayer()
        
        controlsContainerView.frame = frame
        addSubview(controlsContainerView)
        controlsContainerView.addSubview(activityIndicatorView)
        activityIndicatorView.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        
        controlsContainerView.addSubview(pausePlayButton)
        pausePlayButton.centerXAnchor.constraint(equalTo: controlsContainerView.centerXAnchor).isActive = true
        pausePlayButton.centerYAnchor.constraint(equalTo: controlsContainerView.centerYAnchor).isActive = true
        pausePlayButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        pausePlayButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        controlsContainerView.addSubview(currentTimelabel)
        currentTimelabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        currentTimelabel.bottomAnchor.constraint(equalTo: bottomAnchor,constant: -2).isActive = true
        currentTimelabel.widthAnchor.constraint(equalToConstant: 50).isActive = true
        currentTimelabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoLengthlabel)
        videoLengthlabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -8).isActive = true
        videoLengthlabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -2).isActive = true
        videoLengthlabel.widthAnchor.constraint(equalToConstant: 60).isActive = true
        videoLengthlabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        controlsContainerView.addSubview(videoSlider)
        videoSlider.rightAnchor.constraint(equalTo: videoLengthlabel.leftAnchor).isActive = true
        videoSlider.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        videoSlider.leftAnchor.constraint(equalTo: currentTimelabel.rightAnchor).isActive = true
        videoSlider.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        backgroundColor = .black
        
        let panGesture = UIPanGestureRecognizer(target: self, action:#selector(handlePanGesture))
        addGestureRecognizer(panGesture)
        
    }
    
    var player: AVPlayer?
    
    
    @objc func handlePanGesture (){
        
        delegate?.didMinimize()
    }
    
    func setupPlayerView() {
        let urlstring = "https://media.w3.org/2010/05/sintel/trailer.mp4"
        
        if let url = URL(string: urlstring) {
            player = AVPlayer(url: url)
            let playerLayer = AVPlayerLayer(player: player)
            self.layer.addSublayer(playerLayer)
            playerLayer.frame = self.frame
            player?.play()
            
            player?.addObserver(self, forKeyPath: "currentItem.loadedTimeRanges", options: .new, context: nil)
            
            //跟踪播放进度
            let interVal = CMTime(value: 1, timescale: 2)
            player?.addPeriodicTimeObserver(forInterval: interVal, queue: DispatchQueue.main, using: { (progressTime) in
                let seconds = CMTimeGetSeconds(progressTime)
                print(seconds)
                let secondsString = String(format: "%02d", Int(seconds) % 60)
                let minutesString = String(format: "%02d", Int(seconds) / 60)
                self.currentTimelabel.text = "\(minutesString):\(secondsString)"
                
                //进度条跟踪
                if let duration = self.player?.currentItem?.duration {
                    let durationSeconds = CMTimeGetSeconds(duration)
                    self.videoSlider.value = Float(seconds / durationSeconds)
                }
            })
        }
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "currentItem.loadedTimeRanges" {
            activityIndicatorView.stopAnimating()
            controlsContainerView.backgroundColor = .clear
            
            pausePlayButton.isHidden = false
            isPlaying = true
            if let duration = player?.currentItem?.duration {
                let seconds = CMTimeGetSeconds(duration)
                //这里出现一次seconds为naN bug 没再重现，有时间解决
                let secondsText = Int(seconds) % 60
                let minutesText = String(format: "%02d", Int(seconds) / 60)
                videoLengthlabel.text = "\(minutesText):\(secondsText)"
            }
            
        }
    }
    
    func setupGradientLayer() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.7,1.2]
        controlsContainerView.layer.addSublayer(gradientLayer)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class VideoLauncher: NSObject, PlayerVCDelegate {
    
    
    
    var view: UIView?
    var videoPlayerView: VideoPlayerView?
    
    func tap() {
        print("点了")
    }
    func didMinimize() {
        if let view = self.view {
            UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
                let screenFrame = UIScreen.main.bounds.size
                let height = screenFrame.width * 9 / 16
                
                let frame = CGRect(x: 0, y: screenFrame.height - height - 10, width: screenFrame.width, height: height)
                view.frame = frame
            }) { (completedAnimation) in
                UIApplication.shared.setStatusBarHidden(false, with: .fade)
            }
        }
    }
    func showVideoPlayer() {
        print("showing video player animation...")
        
        if let keyWindow = UIApplication.shared.keyWindow {
            view = UIView(frame: keyWindow.frame)
            if let view = view{
                view.backgroundColor = .white
                
                view.frame = CGRect(x: keyWindow.frame.width - 10, y: keyWindow.frame.height - 10, width: 10, height: 10)
                
                let height = keyWindow.frame.width * 9 / 16
                
                let videoPlayerFrame = CGRect(x: 0, y: 0, width: keyWindow.frame.width, height: height)
                
                videoPlayerView = VideoPlayerView(frame: videoPlayerFrame)
                if let videoPlayerView = videoPlayerView {
                    videoPlayerView.delegate = self
                    view.addSubview(videoPlayerView)
                }
                
                keyWindow.addSubview(view)
                viewAnimation(view: view)
                
            }
        }
    }
}


func viewAnimation(view: UIView) {
    
    if let keyWindow = UIApplication.shared.keyWindow{
        UIView.animate(withDuration: 0.5, delay: 0, options: .curveEaseOut, animations: {
            view.frame = keyWindow.frame
        }) { (completedAnimation) in
            UIApplication.shared.setStatusBarHidden(true, with: .fade)
        }
    }
    
}
