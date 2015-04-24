//
//  VideoAuthController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/4/23.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#define kLocalVideo_Width                   100.0f
#define kLocalVideo_Height                  130.0f
#define kBar_Height                         30.0f
#define kSelfView_Width                     self.view.frame.size.width
#define kSelfView_Height                    self.view.frame.size.height

#define kLocalVideoPortrait_CGRect          CGRectMake(kSelfView_Width-2-kLocalVideo_Width, kSelfView_Height- kLocalVideo_Height-2-kBar_Height, kLocalVideo_Width,kLocalVideo_Height)
#define kLocalVideoLandscape_CGRect         CGRectMake(kSelfView_Width-2-kLocalVideo_Height, kSelfView_Height-kLocalVideo_Width-2-kBar_Height, kLocalVideo_Height, kLocalVideo_Width)

#define kRadians(degrees)                   M_PI / 180.0 * degrees
#define kLayer3DRotation_Z_Axis(degrees)    CATransform3DMakeRotation(kRadians(degrees), 0.0, 0.0, 1.0)

#import "VideoAuthController.h"
#import <AVFoundation/AVFoundation.h>

#import "AnyChatPlatform.h"
#import "AnyChatDefine.h"
#import "AnyChatErrorCode.h"

#import "AppDelegate.h"

@interface VideoAuthController ()<AnyChatNotifyMessageDelegate>

@property (nonatomic, strong) AnyChatPlatform *anyChat;

@property (nonatomic, assign) int myUserID;  //视频认证登录后自己的id

@property (nonatomic, assign) int remoteID;  //远程连接的id

@property (strong, nonatomic) AVCaptureVideoPreviewLayer *localVideoSurface;
@property (nonatomic, strong) UIImageView *remoteVideoSurface;
@property (nonatomic, strong) UIView *theLocalView;

@end

@implementation VideoAuthController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"视频认证";
    [self initUI];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:kImageName(@"back.png")
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self
                                                                action:@selector(back)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //初始化
    [AnyChatPlatform InitSDK:0];
    _anyChat = [[AnyChatPlatform alloc] init];
    _anyChat.notifyMsgDelegate = self;
    [AnyChatPlatform Connect:kVideoAuthIP :kVideoAuthPort];
    _remoteID = -1;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(AnyChatNotifyHandler:)
                                                 name:@"ANYCHATNOTIFY"
                                               object:nil];
    
    NSLog(@"terminalID = %@",_terminalID);
    [self userLoginIn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)back {
    [self FinishVideoChat];
    //    [AnyChatPlatform Release];
}

- (void)initUI {
    _remoteVideoSurface = [[UIImageView alloc] init];
    _remoteVideoSurface.translatesAutoresizingMaskIntoConstraints = NO;
    _remoteVideoSurface.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:_remoteVideoSurface];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_remoteVideoSurface
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_remoteVideoSurface
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_remoteVideoSurface
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_remoteVideoSurface
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    _theLocalView = [[UIImageView alloc] init];
    _theLocalView.translatesAutoresizingMaskIntoConstraints = NO;
    _theLocalView.backgroundColor = [UIColor blackColor];
    [self.view addSubview:_theLocalView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_theLocalView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_theLocalView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:-10]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_theLocalView
                                                          attribute:NSLayoutAttributeWidth
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeWidth
                                                         multiplier:1.0
                                                           constant:100]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_theLocalView
                                                          attribute:NSLayoutAttributeHeight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:nil
                                                          attribute:NSLayoutAttributeHeight
                                                         multiplier:1.0
                                                           constant:130]];
    
}

#pragma mark -

- (void)userLoginIn {
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_WIDTHCTRL :640];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_HEIGHTCTRL :480];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_BITRATECTRL :1000000];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_FPSCTRL :25];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_PRESETCTRL :5];
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_QUALITYCTRL :4];
    // 采用本地视频参数设置，使参数设置生效
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_APPLYPARAM :1];
    
    AppDelegate *delegate = [AppDelegate shareAppDelegate];
    [AnyChatPlatform Login:delegate.userID :@"x"];
}

#pragma mark - NSNotification

- (void)AnyChatNotifyHandler:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    [_anyChat OnRecvAnyChatNotify:dict];
}

#pragma mark - AnyChatNotifyMessageDelegate

//连接服务器消息
- (void)OnAnyChatConnect:(BOOL)bSuccess {
    
}

//用户登录
- (void)OnAnyChatLogin:(int)dwUserId :(int)dwErrorCode {
    if (dwErrorCode == GV_ERR_SUCCESS) {
        _myUserID = dwUserId;
        [AnyChatPlatform EnterRoom:[_terminalID intValue] :@""];
    }
}

//用户进入房间
- (void)OnAnyChatEnterRoom:(int)dwRoomId :(int)dwErrorCode {
    if (dwErrorCode != GV_ERR_SUCCESS) {
        NSLog(@"进入房间失败");
    }
}

//房间在线用户消息
- (void)OnAnyChatOnlineUser:(int)dwUserNum :(int)dwRoomId {
    NSArray *otherUsers = [AnyChatPlatform GetOnlineUser];
    NSLog(@"online = %@",otherUsers);
    if ([otherUsers count] > 0) {
        _remoteID = [[otherUsers firstObject] intValue];
        [self StartVideoChat:_remoteID];
    }
}

//其他用户进入房间
- (void)OnAnyChatUserEnterRoom:(int)dwUserId {
    NSArray *otherUsers = [AnyChatPlatform GetOnlineUser];
    NSLog(@"enter = %@",otherUsers);
    if (_remoteID < 0 && [otherUsers count] > 0) {
        _remoteID = [[otherUsers firstObject] intValue];
        [self StartVideoChat:_remoteID];
    }
}

- (void)OnAnyChatUserLeaveRoom:(int)dwUserId {
    NSArray *otherUsers = [AnyChatPlatform GetOnlineUser];
    NSLog(@"leave = %@",otherUsers);
    if (dwUserId == _remoteID) {
        [self FinishVideoChat];
        _remoteID = -1;
    }
}

//网络断开
- (void)OnAnyChatLinkClose:(int)dwErrorCode {
    [self FinishVideoChat];
}

#pragma mark - 认证
- (void)StartVideoChat:(int)userid
{
    //Get a camera, Must be in the real machine.
    NSMutableArray* cameraDeviceArray = [AnyChatPlatform EnumVideoCapture];
    if (cameraDeviceArray.count > 0)
    {
        [AnyChatPlatform SelectVideoCapture:[cameraDeviceArray objectAtIndex:0]];
        
    }
    
    // open local video
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_OVERLAY :1];
    [AnyChatPlatform UserSpeakControl: -1:YES];
    [AnyChatPlatform SetVideoPos:-1 :self :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:-1 : YES];
    // request other user video
    [AnyChatPlatform UserSpeakControl: userid:YES];
    [AnyChatPlatform SetVideoPos:userid :_remoteVideoSurface :0 :0 :0 :0];
    [AnyChatPlatform UserCameraControl:userid : YES];
    
    //远程视频显示时随设备的方向改变而旋转（参数为int型， 0表示关闭， 1 开启[默认]，视频旋转时需要参考本地视频设备方向参数）
    [AnyChatPlatform SetSDKOptionInt:BRAC_SO_LOCALVIDEO_ORIENTATION : self.interfaceOrientation];
}

- (void)FinishVideoChat
{
    // 关闭摄像头
    [AnyChatPlatform UserSpeakControl: -1 : NO];
    [AnyChatPlatform UserCameraControl: -1 : NO];
    
    [AnyChatPlatform UserSpeakControl:_remoteID : NO];
    [AnyChatPlatform UserCameraControl:_remoteID : NO];
    
    _remoteID = -1;
    [AnyChatPlatform LeaveRoom:-1];
    [AnyChatPlatform Logout];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) OnLocalVideoRelease:(id)sender
{
    if(self.localVideoSurface) {
        self.localVideoSurface = nil;
    }
}

- (void) OnLocalVideoInit:(id)session
{
    self.localVideoSurface = [AVCaptureVideoPreviewLayer layerWithSession: (AVCaptureSession*)session];
    self.localVideoSurface.frame = CGRectMake(0, 0, kLocalVideo_Width, kLocalVideo_Height);
    self.localVideoSurface.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.theLocalView.layer addSublayer:self.localVideoSurface];
}

#pragma mark - Orientation Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    //device orientation
    UIDeviceOrientation devOrientation = [UIDevice currentDevice].orientation;
    
    if (devOrientation == UIDeviceOrientationLandscapeLeft)
    {
        [self setFrameOfLandscapeLeft];
    }
    else if (devOrientation == UIDeviceOrientationLandscapeRight)
    {
        [self setFrameOfLandscapeRight];
    }
    else if (devOrientation == UIDeviceOrientationPortrait)
    {
        [self setFrameOfPortrait];
    }
}

#pragma mark - Video Rotation

-(void)setFrameOfPortrait
{
    //Rotate
    _remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(0.0);
    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(0.0);
    //Scale
    self.remoteVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.theLocalView.frame = kLocalVideoPortrait_CGRect;
}

-(void)setFrameOfLandscapeLeft
{
    //Rotate
    _remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(-90.0);
    //Scale
    self.remoteVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.theLocalView.frame = kLocalVideoLandscape_CGRect;
}

-(void)setFrameOfLandscapeRight
{
    //Rotate
    _remoteVideoSurface.layer.transform = kLayer3DRotation_Z_Axis(90.0);
    self.theLocalView.layer.transform = kLayer3DRotation_Z_Axis(90.0);
    //Scale
    self.remoteVideoSurface.frame = CGRectMake(0, 0, kSelfView_Width, kSelfView_Height);
    self.theLocalView.frame = kLocalVideoLandscape_CGRect;
}


@end
