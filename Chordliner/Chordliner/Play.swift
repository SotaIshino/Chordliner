//
//  Play.swift
//  Chordliner
//
//  Created on 2020/06/22.
//  Copyright © 2020 SotaIshino All rights reserved.
//

import UIKit
import AudioToolbox

class Play: NSObject {
    
    var soundURL = NSURL()
    var soundID = SystemSoundID()
    
    func playGuitar(i: String) {
        //ファイルを読み込んで、soundURLを生成
        switch i {
            case "rest":
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "rest" as CFString?, "wav" as CFString?, nil)
            default:
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "\(i)_guitar" as CFString?, "wav" as CFString?, nil)
            }
        
        //soundIDをセット
        AudioServicesCreateSystemSoundID(soundURL, &soundID)
    
        //再生
        AudioServicesPlaySystemSound(soundID)
    }
    
    func playPiano(i: String) {
        //ファイルを読み込んで、soundURLを生成
            switch i {
                case "rest":
                soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "rest" as CFString?, "wav" as CFString?, nil)
                default:
                    soundURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), "\(i)_piano" as CFString?, "wav" as CFString?, nil)
                }
            
            //soundIDをセット
            AudioServicesCreateSystemSoundID(soundURL, &soundID)
        
            //再生
            AudioServicesPlaySystemSound(soundID)
    }
    
    func stop() {
        AudioServicesDisposeSystemSoundID(soundID)
    }

}
