//
//  ContactsDetailsViewController.m
//  Contacts
//
//  Created by Ashwin Raghuraman on 12/15/14.
//  Copyright (c) 2014 Ashwin Raghuraman. All rights reserved.
//

#import "ContactsDetailsViewController.h"
#import "ContactListDetails.h"
#import "PersonDetails.h"

@interface ContactsDetailsViewController ()

@property (nonatomic, weak) IBOutlet UILabel *nameLabel;
@property (nonatomic, weak) IBOutlet UILabel *companyLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneNumberLabel;
@property (nonatomic, weak) IBOutlet UILabel *streetLabel;
@property (nonatomic, weak) IBOutlet UILabel *cityAndStateLabel;
@property (nonatomic, weak) IBOutlet UILabel *emailLabel;
@property (nonatomic, weak) IBOutlet UILabel *birthDateLabel;
@property (nonatomic, weak) IBOutlet UIImageView *detailsImageView;
@property (nonatomic, weak) IBOutlet UIImageView *favoriteIconImageView;

@property (nonatomic, strong) ContactListDetails *contactListDetails;
@property (nonatomic, strong) PersonDetails *personDetails;

@end

@implementation ContactsDetailsViewController

- (id)initWithContactDetails:(ContactListDetails *)contactDetails
{
    self = [super initWithNibName:@"ContactsDetailsViewController" bundle:nil];
    
    if (self)
    {
        self.contactListDetails = contactDetails;
        self.personDetails = [[PersonDetails alloc] init];
        
        [self fetchDetails];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.nameLabel.text = self.contactListDetails.name;
    self.companyLabel.text = self.contactListDetails.company;
    self.phoneNumberLabel.text = self.contactListDetails.homePhone;
    self.birthDateLabel.text = self.contactListDetails.birthDate;
    
    self.streetLabel.text = self.personDetails.street;
    self.cityAndStateLabel.text = [NSString stringWithFormat:@"%@, %@",self.personDetails.city, self.personDetails.state];
    
    self.emailLabel.text = self.personDetails.email;
    
    self.detailsImageView.layer.cornerRadius = 9.0;
    self.detailsImageView.layer.masksToBounds = YES;
    self.detailsImageView.image = self.personDetails.largeImage;
    
    self.favoriteIconImageView.hidden = !self.personDetails.favorite;
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
    
    self.personDetails.favorite = [contactsDetailsDict[@"favorite"] boolValue];
    self.personDetails.email = contactsDetailsDict[@"email"];
    self.personDetails.website = contactsDetailsDict[@"website"];
    
    NSDictionary *addressDict = contactsDetailsDict[@"address"];
    self.personDetails.street = addressDict[@"street"];
    self.personDetails.city = addressDict[@"city"];
    self.personDetails.state = addressDict[@"state"];
    self.personDetails.country = addressDict[@"country"];
    self.personDetails.zip = addressDict[@"zip"];
    
    NSData *imageData;
    NSString *largeImageURL = contactsDetailsDict[@"largeImageURL"];
    imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:largeImageURL]];
    self.personDetails.largeImage = [UIImage imageWithData:imageData];
    
}

@end
