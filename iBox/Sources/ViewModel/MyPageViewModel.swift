//
//  MyPageViewModel.swift
//  iBox
//
//  Created by jiyeon on 2/22/24.
//

import Foundation

class MyPageViewModel {
    
    let myPageSectionViewModels: [MyPageSectionViewModel] = [
        MyPageSectionViewModel(MyPageSection(
            title: "settings",
            items: [MyPageItem(title: "테마")]
        )),
        MyPageSectionViewModel(MyPageSection(
            title: "help",
            items: [
                MyPageItem(title: "이용 가이드"),
                MyPageItem(title: "앱 피드백"),
                MyPageItem(title: "개발자 정보")
            ]
        ))
    ]
    
}
