import UIKit

class Splash_ViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var termsTextView: UITextView!
    @IBOutlet weak var checkboxButton: UIButton!
    @IBOutlet weak var continueButton: UIButton!
    
    private var isTermsAccepted: Bool = false
    
    // Define your custom cyan color (#53C5DE) once so it can be used everywhere
    private let customCyan = UIColor(red: 83/255, green: 197/255, blue: 222/255, alpha: 1.0)
    
    // The legal text to be animated
    private let termsText = """
    Terms of Use & Clinical Disclaimer
    
    1. Purpose: This application is for histopathological research and decision support. It is NOT a substitute for professional medical diagnosis.
    
    2. Mandatory Oversight: All predictions MUST be verified by a board-certified pathologist.
    
    3. Privacy: All Core ML inference occurs on-device. No patient data is transmitted to external servers.
    
    4. Liability: The developers assume no liability for clinical decisions made using this tool.
    """

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateTextViewTyping(text: termsText, textView: termsTextView)
    }

    private func setupUI() {
        // 1. Prepare the Text View
        termsTextView.text = ""
        termsTextView.isEditable = false
        termsTextView.layer.cornerRadius = 8
        
        // 2. Setup the Continue Button
        continueButton.isEnabled = false
        continueButton.backgroundColor = .systemGray4
        continueButton.layer.cornerRadius = 10
        
        // 3. Setup the Checkbox Button
        // Normal state (unchecked): Cyan square outline
        checkboxButton.setImage(UIImage(systemName: "square"), for: .normal)
        checkboxButton.tintColor = customCyan
        
        // Selected state (checked): Cyan filled box with a White tick/edges
        if #available(iOS 15.0, *) {
            let colorConfig = UIImage.SymbolConfiguration(paletteColors: [.white, customCyan])
            let checkedImage = UIImage(systemName: "checkmark.square.fill", withConfiguration: colorConfig)
            checkboxButton.setImage(checkedImage, for: .selected)
        } else {
            checkboxButton.setImage(UIImage(systemName: "checkmark.square.fill"), for: .selected)
        }
        
        checkboxButton.isSelected = false
    }

    // MARK: - Typewriter Animation
    private func animateTextViewTyping(text: String, textView: UITextView) {
        textView.text = ""
        let characterArray = Array(text)
        var characterIndex = 0
        
        Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { timer in
            if characterIndex < characterArray.count {
                let char = characterArray[characterIndex]
                textView.text?.append(char)
                characterIndex += 1
            } else {
                timer.invalidate()
            }
        }
    }

    // MARK: - Actions
    @IBAction func checkboxTapped(_ sender: UIButton) {
        // Toggle state
        sender.isSelected.toggle()
        isTermsAccepted = sender.isSelected
        
        // Update the Continue button to use customCyan instead of systemBlue
        if isTermsAccepted {
            continueButton.isEnabled = true
            continueButton.backgroundColor = customCyan
        } else {
            continueButton.isEnabled = false
            continueButton.backgroundColor = .systemGray4
        }
    }

    @IBAction func continueTapped(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let homeVC = storyboard.instantiateViewController(withIdentifier: "Home_ViewController") as? Home_ViewController {
            homeVC.modalPresentationStyle = .fullScreen
            self.present(homeVC, animated: true)
        }
    }
}
