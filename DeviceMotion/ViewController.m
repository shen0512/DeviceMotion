//
//  ViewController.m
//  DeviceMotion
//
//  Created by Shen on 2021/10/16.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController (){
    CMMotionManager *motionManager;
}

@property (weak, nonatomic) IBOutlet UITextView *textView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self->motionManager = [[CMMotionManager alloc] init];
    
    [self useDeviceMotionPush: YES];
    
}

-(void)useDeviceMotionPush:(BOOL) useReferenceFrame{
    
    if(!self->motionManager.deviceMotionAvailable){
        NSLog(@"裝置不支援 device motion 偵測");
        self.textView.text = @"裝置不支援 device motion 偵測";
        return;
    }
    
       
    if(useReferenceFrame){
        [self->motionManager startDeviceMotionUpdatesUsingReferenceFrame:CMAttitudeReferenceFrameXTrueNorthZVertical];
    }else{
        [self->motionManager startDeviceMotionUpdates];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(){
        while([self->motionManager isDeviceMotionActive]) {
            // heading (指北針)
            NSString *headingOut = @"Heading(指北針)\n";
            headingOut = [headingOut stringByAppendingFormat:@"heading:%.2f\n"
                          , self->motionManager.deviceMotion.heading];
            
            // magnetic (磁場)
            NSString *magneticOut = @"Magnetic(磁場)\n";
            magneticOut = [magneticOut stringByAppendingFormat:@"x=%.2f\ny=%.2f\nz=%.2f\naccuracy=%d\n"
                           , self->motionManager.deviceMotion.magneticField.field.x
                           , self->motionManager.deviceMotion.magneticField.field.y
                           , self->motionManager.deviceMotion.magneticField.field.z
                           , self->motionManager.deviceMotion.magneticField.accuracy];

            
            // attitude
            NSString *attitudeOut = @"Attitude\n";
            attitudeOut = [attitudeOut stringByAppendingFormat:@"pitch=%.2f\nroll=%.2f\nyaw=%.2f\n"
                           , self->motionManager.deviceMotion.attitude.pitch
                           , self->motionManager.deviceMotion.attitude.roll
                           , self->motionManager.deviceMotion.attitude.yaw];
            
            // rotationRate
            NSString *rotationRateOut = @"RotationRate(旋轉速率)\n";
            rotationRateOut = [rotationRateOut stringByAppendingFormat:@"x=%.2f\ny=%.2f\nz=%.2f\n"
                               ,self->motionManager.deviceMotion.rotationRate.x
                               ,self->motionManager.deviceMotion.rotationRate.y
                               ,self->motionManager.deviceMotion.rotationRate.z];
            
            // gravity
            NSString *gravityOut = @"Gravity(重力)\n";
            gravityOut = [gravityOut stringByAppendingFormat:@"x=%.2f\ny=%.2f\nz=%.2f\n"
                       , self->motionManager.deviceMotion.gravity.x
                       , self->motionManager.deviceMotion.gravity.y
                       , self->motionManager.deviceMotion.gravity.z];
            
            // userAcceleration
            NSString *userAccelerationOut = @"Acceleration(加速度)\n";
            userAccelerationOut = [userAccelerationOut stringByAppendingFormat:@"x=%.2f\ny=%.2f\nz=%.2f\n"
                                   ,self->motionManager.deviceMotion.userAcceleration.x
                                   ,self->motionManager.deviceMotion.userAcceleration.y
                                   ,self->motionManager.deviceMotion.userAcceleration.z];
            
            
            NSString *finalOut = [NSString stringWithFormat:@"%@\n%@\n%@\n%@\n%@\n%@\n"
                                  , headingOut
                                  , magneticOut
                                  , attitudeOut
                                  , rotationRateOut
                                  , gravityOut
                                  , userAccelerationOut];

            NSLog(@"%@", finalOut);
            [self.textView performSelectorOnMainThread:@selector(setText:) withObject:finalOut waitUntilDone:YES];
        }
    });

}

@end
