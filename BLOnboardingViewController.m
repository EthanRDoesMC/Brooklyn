//
//  BLOnboardingViewController.m
//  xchighlight
//
//  Created by EthanRDoesMC on 4/21/21.
//
#import "BLOnboardingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "BLMautrixTask.h"
#import "NSTask.h"

// https://useyourloaf.com/blog/reading-qr-codes/

@interface BLOnboardingViewController () <AVCaptureMetadataOutputObjectsDelegate>

@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) CALayer *targetLayer;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) NSMutableArray *codeObjects;

@end

@implementation BLOnboardingViewController
- (IBAction)logItems:(id)sender {
    NSLog(@"%@", _codeObjects);
    if ([self.codeObjects count]) {
        // so why didn't i go with this? you may be asking.
        // simple.
        // foundation didn't support the cipher that tulir uses.
        // on modern ios this will be utilized.
//        NSURLSessionDownloadTask * dlTask = [[NSURLSession sharedSession] downloadTaskWithURL:[NSURL URLWithString:((AVMetadataMachineReadableCodeObject *) self.codeObjects[0]).stringValue] completionHandler:^(NSURL *location, NSURLResponse *response, NSError *error) {
//            NSLog(@"location: %@, response: %@, error: %@", location,response,error);
//            if (error == nil) {
//                [NSFileManager.defaultManager moveItemAtURL:location toURL:[NSURL fileURLWithPath:@"/var/mobile/Documents/mautrix-imessage-armv7/config.yaml"] error:nil];
//            }
//        }];
//        [dlTask resume];
        
        // [NSURL URLWithString:((AVMetadataMachineReadableCodeObject *) self.codeObjects[0]).stringValue]
        //[[[BLMautrixTask sharedTask] task] resume];
        [self handleURL:((AVMetadataMachineReadableCodeObject *) self.codeObjects[0]).stringValue];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

-(void)handleURL:(NSString *)url {
    [NSUserDefaults.standardUserDefaults setValue:url forKey:@"configurl"];
    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"redirect"];
    //NSLog(@"%@", [NSUserDefaults valueForKey:@"configurl"]);
    NSLog(@"%@", [[BLMautrixTask alloc] initAndLaunch]);
    [self stopRunning];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (AVCaptureSession *)captureSession {
    if (!_captureSession) {
        NSError *error = nil;
        AVCaptureDevice *device = [AVCaptureDevice
                                   defaultDeviceWithMediaType:AVMediaTypeVideo];
        if (device.isAutoFocusRangeRestrictionSupported) {
            if ([device lockForConfiguration:&error]) {
                [device setAutoFocusRangeRestriction:AVCaptureAutoFocusRangeRestrictionNear];
                [device unlockForConfiguration];
            }
        }
        AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput
                                             deviceInputWithDevice:device error:&error];
        if (deviceInput) {
            _captureSession = [[AVCaptureSession alloc] init];
            if ([_captureSession canAddInput:deviceInput]) {
                [_captureSession addInput:deviceInput];
            }
        }
        AVCaptureMetadataOutput *metadataOutput = [[AVCaptureMetadataOutput alloc] init];
        if ([_captureSession canAddOutput:metadataOutput]) {
            [_captureSession addOutput:metadataOutput];
            [metadataOutput setMetadataObjectsDelegate:self
                                                 queue:dispatch_get_main_queue()];
            [metadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
        }
        self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_captureSession];
        self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        self.previewLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.previewLayer];
        self.targetLayer = [CALayer layer];
        self.targetLayer.frame = self.view.bounds;
        [self.view.layer addSublayer:self.targetLayer];
    }
    return _captureSession;
}
- (IBAction)buttonPushed:(id)sender {
    [self startRunning];
}

- (void)startRunning {
    self.codeObjects = nil;
    [self.captureSession startRunning];
}

- (void)stopRunning {
    [self.captureSession stopRunning];
    self.captureSession = nil;
}

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//    [self startRunning];
//}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self stopRunning];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    self.codeObjects = nil;
    for (AVMetadataObject *metadataObject in metadataObjects) {
        AVMetadataObject *transformedObject = [self.previewLayer
                                               transformedMetadataObjectForMetadataObject:metadataObject];
        [self.codeObjects addObject:transformedObject];
    }
    
    [self clearTargetLayer];
    [self showDetectedObjects];
}

- (void)clearTargetLayer {
    NSArray *sublayers = [[self.targetLayer sublayers] copy];
    for (CALayer *sublayer in sublayers) {
        [sublayer removeFromSuperlayer];
    }
}

- (void)showDetectedObjects {
    for (AVMetadataObject *object in self.codeObjects) {
        if ([object isKindOfClass:[AVMetadataMachineReadableCodeObject class]]) {
            CAShapeLayer *shapeLayer = [CAShapeLayer layer];
            shapeLayer.strokeColor = [UIColor redColor].CGColor;
            shapeLayer.fillColor = [UIColor clearColor].CGColor;
            shapeLayer.lineWidth = 2.0;
            shapeLayer.lineJoin = kCALineJoinRound;
            shapeLayer.cornerRadius = 3.0;
            CGPathRef path = createPathForPoints([(AVMetadataMachineReadableCodeObject *)object corners]);
            shapeLayer.path = path;
            CFRelease(path);
            [self.targetLayer addSublayer:shapeLayer];
        }
    }
}

CGMutablePathRef createPathForPoints(NSArray* points) {
    CGMutablePathRef path = CGPathCreateMutable();
    CGPoint point;
    if ([points count] > 0) {
        CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:0], &point);
        CGPathMoveToPoint(path, nil, point.x, point.y);
        int i = 1;
        while (i < [points count]) {
            CGPointMakeWithDictionaryRepresentation((CFDictionaryRef)[points objectAtIndex:i], &point);
            CGPathAddLineToPoint(path, nil, point.x, point.y);
            i++;
        }
        CGPathCloseSubpath(path);
    }
    return path;
}

- (NSMutableArray *)codeObjects
{
    if (!_codeObjects)
        {
        _codeObjects = [NSMutableArray new];
        }
    return _codeObjects;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
