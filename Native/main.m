#import <Cocoa/Cocoa.h>
#import <QuartzCore/QuartzCore.h>

static const NSInteger FCBreakDuration = 20;

@interface FCBreakView : NSView
@property(nonatomic) NSInteger remainingSeconds;
@property(nonatomic, strong) NSTimer *displayTimer;
@property(nonatomic) NSTimeInterval animationStart;
@end

@implementation FCBreakView

- (instancetype)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _remainingSeconds = FCBreakDuration;
        _animationStart = [NSDate timeIntervalSinceReferenceDate];
        self.wantsLayer = YES;
        self.layer.backgroundColor = [[NSColor colorWithWhite:0.0 alpha:0.42] CGColor];
        _displayTimer = [NSTimer scheduledTimerWithTimeInterval:(1.0 / 60.0)
                                                         target:self
                                                       selector:@selector(animationTick:)
                                                       userInfo:nil
                                                        repeats:YES];
    }
    return self;
}

- (void)dealloc {
    [_displayTimer invalidate];
}

- (void)animationTick:(NSTimer *)timer {
    (void)timer;
    [self setNeedsDisplay:YES];
}

- (void)setRemainingSeconds:(NSInteger)remainingSeconds {
    _remainingSeconds = remainingSeconds;
    [self setNeedsDisplay:YES];
}

- (NSView *)hitTest:(NSPoint)point {
    (void)point;
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    NSTimeInterval time = [NSDate timeIntervalSinceReferenceDate] - self.animationStart;
    [self drawMessage];
    [self drawCatAt:[self catPositionForTime:time] phase:time];
}

- (NSPoint)catPositionForTime:(NSTimeInterval)time {
    CGFloat travelWidth = NSWidth(self.bounds) + 320.0;
    CGFloat x = fmod(time * 125.0, travelWidth) - 160.0;
    CGFloat baseY = MAX(90.0, NSHeight(self.bounds) * 0.25);
    return NSMakePoint(x, baseY + sin(time * 7.0) * 5.0);
}

- (void)drawMessage {
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.alignment = NSTextAlignmentCenter;
    NSDictionary *titleAttributes = @{
        NSFontAttributeName: [NSFont systemFontOfSize:36.0 weight:NSFontWeightBold],
        NSForegroundColorAttributeName: NSColor.whiteColor,
        NSParagraphStyleAttributeName: paragraph
    };
    NSDictionary *countdownAttributes = @{
        NSFontAttributeName: [NSFont monospacedDigitSystemFontOfSize:20.0 weight:NSFontWeightMedium],
        NSForegroundColorAttributeName: [NSColor colorWithWhite:1.0 alpha:0.86],
        NSParagraphStyleAttributeName: paragraph
    };
    NSString *countdown = [NSString stringWithFormat:@"胖猫将在 %ld 秒后让路", (long)self.remainingSeconds];
    [@"休息一下，看看远处" drawInRect:NSMakeRect(20.0, NSMidY(self.bounds) + 34.0,
                                                   NSWidth(self.bounds) - 40.0, 50.0)
                              withAttributes:titleAttributes];
    [countdown drawInRect:NSMakeRect(20.0, NSMidY(self.bounds) - 6.0,
                                     NSWidth(self.bounds) - 40.0, 34.0)
            withAttributes:countdownAttributes];
}

- (NSBezierPath *)triangleFrom:(NSPoint)a to:(NSPoint)b to:(NSPoint)c {
    NSBezierPath *path = [NSBezierPath bezierPath];
    [path moveToPoint:a];
    [path lineToPoint:b];
    [path lineToPoint:c];
    [path closePath];
    return path;
}

- (void)drawLegAtX:(CGFloat)x color:(NSColor *)color outline:(NSColor *)outline {
    NSBezierPath *outer = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x, 18.0, 28.0, 43.0)
                                                         xRadius:14.0 yRadius:14.0];
    [outline setFill];
    [outer fill];
    NSBezierPath *inner = [NSBezierPath bezierPathWithRoundedRect:NSMakeRect(x + 4.0, 22.0, 20.0, 35.0)
                                                         xRadius:10.0 yRadius:10.0];
    [color setFill];
    [inner fill];
}

- (void)drawWhiskersWithColor:(NSColor *)outline {
    NSBezierPath *whiskers = [NSBezierPath bezierPath];
    [whiskers moveToPoint:NSMakePoint(174, 111)]; [whiskers lineToPoint:NSMakePoint(143, 116)];
    [whiskers moveToPoint:NSMakePoint(174, 105)]; [whiskers lineToPoint:NSMakePoint(142, 101)];
    [whiskers moveToPoint:NSMakePoint(201, 111)]; [whiskers lineToPoint:NSMakePoint(232, 117)];
    [whiskers moveToPoint:NSMakePoint(201, 105)]; [whiskers lineToPoint:NSMakePoint(233, 101)];
    whiskers.lineWidth = 2.5;
    [outline setStroke];
    [whiskers stroke];
}

- (void)drawCatAt:(NSPoint)position phase:(NSTimeInterval)phase {
    [NSGraphicsContext saveGraphicsState];
    NSAffineTransform *transform = [NSAffineTransform transform];
    [transform translateXBy:position.x yBy:position.y];
    [transform concat];

    NSColor *outline = [NSColor colorWithCalibratedRed:0.18 green:0.14 blue:0.12 alpha:1.0];
    NSColor *fur = [NSColor colorWithCalibratedRed:0.94 green:0.58 blue:0.24 alpha:1.0];
    NSColor *cream = [NSColor colorWithCalibratedRed:1.0 green:0.86 blue:0.64 alpha:1.0];
    CGFloat legSwing = sin(phase * 9.0) * 9.0;

    NSBezierPath *tail = [NSBezierPath bezierPath];
    [tail moveToPoint:NSMakePoint(34, 68)];
    [tail curveToPoint:NSMakePoint(1, 112)
         controlPoint1:NSMakePoint(4, 71) controlPoint2:NSMakePoint(-12, 98)];
    [tail curveToPoint:NSMakePoint(20, 126)
         controlPoint1:NSMakePoint(6, 131) controlPoint2:NSMakePoint(15, 133)];
    tail.lineCapStyle = NSLineCapStyleRound;
    tail.lineWidth = 18.0; [outline setStroke]; [tail stroke];
    tail.lineWidth = 12.0; [fur setStroke]; [tail stroke];

    [self drawLegAtX:72.0 + legSwing color:fur outline:outline];
    [self drawLegAtX:120.0 - legSwing color:fur outline:outline];
    [self drawLegAtX:164.0 + legSwing color:fur outline:outline];

    [outline setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(30, 34, 160, 105)] fill];
    [fur setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(35, 39, 150, 95)] fill];
    [cream setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(70, 43, 92, 70)] fill];

    [outline setFill];
    [[self triangleFrom:NSMakePoint(143, 139) to:NSMakePoint(154, 180) to:NSMakePoint(174, 146)] fill];
    [[self triangleFrom:NSMakePoint(194, 146) to:NSMakePoint(216, 178) to:NSMakePoint(226, 136)] fill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(132, 83, 105, 85)] fill];
    [fur setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(137, 88, 95, 75)] fill];

    [outline setFill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(162, 127, 9, 12)] fill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(202, 127, 9, 12)] fill];
    [[NSBezierPath bezierPathWithOvalInRect:NSMakeRect(183, 111, 10, 7)] fill];
    NSBezierPath *muzzle = [NSBezierPath bezierPath];
    [muzzle moveToPoint:NSMakePoint(188, 112)];
    [muzzle curveToPoint:NSMakePoint(176, 104)
           controlPoint1:NSMakePoint(186, 106) controlPoint2:NSMakePoint(181, 103)];
    [muzzle moveToPoint:NSMakePoint(188, 112)];
    [muzzle curveToPoint:NSMakePoint(200, 104)
           controlPoint1:NSMakePoint(190, 106) controlPoint2:NSMakePoint(195, 103)];
    muzzle.lineWidth = 3.0;
    [muzzle stroke];
    [self drawWhiskersWithColor:outline];
    [NSGraphicsContext restoreGraphicsState];
}

@end

@interface FCBreakWindow : NSWindow
@property(nonatomic, strong) FCBreakView *breakView;
- (instancetype)initWithScreen:(NSScreen *)screen;
@end

@implementation FCBreakWindow

- (instancetype)initWithScreen:(NSScreen *)screen {
    self = [super initWithContentRect:screen.frame
                           styleMask:NSWindowStyleMaskBorderless
                             backing:NSBackingStoreBuffered
                               defer:NO
                              screen:screen];
    if (self) {
        _breakView = [[FCBreakView alloc] initWithFrame:NSMakeRect(0, 0, NSWidth(screen.frame), NSHeight(screen.frame))];
        [self setFrame:screen.frame display:YES];
        self.level = NSScreenSaverWindowLevel;
        self.backgroundColor = NSColor.clearColor;
        self.opaque = NO;
        self.hasShadow = NO;
        self.ignoresMouseEvents = NO;
        self.acceptsMouseMovedEvents = YES;
        self.collectionBehavior = NSWindowCollectionBehaviorCanJoinAllSpaces |
                                  NSWindowCollectionBehaviorFullScreenAuxiliary |
                                  NSWindowCollectionBehaviorStationary;
        self.contentView = _breakView;
    }
    return self;
}

- (BOOL)canBecomeKeyWindow { return YES; }
- (BOOL)canBecomeMainWindow { return YES; }

@end

@interface FCAppDelegate : NSObject <NSApplicationDelegate>
@property(nonatomic, strong) NSMutableArray<FCBreakWindow *> *windows;
@property(nonatomic, strong) NSTimer *countdownTimer;
@property(nonatomic, strong) id eventMonitor;
@property(nonatomic) NSInteger remainingSeconds;
@property(nonatomic) BOOL breakIsActive;
@property(nonatomic) NSApplicationPresentationOptions previousPresentationOptions;
@end

@implementation FCAppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    (void)notification;
    [self startBreak];
}

- (void)startBreak {
    self.breakIsActive = YES;
    self.remainingSeconds = FCBreakDuration;
    self.previousPresentationOptions = NSApp.presentationOptions;
    NSApp.presentationOptions = NSApplicationPresentationHideDock |
                                NSApplicationPresentationHideMenuBar |
                                NSApplicationPresentationDisableAppleMenu |
                                NSApplicationPresentationDisableProcessSwitching |
                                NSApplicationPresentationDisableForceQuit |
                                NSApplicationPresentationDisableSessionTermination |
                                NSApplicationPresentationDisableHideApplication;

    self.windows = [NSMutableArray array];
    for (NSScreen *screen in NSScreen.screens) {
        FCBreakWindow *window = [[FCBreakWindow alloc] initWithScreen:screen];
        [window makeKeyAndOrderFront:nil];
        [self.windows addObject:window];
    }

    self.eventMonitor = [NSEvent addLocalMonitorForEventsMatchingMask:(NSEventMaskKeyDown |
                                                                       NSEventMaskKeyUp |
                                                                       NSEventMaskFlagsChanged)
                                                            handler:^NSEvent *(NSEvent *event) {
        (void)event;
        return nil;
    }];
    [NSApp activateIgnoringOtherApps:YES];
    [self updateViews];
    self.countdownTimer = [NSTimer scheduledTimerWithTimeInterval:1.0
                                                           target:self
                                                         selector:@selector(countdownTick:)
                                                         userInfo:nil
                                                          repeats:YES];
}

- (void)countdownTick:(NSTimer *)timer {
    self.remainingSeconds = MAX(0, self.remainingSeconds - 1);
    [self updateViews];
    if (self.remainingSeconds == 0) {
        [timer invalidate];
        [self finishBreak];
    }
}

- (void)updateViews {
    for (FCBreakWindow *window in self.windows) {
        window.breakView.remainingSeconds = self.remainingSeconds;
    }
}

- (void)finishBreak {
    self.breakIsActive = NO;
    [self.countdownTimer invalidate];
    self.countdownTimer = nil;
    if (self.eventMonitor) {
        [NSEvent removeMonitor:self.eventMonitor];
        self.eventMonitor = nil;
    }
    for (FCBreakWindow *window in self.windows) {
        [window orderOut:nil];
    }
    [self.windows removeAllObjects];
    NSApp.presentationOptions = self.previousPresentationOptions;
    [NSApp terminate:nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender {
    (void)sender;
    return self.breakIsActive ? NSTerminateCancel : NSTerminateNow;
}

@end

int main(int argc, const char *argv[]) {
    (void)argc;
    (void)argv;
    @autoreleasepool {
        NSApplication *application = NSApplication.sharedApplication;
        FCAppDelegate *delegate = [[FCAppDelegate alloc] init];
        application.delegate = delegate;
        [application setActivationPolicy:NSApplicationActivationPolicyAccessory];
        [application run];
    }
    return 0;
}
