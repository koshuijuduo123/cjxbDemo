//
//  WeatherView.m
//  CJXBiOSdemo
//
//  Created by AceBlack on 16/10/31.
//  Copyright © 2016年 wang. All rights reserved.
//

#import "WeatherView.h"
#import "AFNetworking.h"


@implementation WeatherView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        //从xib中找到我们定义的view
        NSArray *viewArray = [[NSBundle mainBundle]loadNibNamed:@"WeatherView" owner:self options:nil];
        self = viewArray[0];
        self.frame = frame;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            [self loadView];
            
        });

        
        
    }
    
    return self;
    
}

//加载天气数据
-(void)loadView{
   
    
    
    
    
    
   NSURL *URL =[NSURL URLWithString:@"http://api.k780.com:88/?app=weather.today&weaid=101180301&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json"];
   
    
    
    NSError *error;
    NSString *stringFromFileAtURL = [[NSString alloc]
                                     initWithContentsOfURL:URL
                                     encoding:NSUTF8StringEncoding
                                     error:&error];
    
    
       
    
    NSString *strTempL;
    NSString *strTempH;
    NSString *strWeather;
    NSString *fileName=@"晴.png";
    NSString *strWind;
    if (stringFromFileAtURL !=nil) {
        NSArray *strarray = [stringFromFileAtURL componentsSeparatedByString:@"\""];
        
        for(int i=0;i<strarray.count;i++)
        {
            
            NSString *str = [strarray objectAtIndex:i];
            if(YES == [str isEqualToString:@"temp_high"])//最高温度
            {
                strTempH = [strarray objectAtIndex:i+2];
                
            }
            else if(YES == [str isEqualToString:@"temp_low"])//最低温度
            {
                strTempL = [strarray objectAtIndex:i+2];
            }
            else if(YES == [str isEqualToString:@"weather"])//天气
            {
                strWeather = [strarray objectAtIndex:i+2];
            }
            else if(YES == [str isEqualToString:@"wind"])//风向
            {
                strWind = [strarray objectAtIndex:i+2];
            }
            
            
            
        }
        NSString *sweather ;
        if (size_width<=350) {
        sweather = [[NSString alloc]initWithFormat:@"%@\n%@℃~%@℃",strWeather,strTempL,strTempH];
        }else{
            
            sweather = [[NSString alloc]initWithFormat:@"%@\n%@℃~%@℃ %@",strWeather,strTempL,strTempH,strWind];
        }
        
        
        if(NSNotFound != [strWeather rangeOfString:@"晴"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@",@"晴.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"多云"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"多云.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"阴"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"阴.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雨"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"中雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雪"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"小雪.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雷"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"雷雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雾"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"雾.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"大雪"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"大雪.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"大雨"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"大雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"中雪"].location)
        {
            fileName = [[NSString alloc]initWithFormat:@"%@",@"中雪.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"中雨"].location)
        {
            fileName = [[NSString alloc]initWithFormat:@"%@",@"中雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"小雪"].location)
        {
            fileName = [[NSString alloc]initWithFormat:@"%@",@"小雪.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"小雨"].location)
        {
            fileName = [[NSString alloc]initWithFormat:@"%@",@"中雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雨加雪"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"雨夹雪.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"阵雨"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"中雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"雷阵雨"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"雷阵雨.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"大雨转晴"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"大雨转晴.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"阴转晴"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"阴转晴.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"霾"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"雾.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"冰"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"冰.png"];
        }
        if(NSNotFound != [strWeather rangeOfString:@"风"].location)
        {
            fileName =[[NSString alloc]initWithFormat:@"%@", @"风.png"];
        }
        
        
        
        if(sweather !=nil)
            self.weatherText.text = sweather;

    }
    
     dispatch_async(dispatch_get_main_queue(), ^{
         self.wearherImg.image = [UIImage imageNamed:fileName];
     
     });
    
    
    
    
    
}


@end
