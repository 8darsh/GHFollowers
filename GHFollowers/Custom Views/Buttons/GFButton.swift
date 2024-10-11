//
//  GFButton.swift
//  GitHubFollowers
//
//  Created by Adarsh Singh on 01/10/24.
//

import UIKit

class GFButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    convenience init(color: UIColor, title: String, systemImageName: String){
        self.init(frame: .zero)
        set(color: color, title: title, systemImageName: systemImageName)
        
    }
    
    private func configure(){
       
//        layer.cornerRadius = 12
//        setTitleColor(.white, for: .normal)
//        titleLabel?.font = UIFont.preferredFont(forTextStyle: .headline)

        // MARK: - FOR iOS 15 OR LATER
        
        configuration = .filled()      //fill the background
        configuration?.cornerStyle = .medium
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    func set(color: UIColor, title: String, systemImageName: String){
//        self.backgroundColor = backgroundColor
//        setTitle(title, for: .normal)
        
        // MARK: - FOR iOS 15 OR LATER
        configuration?.baseBackgroundColor = color
        configuration?.baseForegroundColor = .white
        configuration?.title = title
        
        configuration?.image = UIImage(systemName: systemImageName)
        configuration?.imagePadding = 6
        configuration?.imagePlacement = .leading
    }
    

}
#Preview{
    return GFButton(color: .blue, title: "Hellp", systemImageName: "pencil")
}
