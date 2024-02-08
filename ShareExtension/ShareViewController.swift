//
//  ShareViewController.swift
//  iBoxShareExtension
//
//  Created by jiyeon on 1/30/24.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        // Do validation of contentText and/or NSExtensionContext attachments here
        
        // contentText : 유저가 공유하기 창을 눌러 넘어온 문자열 값(상수)
        if let currentMessage = contentText{
            let currentMessageLength = currentMessage.count
            // charactersRemaining : 문자열 길이 제한 값(상수)
            charactersRemaining = (100 - currentMessageLength) as NSNumber
            
            print("currentMessage : \(currentMessage) // 길이 : \(currentMessageLength) // 제한 : \(charactersRemaining)")
            if Int(charactersRemaining) < 0 {
                print("100자가 넘었을때는 공유할 수 없다!")
                return false
            }
        }
        return true
    }

    override func didSelectPost() {
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
    override func configurationItems() -> [Any]! {
        let item = SLComposeSheetConfigurationItem()
        
        item?.title = "여기는 제목입니다"
        // item?.tapHandler : 유저가 터치했을 때 호출되는 핸들러
        return [item]
    }
}
