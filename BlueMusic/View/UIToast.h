#import <UIKit/UIKit.h>
#define TOAST_BOUNDS CGSizeMake(30, 15);

typedef enum{
	TOAST_LENGTH_SHORT,//约展示3s
	TOAST_LENGTH_LONG,//约展示6s
}TOAST_LENGTH;

typedef enum{
	TOAST_GRAVITY_UP,
	TOAST_GRAVITY_CENTURE,
	TOAST_GRAVITY_DOWN,
}TOAST_GRAVITY;//toast在屏幕中的大概位置

@interface UIToast : UIView {
	UIView *animationView;
	NSInteger animation;
	TOAST_LENGTH m_length;
	TOAST_GRAVITY m_gravity;
}

//初始化方法
-(id)init;

//显示配置后的toast
-(void)show:(NSString*)content Gravity:(TOAST_GRAVITY)gravity Length:(TOAST_LENGTH)length;

//快速显示toast
-(void)show:(NSString*)content;

//在屏幕中动画弹出一个iew,gravity取值范围0~1.0,建议数值0.7
-(void)showView:(UIView*)smallView WithGravity:(CGFloat)gravity Length:(TOAST_LENGTH)length;
@end
