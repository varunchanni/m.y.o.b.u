//
//  EditUserProfilController.m
//  M.Y.O.B.U.
//
//  Created by Raymond Kelly on 3/30/14.
//  Copyright (c) 2014 MYOB University. All rights reserved.
//

#import "EditUserProfileController.h"

@interface EditUserProfileController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *usernameTxt;
@property (weak, nonatomic) IBOutlet UITextField *firstNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *lastNameTxt;
@property (weak, nonatomic) IBOutlet UITextField *emailTxt;
@property (weak, nonatomic) IBOutlet UIImageView *avtarImg;
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation EditUserProfileController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureKeyboardControls];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initUserInfo];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)initUserInfo
{
    UserAccount * userAccount = self.dataManager.currentUserAccount;
    if(userAccount != NULL)
    {
        self.usernameTxt.text = userAccount.username;
        self.firstNameTxt.text = userAccount.firstname;
        self.lastNameTxt.text = userAccount.lastname;
        self.emailTxt.text = userAccount.email;
        
        self.avtarImg.image = [UIImage imageNamed:@"guest_icon.png"];
        self.avtarImg.contentMode = UIViewContentModeScaleAspectFill;
        self.avtarImg.clipsToBounds = YES;
        self.avtarImg.layer.borderWidth = 4.0f;
        self.avtarImg.layer.cornerRadius = 55.0f;
        //self.avtarImg.layer.borderColor = self.imageBorderColor.CGColor;
    }
}

- (IBAction)backPressed:(id)sender {
  
    [self.uiManager popFadeViewController:self.navigationController];

}


- (IBAction)updatePressed:(id)sender {

}

- (IBAction)editAvtarPressed:(id)sender {
    
    if (self.imagePickerController == nil)
	{
		self.imagePickerController = [[UIImagePickerController alloc] init];
        //self.imagePickerController.
		self.imagePickerController.allowsEditing = NO;
		self.imagePickerController.delegate = self;
		self.imagePickerController.sourceType = UIImagePickerControllerCameraCaptureModePhoto | UIImagePickerControllerSourceTypePhotoLibrary;
	}
	
    
	[self presentViewController:self.imagePickerController animated:YES completion:nil];
}

- (void)configureKeyboardControls
{
    
    self.usernameTxt.delegate = self;
    self.firstNameTxt.delegate = self;
    self.lastNameTxt.delegate = self;
    self.emailTxt.delegate = self;
    
    
    NSArray *fields = @[ self.usernameTxt, self.firstNameTxt, self.lastNameTxt, self.emailTxt];
    NSArray *options = @[ kMSKeyboardValidationOptionsOptional, kMSKeyboardValidationOptionsOptional, kMSKeyboardValidationOptionsOptional, kMSKeyboardValidationOptionsOptional];
    
    [self setKeyboardControls:[[MSKeyboardControls alloc] initWithFields:fields validateOptions:options]];
    [self.keyboardControls setDelegate:self];
    [self.keyboardControls setToolbarVisibility:YES];
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)imagePickerController didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editInfo
{

        [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    [self.imagePickerController
     dismissViewControllerAnimated:YES
     completion:nil];
    
    self.avtarImg.image = image;

}
#pragma mark Keyboard Controls Delegate
- (void)keyboardControlsDonePressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsDonePressed:keyboardControls];
}

- (void)keyboardControlsCancelPressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsCancelPressed:keyboardControls];
}

- (void)keyboardControlsSavePressed:(MSKeyboardControls *)keyboardControls
{
    [self base_keyboardControlsSavePressed:keyboardControls];
}
@end
