//
//  SFGraphRenderingView.m
//  CocoaBubble
//
//  Created by Kaili Hill on 6/23/15.
//  Copyright (c) 2015 Kaili Hill. All rights reserved.
//

#import "SFGraphRenderingView.h"
#import "SFNodeView.h"
#import "SFEdge.h"
#import "SFSettings.h"

@interface SFGraphRenderingView() <UIScrollViewDelegate>

@property (nonatomic) NSMutableArray* nodes;
@property (nonatomic) NSMutableArray* paths;
//@property (nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (nonatomic) UIScrollView* scrollView;
@property (nonatomic) UIButton* closeButton;
@end

@implementation SFGraphRenderingView

-(id)initWithFrame:(CGRect)frame {

    if (self = [super initWithFrame:frame]) {

        self.nodes = [[NSMutableArray alloc] init];
        self.paths = [[NSMutableArray alloc] init];

        self.backgroundColor = [UIColor whiteColor];
        //self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(moveView:)];
        //[self addGestureRecognizer:self.panGestureRecognizer];
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.delegate = self;
        self.scrollView.contentSize = CGSizeMake(10000,10000);
        [self.scrollView setContentOffset:CGPointMake(5000-self.frame.size.width/2.0f,5000-self.frame.size.height/2.0f) animated:NO];
        [self addSubview:self.scrollView];

        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.closeButton.frame = CGRectMake(8,64+8,64,32);
        [self.closeButton setTitle:@"Close" forState:UIControlStateNormal];
        [self.closeButton setTitleColor:[UIColor sf_primaryColor] forState:UIControlStateNormal];
        [self.closeButton addTarget:self action:@selector(closeButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];


        [self testScene];

    }

    return self;

}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//
//    CGContextRef context = UIGraphicsGetCurrentContext();
//
//    for (int i = 0; i < self.paths.count; i++) {
//        UIBezierPath *path = self.paths[i];
//        [path setLineWidth:1.0f];
//        [[UIColor blueColor] setFill];
//        [[UIColor blueColor] setStroke];
//    }
//
//}

-(void)testScene {



    CGFloat xAxisTransform = self.scrollView.contentSize.width / 2.0f;
    CGFloat yAxisTransform = self.scrollView.contentSize.height / 2.0f;
    
    CGFloat x = 0;// + (rand() % 10);
    CGFloat y = 0;// + (rand() % 10);
    
    /*
     * 10010
     * 10c01
     * 10010
     */
    
    SFNodeView* me = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    me.center = CGPointMake(xAxisTransform, yAxisTransform);
    me.backgroundColor = [UIColor blueColor];
    me.clipsToBounds = NO;

    y = -64 + (rand()%25);
    x = -64 - (rand()%25);

    SFNodeView* node = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node];

    y = -64 + (rand()%25);
    x = 64 + (rand()%25);

    SFNodeView* node2 = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node2.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node2];

    y = 0 + (rand()%25);
    x = -64 - (rand()%25);

    SFNodeView* node3 = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node3.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node3];

    y = 0 + (rand()%25);
    x = 128 + (rand()%25);

    SFNodeView* node4 = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node4.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node4];

    y = 64 + (rand()%15);
    x = -64 + (rand()%15);

    SFNodeView* node5 = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node5.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node5];

    y = 64 + (rand()%15);
    x = 64 + (rand()%15);

    SFNodeView* node6 = [[SFNodeView alloc] initWithFrame:CGRectMake(0,0,32,32)];
    node6.center = CGPointMake(me.center.x + x, me.center.y + y);
    [me createEdge:node6];

    [self.nodes addObject:node];
    [self.nodes addObject:node2];
    [self.nodes addObject:node3];
    [self.nodes addObject:node4];
    [self.nodes addObject:node5];
    [self.nodes addObject:node6];

    for(SFEdge* edge in me.edges) {
        UIBezierPath *path = [UIBezierPath bezierPath];

        CGPoint transformOrigin = CGPointMake(edge.origin.center.x-xAxisTransform+16.0f, edge.origin.center.y-yAxisTransform+16.0f);
        CGPoint transformDestination = CGPointMake(edge.destination.center.x-xAxisTransform+16.0f, edge.destination.center.y-yAxisTransform+16.0f);

        [path moveToPoint:transformOrigin];
        [path addLineToPoint:transformDestination];
        [path setLineWidth:1.0f];
        CAShapeLayer* line = [CAShapeLayer layer];
        //line.frame = self.frame;
        line.strokeColor = [UIColor blueColor].CGColor;
        line.lineWidth = 1.0f;
        line.path = path.CGPath;
        line.opacity = 1.0;

        [me.layer addSublayer:line];
        [self.paths addObject:path];
    }

    // No idea what to do with the graph data
    // Create paths for each of the edges???
    [self.scrollView addSubview:me];
    [self.scrollView addSubview:node];
    [self.scrollView addSubview:node2];
    [self.scrollView addSubview:node3];
    [self.scrollView addSubview:node4];
    [self.scrollView addSubview:node5];
    [self.scrollView addSubview:node6];

}

/*
-(void)moveView:(UIPanGestureRecognizer *)recognizer {

    CGPoint translation = [recognizer translationInView:recognizer.view];
    CGPoint velocity = [recognizer velocityInView:recognizer.view];

    if (recognizer.state == UIGestureRecognizerStateBegan) {
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGRect next = recognizer.view.frame;
        next.origin.x = next.origin.x + translation.x;
        next.origin.y = next.origin.y + translation.y;
        recognizer.view.frame = next;
        //CGFloat a = 1.0f - (fabs(next.origin.x) / recognizer.view.frame.size.width);
        //recognizer.view.alpha = a;
        [recognizer setTranslation:CGPointMake(0, 0) inView:self];

    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    }

}
*/

-(void)closeButtonTapped:(id)sender {

    [UIView animateWithDuration:.35f delay:0 usingSpringWithDamping:.8f initialSpringVelocity:0 options:0 animations:^{
        self.alpha =0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];

}

@end
