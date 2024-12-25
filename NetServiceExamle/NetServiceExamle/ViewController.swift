//
//  ViewController.swift
//  NetServiceExamle
//
//  Created by zhangxueyang on 2024/12/25.
//

import UIKit
import Toast_Swift
import Combine

extension NetworkError {
    static let noData = NetworkError.businessError(code: 444, message: "没有列表数据")
}

class ViewController: UIViewController {

    fileprivate var subspritions: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func zipTap(_ sender: Any) {
        
        self.view.makeToastActivity(.center)
        Publishers.Zip(songListPublisher(singer: "张杰"), songDetailPublisher(singer: "张杰", n: 1))
            .sink { completion in
                self.view.hideToastActivity()
                switch completion {
                case .finished:
                    self.view.makeToast("success")
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            } receiveValue: { lists, detail in
                self.view.makeToast("receiveValue \n lists== \(String(describing: lists)) \n detail == \(String(describing: detail))")
            }.store(in: &subspritions)

    }
    
    @IBAction func dependencyTap(_ sender: Any) {
        self.view.makeToastActivity(.center)
        let singer = "张杰"
        songListPublisher(singer: singer)
            .tryMap { lists -> SongLists in
                guard let song = lists.first else {
                    throw NetworkError.noData
                }
                return song
            }
            // FixMe: 处理有点儿难受
            .mapError({ error in
                error as? NetworkError ?? .unknownError
            })
            .flatMap { [unowned self] song in
                self.songDetailPublisher(singer: song.singer, n: song.n)
            }
            .sink { [unowned self] completion in
                self.view.hideToastActivity()
                switch completion {
                case .finished:
                    self.view.makeToast("success")
                case .failure(let error):
                    self.view.makeToast(error.localizedDescription)
                }
            } receiveValue: { song in
                self.view.makeToast("获取歌曲详情成功song == \(String(describing: song))")
            }.store(in: &subspritions)
    }
    
}

extension ViewController {
    func songListPublisher(singer: String = "张杰") -> AnyPublisher<[SongLists], NetworkError> {
        let target = SongApi.lists(singer: singer)
        return NetService.requestPublisher(target: target, dataType: [SongLists].self)
    }
    
    func songDetailPublisher(singer: String, n: Int) -> AnyPublisher<Song, NetworkError> {
        let target = SongApi.songDetail(singer: singer, n: n)
        return NetService.requestPublisher(target: target, dataType: Song.self)
    }
    
}

