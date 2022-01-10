//
//  File.swift
//  
//
//  Created by Jhonatan A. on 6/01/22.
//

import Publish

try Blog().publish(
    withTheme: .blog,
    at: "docs",
    rssFeedSections: [],
    deployedUsing: .git("git@github.com:baguio/blog.git", branch: "generated")
)
