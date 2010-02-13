//
//  MEPrefs.h
//  Meteorologist
//
//  Created by Matthew Fahrenbacher on Thu Sep 05 2002.
//  Copyright (c) 2004 The Meteorologist Group. All rights reserved.
//

#import <Cocoa/Cocoa.h>

enum{kPeriodType,kNumberType,kStringType};

@interface MEPrefs : NSObject 
{
	//Windows
	IBOutlet NSWindow *prefsWindow;

    //Buttons
    IBOutlet NSButton *applyButton, *revertButton, *resetButton;

    //Weather Prefs
    IBOutlet NSButton *displayTodayInSubmenu;
    IBOutlet NSButton *displayDayImage;
    IBOutlet NSButton *viewForecastInSubmenu;
    IBOutlet NSPopUpButton *forecastDaysNumber;
    IBOutlet NSButton *forecastDaysOn;
    IBOutlet NSButton *forecastInline;
    
    IBOutlet NSButton *embedControls;
    
    //Temp prefs
    IBOutlet NSColorWell *tempColor;
    IBOutlet NSPopUpButton *tempFont;
    IBOutlet NSButton *hideCF;
    IBOutlet NSButton *displayTemp;
    
    //Dock prefs
    IBOutlet NSSlider *imageOpacity;
    IBOutlet NSMatrix *whereToDisplay;
    
    //Menu prefs
    IBOutlet NSButton *displayCityName;
    IBOutlet NSButton *displayMenuIcon;
    IBOutlet NSPopUpButton *menuFontName;
    IBOutlet NSColorWell *menuColor;
    IBOutlet NSPopUpButton *menuFontSize;
    IBOutlet NSButton *logMessagesToConsole;
    
    //Updating prefs
    IBOutlet NSMatrix *cycleMode;
    IBOutlet NSTextField *autoUpdateTime;
    IBOutlet NSTextField *cycleUpdateTime;
    IBOutlet NSTextField *changeUpdateTime;
    
    //Updates
    IBOutlet NSButton *checkNewVersions, *checkNewServerErrors;
    IBOutlet NSButton *checkNewVersionsNow, *checkNewServerErrorsNow;
    IBOutlet NSProgressIndicator *checkProgress;
    IBOutlet NSTextView *checkResult;
    
    //Global units
    IBOutlet NSButton *useGlobalUnits;
    IBOutlet NSPopUpButton *degreeUnits, *distanceUnits, *speedUnits, *pressureUnits;

    //Weather Alerts
    IBOutlet NSMatrix *alertOptions;
    IBOutlet NSTextField *alertEmail;
    IBOutlet NSTextField *alertSong;
    
    //threading
    BOOL updatingMenu;
    BOOL shouldActivateApply;
    BOOL shouldActivateReset;
    BOOL shouldActivateRevert;
    IBOutlet NSProgressIndicator *updateProgress;
    
    IBOutlet NSButton *killOtherMeteo;
}

+ (MEPrefs *)sharedInstance;

- (void)checkUnsavedPrefs;

- (IBAction)applyPrefs:(id)sender;
- (IBAction)resetPrefs:(id)sender;
- (void)endResetPrefsSheet:(NSWindow *)sheet returnCode:(int)returnCode contextInfo:(void *)contextInfo;
- (IBAction)revertPrefs:(id)sender;

- (IBAction)outletAction:(id)sender;

- (IBAction)checkNewVersionsNow:(id)sender;
- (IBAction)checkNewServerErrorsNow:(id)sender;

- (IBAction)openGroupPage:(id)sender;
- (IBAction)openHomePage:(id)sender;
- (IBAction)openEmail:(id)sender;
- (IBAction)openDonatation:(id)sender;

- (IBAction)chooseAlertSong:(id)sender;

- (IBAction)displayLocationClicked:(id)sender;

- (NSString *)checkNewVersion;
- (NSString *)checkForNewServerErrors;
- (NSComparisonResult)compareVersion:(NSString *)versionA toVersion:(NSString *)versionB;
- (NSArray *)splitVersion:(NSString *)version;
- (int)getCharType:(NSString *)character;


- (void)updateInterfaceFromDefaults;
- (void)updateDefaultsFromInterface;
- (void)resetDefaults;
- (void)applyNewDefaults;
- (void)validateDefaults;

- (BOOL)written;

- (BOOL)displayTodayInSubmenu;
- (BOOL)displayDayImage;
- (BOOL)viewForecastInSubmenu;
- (int)forecastDaysNumber;
- (BOOL)forecastDaysOn;
- (BOOL)forecastInline;

- (NSColor *)tempColor;
- (NSString *)tempFont;
- (BOOL)hideCF;
- (BOOL)displayTemp;

- (float)imageOpacity;

- (BOOL)displayInDock;
- (BOOL)displayInMenubar;
- (BOOL)displayInDockAndMenuBar;

- (BOOL)displayCityName;
- (BOOL)displayMenuIcon;
- (NSString *)menuFontName;
- (NSColor *)menuColor;
- (int)menuFontSize;
- (BOOL)logMessagesToConsole;

- (int)alertOptions;
- (NSString*)alertEmail;
- (NSString*)alertSong;

- (int)cycleMode;
- (int)autoUpdateTime;
- (int)cycleUpdateTime;
- (int)changeUpdateTime;

- (BOOL)embedControls;

- (BOOL)checkNewServerErrors;
- (BOOL)checkNewVersions;

- (BOOL)useGlobalUnits;
- (NSString *)degreeUnits;
- (NSString *)speedUnits;
- (NSString *)distanceUnits;
- (NSString *)pressureUnits;

- (int)alertOptions;

- (BOOL)killOtherMeteo;

NSArray *allFonts();

- (void)deactivateInterface;
- (void)activateInterface;


//JRC
- (void)textDidChange:(NSNotification *)notification;

@end


@interface MESpecialMatrix : NSMatrix
{
	
}

- (void)mouseDown:(NSEvent *)theEvent;
@end