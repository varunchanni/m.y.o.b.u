//
//  Feature.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 1/4/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "MSModelObject.h"

@interface Feature : MSModelObject
@property (nonatomic, strong) NSString * title;
@property (nonatomic, strong) NSString * plist;
@property (nonatomic, strong) NSString * iconImage;
@property (nonatomic, strong) NSString * viewController;
@end
