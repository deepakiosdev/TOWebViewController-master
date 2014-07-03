//
//  TOViewController.m
//  TOWebViewControllerExample
//
//  Created by Tim Oliver on 6/05/13.
//  Copyright (c) 2013 Tim Oliver. All rights reserved.
//

#import "TOViewController.h"
#import "TOWebViewController.h"
#import <UIKit/UIKit.h>


#import <MediaPlayer/MediaPlayer.h>


#ifndef NSFoundationVersionNumber_iOS_6_1
    #define NSFoundationVersionNumber_iOS_6_1  993.00
#endif

/* Detect if we're running iOS 7.0 or higher */
#define MINIMAL_UI (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1)

@interface TOViewController ()
@property (nonatomic, strong)UIWebView *videoView;
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
- (IBAction)playMovie:(id)sender;
@end

@implementation TOViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9f alpha:1.0f];
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:self.tableView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.frame = ({
            CGRect frame = self.tableView.frame;
            frame.size.width = CGRectGetWidth(frame) * 0.65f;
            frame.origin.x = CGRectGetMidX(self.view.frame) - (CGRectGetWidth(frame) *0.5f);
            frame;
        });
    }
}

- (void)viewDidLoad
{
    self.title = @"TOWebViewController";
    
    if (MINIMAL_UI) {
        self.tableView.backgroundView = [UIView new];
        self.view.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
        self.tableView.backgroundView.backgroundColor = [UIColor colorWithWhite:0.95f alpha:1.0f];
    }
    else {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            self.tableView.backgroundView = [UIView new];
            self.tableView.backgroundView.backgroundColor = [UIColor clearColor];
        }
        
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLineEtched;
    }
    
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    [self.navigationItem setBackBarButtonItem:backItem];
}

#pragma mark - Table View Protocols -
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tableCellIdentifier = @"TableViewCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableCellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:tableCellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    if (indexPath.row == 0) {
        cell.textLabel.text = @"Present as Modal View Controller";
    }else if (indexPath.row == 1) {
        cell.textLabel.text = @"Push onto Navigation Controller";
    }
    else {
        cell.textLabel.text = @"You Tube";
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSURL *url = nil;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        url = [NSURL URLWithString:@"www.apple.com/ipad"];
    else if ([[[UIDevice currentDevice] model] rangeOfString:@"iPod"].location != NSNotFound)
        url = [NSURL URLWithString:@"www.apple.com/ipod-touch"];
    else
        url = [NSURL URLWithString:@"https://www.youtube.com/v=xK5aksWjp2A"];
    
    TOWebViewController *webViewController = [[TOWebViewController alloc] initWithURL:url];
    
    if (indexPath.row == 0) {
        [self presentViewController:[[UINavigationController alloc] initWithRootViewController:webViewController] animated:YES completion:nil];
    } if (indexPath.row == 1) {
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    else {
        
        /*NSURL *videoUrl = [NSURL URLWithString:@"https://www.youtube.com/v=xK5aksWjp2A"];
        CGRect frame = self.view.frame;
        NSString* embedHTML = @"\
        <html><head>\
        <style type=\"text/css\">\
        body {\
            background-color: transparent;\
        color: white;\
        }\
        </style>\
        </head><body style=\"margin:0\">\
        <embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \
        width=\"%0.0f\" height=\"%0.0f\"></embed>\
        </body></html>";
        
        NSString* html = [NSString stringWithFormat:embedHTML, videoUrl, frame.size.width, frame.size.height];
        if(self.videoView == nil) {
            self.videoView = [[UIWebView alloc] initWithFrame:frame];
            [self.view addSubview:self.videoView];
        }
        [self.videoView loadHTMLString:html baseURL:nil];*/
        
        
       /* float width = 200.0f;
        float height = 200.0f;
        
        NSString *youTubeURL = @"https://www.youtube.com/v=xK5aksWjp2A";
        
        UIWebView *webView = [UIWebView new];
        webView.frame = CGRectMake(60, 60, width, height);
        
        NSMutableString *html = [NSMutableString string];
        [html appendString:@"<html><head>"];
        [html appendString:@"<style type=\"text/css\">"];
        [html appendString:@"body {"];
        [html appendString:@"background-color: transparent;"];
        [html appendString:@"color: white;"];
        [html appendString:@"}"];
        [html appendString:@"</style>"];
        [html appendString:@"</head><body style=\"margin:0\">"];
        [html appendFormat:@"<embed id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\"", youTubeURL];
        [html appendFormat:@"width=\"%0.0f\" height=\"%0.0f\"></embed>", width, height];
        [html appendString:@"</body></html>"];
        
        [webView loadHTMLString:html baseURL:nil];
        
        [self.view addSubview:webView];*/
        
       /* NSString *html = @"\
        <html><head>\
        <style type=\"text/css\">\
        body {    background-color: transparent;\
        color: white; \
        }\
        </style>\
        </head><body style=\"margin:0\">\
        <iframe class=\"youtube-player\" width=\"300\" height=\"300\" src=\"http://www.youtube.com/embed/efRNKkmWdc0\" frameborder=\"0\" allowfullscreen=\"true\"></iframe>\
        </body></html>";
        
        UIWebView *videoView = [[UIWebView alloc] initWithFrame:CGRectMake(10.0, 0.0, 320.0, 200.0)];
        [videoView loadHTMLString:html baseURL:nil];
        [self.view addSubview:videoView];*/
        
        
       /* NSMutableString *html = [[NSMutableString alloc] initWithCapacity:1] ;
        [html appendString:@"<html><head>"];
        [html appendString:@"<style type=\"text/css\">"];
        [html appendString:@"body {"];
        [html appendString:@"background-color: transparent;"];
        [html appendString:@"color: white;"];
        [html appendString:@"}"];
        [html appendString:@"</style>"];
        [html appendString:@"</head><body style=\"margin:0\">"];
        [html appendString:@"<iframe src=\"//player.vimeo.com/video/84403700?autoplay=1&amp;loop=1\" width=\"1024\" height=\"768\" frameborder=\"0\" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>"];
        [html appendString:@"</body></html>"];
        
        
        [self.videoView loadHTMLString:html baseURL:urlMovie];*/
        
        [self playMovie:nil];
        
       /* NSString *youTubeURL = @"https://www.youtube.com/v=xK5aksWjp2A";
        NSString *youTubeVideoHTML = @"<html><head><style>body{margin:0;}</style></head> <body> <div id=\"player\"></div> <script> var tag = document.createElement('script'); tag.src = 'http://www.youtube.com/player_api'; var firstScriptTag = document.getElementsByTagName('script')[0]; firstScriptTag.parentNode.insertBefore(tag, firstScriptTag); var player; function onYouTubePlayerAPIReady() { player = new YT.Player('player', { width:\'100%%\', height:'200px', videoId:\'%@\', events: { 'onReady': onPlayerReady } }); } function onPlayerReady(event) { event.target.playVideo(); } </script> </body> </html>";
        
        NSString *html = [NSString stringWithFormat:youTubeVideoHTML, youTubeURL];
        self.videoView.mediaPlaybackRequiresUserAction = NO;
        
        [self.videoView loadHTMLString:html baseURL:[[NSBundle mainBundle] resourceURL]];
        
        [self.view addSubview:self.videoView];*/
    }
}


-(void)playMovie:(id)sender
{
    /*NSURL *url = [NSURL URLWithString:
                  @"http://www.ebookfrenzy.com/ios_book/movie/movie.mov"];*/
   NSURL *url = [NSURL URLWithString:
                  @"http://www.dailymotion.com/cdn/manifest/video/xweiiv.m3u8?auth=1404562468-2562-el8x71i4-d4d3c871a191791a10081fc9d082a1be&default=380"];
    
   /* NSURL *url = [NSURL URLWithString:
                  @"https://www.youtube.com/watch?v=3IsVTMB_hnw"];*/
    //
    _moviePlayer =  [[MPMoviePlayerController alloc]
                     initWithContentURL:url];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:MPMoviePlayerPlaybackDidFinishNotification
                                               object:_moviePlayer];
    
    _moviePlayer.controlStyle = MPMovieControlStyleDefault;
    _moviePlayer.shouldAutoplay = YES;
    [self.view addSubview:_moviePlayer.view];
    [_moviePlayer setFullscreen:YES animated:YES];
}

- (void) moviePlayBackDidFinish:(NSNotification*)notification {
    MPMoviePlayerController *player = [notification object];
    [[NSNotificationCenter defaultCenter]
     removeObserver:self
     name:MPMoviePlayerPlaybackDidFinishNotification
     object:player];
    
    if ([player
         respondsToSelector:@selector(setFullscreen:animated:)])
    {
        [player.view removeFromSuperview];
    }
}

@end
