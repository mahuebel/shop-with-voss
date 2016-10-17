//
// VideoViewController.swift
//
// MIT License
//
// Copyright (c) 2016 Chris Voss
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//

import Foundation
import UIKit

/// A view controller that displays a video
final public class VideoViewController: UIViewController {
    
    /// The URL of the video being played
    public let url: URL?
    
    // MARK: - Initialization
    
    /// Initialize a new video view controller
    public init(url: URL?) {
        self.url = url
        super.init(nibName: nil, bundle: nil)
        
        view.addSubview(videoPlayerView)
        view.addSubview(progressView)
        
        NSLayoutConstraint.activate([
            videoPlayerView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            videoPlayerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            videoPlayerView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0),
            videoPlayerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0),
            progressView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
            progressView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -0),
            ])
        
        videoPlayerView.url = url
        videoPlayerView.didUpdateProgress = { [weak self] progress in
            self?.progressView.progress = progress
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapVideoPlayer(_:)))
        videoPlayerView.addGestureRecognizer(tapGesture)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Controller
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        videoPlayerView.rewind()
        videoPlayerView.isPlaying = true
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        videoPlayerView.isPlaying = false
    }
    
    // MARK: - Private 
    
    @objc fileprivate func didTapVideoPlayer(_ gesture: UITapGestureRecognizer) {
        videoPlayerView.isPlaying = !videoPlayerView.isPlaying
    }
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0
        view.progressTintColor = .white
        view.trackTintColor = UIColor(white: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    fileprivate let videoPlayerView: VideoPlayerView = {
        let view = VideoPlayerView(frame: .zero)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .black
        
        return view
    }()
    
}
