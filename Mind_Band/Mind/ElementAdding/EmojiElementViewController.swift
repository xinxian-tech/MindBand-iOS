//
//  EmojiElementViewController.swift
//  Mind_Band
//
//  Created by 李灿晨 on 7/18/19.
//  Copyright © 2019 李灿晨. All rights reserved.
//

import UIKit

class EmojiCollectionViewCell: UICollectionViewCell {
    
    var emojiLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 30)
        label.textAlignment = .center
        return label
    }()
    
    var text: String? {
        get {
            return emojiLabel.text
        } set {
            emojiLabel.text = newValue
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                backgroundColor = .darkGray
            } else {
                backgroundColor = .black
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(emojiLabel)
        NSLayoutConstraint.activate([
            emojiLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 0),
            emojiLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0),
            emojiLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0),
            emojiLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0)
        ])
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class EmojiElementViewController: MediaElementAddViewController {
    
    var emojiCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .vertical
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .black
        collectionView.register(EmojiCollectionViewCell.self, forCellWithReuseIdentifier: "emojiCollectionViewCell")
        return collectionView
    }()
    
    private var selectedIndex: Int? {
        didSet {
            guard oldValue != nil else {return}
            emojiCollectionView.deselectItem(at: IndexPath(row: oldValue!, section: 0), animated: true)
            emojiCollectionView.reloadItems(at: [IndexPath(row: oldValue!, section: 0)])
        }
    }
    
    private let candidateEmojis: [String] = [
        "\u{1F620}",
        "\u{1F616}",
        "\u{1F615}",
        "\u{1F622}",
        "\u{1F61E}",
        "\u{1F611}",
        "\u{1F631}",
        "\u{1F618}",
        "\u{1F613}",
        "\u{1F61B}",
        "\u{1F61D}",
        "\u{1F61C}",
        "\u{1F602}",
        "\u{1F633}",
        "\u{1F62C}",
        "\u{1F600}",
        "\u{1F601}",
        "\u{1F62D}",
        "\u{1F610}",
        "\u{1F614}",
        "\u{1F623}",
        "\u{1F60C}",
        "\u{1F634}",
        "\u{1F60D}",
        "\u{1F60A}",
        "\u{1F604}",
        "\u{1F60E}",
        "\u{1F60F}",
        "\u{1F62B}",
        "\u{1F612}",
        "\u{1F629}",
        "\u{1F609}"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadMediaElement()
        contentView.addSubview(emojiCollectionView)
        emojiCollectionView.dataSource = self
        emojiCollectionView.delegate = self
        NSLayoutConstraint.activate([
            emojiCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            emojiCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: 0),
            emojiCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 0),
            emojiCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 0)
        ])
    }
    
    private func loadMediaElement() {
        if mediaElement == nil {
            mediaElement = EmojiElement()
        } else {
            for index in 0 ..< candidateEmojis.count {
                if candidateEmojis[index] == (mediaElement as! EmojiElement).emoji {
                    selectedIndex = index
                    emojiCollectionView.cellForItem(at: IndexPath(row: index, section: 0))?.isSelected = true
                    break
                }
            }
            setConfirmButtonEnabled()
        }
    }
    
}

extension EmojiElementViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return candidateEmojis.count
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "emojiCollectionViewCell", for: indexPath) as! EmojiCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        let cell = cell as! EmojiCollectionViewCell
        cell.text = candidateEmojis[indexPath.row]
        cell.isSelected = indexPath.row == selectedIndex
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
        mediaElement?.prepareContent(content: candidateEmojis[indexPath.row])
        setConfirmButtonEnabled()
    }
}
