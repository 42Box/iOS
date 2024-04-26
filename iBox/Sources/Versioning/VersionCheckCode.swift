//
//  VersionCheckCode.swift
//  iBox
//
//  Created by Chan on 3/2/24.
//

enum VersionCheckCode: Equatable {
    case initial // 초기값
    case success // 성공
    case later // 나중에 (ab testing code)
    case update // 업데이트 (ab testing code)
    case urlError // URL 관련 에러
    case networkError // 네트워크 요청 실패
    case decodingError // 디코딩 실패
    case versionOutdated(mandatoryUpdate: Bool, updateUrl: String) // 버전이 구버전일 때
    case serverError // 서버 에러 또는 기타 에러
    case internalSceneError // 내부 씬 에러
    case internalInfoError // 내부 인포 에러
    case maxRetryReached // 최대 재시도 횟수 도달
}
