//
//  RegisterProtocolController.m
//  ZFAB
//
//  Created by 徐宝桥 on 15/5/16.
//  Copyright (c) 2015年 ___MyCompanyName___. All rights reserved.
//

#import "RegisterProtocolController.h"

@interface RegisterProtocolController ()

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation RegisterProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"华尔街金融平台用户使用协议";
    [self initAndLayoutUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UI

- (void)initAndLayoutUI {
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.backgroundColor = kColor(244, 243, 243, 1);
    _scrollView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:_scrollView];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeTop
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTop
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1.0
                                                           constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_scrollView
                                                          attribute:NSLayoutAttributeBottom
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeBottom
                                                         multiplier:1.0
                                                           constant:0]];
    NSString *protocolString = @"\n     华尔街金融平台用户使用协议（下称\"协议\"）是您与上海掌富网络技术有限公司（下称\"我们\"）之间的协议。您对本公司互联网站www.ebank007.com （下称\"本网站\"）的所有使用，包括但不限于对本网站的访问、加入本网站各论坛，或参加本网站上的其他竞赛、浏览本网站的内容等，代表您同意了本协议下的所有条款及声明。\n\
    \n\
    您同意在使用本网站前认真阅读本协议，并同意接受包含于本协议中的所有条款。\n\
    \n\
    出于安全要求，我们须监控您对本公司网站的使用，并有权因合法的原因或目的自由地使用或披露从您那里接收到或通过您对公司网站的使用而收集到的全部或部分信息。当然您的隐私将依据我们的隐私保护措施被我们完好的保护。\n\
    \n\
    我们保留依据我们自身的判断斟酌决定随时改变、修改、增加或删除本协议全部或部分条款的权利。我们会将本协议修改的通知登载于本网站上。\n\
    \n\
    依据中国的著作权法律、中国签订的国际条约及其他著作权法律的约定，我们及相关权利方独立地或共同的对本网站所有内容（包括但不限于文 字、图片、音 频、视频资料及页面设计、编排、软件等）拥有完整的著作权，且该著作权受到法律保护，未经我们及/或相关权利方的书面许可，您不能以任何方式单独、与他人 共同或授权他人、协助他人复制、转载或其他方式的使用前述内容。\n\
    \n\
    \"华尔街金融\"相关权利方授权公司在本网站上使用。您不能在没有我们或相关授权方书面许可的情况下以任何方式使用或与他人共同使用或授权、协助他 人使用商标标识或名称，或使用、授权他人使用（包括申请注册）与该商标、标识、名称相近或类似或可能产生混淆的其他商标、标识、或名称。本条款适用本网站 上包含的其他商标、标识。\n\
    \n\
    为了保护您及我们与相关方的合法权益。本网站中的所有内容及题材（下称\"内容\"）请保证仅为您个人的、非商业的目的而使用。所有本网站包 含的内容均 受著作权保护并由我们及/或我们的关联公司、合作方所有，或经所有权方授权我们使用。请您同时遵守所有包含于本网站的任一内容中关于著作权的其它通知、信 息或限制的规定。只有您认可本网站内容著作权的归属及应被保护，且您承诺将保护那些著作权，并遵守包本网站关于著作权的其它所有通知后，您方可以仅以您个人的、非商业的使用为目的而下载或复制本公司网站上显示的内容及其他可下载的项目。在未获得我们及/或我们的关联公司及/或相关权利方的事先书面同意的情 况下，凡是以非个人且非商业的其他任何目的而对本网站内容的任何形式的复制或使用、存储行为，在此都是被明确禁止的；如您确有前述被禁止的行为，我们及关 联公司或相关权利方有权向您主张权利。\n\
    \n\
    我们将尽一切努力及注意义务来确保公司网站保持高标准及延续地为您提供服务。但互联网的自身特性决定了它并不是一个具有稳定性的媒体，错误、遗漏或 服务中断及延误有可能随时发生。因此相应的，我们无法承担任何即时的、随时的义务或责任来使网站或网站的任何部分始终任何时刻都正常运营，或使本网站的服 务随时提供。鉴于此，我们可以随时变更、延期或停止所有或部分本网站的运营，包括本网站全部或部分的服务、特性、数据库或内容的可使用性。我们也可以在不 事先通知并不承担责任的情况下，更正本网站任何部分的任何错误或遗漏，或在某些特性或服务中加以限制，或限制您访问本网站的全部或部分。\n\
    \n\
    为了您及我们、相关方的合法权益，您必须保证、担保并承诺您不会向公司网站上传、登载、传输、散布或以其他任何方式公布包含以下任一题材、内容的任何资料或信息：\n\
    \n\
    限制或禁止其他用户使用或享受本网站及通过本网站提供的服务的；\n\
    非法的、危险的、辱骂性的、损害他人名誉的、淫秽的、粗俗的、有侵犯性的、色情的、亵渎的或下流的；\n\
    构成或引诱他人构成犯罪的，有可能引发任何民事责任的，或其他可能违反法律的；\n\
    侵犯、剽窃或违反包括但不限于著作权、商标权、专利权、隐私权或公共权利其他财产权利等任何合法权利的；\n\
    带有病毒或其他损坏性组成部分的；\n\
    带有商业特性的任何信息、软件或其他主题、题材、材料的；\n\
    带有任何类型广告或宣传信息的；\n\
    或构成或包含对任何源由或事实记录错误的或误导的暗示的。\n\
    \n\
    对于因您违反本协议或前述的保证、担保及承诺而导致的任何第三方的主张，您在此同意防止并保证我们及我们关联公司、合作方的管理人员、主管、所有者、代理人、职员、信息提供者、关联企业、许可人及被许可人（统称为\"受赔偿方\"）不承担任何责任或费用（包括但不限于律师费及其他费用等）；如果前述受 赔偿方已先予承担责任，则就受赔偿方已承担的责任及受赔偿方遭受的其他损失，您将对受赔偿方承担全部赔偿责任。作为本网站的使用者、访问者，为了您和我们 的共同权益，您应尽合理的最大努力与我们一起防止该损害发生。当然，在自行承担费用的前提下，对于您能够用以向我们承担赔偿责任的任何事物，我们保留采取 独家保护及控制的权利；在没有获得我们书面许可的情况下您无论何种情况都不得处置该些事物；我们对于自行承担的前述费用，有权在您的侵害被确认后依法向您追偿。\n\
    \n\
    本网站对第三方享有权利的网站的链接，并不构成我们或我们的下属公司、关联公司、合作方对该第三方资源或内容的认可。\n\
    \n\
    我们对于第三方通过本网站或网站中的论坛登载、显示或发布的任何建议、意见、陈述或其他信息（下称\"信息\"）的准确性、完整性或可靠性不承担任何保证义务。\n\
    \n\
    现有技术及客观情况决定了我们对于网站的用户在本网站上发布的内容或主题、题材、材料等各种信息无法做全部的审查。因此由用户 发布或登载 的内容或主题、题材、材料并不必然代表我们的观点，我们对这些内容和主题、题材、材料也不承担任何责任。但是，出于安全原则，虽然我们有审查的义务，但我 们仍保留在任何时候全部、或部分审查、编辑、移动、拒绝发布或移除、删除那些用户在本网站上发布的、我们认为将对本协议构成违反或侵犯的任何内容或主题、 题材、材料等各种信息的权利。我们同时保留在任何时候为了符合法律、法规或政府要求的目的而揭露该些信息的权利。\n\
    \n\
    请您知道，本网站，包括所有本网站上可用的或通过本网站可访问的内容、服务、特性、软件、功能、材料及信息，均是以现状方式提供的。在合 法的范围 内，我们及我们的下属公司、关联公司、合作方对于本网站上的任何内容、服务及特性，或对于本网站上使用的或通过本网站可访问的任何软件所提供的用于完成对 任何第三方的产品或服务或超文本链接访问的任何信息、功能，或因任何通过本网站或任何其他相链接网站传输敏感信息所带来的对安全原则的违反，均不承担任何 形式的保证或担保责任。同时，我们及我们的下属公司及关联企业、合作方拒绝对本网站无法预料或无法具备的特性，如非侵害性、特殊商业能力或符合特殊用途 等，承担明示或暗示的任何保证责任。我们无法保证本网站上的功能或包含在本网站上的任何内容、服务或特性从不间断或从不发生错误，我们也无法保证该错误能 够随时被更正，我们也不保证本网站或使本网站得以运营的服务器不受病毒或其他有害因素的感染。我们及我们的下属公司及关联企业、合作方对于本网站的使用价 值，包括但不限于对材料、内容、服务及其它特性的使用价值，及对于本网站所包含的错误均不承担任何责任。\n\
    \n\
    由于互联网络自身具有的公开特性，对于通过向本网站登载消息、上载文件、插入数据或从事其他形式的任何沟通（下称\"通讯\"），您在本网站 上为上述通 讯行为即代表您授予了我们及我们的下属公司、关联企业、合作方对该通讯在现在已存在的所有媒体或后续发展出现的任何媒体中永久的、全世界范围的、不可撤销 的、无限制的、非排他的、免许可使用费的许可使用、复制、授权许可、分许可、改编、翻译、发布、展示、公开演出、复制、传播、修改、编辑及以其他合理合法 方式使用的权利，鉴于此，就任何财产权、隐私权、发表权、道德权及其它起因于该通讯的任何权利的侵权责任，您在此均放弃向我们及/或我们下属公司、关联公 司、合作方以声称的或实际的任何方式主张。\n\
    \n\
    在此请您知道，基于现有的技术、客观情况及互联网自身的公开特性，即使我们尽了最大的注意义务及努力，从本网站的或对本网站的传输仍不能 保证完全被 保密，您的任何通讯都可能被其他方阅读或中途截取。您也在此确认，对于通过本网站的通讯的行为及向我们提供信息的行为，除了遵守本协议外，您与我们之间不 再存在任何保密的、受托的、合同隐含的某种含义的或其他的关系。\n\
    \n\
    本协议受中国法律管辖并依据中国法律解释，且不适用冲突规范。因履行本协议或与本协议相关的任何诉讼或法律程序应由我们法定地址所在地法院管辖。\n\
    \n\
    在使用本网站过程中，如果您遇到任何您认为侵犯了您权利的内容、主题、题材、或信息（下称\"材料\"），您可以立即向我们及该材料的上传方 或发布方发 出声明侵权的书面通知，该通知应包含足够的具体细节以使我们能够据以查找到该上传或发布情况。在我们调查结束前您可以要求上传方、发布方移除该材料。您应 该依据法律法规的规定同时在侵权通知中向公司提供您据以主张的证据、您的权利来源、您的姓名或名称、身份证明、您的地址、联系方式及主张的真实性承诺。根 据您的通知，该上传方或发布方可以向我们书面提出对于您侵权通知的抗辩。根据收到的您的证据信息，我们将开始着手调查。在调查期间，我们可以暂时移除该争 议材料或采取措施拒绝网站用户对该争议材料的访问，来保护相关的所有权利。如果我们判断您的主张合法，我们将继续拒绝网站用户对该争议材料的访问；如果我 们判断您的主张不成立，我们将恢复对该争议材料的访问。根据本条款您可以发送电子邮件至以下地址来对我们发出声明侵权的书面通 知：ebank007@epalmpay.cn\n\
    \n\
    本协议构成您与我们之间就您使用本网站事宜的全部协议。您就使用本网站产生的争议而采取的任何主张或法律诉讼及其他法律措施须在该争议发生之日起两年内提出。如果因任何原因，任一有合法管辖权的法院裁决本协议的任何条款或本协议部分没有强制执行力，该条款或部分应由您和我们在合法的最大范围内执行， 以尽可能达到本协议目的；同时本协议其余部分或其余条款应继续有效且严格被执行。\n\
    \n\
    我们对于任何第三方通过本网站链接提供的任何资料及其中包含的内容不承担任何责任。";
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:protocolString];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:5.f];
    [paragraphStyle setFirstLineHeadIndent:10.f];
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              [UIFont systemFontOfSize:15.f],NSFontAttributeName,
                              paragraphStyle,NSParagraphStyleAttributeName,
                              nil];
    [attrString setAttributes:attrDict range:NSMakeRange(0, protocolString.length)];
    CGRect rect = [attrString boundingRectWithSize:CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, kScreenWidth - 40, rect.size.height + 1)];
    contentLabel.backgroundColor = [UIColor clearColor];
    contentLabel.numberOfLines = 0;
    contentLabel.attributedText = attrString;
    [_scrollView addSubview:contentLabel];
    _scrollView.contentSize = CGSizeMake(kScreenWidth, rect.size.height + 20);
}

@end
