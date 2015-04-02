//
//  RecordedAudio.swift
//  Pitch Perfect
//
//  Created by Игорь Боляев on 29.03.15.
//  Copyright (c) 2015 Igor Bolyaev. All rights reserved.
//

import Foundation

class RecordedAudio: NSObject{
    var filePathUrl: NSURL!
    var title: String!
    
    init(filePathUrl : NSURL,title:String)
    {
        self.filePathUrl = filePathUrl;
        self.title = title;
    }
}