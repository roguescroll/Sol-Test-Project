//
//  ContactsDetailsViewController.m
//  Contacts
//
//  Created by Ashwin Raghuraman on 12/15/14.
//  Copyright (c) 2014 Ashwin Raghuraman. All rights reserved.
//

#import "ContactsDetailsViewController.h"
#import "ContactListDetails.h"
#import "ContactDetails.h"

@interface ContactsDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, weak) IBOutlet UIImageView *detailsImageView;

@property (nonatomic, strong) ContactListDetails *contactDetails;

@end

@implementation ContactsDetailsViewController

- (id)initWithContactDetails:(ContactListDetails *)contactDetails
{
    self = [super initWithNibName:@"ContactsDetailsViewController" bundle:nil];
    
    if (self)
    {
        self.contactDetails = contactDetails;
        [self fetchDetails];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.contactDetails.name;
    self.companyLabel.text = self.contactDetails.company;
}

#pragma mark - Private Methods

- (void)fetchDetails
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.contactDetails.detailsURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
    
    NSError *jsonParsingError;
    NSDictionary *contactsDetailsDictArray = [NSJSONSerialization JSONObjectWithData:response
                                                                 options:0
                                                                   error:&jsonParsingError];
    
    
}

@end
