//
// VideoPlayerView.swift
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
import AVFoundation

/// A view that plays a video
final public class VideoPlayerView: UIView {
    
    /// URL for the video to play
    public var url: URL? {
        didSet {
            videoLayer?.player = AVPlayer(url: url!)
            videoLayer?.player?.actionAtItemEnd = .none
            videoLayer?.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
                if let duration = self?.videoLayer?.player?.currentItem?.duration {
                    self?.progressView.progress = Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(duration))
                }
                
            })
        }
    }

    /// Play or pause the video
    public var isPlaying: Bool = false {
        didSet {
            if isPlaying {
                videoLayer?.player?.play()
            } else {
                videoLayer?.player?.pause()
            }
        }
    }
    
    // MARK: - Initialization
    
    override public init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(progressView)
        
        NSLayoutConstraint.activate([
            progressView.heightAnchor.constraint(equalToConstant: 5),
            progressView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0),
            progressView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            progressView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -0),
            ])
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UIView
    
    open override class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
    
    // MARK: - Private
    
    let progressView: UIProgressView = {
        let view = UIProgressView(progressViewStyle: .default)
        view.progress = 0
        view.progressTintColor = .white
        view.trackTintColor = UIColor(white: 0, alpha: 0.4)
        view.translatesAutoresizingMaskIntoConstraints = false

        return view
    }()

    fileprivate var videoLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
}
