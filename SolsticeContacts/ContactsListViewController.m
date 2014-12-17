//
//  ContactsListViewController.m
//  ContactsApplication
//
//  Created by Ashwin Raghuraman on 12/15/14.
//  Copyright (c) 2014 Ashwin Raghuraman. All rights reserved.
//

#import "ContactsListViewController.h"
#import "ContactListDetails.h"
#import "ContactsDetailsViewController.h"

@interface ContactsListViewController ()

@property (nonatomic, strong) NSMutableArray *contactDetailsArray;

@end

static NSString *kContactsListCellIdentifier = @"ContactsListCell";

@implementation ContactsListViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        [self fetchContactList];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"Contacts";
    self.tableView.tableFooterView = [UIView new];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [self.contactDetailsArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kContactsListCellIdentifier];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:kContactsListCellIdentifier];
    }
    
    ContactListDetails *contactAtIndex = [self.contactDetailsArray objectAtIndex:indexPath.section];
    
    cell.textLabel.text = [contactAtIndex name];
    cell.detailTextLabel.text = [contactAtIndex workPhone];
    cell.imageView.image = [contactAtIndex smallDetailsImage];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ContactsDetailsViewController *detailsViewController = [[ContactsDetailsViewController alloc] initWithContactDetails:[self.contactDetailsArray objectAtIndex:indexPath.section]];
    
    [self.navigationController pushViewController:detailsViewController animated:YES];
}


#pragma mark - Private Methods

/**
 Makes a request to the URL having the contacts json, serializes it and creates an array of the ContactDetails Object
 containing details about each contact.
 */
- (void)fetchContactList
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://solstice.applauncher.com/external/contacts.json"]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request
                                             returningResponse:nil
                                                         error:nil];
    
    NSError *jsonParsingError;
    NSArray *contactsDictArray = [NSJSONSerialization JSONObjectWithData:response
                                                                 options:0
                                                                   error:&jsonParsingError];
    
    self.contactDetailsArray = [NSMutableArray new];
    
    for (NSDictionary *contact in contactsDictArray)
    {
        ContactListDetails *details = [ContactListDetails new];
        details.name = contact[@"name"];
        details.company = contact[@"company"];
        
        NSDictionary *phoneDetails = contact[@"phone"];
        details.homePhone = phoneDetails[@"home"];
        details.workPhone = phoneDetails[@"work"];
        details.mobilePhone = phoneDetails[@"mobile"];
        
        NSString *birthDateString = contact[@"birthdate"];
        NSInteger birthDateInteger = [birthDateString integerValue];
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:birthDateInteger];
        details.birthDate = [NSDateFormatter localizedStringFromDate:date
                                                                      dateStyle:NSDateFormatterShortStyle
                                                                      timeStyle:NSDateFormatterNoStyle];
        
        NSData *imageData;
        NSString *smallImageDetailsURL = contact[@"smallImageURL"];
        imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:smallImageDetailsURL]];
        details.smallDetailsImage = [UIImage imageWithData:imageData];
        
        details.detailsURL = contact[@"detailsURL"];
        
        [self.contactDetailsArray addObject:details];
    }
    
}

@end
