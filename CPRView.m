//
//  CPRView.m
//  OsiriX
//
//  Created by Joël Spaltenstein on 6/5/11.
//  Copyright 2011 OsiriX Team. All rights reserved.
//

#import "CPRView.h"
#import "CPRStraightenedView.h"
#import "CPRStretchedView.h"

@implementation CPRView

@synthesize reformationType = _reformationType;

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _straightenedView = [[CPRStraightenedView alloc] initWithFrame:[self bounds]];
        _stretchedView = [[CPRStretchedView alloc] initWithFrame:[self bounds]];

        [self addSubview:_straightenedView];
    }
    return self;
}

- (void)dealloc
{
    [_straightenedView release];
    _straightenedView = nil;
    [_stretchedView release];
    _stretchedView = nil;
    
    [super dealloc];
}

- (void)setFrame:(NSRect)frameRect
{
    [super setFrame:frameRect];
    [_straightenedView setFrame:[self bounds]];
    [_stretchedView setFrame:[self bounds]];
}

- (void)setReformationType:(CPRViewReformationType)reformationType
{
    assert(reformationType == CPRViewStraightenedReformationType || reformationType == CPRViewStretchedReformationType);
    
    if (reformationType != _reformationType) {
        if (_reformationType == CPRViewStraightenedReformationType) { // going from straightened to stretched
            [_straightenedView removeFromSuperview];
            _stretchedView.curvedPath = _straightenedView.curvedPath;
            _stretchedView.displayInfo = _straightenedView.displayInfo;
            [self addSubview:_stretchedView];
        } else {
            [_stretchedView removeFromSuperview];
            _straightenedView.curvedPath = _stretchedView.curvedPath;
            _straightenedView.displayInfo = _stretchedView.displayInfo;
            [self addSubview:_straightenedView];
        }
        _reformationType = reformationType;
    }
}

- (id)reformationView // returns the actual view that does the reformation. I expect hacky calls that do and do screen grabs and such will need this
{
    if (_reformationType == CPRViewStraightenedReformationType) {
        return _straightenedView;
    } else {
        return _stretchedView;
    }
}

- (void)waitUntilPixUpdate // returns once the refomration view's DCM pix object has been updated to reflect any changes made to the view.
{
    [[self reformationView] waitUntilPixUpdate];
}


#pragma mark DCMView-like methods

- (void)setWLWW:(float)wl :(float) ww
{
    [_straightenedView setWLWW:wl :ww];
    [_stretchedView setWLWW:wl :ww];
}

- (void)getWLWW:(float*)wl :(float*)ww
{
    [[self reformationView] getWLWW:wl :ww];
}

- (void)setCLUT:(unsigned char*)r :(unsigned char*)g :(unsigned char*)b
{
    [_straightenedView setCLUT:r :g :b];
    [_stretchedView setCLUT:r :g :b];
}

- (DCMPix *)curDCM
{
    return [[self reformationView] curDCM];
}

- (short)curImage
{
    return [[self reformationView] curImage];
}

- (void)setIndex:(short)index
{
    [_straightenedView setIndex:index];
    [_stretchedView setIndex:index];
}

-(void)setCurrentTool:(short)i
{
    [_straightenedView setCurrentTool:i];
    [_stretchedView setCurrentTool:i];
}


#pragma mark standard CPRView Methods

- (id<CPRViewDelegate>)delegate
{
    return [[self reformationView] delegate];
}

- (void)setDelegate:(id <CPRViewDelegate>)delegate
{
    _straightenedView.delegate = delegate;
    _stretchedView.delegate = delegate;
}

- (CPRVolumeData *)volumeData
{
    return [(CPRStraightenedView *)[self reformationView] volumeData]; // cast to make sure the compiler picks the right return type for the method
}

- (void)setVolumeData:(CPRVolumeData *)volumeData
{
    _straightenedView.volumeData = volumeData;
    _stretchedView.volumeData = volumeData;
}

- (CPRCurvedPath *)curvedPath
{
    return [[self reformationView] curvedPath];
}

- (void)setCurvedPath:(CPRCurvedPath *)curvedPath
{
    _straightenedView.curvedPath = curvedPath;
    _stretchedView.curvedPath = curvedPath;
}

- (CPRDisplayInfo *)displayInfo
{
    return [[self reformationView] displayInfo];
}

- (void)setDisplayInfo:(CPRDisplayInfo *)displayInfo
{
    _straightenedView.displayInfo = displayInfo;
    _stretchedView.displayInfo = displayInfo;
}

- (CPRViewClippingRangeMode)clippingRangeMode
{
    return [[self reformationView] clippingRangeMode];
}

- (void)setClippingRangeMode:(CPRViewClippingRangeMode)clippingRangeMode
{
    _straightenedView.clippingRangeMode = clippingRangeMode;
    _stretchedView.clippingRangeMode = clippingRangeMode;
}

// BOGUS implementations until the stretched CPR View can handle these
- (N3Plane)orangePlane
{
    return _straightenedView.orangePlane;
}

- (void)setOrangePlane:(N3Plane)orangePlane
{
    _straightenedView.orangePlane = orangePlane;
}

- (N3Plane)purplePlane
{
    return _straightenedView.purplePlane;
}

- (void)setPurplePlane:(N3Plane)purplePlane
{
    _straightenedView.purplePlane = purplePlane;
}

- (N3Plane)bluePlane
{
    return _straightenedView.bluePlane;
}

- (void)setBluePlane:(N3Plane)bluePlane
{
    _straightenedView.bluePlane = bluePlane;
}


- (CGFloat)orangeSlabThickness
{
    return _straightenedView.orangeSlabThickness;
}

- (void)setOrangeSlabThickness:(CGFloat)orangeSlabThickness
{
    _straightenedView.orangeSlabThickness = orangeSlabThickness;
}

- (CGFloat)purpleSlabThickness
{
    return _straightenedView.purpleSlabThickness;
}

- (void)setPurpleSlabThickness:(CGFloat)purpleSlabThickness
{
    _straightenedView.purpleSlabThickness = purpleSlabThickness;
}

- (CGFloat)blueSlabThickness
{
    return _straightenedView.blueSlabThickness;
}

- (void)setBlueSlabThickness:(CGFloat)blueSlabThickness
{
    _straightenedView.blueSlabThickness = blueSlabThickness;
}


- (NSColor *)orangePlaneColor
{
    return _straightenedView.orangePlaneColor;
}

- (void)setOrangePlaneColor:(NSColor *)orangePlaneColor
{
    _straightenedView.orangePlaneColor = orangePlaneColor;
}

- (NSColor *)purplePlaneColor
{
    return _straightenedView.purplePlaneColor;
}

- (void)setPurplePlaneColor:(NSColor *)purplePlaneColor
{
    _straightenedView.purplePlaneColor = purplePlaneColor;
}

- (NSColor *)bluePlaneColor
{
    return _straightenedView.bluePlaneColor;
}

- (void)setBluePlaneColor:(NSColor *)bluePlaneColor
{
    _straightenedView.bluePlaneColor = bluePlaneColor;
}

- (CPRVolumeData *)curvedVolumeData
{
    return [[self reformationView] curvedVolumeData];
}

- (CGFloat)generatedHeight
{
    return [[self reformationView] generatedHeight];
}

- (BOOL)displayTransverseLines
{
    return _straightenedView.displayTransverseLines;
}

- (void)setDisplayTransverseLines:(BOOL)displayTransverseLines
{
    _straightenedView.displayTransverseLines = displayTransverseLines;
}

- (BOOL)displayCrossLines
{
    return _straightenedView.displayCrossLines;
}

- (void)setDisplayCrossLines:(BOOL)displayCrossLines
{
    _straightenedView.displayCrossLines = displayCrossLines;
}

@end