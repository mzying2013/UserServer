//
//  DefineConst.swift
//  App
//
//  Created by Liu on 2018/7/25.
//

import Vapor


public let kPasswordMaxCount = 18
public let kPasswordMinCount = 6


public let kAccountMaxCount = 18
public let kAccountMinCount = 6

public let kImageMaxBytesSize = 2 * 1024 * 1024

public let kImageDir = DirectoryConfig.detect().workDir + "/image/"

