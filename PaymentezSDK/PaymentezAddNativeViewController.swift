//
//  PaymentezAddNativeViewController.swift
//  PaymentezSDK
//
//  Created by Gustavo Sotelo on 31/08/17.
//  Copyright © 2017 Paymentez. All rights reserved.
//

import UIKit


@objc public protocol PaymentezCardAddedDelegate
{
    func cardAdded(_ error:PaymentezSDKError?, _ cardAdded:PaymentezCard?)
    func viewClosed()
}




open class PaymentezAddNativeViewController: UIViewController {
    
    open var backgroundColor:UIColor = .white {
        didSet{
            setupColor()
        }
    }
    open var baseColor = PaymentezStyle.baseBaseColor {
        didSet {
            setupColor()
        }
    }
    open var baseFont = PaymentezStyle.font {
        didSet {
            setupColor()
        }
    }
    open var baseFontColor:UIColor = .black {
        didSet {
            setupColor()
        }
    }
    
    var bundle = Bundle(for: PaymentezCard.self)
    var titleString:String  = "Add Card".localized
   
    internal var isModal = false
    open var showLogo:Bool = true {
        didSet {
            self.paymentezLogo.isHidden = !self.showLogo
        }
    }
    
    let buttonMessage = ["off":"Continue without code".localized, "on": "Continue with NIP".localized]
    private var showNip = true {
        didSet{
            self.toggleNip(show: showNip) // show
        }
    }
    private var showTuya = false {
        didSet {
            self.toggleTuya(show: self.showTuya)
        }
        
    }
    
    private var showOtp = false {
        didSet{
            if self.showOtp{
                self.useSMSButton.isHidden = false
            } else {
                
                self.useSMSButton.isHidden = true
            }
        }
    }
    
    let paymentezCard:PaymentezCard = PaymentezCard()
    
    var uid:String?
    var email:String?
    
    let mainView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill

        stackView.backgroundColor = .red
        return stackView
    }()
    let nameView: UIStackView = {
        let stackView = UIStackView()
        //stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.backgroundColor = .red
        stackView.distribution = .fillEqually
        return stackView
    }()
    let cardNumberView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .red
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    let verificationView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.backgroundColor = .red
        stackView.spacing = 5
        stackView.distribution = .fill
        return stackView
    }()
    let tuyaView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.vertical
        stackView.spacing = 10
        return stackView
    }()
    let otpNipView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    //CUSTOMIZE TITLE
    
    open var nameTitle = "Name of Cardholder".localized{
        didSet {
            self.nameField.placeholder = self.nameTitle
        }
    }
    
    open var cardTitle = "Card Number".localized{
        didSet {
            self.cardField.placeholder = self.cardTitle
        }
    }
    
    open var documentTitle = "Document Identifier".localized{
        didSet {
            self.documentField.placeholder = self.documentTitle
        }
    }
    open var invalidNameTitle = "Invalid".localized
    
    open var invalidCardTitle = "Invalid Card Number".localized
    
    open var invalidDocumentTitle = "Invalid".localized
    
    let cardField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Card Number".localized
        field.keyboardType = .numberPad
        return field
    }()
    let cvcField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "CVC/CVV"
        field.keyboardType = .numberPad
        return field
    }()
    let expirationField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Expiration (MM/YY)".localized
        field.keyboardType = .numberPad
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    let nameField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Name of Cardholder".localized
        return field
    }()
    
    //TUYA Elements
    
    let documentField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "Document Identifier".localized
        field.keyboardType = .numberPad
        return field
    }()
    
    let nipField: SkyFloatingLabelTextField = {
        let field = SkyFloatingLabelTextField()
        field.placeholder = "NIP".localized
        field.keyboardType = .numberPad
        field.isSecureTextEntry = true
        return field
    }()
    
    let useSMSButton: UIButton = {
        let btn = UIButton()
        btn.setTitleColor(PaymentezStyle.baseBaseColor, for: .normal) 
        btn.clipsToBounds = true
        btn.setTitle("Continue without code".localized, for: .normal)
        btn.titleLabel?.font = PaymentezStyle.fontSmall
        //btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let smsMessageField: UITextView = {
        let txtView = UITextView()
        txtView.text = "Validate this operation using a temporal unique code that will be sent by SMS or E-email registered at Tuya.".localized
        txtView.isEditable = false
        txtView.textAlignment = .center
        txtView.isSelectable = false
        txtView.isScrollEnabled = false
        txtView.isHidden = true
        txtView.font = PaymentezStyle.fontExtraSmall
        txtView.textColor = PaymentezStyle.baseFontColor
        txtView.backgroundColor = PaymentezStyle.baseBaseColor
        return txtView
    }()
    
    private let paymentezLogo : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"logo_paymentez_black", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)
        imageView.contentMode = .scaleAspectFit

        return imageView
    }()
    
    let logoView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"stp_card_unknown", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true

        return imageView
    }()
    let cvcImageView : UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named:"stp_card_cvc", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    let scanButton: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named:"ic_photo_camera", in: Bundle(for: PaymentezCard.self), compatibleWith: nil), for:.normal)
       btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let addButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = PaymentezStyle.baseBaseColor
        btn.tintColor = PaymentezStyle.baseFontColor
        btn.layer.cornerRadius = 5
        btn.clipsToBounds = true
        btn.setTitle("Add Card".localized, for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let spinner: UIActivityIndicatorView = {
        let sp = UIActivityIndicatorView(style: .whiteLarge)
        sp.color = PaymentezStyle.baseBaseColor
        sp.translatesAutoresizingMaskIntoConstraints = false
        sp.hidesWhenStopped = true
        sp.startAnimating()
        return sp
    }()
    
    let spinnerView: UIView = {
        let view = UIView()
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.init(red: 1, green: 1, blue: 1, alpha: 0.8)
        return view
    }()
    
    
    // SWITCH
    @objc var isWidget:Bool = true
    
    //DELEGATE
    @objc public var addDelegate:PaymentezCardAddedDelegate?
    
    //MASK DELEGATES
    var cardMaskedDelegate: MaskedTextFieldDelegate!
    var expirationMaskedDelegate: MaskedTextFieldDelegate!
    var cvcMaskedField: MaskedTextFieldDelegate!
    var nameMask: MaskedTextFieldDelegate!
    var documentMask: MaskedTextFieldDelegate!
    var nipMaskedField: MaskedTextFieldDelegate!
    
    //MASK
    var cardMask:Mask = try! Mask(format: "[0000]-[0000]-[0000]-[0009]")
    var expirationMask:Mask = try! Mask(format: "[00]/[00]")
    var cvcMask:Mask = try! Mask(format: "[0009]")
    
    
    var cardType:PaymentezCardType =  PaymentezCardType.notSupported {
        didSet {
        
            self.paymentezCard.cardType = self.cardType
            DispatchQueue.main.async {
                // change card
                if self.cardType == .notSupported {
                    self.logoView.image = UIImage(named: "stp_card_unknown", in: self.bundle, compatibleWith: nil)
                    self.cvcImageView.image = UIImage(named: "stp_card_cvc", in: self.bundle, compatibleWith: nil)
                }
            }
           
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    
    @objc public init(isWidget:Bool, isModal:Bool = false)
    {
        super.init(nibName: nil, bundle: nil)
        self.isWidget = isWidget
        self.isModal = isModal
        setupViews()
    }
    
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    override open func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    //MARK: View Setup Methods
    private func setupViews(){
        setupColor()
        setupMask()
        setupAddPresentation()
        setupViewLayouts()
    }
    
    private func setupColor(){
        self.view.backgroundColor = backgroundColor
        //SETUP COLOR
        cardField.selectedLineColor = baseColor
        nameField.selectedLineColor = baseColor
        expirationField.selectedLineColor = baseColor
        cvcField.selectedLineColor = baseColor
        documentField.selectedLineColor = baseColor
        documentField.selectedTitleColor = baseColor
        nipField.selectedLineColor = baseColor
        nipField.selectedTitleColor = baseColor
        cardField.selectedTitleColor = baseColor
        nameField.selectedTitleColor = baseColor
        expirationField.selectedTitleColor = baseColor
        cvcField.selectedTitleColor = baseColor
        
        cardField.textColor = baseFontColor
        nameField.textColor = baseFontColor
        expirationField.textColor = baseFontColor
        cvcField.textColor = baseFontColor
        documentField.textColor = baseFontColor
        documentField.textColor = baseFontColor
        nipField.textColor = baseFontColor
        nipField.textColor = baseFontColor
        cardField.textColor = baseFontColor
        nameField.textColor = baseFontColor
        expirationField.textColor = baseFontColor
        cvcField.textColor = baseFontColor
        
        cardField.font = baseFont
        nameField.font = baseFont
        expirationField.font = baseFont
        cvcField.font = baseFont
        documentField.font = baseFont
        documentField.font = baseFont
        nipField.font = baseFont
        nipField.font = baseFont
        cardField.font = baseFont
        nameField.font = baseFont
        expirationField.font = baseFont
        cvcField.font = baseFont
        
    }
    
    private func setupMask(){
        //SETUP MASK
        self.cardMaskedDelegate = MaskedTextFieldDelegate(format: "[0000]-[0000]-[0000]-[0009]")
        self.cardMaskedDelegate.listener = self
        self.cardField.delegate = cardMaskedDelegate
        
        self.expirationMaskedDelegate = MaskedTextFieldDelegate(format: "[00]/[00]")
        self.expirationMaskedDelegate.listener = self
        self.expirationField.delegate = expirationMaskedDelegate
        
        self.cvcMaskedField = MaskedTextFieldDelegate(format: "[0000]")
        self.cvcMaskedField.listener = self
        self.cvcField.delegate = cvcMaskedField
        
        self.nipMaskedField = MaskedTextFieldDelegate(format: "[0000]")
        self.nipMaskedField.listener = self
        
        self.nipField.delegate = nipMaskedField
        
        
        self.nameField.addTarget(self, action:#selector(self.textfieldDidChange(_:)), for: .editingChanged)

        
        documentMask = MaskedTextFieldDelegate(format:"[-------------------------------------------]")
        documentMask.listener = self
        self.documentField.delegate = documentMask
        
        
    }
    
    private func setupAddPresentation(){
        if self.isWidget{
            self.addButton.isHidden = true
            
        }else{
            //CONFIGURE ADDBUTTON
            self.title = self.titleString
            self.addButton.isHidden = false
            self.addButton.addTarget(self, action: #selector(self.addCard(_:)), for: .touchUpInside)
            self.view.addSubview(self.addButton)
            
            //self.addButton.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
            self.addButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            self.addButton.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
            self.addButton.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
            
            // Create close button
            if isModal {
                let barBtn = UIBarButtonItem(image: UIImage(named:"icon_close", in: self.bundle, compatibleWith: nil), style: .plain, target: self, action: #selector(close(_:)))
                barBtn.tintColor = PaymentezStyle.baseFontColor
                self.navigationItem.rightBarButtonItem = barBtn
            }
            
            let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
            tap.cancelsTouchesInView = false
            self.view.addGestureRecognizer(tap)
            
            //Configure Spinner
            
            self.spinnerView.addSubview(self.spinner)
            
            

        }
    }
    private func setupViewLayouts(){
        //SETUP nameView
        self.nameView.addArrangedSubview(self.nameField)
        
        //SETUP cardNumberView
        
        self.scanButton.addTarget(self, action: #selector(self.scanCard(_:)), for: .touchUpInside)
        self.cardNumberView.addArrangedSubview(self.logoView)
        self.cardNumberView.addArrangedSubview(self.cardField)
        self.cardNumberView.addArrangedSubview(self.scanButton)
        
        self.logoView.widthAnchor.constraint(equalToConstant: 35).isActive = true
        self.logoView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        //self.logoView.heightAnchor.constraint(equalToConstant: 35).isActive = true
        self.scanButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        //SETUP VERIFICATIONVIEW
        
        self.verificationView.addArrangedSubview(self.expirationField)
        self.verificationView.addArrangedSubview(self.cvcImageView)
        self.verificationView.addArrangedSubview(self.cvcField)
        self.expirationField.widthAnchor.constraint(equalTo: self.verificationView.widthAnchor, multiplier: 0.5).isActive = true
        self.cvcImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        //SETUP TUYA VIEW
        
        self.useSMSButton.addTarget(self, action: #selector(dismissNip(_:)), for: .touchUpInside)
        self.otpNipView.addArrangedSubview(self.nipField)
        self.otpNipView.addArrangedSubview(self.useSMSButton)
        
        
        self.tuyaView.addArrangedSubview(self.documentField)
        self.tuyaView.addArrangedSubview(self.otpNipView)
        self.tuyaView.addArrangedSubview(self.smsMessageField)
        
        
        
        // ADD SUBVIEWS
        self.mainView.addArrangedSubview(self.nameView)
        self.mainView.addArrangedSubview(self.cardNumberView)
        self.mainView.addArrangedSubview(self.verificationView)
        if showLogo{
            self.mainView.addArrangedSubview(self.paymentezLogo)
        }
        self.view.addSubview(self.mainView)
        
        //SETUP MAIN VIEW
        if isWidget {
            self.mainView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
            // self.mainView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
        } else{
            self.addButton.topAnchor.constraint(equalTo: self.mainView.bottomAnchor, constant: 10).isActive = true
            
            
            self.view.addSubview(self.spinnerView)

            self.spinnerView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
            self.spinnerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 1).isActive = true
            self.spinnerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1).isActive = true
            self.spinnerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -10).isActive = true
            
            self.spinner.centerXAnchor.constraint(equalTo: self.spinnerView.centerXAnchor).isActive = true
            self.spinner.centerYAnchor.constraint(equalTo: self.spinnerView.centerYAnchor).isActive = true
            self.spinner.heightAnchor.constraint(equalToConstant: 100 ).isActive = true
            self.spinner.widthAnchor.constraint(equalToConstant: 100 ).isActive = true
            //self.mainView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        }
        
        if #available(iOS 11.0, *) {
            self.mainView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        } else {
            self.mainView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 10).isActive = true
        }
        self.mainView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        self.mainView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -10).isActive = true
    }
    
    private func toggleTuya(show:Bool){
        
        if !show {
            // dismiss
            self.tuyaView.isHidden = true
            self.verificationView.isHidden = false
            self.mainView.insertArrangedSubview(self.verificationView, at: 2)
            self.tuyaView.removeFromSuperview()
        } else if show {
            // show
            //
            self.tuyaView.isHidden = false
            self.verificationView.isHidden = true
            self.mainView.insertArrangedSubview(self.tuyaView, at: 2)
            self.verificationView.removeFromSuperview()
            self.showNip = true
        }
    }
    
    
    @objc func dismissNip(_ sender:Any){
        self.showNip = false
    }
    
    @objc func showNip(_ sender:Any){
        self.showNip = true
    }
    
    
    private func toggleNip(show:Bool){
        if !show {
            // dismiss
            self.useSMSButton.setTitle(buttonMessage["on"], for: .normal)
            self.nipField.isHidden = true
            self.smsMessageField.isHidden = false
            self.useSMSButton.removeTarget(self, action: #selector(dismissNip(_:)), for: .touchUpInside)
            self.useSMSButton.addTarget(self, action: #selector(showNip(_:)), for: .touchUpInside)
        } else if show{
            // show
            //
            self.useSMSButton.setTitle(buttonMessage["off"], for: .normal)
            self.smsMessageField.isHidden = true
            self.nipField.isHidden = false
            self.useSMSButton.removeTarget(self, action: #selector(showNip(_:)), for: .touchUpInside)
            self.useSMSButton.addTarget(self, action: #selector(dismissNip(_:)), for: .touchUpInside)
        }
    }
    

    override open func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Card Validation Methods
    
    private func validateCard(_ cardNumber:String){
        PaymentezCard.validate(cardNumber: (self.cardField.text?.replacingOccurrences(of: "-", with: ""))!) { (cardType, imageUrl, cvvLength, mask, showOtp) in
            
            self.cardType = cardType
            DispatchQueue.main.async {
                
                self.showOtp = showOtp
                
                if let img = imageUrl{
                    self.loadImageFromUrl(urlString: img)
                }
                if cvvLength == 4{
                    self.cvcImageView.image = UIImage(named:"stp_card_cvc_amex", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)
                }else{
                    self.cvcImageView.image = UIImage(named:"stp_card_cvc", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)

                }
                if cardType == .alkosto || cardType == .exito {
                    self.toggleTuya(show:true)
                }else {
                    self.toggleTuya(show:false)
                }
            }
        }
    }
    
     @objc open func getValidCard()->PaymentezCard?
    {
        
        
        if self.paymentezCard.cardType == .notSupported{
            return nil
        }
        guard let _ = self.paymentezCard.cardHolder else {
            self.nameField.errorMessage = self.invalidNameTitle
            return nil
        }
        guard let _ = self.paymentezCard.cardNumber else {
             self.cardField.errorMessage = self.invalidCardTitle
            return nil
        }
        if self.cardType == .alkosto || self.cardType == .exito  //tarjetas tuya
        {
            if showNip{
                guard let _ = self.paymentezCard.nip  else {
                    self.nipField.errorMessage = "Invalid".localized
                    return nil
                }
            }
            guard let _ = self.paymentezCard.fiscalNumber else {
                 self.documentField.errorMessage = "Invalid".localized
                return nil
            }
            
            return self.paymentezCard
            
        }else { // las demás
            guard let _ = self.paymentezCard.cvc else {
                 self.cvcField.errorMessage = "Invalid".localized
                return nil
            }
            guard let _ = self.paymentezCard.expiryMonth else {
                 self.expirationField.errorMessage = "Invalid Date".localized
                return nil
            }
            guard let _ = self.paymentezCard.expiryYear else {
                 self.expirationField.errorMessage = "Invalid Date".localized
                return nil
            }
           return self.paymentezCard
        }
    }
    
    //MARK:Scan Card
    
    @objc func scanCard(_ sender: Any) {
        PaymentezSDKClient.scanCard(self) { (closed, number, expiry, cvv, card) in
            if !closed
            {
                guard let cardNumber = number else {
                    return
                }
                let result: Mask.Result = self.cardMask.apply(
                    toText: CaretString(
                        string: number!,
                        caretPosition: number!.endIndex
                    ),
                    autocomplete: false // you may consider disabling autocompletion for your case
                )
                let resultEx: Mask.Result = self.expirationMask.apply(
                    toText: CaretString(
                        string: expiry!,
                        caretPosition: expiry!.endIndex
                    ),
                    autocomplete: false // you may consider disabling autocompletion for your case
                )
                let resultCvv: Mask.Result = self.cvcMask.apply(
                    toText: CaretString(
                        string: cvv!,
                        caretPosition: cvv!.endIndex
                    ),
                    autocomplete: false // you may consider disabling autocompletion for your case
                )
                self.cardField.text = result.formattedText.string
                
                self.expirationField.text = resultEx.formattedText.string
                self.cvcField.text = resultCvv.formattedText.string
                self.paymentezCard.cvc = self.cvcField.text
                
                self.paymentezCard.cardNumber = self.cardField.text?.replacingOccurrences(of: "-", with: "")
                self.cardType = PaymentezCard.getTypeCard((self.paymentezCard.cardNumber)!)
                let valExp = self.expirationField.text!.components(separatedBy: "/")
                if valExp.count > 1
                {
                    let expiryYear = Int(valExp[1])! + 2000
                    let expiryMonth = valExp[0]
                    self.paymentezCard.expiryYear =  "\(expiryYear)"
                    self.paymentezCard.expiryMonth =  expiryMonth
                }
                
                //Validate Card
            
                if cardNumber.count >= 10{
                    let indexEnd = cardNumber.index(cardNumber.startIndex, offsetBy:10)
                    self.validateCard(String(cardNumber[..<indexEnd]))
                } else {
                    self.validateCard(cardNumber)
                }
                
            }
        }
    }
    
    //MARK: Actions
    
    @objc func close(_ sender:Any){
        self.dismiss(animated: true) {
            self.addDelegate?.viewClosed()
        }
    }
    
    @objc func addCard(_ sender: Any) {
        self.view.endEditing(true)
        if !isWidget
        {
            guard let uid  = self.uid else {
                return
            }
            guard let email = self.email else {
                return
            }
            if let validCard = self.getValidCard() {
                self.showSpinner()
                PaymentezSDKClient.add(validCard, uid: uid, email: email, callback: { [weak self] (error, cardAdded) in
                    self?.hideSpinner()
                    DispatchQueue.main.async {
                        if self?.isModal ?? false {
                            self?.dismiss(animated: true, completion: {
                                self?.addDelegate?.cardAdded(error, cardAdded)
                            })
                        }else{
                            self?.navigationController?.popViewController(animated: true)
                            self?.addDelegate?.cardAdded(error, cardAdded)
                        }
                    }
                    
                })
            }
        }
    }
    
}
//MARK: Load CardImage
extension PaymentezAddNativeViewController{
    func loadImageFromUrl(urlString:String){
        guard let url = URL(string: urlString) else{
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if error ==  nil {
                if let imageData = data{
                    DispatchQueue.main.async {
                        
                        self.logoView.image = UIImage(data: imageData) ?? UIImage(named:"stp_card_unknown", in: Bundle(for: PaymentezCard.self), compatibleWith: nil)!
                    }
                }
            }
            }.resume()
    }
}


extension PaymentezAddNativeViewController: MaskedTextFieldDelegateListener
{
    
    public func textField(_ textField: UITextField, didFillMandatoryCharacters complete: Bool, didExtractValue value: String) {
        
        if textField == self.cardField
        {
            self.cardField.errorMessage = ""
            self.paymentezCard.cardNumber = self.cardField.text?.replacingOccurrences(of: "-", with: "")
            if value.count >= 6 && self.cardType == .notSupported  { // check bin
                if value.count >= 10{
                    let indexEnd = value.index(value.startIndex, offsetBy:10)
                    self.validateCard(String(value[..<indexEnd]))
                } else {
                    self.validateCard(value)
                }
                if value.count < 15 {
                    self.cardField.errorMessage = self.invalidCardTitle
                }
            } else if value.count < 6 {
                self.cardType = .notSupported
                self.cardField.errorMessage = self.invalidCardTitle
                self.toggleTuya(show:false)
                
            }
            if value.count < 15 {
                self.cardField.errorMessage = self.invalidCardTitle
            }
            
            
        }
        if textField == self.expirationField
        {
            self.expirationField.errorMessage = ""
            if complete
            {
                if PaymentezCard.validateExpDate(self.expirationField.text!)
                {
                    let valExp = self.expirationField.text!.components(separatedBy: "/")
                    if valExp.count > 1
                    {
                        let expiryYear = Int(valExp[1])! + 2000
                        
                        self.paymentezCard.expiryYear =  "\(expiryYear)"
                        self.paymentezCard.expiryMonth = valExp[0]
                    }
                }
                else
                {
                    self.paymentezCard.expiryYear = nil
                    self.paymentezCard.expiryMonth = nil
                    self.expirationField.errorMessage = "Invalid Date".localized
                }
                
            }
            
        }
        if textField == self.cvcField
        {
            self.cvcField.errorMessage = ""
                if (value.count != 3 && self.cardType != .amex) || (value.count != 4 && self.cardType == .amex)
                {
                    self.cvcField.errorMessage = "Invalid".localized
                    self.paymentezCard.cvc = nil
                }
                else
                {
                    self.paymentezCard.cvc = value
                }
        }
        if textField == self.documentField{
            self.paymentezCard.fiscalNumber = self.documentField.text
        }
        if textField == self.nipField {
            self.nipField.errorMessage = ""
            if value.count != 4{
                self.nipField.errorMessage = "Invalid".localized
                self.paymentezCard.nip = nil
            } else {
                self.paymentezCard.nip  = self.nipField.text
            }
            
        }
       
        if textField == self.documentField{
            self.documentField.errorMessage = ""
            if value.count > 3{
                self.paymentezCard.fiscalNumber = value
            } else {
                self.documentField.errorMessage = self.invalidDocumentTitle
                self.paymentezCard.fiscalNumber = nil
            }
        }
        
    }
}
// MARK: TextField Didchange
extension PaymentezAddNativeViewController {
    
    func cancelEditing(){
        self.nameField.resignFirstResponder()
        self.cardField.resignFirstResponder()
        self.cvcField.resignFirstResponder()
        self.expirationField.resignFirstResponder()
        self.documentField.resignFirstResponder()
        self.nipField.resignFirstResponder()
        
    }
    
    @objc func textfieldDidChange(_ sender:Any){
        
        if sender as? SkyFloatingLabelTextField == self.nameField{
            guard let value = self.nameField.text else {
                return
            }
            self.nameField.errorMessage = ""
            if value.count > 4{
                self.paymentezCard.cardHolder = value
            } else {
                self.nameField.errorMessage = "Invalid".localized
                self.paymentezCard.cardHolder = nil
            }
        }
        
    }
}

extension PaymentezAddNativeViewController {
    
    func showSpinner(){
        if !isWidget{
            DispatchQueue.main.async {
               self.spinnerView.isHidden = false
            }
            
        }
    }
    
    func hideSpinner(){
        DispatchQueue.main.async {
            self.spinnerView.isHidden = true
        }
        
    }
}


@objc public extension UIViewController {
    
    func addPaymentezWidget(toView containerView:UIView,  delegate:PaymentezCardAddedDelegate?, uid:String, email:String) -> PaymentezAddNativeViewController{
        let paymentezAddVC = PaymentezSDKClient.createAddWidget()
        paymentezAddVC.uid = uid
        paymentezAddVC.email = email
        paymentezAddVC.addDelegate = delegate
        self.addChild(paymentezAddVC)
        let paymentezView = paymentezAddVC.view
        paymentezView?.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(paymentezView!)
        paymentezView?.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        paymentezView?.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        paymentezView?.leftAnchor.constraint(equalTo: containerView.leftAnchor).isActive = true
        paymentezView?.rightAnchor.constraint(equalTo: containerView.rightAnchor).isActive = true
        paymentezAddVC.didMove(toParent: self)
        return paymentezAddVC
    }
    func presentPaymentezViewController(delegate:PaymentezCardAddedDelegate, uid:String, email:String){
        let paymentezAddVC = PaymentezAddNativeViewController(isWidget: false, isModal:true)
        paymentezAddVC.isModal = true
        paymentezAddVC.addDelegate = delegate
        paymentezAddVC.uid = uid
        paymentezAddVC.email = email
        let navigationViewController = UINavigationController(rootViewController: paymentezAddVC)
        navigationViewController.navigationBar.barTintColor = PaymentezStyle.baseBaseColor
        navigationViewController.navigationBar.isTranslucent = false
        self.present(navigationViewController, animated: true) {
            
        }
    }
    
}

@objc public extension UINavigationController {
    func pushPaymentezViewController(delegate:PaymentezCardAddedDelegate, uid:String, email:String){
        let paymentezAddVC = PaymentezAddNativeViewController(isWidget: false)
        paymentezAddVC.uid = uid
        paymentezAddVC.email = email
        paymentezAddVC.addDelegate = delegate
        self.pushViewController(paymentezAddVC, animated: true)
    }
}

