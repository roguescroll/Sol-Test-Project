//
//  ContactListDetails.h
//  Contacts
//
//  Created by Ashwin Raghuraman on 12/15/14.
//  Copyright (c) 2014 Ashwin Raghuraman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactListDetails : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *company;
@property (nonatomic, copy) NSString *workPhone;
@property (nonatomic, strong) UIImage *smallDetailsImage;
@property (nonatomic, copy) NSString *detailsURL;

@end
