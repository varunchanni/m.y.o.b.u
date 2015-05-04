//
//  PinViewController.h
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 12/14/13.
//  Copyright (c) 2013 MYOB University. All rights reserved.
//

#import "MYOBViewController.h"

enum PinViewControllerType {
    PinViewControllerTypeAuthenicate,
    PinViewControllerTypeCreate
};
@interface PinViewController : MYOBViewController
@property (nonatomic, assign) enum PinViewControllerType pinViewControllerType;
@end
