//
//  Controllers.swift
//  iDragProject
//
//  Created by runforever on 2017/2/1.
//  Copyright © 2017年 defcoding. All rights reserved.
//

import Qiniu
import CryptoSwift
import SwiftyJSON
import PromiseKit

class DragUploadManager {

    func uploadFiles(filePaths: NSArray) {
        var uploadFiles: [Promise<String>] = []

        // 将需要上传的文件加入到 promise 对象列表中
        for path in filePaths {
            let filePath = path as! String
            uploadFiles.append(uploadFile(filePath: filePath))
        }

        // 当所有文件都上传完成后执行操作
        when(fulfilled: uploadFiles).then(
            execute: { filenames -> Void in
                print("upload success")
            }
        ).catch(
            execute: {error in
                print(error)
            }
        )
    }

    func uploadFile(filePath: String) -> Promise<String> {
        // 构造 Promise 对象
        return Promise { fulfill, reject in
            // 获取文件路径中的文件名
            let filename = NSURL(fileURLWithPath: filePath).lastPathComponent!

            // 创建上传凭证
            let token = createQiniuToken(filename: filename)

            // 上传文件
            let qiNiu = QNUploadManager()!
            qiNiu.putFile(filePath, key: filename, token: token, complete: {info, key, resp -> Void in
                switch info?.statusCode {
                case Int32(200)?:
                    print("\(filename) upload success")
                    fulfill(filename)
                default:
                    reject((info?.error)!)
                }
            }, option: nil)
        }
    }

    func createQiniuToken(filename: String) -> String {
        let accessKey = "your access key"
        let secretKey = "your secret key"
        let bucket = "your bucket"
        let deadline = round(NSDate(timeIntervalSinceNow: 3600).timeIntervalSince1970)
        let putPolicyDict:JSON = [
            "scope": "\(bucket):\(filename)",
            "deadline": deadline,
            ]

        let b64PutPolicy = QNUrlSafeBase64.encode(putPolicyDict.rawString()!)!
        let secretSign =  try! HMAC(key: (secretKey.utf8.map({$0})), variant: .sha1).authenticate((b64PutPolicy.utf8.map({$0})))
        let b64SecretSign = QNUrlSafeBase64.encode(Data(bytes: secretSign))!

        let putPolicy:String = [accessKey, b64SecretSign, b64PutPolicy].joined(separator: ":")
        return putPolicy
    }
}
