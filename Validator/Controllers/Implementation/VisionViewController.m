//
//  VisionViewController.m
//  Validator
//
//  Created by Lukas Kasakaitis on 16.01.20.
//  Copyright © 2020 Lukas Kasakaitis. All rights reserved.
//

#import "VisionViewController.h"
#import "CheckViewController.h"
#import "PreviewView.h"

@protocol  ResultReceiver;

@interface VisionViewController ()

@property (weak, nonatomic) IBOutlet PreviewView *previewView;
@property (weak, nonatomic) IBOutlet UIView *cutoutView;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (nonatomic) CGRect regionOfInterest;

@property (nonatomic) UIDeviceOrientation currentOrientation;
@property (nonatomic) CGImagePropertyOrientation textOrientation;

@property (nonatomic) AVCaptureSession * captureSession;
@property (nonatomic) AVCaptureDevice *captureDevice;
@property (nonatomic) AVCaptureVideoDataOutput *videoDataOutput;

@property (nonatomic) double bufferAspectRatio;

@property (nonatomic) dispatch_queue_t sessionCaptureQueue;
@property (nonatomic) dispatch_queue_t videoDataOutputQueue;

@property (nonatomic) NSMutableArray *boxLayer;

@property (nonatomic) CGAffineTransform uiRotationTransform;
@property (nonatomic) CGAffineTransform bottomToTopTransform;
@property (nonatomic) CGAffineTransform roiToGlobalTransform;
@property (nonatomic) CGAffineTransform visionToAVFTransform;



-(void) recognizeTextHandler;

@end

@implementation VisionViewController
@synthesize resultReceiverDelegate;

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        _request = [[VNRecognizeTextRequest alloc] init];
        _maskLayer = [[CAShapeLayer alloc] init];
        _textOrientation = kCGImagePropertyOrientationUp;
        _currentOrientation = UIDeviceOrientationPortrait;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"%@", self.resultReceiverDelegate);


    self.regionOfInterest = CGRectMake(0, 0, 1, 1);
    self.textOrientation = kCGImagePropertyOrientationUp;
    
    self.resultEmailAddress = [[NSString alloc] init];
    
    [self recognizeTextHandler];
    
    self.uiRotationTransform = CGAffineTransformIdentity;
    self.bottomToTopTransform = CGAffineTransformTranslate(CGAffineTransformMakeScale(1, -1), 0, 1);
    self.roiToGlobalTransform = CGAffineTransformIdentity;
    self.visionToAVFTransform = CGAffineTransformIdentity;
    
    self.captureSession = [[AVCaptureSession alloc] init];
    self.videoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
    
    self.previewView.sesssion = self.captureSession;
    
    UIColor *brandColor = [[UIColor alloc] initWithHue:170 / 100 saturation:64 / 100 brightness:69 / 100 alpha:0.5];
    
    self.cutoutView.backgroundColor = brandColor;
    
    self.maskLayer.backgroundColor = UIColor.clearColor.CGColor;
    self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    
    self.cutoutView.layer.mask = self.maskLayer;
    
    self.sessionCaptureQueue = dispatch_queue_create("SessionCaptureQueue", DISPATCH_QUEUE_SERIAL);
    self.videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(self.sessionCaptureQueue, ^{
        
        [self setupCamera];

    });
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    NSLog(@"RESULT: %@", self.resultEmailAddress);

    NSLog(@"View Will Dissapear");
    NSLog(@"RESULT: %@", self.resultEmailAddress);
    [self.resultReceiverDelegate passResult:self.resultEmailAddress];
    [self.captureSession stopRunning];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];

    self.currentOrientation = UIDevice.currentDevice.orientation;
    
    AVCaptureConnection *videoPreviewLayerConnection = self.previewView.videoPreviewLayer.connection;
    
    AVCaptureVideoOrientation newVideoOrientation = self.currentOrientation == UIDeviceOrientationPortrait ? AVCaptureVideoOrientationPortrait : AVCaptureVideoOrientationLandscapeLeft;
    
    videoPreviewLayerConnection.videoOrientation = newVideoOrientation;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    CVImageBufferRef pixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    
    if (pixelBuffer) {
        
        self.request.recognitionLevel = VNRequestTextRecognitionLevelAccurate;
        self.request.usesLanguageCorrection = NO;
        //self.request.regionOfInterest = self.regionOfInterest;
        
        VNImageRequestHandler * requestHandler = [[VNImageRequestHandler alloc] initWithCVPixelBuffer:pixelBuffer orientation:kCGImagePropertyOrientationRight  options:@{}];
        
        NSArray *requests = [NSArray arrayWithObject:self.request];
        NSError *error = nil;
        
        
        [requestHandler performRequests:requests error:&error];
        
    }
    
}

- (void)recognizeTextHandler {
    
    //NSMutableArray * characters = [[NSArray alloc] init];
    //NSMutableArray * redBoxes = [[NSArray alloc] init];
    //NSMutableArray * greenBoxes = [[NSArray alloc] init];
    
    self.request = [[VNRecognizeTextRequest alloc] initWithCompletionHandler:^(VNRequest * _Nonnull request, NSError * _Nullable error) {
        
        int maximumCandidates = 1;
        
        if (error) {
            
            NSLog(@"%@", error);
            
        } else {
            
            for(VNRecognizedTextObservation *textObservation in request.results) {
                
                if (textObservation != nil) {
                    
                    VNRecognizedText *candidate = [textObservation topCandidates:maximumCandidates].firstObject;
                    
                    NSString *result = [self extractEmailAddressFrom:candidate.string];
                    
                    NSLog(@"%@", result);
                    
                    if (result.length > 5) {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            self.resultEmailAddress = result;
                            [self dismissViewControllerAnimated:YES completion:nil];
                        });
                    }
                    
                }
                
            }
            
        }
        
    }];
    
    
}

-(void)setupCamera {
    
    AVCaptureDevice * captureDevice = [AVCaptureDevice defaultDeviceWithDeviceType: AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    self.captureDevice = captureDevice;
    
    if ([captureDevice supportsAVCaptureSessionPreset:AVCaptureSessionPreset3840x2160]) {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset3840x2160];
        self.bufferAspectRatio = 3840.0 / 2160.0;
    } else {
        [self.captureSession setSessionPreset:AVCaptureSessionPreset1920x1080];
        self.bufferAspectRatio = 1920.0 / 1080.0;
    }
    
    NSError *error = nil;
    AVCaptureDeviceInput * deviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];
    
    if ([self.captureSession canAddInput:deviceInput]) {
        [self.captureSession addInput:deviceInput];
    }
    
    self.videoDataOutput.alwaysDiscardsLateVideoFrames = YES;
    
    [self.videoDataOutput setSampleBufferDelegate:self queue:self.videoDataOutputQueue];
    
    NSDictionary *videoSettings = @{};
    
    [self.videoDataOutput setVideoSettings:videoSettings];
    
    
    if ([self.captureSession canAddOutput:self.videoDataOutput]) {
        [self.captureSession addOutput:self.videoDataOutput];
        [self.videoDataOutput connectionWithMediaType:AVMediaTypeVideo].preferredVideoStabilizationMode = AVCaptureVideoStabilizationModeOff;
    } else {
        NSLog(@"Could not add VDO output");
    }
    
    NSError *configError = nil;
    [self.captureDevice lockForConfiguration:&configError];
    self.captureDevice.videoZoomFactor = 2;
    self.captureDevice.autoFocusRangeRestriction = AVCaptureAutoFocusRangeRestrictionNear;
    [self.captureDevice unlockForConfiguration];
    
    
    [self.captureSession startRunning];
}

- (NSString *) extractEmailAddressFrom:(NSString *)string {
    
    NSMutableString *emailAddress = [[NSMutableString alloc] init];
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"([a-zA-Z0-9_\\-\\.]+@)([a-zA-Z0-9_\\-\\.]+\\.)([a-zA-Z]{2,5})" options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range: NSMakeRange(0, [string length])];
    
    
    if (match != 0) {
        
        for (NSUInteger i = 1; i < match.numberOfRanges; i++) {
            
            NSRange range = [match rangeAtIndex:i];
            NSString *matchString = [string substringWithRange:range];
            [emailAddress appendString:matchString];
            
        }
        
    }
    
    return emailAddress;
}

@end
