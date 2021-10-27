//
//  ViewController.swift
//  KakaoOCR
//
//  Created by hoseung Lee on 2021/10/27.
//

import UIKit
import Alamofire
import SwiftyJSON
import PhotosUI

class ViewController: UIViewController {
  
  @IBOutlet weak var imageView: UIImageView!
  @IBOutlet weak var uploadButton: UIButton!
  @IBOutlet weak var sendButton: UIButton! {
    didSet {
      sendButton.setTitleColor(.blue, for: .highlighted)
    }
  }
  @IBOutlet weak var resultTextView: UITextView!
  
  let boxes = BoxView()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    boxes.backgroundColor = .clear
    imageView.addSubview(boxes)
    boxes.frame = imageView.bounds
//    print(imageView.frame.size)
//    print(imageView.image!.size)
//    print(imageView.image?.cgImage?.width)
//    print(imageView.image?.cgImage?.height)
  }
  
  
  @IBAction func uploadImage(_ sender: UIButton) {
    var configuration = PHPickerConfiguration()
    configuration.filter = .images
    configuration.selectionLimit = 1
    let pickerView = PHPickerViewController(configuration: configuration)
    pickerView.delegate = self
    present(pickerView, animated: true)
  }
  
  @IBAction func requestOCR(_ sender: UIButton) {
    guard let image = imageView.image else {
      print("alert")
      return
    }
    
    
    OCRManager.shared.requestAnalyz(with: image) { [weak self] code, json in
      guard let self = self else { fatalError() }
      switch code {
      case 200:
        print("200!")
        print(json)
        var resultString = ""
        json["result"].arrayValue.forEach { json in
          json["recognition_words"].arrayValue.forEach { words in
            resultString.write("\(words.stringValue), ")
          }
        }
        self.resultTextView.text = resultString
      case 400:
        print("400!")
        print(json.stringValue)
      default:
        print(code)
        print(json)
      }
    }
  }
}

//MARK: - PHPickerDelegate
extension ViewController: PHPickerViewControllerDelegate {
  func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
    dismiss(animated: true)
    if !results.isEmpty {
      let result = results[0]
      let itemProvider = result.itemProvider
      if itemProvider.canLoadObject(ofClass: UIImage.self) {
        itemProvider.loadObject(ofClass: UIImage.self) { image, error in
          guard let image = image as? UIImage else { return }
          DispatchQueue.main.async {
            self.imageView.image = image
          }
        }
      }
    }
  }
}


//MARK: - Bound

class BoxView: UIView {
  override func draw(_ rect: CGRect) {
    super.draw(rect)
    guard let context = UIGraphicsGetCurrentContext() else { return }
    context.setStrokeColor(UIColor.green.cgColor)
    context.setLineWidth(1)
//
//    //335
////    105:1024 = x :335
////    1024x = 105*335
////    x = 105*335/1024
//
    let xRatio = 335.0 / 907
    let yRatio = 335.0 / 1210


    context.move(to: .init(x: 105 * xRatio, y:  135 * yRatio))
    context.addLine(to: .init(x: 699 * xRatio, y: 119 * yRatio))
    context.addLine(to: .init(x: 704 * xRatio, y: 310 * yRatio))
    context.addLine(to: .init(x: 111 * xRatio, y: 327 * yRatio))
    context.closePath()
    context.strokePath()

    guard let context2 = UIGraphicsGetCurrentContext() else { return }
    context2.setStrokeColor(UIColor.green.cgColor)
    context2.setLineWidth(1)

    context2.move(to: .init(x: 356 * xRatio, y:  477 * yRatio))
    context2.addLine(to: .init(x: 473 * xRatio, y: 471 * yRatio))
    context2.addLine(to: .init(x: 475 * xRatio, y: 506 * yRatio))
    context2.addLine(to: .init(x: 357 * xRatio, y: 511 * yRatio))
    context2.closePath()
    context2.strokePath()
  }
}

//MARK: - Managers
class OCRManager {
  static let shared = OCRManager()
  private init() {}
  
  private let endpoitnURL = "https://dapi.kakao.com/v2/vision/text/ocr"
  
  private var apiKey: String {
    guard let key = Bundle.main.infoDictionary?["KakaoAPIKey"] as? String else {fatalError("Key not found")}
    return key
  }
  
  private func getHeaders() -> HTTPHeaders {
    
    let headers: [HTTPHeader] = [
      .init(name: "Authorization", value: apiKey),
      .init(name: "Content-Type", value: "multipart/form-data")
    ]
    
    return HTTPHeaders(headers)
  }
  
  func requestAnalyz(with image: UIImage, completion: @escaping (Int, JSON) -> ()) {
    guard let url = URL(string: endpoitnURL) else { fatalError("url build failure") }
    let headers = getHeaders()
    guard let convertToJPG = image.jpegData(compressionQuality: 0.5) else { fatalError("image convert error!")}
    
    AF.upload(multipartFormData: { multipartFormData in
      multipartFormData.append(convertToJPG, withName: "image", fileName: "image", mimeType: "image/jpg")
    }, to: url, headers: headers)
      .validate(statusCode: 200...500)
      .responseJSON { response in
        switch response.result {
        case .success(let value):
          print("ok!")
          let code = response.response?.statusCode ?? 500
          completion(code, JSON(value))
        case .failure(let error):
          print(error)
        }
      }
  }
}
