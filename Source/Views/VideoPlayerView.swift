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
            videoLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
            videoLayer?.player?.volume = 1.0
            videoLayer?.player = AVPlayer(url: url!)
            videoLayer?.player?.actionAtItemEnd = .none
            videoLayer?.player?.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(0.1, Int32(NSEC_PER_SEC)), queue: nil, using: { [weak self] (time) in
                if let duration = self?.videoLayer?.player?.currentItem?.duration {
                    self?.didUpdateProgress?(Float(CMTimeGetSeconds(time)) / Float(CMTimeGetSeconds(duration)))
                }
                
            })
        }
    }
    
    /// Video progress handler
    public var didUpdateProgress: ((Float) -> Void)?
    
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
    
    /// Rewind to the start
    public func rewind() {
        videoLayer?.player?.seek(to: kCMTimeZero)
    }
        
    // MARK: - UIView
    
    open override class var layerClass: Swift.AnyClass {
        return AVPlayerLayer.self
    }
    
    // MARK: - Private
    
    fileprivate var videoLayer: AVPlayerLayer? {
        return layer as? AVPlayerLayer
    }
}
