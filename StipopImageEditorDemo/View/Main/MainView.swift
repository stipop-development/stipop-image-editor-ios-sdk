//
//  MainView.swift
//  StipopImageEditorDemo
//
//  Created by kyum on 2023/02/02.
//

import UIKit
import StipopImageEditor

class MainView: UIView {
    
    private lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .black
        return imageView
    }()
    
    private lazy var selectImageButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = SEColor.colorFF4500
        button.layer.cornerRadius = 16
        button.clipsToBounds = true
        button.setTitle("Select image", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(selectImageButtonTapped(_:)), for: .touchUpInside)
        return button
    }()
    
    let semaphore = DispatchSemaphore(value: 1)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setup(){
        setupUI()
    }
    
    private func setupUI(){
        backgroundColor = .white
        
        addSubview(imageView)
        addSubview(selectImageButton)
        
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 16).isActive = true
        imageView.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        imageView.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
        imageView.bottomAnchor.constraint(equalTo: selectImageButton.topAnchor, constant: -16).isActive = true
        
        selectImageButton.translatesAutoresizingMaskIntoConstraints = false
        selectImageButton.heightAnchor.constraint(equalToConstant: 56).isActive = true
        selectImageButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -8).isActive = true
        selectImageButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16).isActive = true
        selectImageButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16).isActive = true
    }
    
    @objc private func selectImageButtonTapped(_ sender: UIButton){
        guard let owningController = self.getOwningViewController() else { return }
        
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        
        owningController.showDetailViewController(picker, sender: nil)
    }
}

extension MainView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.editImage(image)
        }
    }
    
    func editImage(_ image: UIImage) {
        guard let owningController = self.getOwningViewController() else { return }
        
        /**
         * You can show StipopImageEditor by using this method.
         * @params
         * _ controller: controller that shows ImageEditor.
         * delegate: set delegate which can observe editor's working.
         * fileName: You can set StipopImageEditor.plist's fileName.    (defValue: StipopImageEditor)
         * image: the image to edit.
         * userId: if you want, you can set user's id    (defValue: -1)
         */
        SEStipopImageEditor.showEditor(owningController,
                                       delegate: self, image: image)
    }
}

extension MainView: SEDelegate {
    
    /**
     * When editing is canceled, this method is called.
     */
    func editorCanceled() {
        print("editorCanceled")
    }
    
    /**
     * When editing is finished, this method is called.
     * @params
     * image: editing finished image.
     */
    func editorFinished(image: UIImage) {
        print("editorFinished")
        self.imageView.image = image
    }
    
    /**
     * If you use SAuth, additionally implement this method.
     * when this method is called, refresh AccessToken and reRequest with 'apiEnum' & 'properties'.
     * @params
     * apiEnum: error occured api type.
     * error: error info.
     * properties: dictionary that contains data for recall api.
     */
    func httpError(apiEnum: SEAPIEnum, error: SEError, properties: Dictionary<String, Any>?) {
        print("⚡️Stipop: HTTP Error => \(apiEnum)")
        DispatchQueue.global().async {
            self.semaphore.wait()
            let userId = SEStipopImageEditor.getUser()?.userID ?? SEStipopImageEditor.getCommonUser().userID
            DemoSAuthManager.getAccessTokenIfOverExpiryTime(userId: userId,
                                                            completion: { accessToken in
                self.semaphore.signal()
                guard let accessToken = accessToken else { return }
                SEStipopImageEditor.setAccessToken(accessToken: accessToken)
                SEAuthManager.reRequest(api: apiEnum, properties: properties)
            })
        }
    }
}
