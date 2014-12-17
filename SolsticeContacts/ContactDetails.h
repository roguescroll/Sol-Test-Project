//
//  ContactDetails.h
//  Contacts
//
//  Created by Ashwin Raghuraman on 12/15/14.
//  Copyright (c) 2014 Ashwin Raghuraman. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ContactDetails : NSObject

@property (nonatomic) BOOL favorite;
@property (nonatomic, strong) UIImage *largeImage;
@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *state;
@property (nonatomic, copy) NSString *country;
@property (nonatomic, copy) NSString *zip;

@end
