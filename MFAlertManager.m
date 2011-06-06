//
//  MFAlertManager.m
//  Meteorologist
//
//  Created by Matthew Fahrenbacher on Fri Mar 14 2003.
//  Copyright (c) 2004 The Meteorologist Group. All rights reserved.
//

#import "MFAlertManager.h"


@implementation MFAlertManager

- (void)awakeFromNib
{
	[weatherAlertsPanel setTitle:NSLocalizedString(@"weatherAlertPanelTitle",nil)];
	[killSoundsButton setTitle:NSLocalizedString(@"killSoundsButtonTitle",nil)];
	[clearLogButton setTitle:NSLocalizedString(@"clearLogButtonTitle",nil)];
}

- (id)init
{
    self = [super init];
    if(self)
        alertingCities = [[NSMutableArray array] retain];
	
    return self;
}

- (void)addCity:(NSArray *)array
{
    [self addCity:[array objectAtIndex:0]
	 alertOptions:[[array objectAtIndex:2] alertOptions]
			email:[[array objectAtIndex:2] alertEmail]
			  sms:[[array objectAtIndex:2] alertSMS]
			 song:[[array objectAtIndex:2] alertSong]
		  warning:[array objectAtIndex:1]];
}

- (void)addCity:(MECity *)city
   alertOptions:(int)options
		  email:(NSString *)email
		    sms:(NSString *)sms
		   song:(NSString *)song
		warning:(NSArray *)warn
{
    if((![alertingCities containsObject:city]) ||
	   ((alertCount != [warn count]) &&
		([warn count])))
	{
		alertCount = [warn count];
        [alertingCities addObject:city];
        
        NSString *warnMsg = NSLocalizedString(@"falseAlarm",nil);
        NSString *smsMsg = NSLocalizedString(@"falseAlarm",nil);

        NSEnumerator *warnEnum = [warn objectEnumerator];
        NSDictionary *dict;
        
        while(dict = [warnEnum nextObject])
        {
            NSString *temp;
            warnMsg = [NSString stringWithFormat:NSLocalizedString(@"warningsFor",nil),[city cityName]];
            smsMsg = [NSString stringWithFormat:NSLocalizedString(@"%@ ",nil),[city cityName]];
            
            //if(temp = [dict objectForKey:@"title"])
			//{
                //warnMsg = [NSString stringWithFormat:@"%@%@\n",warnMsg,temp];
			//}
                
            if(temp = [dict objectForKey:@"link"])
			{
                warnMsg = [NSString stringWithFormat:@"%@%@\n",warnMsg,temp];
                smsMsg = [NSString stringWithFormat:@"%@%@ ",smsMsg,temp];
			}
			
            if(temp = [dict objectForKey:@"description"])
			{
                warnMsg = [NSString stringWithFormat:@"%@%@\n",warnMsg,temp];
                smsMsg = [NSString stringWithFormat:@"%@%@ ",smsMsg,temp];
			}
			
            warnMsg = [NSString stringWithFormat:@"%@\n",warnMsg];
            smsMsg = [NSString stringWithFormat:@"%@\n",smsMsg];
        
			//email
			if(options & 1)
			{
				[emailer emailMessage:warnMsg toAccount:email];
			}
			//beep
			if(options & 2)
			{
				[beeper beginBeeping];
				options = (options | 16); //Force on a message
			}
			//song
			if(options & 4)
			{
				if(![player playSong:song])
					[beeper beginBeeping];
				options = options | 16; //Force on a message
			}
			//bounce
			if(options & 8)
			{
				[NSApp deactivate];
				[NSApp requestUserAttention:NSCriticalRequest];
				options = options | 16; //Force on a message
			}
			
			if(options & 16)
			{
				//display a text view with this info
				[displayer appendMessage:warnMsg];
			}
			//sms
			if(options & 32)
			{
				[emailer smsMessage:smsMsg toAccount:sms];
			}
        }
    }
}

- (void)removeCity:(MECity *)city
{
    [alertingCities removeObjectIdenticalTo:city];
}

- (void)windowWillClose:(NSNotification *)aNotification
{
    [self kill:nil];
}

- (IBAction)kill:(id)sender
{
    [beeper kill];
    [player kill];
}

@end


@implementation MFBeeper

- (id)init
{
    self = [super init];
    if(self)
    {
        timer = nil;
        killer = nil;
    }
    return self;
}

- (void)beginBeeping
{
    if(!timer)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(beep) userInfo:nil repeats:YES];
        killer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(kill) userInfo:nil repeats:NO];
    }
}

- (void)beep
{
    NSBeep();
}

- (void)kill
{
    if(timer && [timer isValid])
        [timer invalidate];
    
    if(killer && [killer isValid])
        [killer invalidate];
    
    killer = nil;
    timer = nil;
}

@end


@implementation MFSongPlayer

- (id)init
{
    self = [super init];
    if(self)
    {
        movieView = [[NSMovieView alloc] init];
        [[[[NSWindow alloc] initWithContentRect:NSMakeRect(0,0,0,0) styleMask:NSBorderlessWindowMask backing:NSBackingStoreBuffered defer:YES] contentView] addSubview:movieView];
        [[movieView window] orderFront:nil];
        
        killer = nil;
    }
    return self;
}

- (BOOL)playSong:(NSString *)path
{
    if(!movie)
    {
        movie = [[[NSMovie alloc] initWithURL:[NSURL fileURLWithPath:path] byReference:YES] autorelease];
        [movieView setMovie:movie];
        
        [movieView start:nil];
        killer = [NSTimer scheduledTimerWithTimeInterval:300 target:self selector:@selector(kill) userInfo:nil repeats:NO];
    }
    
    return (movie != nil);
}

- (void)kill
{
    if(movie)
    {
        [movieView stop:nil];
        [movieView setMovie:nil];
        movie = nil;
    }
    
    if(killer && [killer isValid])
        [killer invalidate];
    
    killer = nil;
}

@end


@implementation MFMessageDisplay

- (void)appendMessage:(NSString *)msg
{
    [NSApp activateIgnoringOtherApps:YES];
    [[message window] makeKeyAndOrderFront:nil];
    [message setEditable:YES];
    [message setSelectedRange:NSMakeRange([[message string] length],0)];
    [message insertText:[NSString stringWithFormat:@"%@\n\n\n",msg]];
    [message setEditable:NO];
}

- (IBAction)clearLog:(id)sender
{
    [message setString:@""];
}

@end


@implementation MFEmailer

- (void)emailMessage:(NSString *)msg toAccount:(NSString *)email
{
    [NSMailDelivery deliverMessage:msg
						   subject:@"Weather Alert"
								to:email];
}

- (void)smsMessage:(NSString *)msg toAccount:(NSString *)sms
{
    [NSMailDelivery deliverMessage:msg
						   subject:@""
								to:sms];
}

@end