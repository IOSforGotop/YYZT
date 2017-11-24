//
//  ViewController.m
//  EPostPickUpByCustomer
//
//  Created by user on 15-9-28.
//  Copyright (c) 2015年 gotop. All rights reserved.
//  Epost.list actCheck 0   pwdCheck 1  ip 2    port 3  account 4

#import "ViewController.h"
#import "SSKeychain.h"
#import "Utility.h"

#import "ViewController.h"
#import "CommonFunc.h"
#import "md5.h"
#import "SBJson.h"
#import "MenuCollectionViewController.h"
//新增

@interface ViewController () <UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate, MBProgressHUDDelegate/*, InputToolBarDelegate*/> {
    MBProgressHUD *HUD;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UISwitch *actSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *pwdSwitch;
//plist  配置ip 端口 是否记住账号密码
@property (nonatomic) NSArray *paths;
@property (nonatomic) NSString *path;
@property (nonatomic) NSString *filename;
@property (nonatomic) NSMutableArray *array;
@property (nonatomic) NSString *service;
// 账号匹配所需变量
@property (nonatomic, strong) NSArray *actArray;
@property (nonatomic) NSInteger actCount;
@property (nonatomic) NSMutableArray *matchArray;   //存放匹配到的用户的账号
@property (nonatomic) NSString *actString;






// 界面调整
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *gotopLabelTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginBtnHeight;
@property (weak, nonatomic) IBOutlet UILabel *gotopLabel;
@property (weak, nonatomic) IBOutlet UILabel *versionLabel;
@property (weak, nonatomic) IBOutlet UILabel *actSwitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdSwitchLabel;
@property (weak, nonatomic) IBOutlet UILabel *actLabel;
@property (weak, nonatomic) IBOutlet UILabel *pwdLabel;
@property (weak, nonatomic) IBOutlet UILabel *ipLabel;
@property (weak, nonatomic) IBOutlet UILabel *portLabel;
@end

@implementation ViewController



@synthesize xmlParser;               //存储解析后的数据
@synthesize soapResults;             //返回结果



#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    //将图片设置为背景图片
     [self.navigationController.navigationBar setHidden:YES];
     [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"login.png"]]];
    self.navigationController.navigationBar.translucent= NO;
    [Utility netWarm];      //网络监测
    [self initVar];
    //    [self.navigationController setTitle:@"登录"];
    //    [self checkUpdate];   //更新
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.navigationController.navigationBar setHidden:YES];
     self.tabBarController.tabBar.hidden = YES;
    [_loginBtn.layer setMasksToBounds:YES];
    [_loginBtn.layer setCornerRadius:5.0f];
    //    NSLog(@"%f", self.view.frame.size.height);
    if (self.view.frame.size.height > 480.0f && self.view.frame.size.height < 570) {
        fonsize = 15.0f;  //fonsize = 12.0f;   fonsize = 15.0f;
        [self adjustLaytout];
    } else if (self.view.frame.size.height > 568) {
        fonsize = 18.0f;   //fonsize = 15.0f;    fonsize = 18.0f;
        [self adjustLaytout];
    }
}

- (void)adjustLaytout {
    _gotopLabel.font = [UIFont systemFontOfSize:18.0f];
    _versionLabel.font = [UIFont systemFontOfSize:18.0f];
    _actSwitchLabel.font = [UIFont systemFontOfSize:fonsize];
    _pwdSwitchLabel.font = [UIFont systemFontOfSize:fonsize];
    _actLabel.font = [UIFont systemFontOfSize:fonsize];
    _accountTextField.font = [UIFont systemFontOfSize:fonsize];
    _pwdLabel.font = [UIFont systemFontOfSize:fonsize];
    _pwdTextField.font = [UIFont systemFontOfSize:fonsize];
    _loginBtn.titleLabel.font = [UIFont systemFontOfSize:fonsize];
    _ipLabel.font = [UIFont systemFontOfSize:fonsize];
    _ipTextField.font = [UIFont systemFontOfSize:fonsize];
    _portLabel.font = [UIFont systemFontOfSize:fonsize];
    _portTextField.font = [UIFont systemFontOfSize:fonsize];
    _gotopLabelTop.constant = 40.0f;
    _loginBtnHeight.constant = _CONSTANT_;
    [self.view layoutIfNeeded];
}

-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:NO];
    [self.navigationController.navigationBar setHidden:NO];
}
- (IBAction)netSetting:(id)sender {
    UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"netSetting"];
    
    [self.navigationController pushViewController:vc animated:NO];
}
- (IBAction)backLogin:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:NO];
}


- (void)checkUpdate {
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *currentVersion = [infoDic objectForKey:@"CFBundleVersion"];
 //   NSLog(@"%@", currentVersion);
    
    NSString *URL = @"http://itunes.apple.com/lookup?id=你的应用程序的ID";
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:[NSURL URLWithString:URL]];
    [request setHTTPMethod:@"POST"];
    
    NSHTTPURLResponse *urlResponse = nil;
    NSError *error = nil;
    NSData *recervedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
    
    NSString *results = [[NSString alloc] initWithBytes:[recervedData bytes] length:[recervedData length] encoding:NSUTF8StringEncoding];
    NSDictionary *dic = [results JSONValue];
    NSArray *infoArray = [dic objectForKey:@"results"];
    
    if ([infoArray count]) {
        NSDictionary *releaseInfo = [infoArray objectAtIndex:0];
        NSString *lastVersion = [releaseInfo objectForKey:@"version"];
        
        if (![lastVersion isEqualToString:currentVersion]) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"有新的版本更新，是否前往更新？" delegate:self cancelButtonTitle:@"关闭" otherButtonTitles:@"更新", nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"更新" message:@"此版本为最新版本" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSURL *url = [NSURL URLWithString:@"https://itunes.apple.com"];
        [[UIApplication sharedApplication]openURL:url];
    }
}

- (void)initVar{
    
    
    self.ipTextField.delegate=self;
    self.portTextField.delegate=self;//将ip 和 端口号 的键盘设置可以关闭
    
    gKey = @"A801C860DD05418F";
    self.service = @"com.gotop.epost";
    //显示几个匹配到到账号
    self.matchArray = [[NSMutableArray alloc]initWithObjects:@"", @"", @"", @"", @"",nil];
    self.actString = @"";
    [self.tableView setHidden:YES];
    [self plistInit];
    
    HUD = [[MBProgressHUD alloc]initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.delegate = self;
    HUD.labelText = @"登录中";
    HUD.square = YES;
  }


- (IBAction)login:(id)sender {
    
    
    if((![_accountTextField.text isEqualToString:@""]) && (![_pwdTextField.text isEqualToString:@""])){
        
        
        if ([Utility netState])
        {
            HUD.labelText = @"登录中";
            [HUD show:YES];
    
    NSDictionary *dic = [[NSDictionary alloc]initWithObjectsAndKeys:self.accountTextField.text, @"V_JGBH", self.pwdTextField.text, @"V_PASSWORD", nil];
   // NSLog(@"444[111%@]\n",dic);
  //  NSLog(@"555[111%@]\n",dic.JSONString);
    
    NSString *decodering1 =[CommonFunc base64StringFromText:dic.JSONString];
  //  NSLog(@"1111111最终出来的密文是:[%@]\n",decodering1);
    // NSLog(@"1111111最终出来的密文是:[%@]\n",decodestring);
    
    
    
    
    
    NSString *hello =[Md5 getMd5_32Bit:decodering1];     //对拼接以后的字符串进行加密  //在这里就可以使用自己定义的类了
    
    NSString *hello2 =[hello stringByAppendingString:@"A801C860DD05418F"];//在后面拼接上字符串秘钥
    
    
    
    NSString *soapMessage = [NSString stringWithFormat:
                             @"<?xml version=\"1.0\" encoding=\"utf-8\"?>\n"
                             "<soap:Envelope xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\" xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\">"
                             "<soap:Body>\n"
                             "<%@ xmlns=\"%@\">\n"  //这里需要填入命名空间 和方法名
                             "<arg0>%@</arg0>"
                             "<arg1>%@</arg1>"
                             "</%@>"
                             "</soap:Body>\n"
                             "</soap:Envelope>",
                             //@"checkLink",
                             @"login",
                             @"http://service.search.gnzq.com",
                             decodering1,      //传入的  data
                             hello2,
                             @"login"];   //这里的方法名并不是 文档当中的方法名 而是要严格按照接口文档当中的来定义//传入的 sign
    
 //   NSLog(@"调用webserivce的字符串是:\n[%@]\n\n",soapMessage);     //这里是发送过去的所有的报文
 
    NSString *msgLength = [NSString stringWithFormat:@"%lu", (unsigned long)[soapMessage length]];
    
    
    NSString *urlstr = [NSString stringWithFormat:@"http://%@:%@/gnzqService/service/%@", [Utility ip], [Utility port], @"UserService"];
   
    NSURL *url = [NSURL URLWithString:urlstr];
    
    
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
  //  NSLog(@"调用webserivce的url是:[%@]\n,消息长度是[%@]\n",url,msgLength);
    
    
    //以下对请求信息添加属性前四句是必有的，
    [urlRequest addValue: @"text/xml; charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    [urlRequest addValue: @"http://service.search.gnzq.com" forHTTPHeaderField:@"SOAPAction"];  //此处再次设置命名空间
    //   [urlRequest addValue: @"http://tdzt.webservice.com/" forHTTPHeaderField:@"SOAPAction"];  //此处再次设置命名空间
    
    [urlRequest addValue: msgLength forHTTPHeaderField:@"Content-Length"];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody: [soapMessage dataUsingEncoding:NSUTF8StringEncoding]];  //属性设置
    
  //  NSLog(@"全部报文是:[%@]\n\n",urlRequest);
    
    
    NSURLConnection *theConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    theConnection = nil;
  
    
        }
        
        else{
            UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"无网络连接，请先设置好网络" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alter show];
        }

    }
    
    //输入警告 的语句 不用管 将警告的页面弹框出来
    else {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请重新输入账号密码" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }

    
    
}


-(void) connection:(NSURLConnection *) connection didReceiveData:(NSData *)responseData
{
    
  //  NSLog(@"url 是[%@]\n\n",connection);
    
    
    NSString * returnSoapXML = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
//    NSLog(@"返回的soap信息是：[%@]\n",returnSoapXML); //设置编码 获得返回值
    
    
    
    
   
    //开始解析xml
    xmlParser = [[NSXMLParser alloc] initWithData: responseData];
    [xmlParser setDelegate:self];
    [xmlParser setShouldResolveExternalEntities: YES];
    
    [xmlParser parse];//这里就是进行解析的函数调用
    
    
    
    
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    
  //  NSLog(@"返回的soap内容中，return值是： [%@]\n\n",string);
    
    
    
    SBJsonParser *parser2 = [[SBJsonParser alloc] init];
    NSError *error1 = nil;
    
    
    NSMutableDictionary *jsonDic4 = [parser2 objectWithString:string error:&error1];//获取根节点 只需要获取一次
    
      NSDictionary *mm =[jsonDic4 objectForKey:@"V_RESULT" ];
    NSDictionary *mm1 =[jsonDic4 objectForKey:@"V_REMARK" ];
    NSDictionary *mm2 =[jsonDic4 objectForKey:@"V_JYLSH" ];
    // NSDictionary *mm3 =[jsonDic4 objectForKey:@"N_JGSJ" ];
    
    
    NSString *nn = [NSString stringWithFormat:@"%@",mm];
    NSString *nn1 = [NSString stringWithFormat:@"%@",mm1];
    NSString *nn2 = [NSString stringWithFormat:@"%@",mm2];
    //NSString *nn3 = [NSString stringWithFormat:@"%@",mm3];   //将字典类型转换为 string 类型
    
  //  NSLog(@"111[%@]\n",nn);  //先将节点打印出来
   // NSLog(@"222[%@]\n",nn1);
 //   NSLog(@"333[%@]\n",nn2);
    // NSLog(@"[%@]\n",nn3);
    
    
    
    
    NSString *codejiexi =[CommonFunc textFromBase64String:nn1];
 //   NSLog(@"最终解析出来的密文是:[%@]\n",codejiexi);
     if([nn isEqualToString:@"F0"])
        
    {
        [HUD hide:YES];
        //  if (iSuc == 1)
        //  {
        jgbh = self.accountTextField.text;
        if (self.actSwitch.on && self.pwdSwitch.on) {
            [SSKeychain setPassword:self.pwdTextField.text forService:self.service account:self.accountTextField.text];
        } else if(self.actSwitch.on){
            [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        }
        else if(!self.actSwitch.on){   // 不记住账号
            [SSKeychain deletePasswordForService:self.service account:self.accountTextField.text];
        }
        [_array replaceObjectAtIndex:4 withObject:self.accountTextField.text];
        [_array writeToFile:_filename  atomically:YES];
       // UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
       // UIViewController *vc = [sb instantiateViewControllerWithIdentifier:@"menu"];
        
       // [self.navigationController pushViewController:vc animated:NO];
//================================================================================
        //获取故事板
        UIStoryboard *sb =  [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        UITabBarController *tb = [sb instantiateViewControllerWithIdentifier:@"tab"];

        [self presentViewController:tb animated:NO completion:^{}];
        
        
        // CollectionViewController *cv = [CollectionViewController new];
        // [self presentViewController:cv animated:NO completion:^{}];
         //[self.navigationController pushViewController:cv animated:NO];
        
        //自定义解析报文  获取操作员工号
        SBJsonParser *loginparser2 = [[SBJsonParser alloc] init];
        NSError *loginerror2 = nil;
        NSMutableDictionary *loginjsonDic2 = [loginparser2 objectWithString:codejiexi error:&loginerror2];//获取根节点 只需要获取一次
        NSDictionary *loginmm23 =[loginjsonDic2 objectForKey:@"CZYID" ];
        czygh = [NSString stringWithFormat:@"%@",loginmm23];
   //     NSLog(@"czyid[%@]",czygh);  //这里是获取操作员工号
        
        NSDictionary *loginmm24 =[loginjsonDic2 objectForKey:@"SFDM" ];
        sfdm = [NSString stringWithFormat:@"%@",loginmm24];
   //     NSLog(@"sfdm[%@]",sfdm);  //这里是获取省份代码
        
        
        
        
    }
    //else if(!iSuc)
    else{
        [HUD hide:YES];
        [SSKeychain setPassword:@"" forService:self.service account:self.accountTextField.text];
        self.pwdTextField.text = @"";
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:codejiexi delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
}


//}












//////////////////////////////////////////////////////


- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD was hidded
    [HUD removeFromSuperview];
}

#pragma mark -  配置ip 端口 是否记住账号密码
// 配置文件
-(void)plistInit{
    
    _paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    _path=[_paths    objectAtIndex:0];
    _filename=[_path stringByAppendingPathComponent:[[NSString alloc]initWithCString:_PLISTFILE_ encoding:NSUTF8StringEncoding]];    _array=[[NSMutableArray alloc] initWithContentsOfFile:_filename];
    
    if([_array count] == 5){
        if ([[self.array objectAtIndex:0] isEqual:@"True"]) {
            self.actSwitch.on = YES;
        } else {
            self.actSwitch.on = NO;
            [self.accountTextField setText:@""];
        }
        if ([[self.array objectAtIndex:1] isEqual:@"True"]) {
            self.actSwitch.on = YES;
            self.pwdSwitch.on = YES;
        } else {
            self.pwdSwitch.on = NO;
        }
        gIP = [_array objectAtIndex:2];
        gPort = [_array objectAtIndex:3];
        _ipTextField.text = gIP;
        _portTextField.text = gPort;
        if (![[self.array objectAtIndex:4] isEqualToString:@""] && self.actSwitch.on) {   //如果获取到了 就保存进去
            self.accountTextField.text = [self.array objectAtIndex:4];
            self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
        }
    }
    else{
        _array=[[NSMutableArray alloc]init];
        [_array addObject:@"False"];
        [_array addObject:@"False"];
        
        //[_array addObject:@"211.156.198.83"];
        [_array addObject:@"211.156.200.95"];
        
        //[_array addObject:@"8019"];
        [_array addObject:@"8082"];
        
      
        
        [_array addObject:@""];
        
        //self.ipTextField.text = @"211.156.198.83";
        self.ipTextField.text = @"211.156.200.95";
        
        //self.portTextField.text = @"8019";
        self.portTextField.text = @"8082";
        
        [_array writeToFile:_filename  atomically:YES];
    }
    
   }



//保存ip和端口号
- (IBAction)saveSetting:(id)sender {
    
    _paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);
    _path=[_paths    objectAtIndex:0];
    _filename=[_path stringByAppendingPathComponent:[[NSString alloc]initWithCString:_PLISTFILE_ encoding:NSUTF8StringEncoding]];    _array=[[NSMutableArray alloc] initWithContentsOfFile:_filename];
    
    
    if([_ipTextField.text isEqual:@""] || [_portTextField.text isEqual:@""]){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"请将ip和端口号填完整" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    else if([self checkIp] == false){
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"警告" message:@"ip格式不正确" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alter show];
    }
    else{
        [_array replaceObjectAtIndex:2 withObject:_ipTextField.text];
        gIP = _ipTextField.text;
        [_array replaceObjectAtIndex:3 withObject:_portTextField.text];
        gPort = _portTextField.text;
        [_array writeToFile:_filename  atomically:YES];
        
               [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    }
}

//是否记住账户
- (IBAction)actCheck:(id)sender {
    if (self.actSwitch.on) {
        [self.array  replaceObjectAtIndex:0 withObject:@"True"];  //记住账户
    } else {
        [self.array  replaceObjectAtIndex:0 withObject:@"False"];  //不记住账户
        [self.array replaceObjectAtIndex:1 withObject:@"False"];   //不记住密码
        self.pwdSwitch.on = NO;                                    //密码控件  也随之关闭
    }
    [_array writeToFile:_filename  atomically:YES];               //实时写入
}

//是否记住密码
- (IBAction)pwdCheck:(id)sender {
    if (self.pwdSwitch.on) {
        [self.array  replaceObjectAtIndex:0 withObject:@"True"];   //账户也记住
        [self.array  replaceObjectAtIndex:1 withObject:@"True"];   //密码也记住
        self.actSwitch.on = YES;                                   //账户随之打开
    } else {
        [self.array  replaceObjectAtIndex:1 withObject:@"False"];  //密码标志位 关闭
    }
    [_array writeToFile:_filename  atomically:YES];
}


#pragma mark - textField Delegate
//有多少个用户
-(void)textFieldDidBeginEditing:(UITextField *)textField{
   
    
     if((textField != self.ipTextField)&&(textField != self.portTextField)){
    
    if (!textField.secureTextEntry) {
        self.actArray = [SSKeychain allAccounts];
        self.actCount = self.actArray.count;
    }
    CGRect rect = self.view.frame;
    if (rect.origin.y >= 0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y - 150, rect.size.width, rect.size.height);
    }
    }
    
     else if ((textField == self.ipTextField)||(textField == self.portTextField)){
     
       //  NSLog(@"haha");
     }
    
}


//匹配用户
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (!textField.secureTextEntry) {
        _pwdTextField.text = @"";
        
        NSString *account = (NSMutableString *)textField.text;
        account = [account stringByAppendingString:string];
        self.actString = account;
        if ([string isEqual:@""]) {
            account = [account substringToIndex:account.length-1];
        }
        self.actString = account;
        
        [self.tableView reloadData];
    }
    return YES;
}

//收起键盘
-(BOOL)textFieldShouldReturn:(UITextField*)textField{
    
    if((textField != self.ipTextField)&&(textField != self.portTextField)){
    [textField resignFirstResponder];
    [self.tableView setHidden:YES];
    if (textField.secureTextEntry && textField != self.pwdTextField) {
        self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
    }
    
    CGRect rect = self.view.frame;
    if (rect.origin.y <=0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 150, rect.size.width, rect.size.height);
    }
    }
    
    else if((textField == self.ipTextField)||(textField == self.portTextField)){
    
    [textField resignFirstResponder];
    
    
    }
   
    return YES;
}

#pragma mark - UITableView Datasource

//返回一组多少行
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger count = 0;
    if(!self.actArray){
        return 0;
    }
    
       for (int i = 0, j = 0; i < self.actCount && count < self.matchArray.count; i++) {
        NSString *act = [self.actArray[i] valueForKey:@"acct"];
        if([act rangeOfString:self.actString].location == 0){
            count++;
            [self.matchArray replaceObjectAtIndex:j++ withObject:act];  //matchArray 存放账户
        }
    }
    if (count == 0) {
        [self.tableView setHidden:YES];
    } else {
        [self.tableView setHidden:NO];
    }
    return count;
}

//返回每行的cell
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    NSString *reuseId = @"act";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:reuseId];
    }
    
   
    
    cell.textLabel.text = self.matchArray[indexPath.row];
    
    return cell;
}



//ip格式检测  这个不用管
-(BOOL)checkIp{
    NSString *ip = _ipTextField.text;
    int i = 0;
    int j = -1;
    int dot = 0;
    char c;
    int length = (int)ip.length;
    for(;i<length;){
        c = [ip characterAtIndex:i];
        if(c == '.'){
            dot++;
            if(i == 0 || i-1 == j)
                return false;
            j = i;
        }
        
        i++;
    }
    if(dot == 3 && j != i-1)
        return true;
    return false;
}




#pragma mark - tableView 代理方法

//点击的时候  从tableview 出现的匹配  自动填上密码的值
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{  //点击的时候的流程
    self.accountTextField.text = self.matchArray[indexPath.row];
    self.pwdTextField.text = [SSKeychain passwordForService:self.service account:self.accountTextField.text];
    [self.tableView setHidden:YES];
    [self.accountTextField resignFirstResponder];
    
    CGRect rect = self.view.frame;
    if (rect.origin.y <=0) {
        self.view.frame = CGRectMake(rect.origin.x, rect.origin.y + 150, rect.size.width, rect.size.height);
    }
    
}





@end

