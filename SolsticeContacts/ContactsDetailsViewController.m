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
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityAndStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UIImageView *detailsImageView;

@property (nonatomic, strong) ContactListDetails *contactListDetails;
@property (nonatomic, strong) ContactDetails *contactDetails;

@end

@implementation ContactsDetailsViewController

- (id)initWithContactDetails:(ContactListDetails *)contactDetails
{
    self = [super initWithNibName:@"ContactsDetailsViewController" bundle:nil];
    
    if (self)
    {
        self.contactListDetails = contactDetails;
        self.contactDetails = [[ContactDetails alloc] init];
        [self fetchDetails];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailsImageView.layer.cornerRadius = 9.0;
    self.detailsImageView.layer.masksToBounds = YES;
    
    self.nameLabel.text = self.contactListDetails.name;
    self.companyLabel.text = self.contactListDetails.company;
    self.detailsImageView.image = self.contactDetails.largeImage;
}

#pragma mark - Private Methods

- (void)fetchDetails
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.contactListDetails.detailsURL]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
    
    NSError *jsonParsingError;
    NSDictionary *contactsDetailsDict = [NSJSONSerialization JSONObjectWithData:response
                                                                 options:0
                                                                   error:&jsonParsingError];
    
    self.contactDetails.favorite = contactsDetailsDict[@"favorite"];
    self.contactDetails.email = contactsDetailsDict[@"email"];
    self.contactDetails.website = contactsDetailsDict[@"website"];
    
    NSDictionary *addressDict = contactsDetailsDict[@"address"];
    self.contactDetails.street = addressDict[@"street"];
    self.contactDetails.city = addressDict[@"city"];
    self.contactDetails.state = addressDict[@"state"];
    self.contactDetails.country = addressDict[@"country"];
    self.contactDetails.zip = addressDict[@"zip"];
    
    NSData *imageData;
    NSString *largeImageURL = contactsDetailsDict[@"largeImageURL"];
    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:largeImageURL]];
    self.contactDetails.largeImage = [UIImage imageWithData:imageData];
    
}

@end
