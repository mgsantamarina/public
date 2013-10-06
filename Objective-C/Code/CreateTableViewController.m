//
//  CreateTableViewController.m
//  Release
//
//  Created by Miguel Garcia-Santamarina Armesto on 10/23/12.
//  Copyright (c) 2012 test. All rights reserved.
//

#import "CreateTableViewController.h"


@implementation CreateTableViewController

@synthesize picker, tvText, bFeedback, bImage, bStyles, iTag, sTagName, sStyles, maParams, maTags, delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    maParams = [[NSMutableArray alloc] init];
    
    //0: tag
    //1: style/image
    //2: text
   
    picker.delegate = self;
    iTag = nil;
    sStyles = @"";
        
    tvText.delegate = self;
    [self loadTags];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)loadImage
{
    ipView =  [[ImagePickerView alloc] initWithFrame:CGRectMake(160, 240, 0, 0) fromStyleTable:YES];
    [self.tableView.window addSubview:ipView];
    ipView.delegate = self;
}

-(IBAction)confirmElement
{
    [maParams addObject:sTagName];
    if ([sTagName isEqualToString:@"img"]) {
        if (iTag == nil) {
            [maParams addObject:[NSNull null]];
        } else {
            [maParams addObject:iTag];
        }
    } else {
        [maParams addObject:sStyles];
        [maParams addObject:[[[tvText text] stringByReplacingOccurrencesOfString:@"'" withString:@"&apos;"]stringByReplacingOccurrencesOfString:@"\n" withString:@"<br>"]];
    }
    [self.delegate createTableViewControllerDidConfirm:self withParams:maParams];
}

-(IBAction)cancelElement
{
    [self.delegate createTableViewControllerDidCancel:self];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
	if ([segue.identifier isEqualToString:@"CreateStyle"])
	{
        NSMutableArray *maStyles = [[NSMutableArray alloc] init];
        
        [maStyles addObject:@"Arial"];
        [maStyles addObject:@"normal"];
        [maStyles addObject:@"normal"];
        [maStyles addObject:@"16px"];
        [maStyles addObject:@"rgb(0, 0, 0)"];
        [maStyles addObject:@"right"];
        [maStyles addObject:@"none"];
        [maStyles addObject:@"transparent"];
        [maStyles addObject:@"none"];
        
		StyleTableViewController *styleTableViewController =
        segue.destinationViewController;
        
        [styleTableViewController importStyles:maStyles];
		
		styleTableViewController.delegate = self;
	}

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tvText resignFirstResponder];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{       
    if (section == 0) {
        return @"Create Element";
    } else {
        if (section == 1) {
            if ([sTagName isEqualToString:@"img"]) {
                return @"Load Image";
            } else {
                return @"Set Text";
            }
        }
    } 
    return @"";
}

#pragma mark - Picker view delegate

-(void)loadTags{
    
    //"var aTag = new Array('a','abbr','acronym','address','area','article','aside','b','bdi','bdo','big','blockquote','button','canvas','caption','cite','code','dd','del','details','dfn','div','dl','dt','em','fieldset','figcaption','figure','footer','form','h1','h2','h3','h4','h5','h6','header','hgroup','hr','i','iframe','img','input','ins','kbd','label','legend','li','mark','menu','nav','ol','output','p','pre','q','ruby','rt','rp','s','samp','section','select','small','span','strong','sub','summary','sup','table','tbody','td','textarea','tfoot','th','thead','time','tr','tt','u','ul','var');"
    
    maTags = [[NSMutableArray alloc] initWithObjects: @"a", @"abbr", @"address", @"article", @"aside", @"b", @"bdo", @"blockquote", @"button", @"cite", @"code", @"del", @"dfn", @"div", @"em", @"fieldset", @"footer", @"h1", @"h2", @"h3", @"h4", @"h5", @"h6", @"header", @"i", @"img", @"ins", @"kbd", @"label", @"mark", @"p", @"pre", @"q", @"s", @"samp", @"section", @"small", @"span", @"strong", @"sub", @"sup", @"time", @"u", @"var", nil];
    
    //44 tags
    
    [picker selectRow:30 inComponent:0 animated:NO];    
    sTagName = @"p";
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 25) {
        bStyles.hidden = YES;
        tvText.hidden = YES;
        sStyles = @"";
        tvText.text = @"Insert new element's text";
        bFeedback.hidden = NO;
        bImage.hidden = NO;
    } else {
        bFeedback.hidden = YES;
        bImage.hidden = YES;
        bStyles.hidden = NO;
        tvText.hidden = NO;
        iTag = nil;
        [bFeedback setImage:[UIImage imageNamed:@"none.png"] forState:UIControlStateNormal];
    }
    sTagName = [maTags objectAtIndex:row];
    [self.tableView reloadData];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [maTags count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [maTags objectAtIndex:row];
}

#pragma mark - Style table view controller

- (void)styleTableViewControllerDidConfirm:(StyleTableViewController *)controller withString:(NSString *)string
{
    sStyles = string;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)styleTableViewControllerDidCancel:(StyleTableViewController *)controller
{    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image picker view controller delegate

-(void)goBackFromImagePickerView
{       

}

- (void)goToImagePicker:(BOOL)fromAlbum
{       
    if (fromAlbum) {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(119/255.0f) green:(139/255.0f) blue:(168/255.0f) alpha:0.1];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentModalViewController:imagePicker animated:YES];
    } else {
        UIImagePickerController * imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.navigationBar.tintColor = [UIColor colorWithRed:(119/255.0f) green:(139/255.0f) blue:(168/255.0f) alpha:0.1];
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentModalViewController:imagePicker animated:YES];
    }
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{    
    [bFeedback setImage:image forState:UIControlStateNormal];
    iTag = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{       
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)returnImageURL:(NSURL *)withURL
{       
    iTag = [UIImage imageWithData:[NSData dataWithContentsOfURL:withURL]];
    [bFeedback setImage:iTag forState:UIControlStateNormal];
}

@end
