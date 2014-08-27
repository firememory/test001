// Դ�ļ�����T2SDK.pas
// �����Ȩ���������ӹɷ����޹�˾
// ϵͳ���ƣ�HSESB
// ����˵����T2SDK��Delphi�汾�ӿڶ���
// ��    �ߣ����پ�
// ��    ע��Tab = 2
// ��    ʷ��
// 20080717 ��ʼ�汾

unit T2SDK;

interface

uses
  Classes;

const
  //ESB�������ȣ�����Ϊ�ɼ��ַ������ܰ���ʵ���ָ������ո񡢷ֺ�;
  IDENTITY_NAME_LENGTH =	32;
  //ʵ��������ռλ����
  ID_LENGTH     =          4;
  //�ڵ���ȫ��,����ʱʹ��char sName[ID_STR_LEN+1]
  ID_STR_LEN	 =  (IDENTITY_NAME_LENGTH + ID_LENGTH + 1);
  //	����ӿ�������󳤶�,����ʱʹ��char sName[PLUGINID_LENGTH+1]
  PLUGINID_LENGTH   =	256;
  //	���ʵ��������󳤶�,����ʱʹ��char sName[PLUGIN_NAME_LENGTH+1]
  PLUGIN_NAME_LENGTH  =	(PLUGINID_LENGTH+ID_LENGTH+1);
  //	��������󳤶�.����ʱʹ��char sName[SVR_NAME_LENGTH+1]
  SVR_NAME_LENGTH    =	256;
  //	����ʵ������󳤶�.����ʱʹ��char sName[PLUGINID_NAME_LENGTH+1]
  SVRINSTANCE_NAME_LENGTH    =	(SVR_NAME_LENGTH+ID_LENGTH+1);

  INIT_RECVQ_LEN = 256;
  STEP_RECVQ_LEN = 512;



type
  // ���ýӿ�
  IConfigInterface = interface(IInterface)
    function Load(const szFileName: PChar): Integer; stdcall;
    function Save(const szFileName: PChar): Integer; stdcall;
    function GetString(const szSection, szEntry, szDefault: PChar): PChar; stdcall;
    function GetInt(const szSection, szEntry: PChar; iDefault: Integer): Integer; stdcall;
    function SetString(const szSection, szEntry, szValue: PChar): Integer; stdcall;
    function SetInt(const szSection, szEntry: PChar; iValue: Integer): Integer; stdcall;
  end;

  IConnectionInterface = interface;
  //IESBMessage = interface;

  //·����Ϣ�Ľṹ�嶨��
  pRoute_Info = ^Route_Info;
  Route_Info = record
    ospfName: array[0..ID_STR_LEN] of char;
    nbrName: array[0..ID_STR_LEN] of char;
    svrName: array[0..SVRINSTANCE_NAME_LENGTH] of char;
    pluginID: array[0..PLUGIN_NAME_LENGTH] of char;
    connectID: Integer;
    memberNO: Integer;
  end;


  //Ϊ�˷��ͺͷ��ض���������Ϣ�����ӵĽṹ��Ķ���
  pREQ_DATA = ^TREQ_DATA;
  TREQ_DATA = record
    sequeceNo: Integer;
    issueType: Integer;
    lpKeyInfo: Pointer;
    keyInfoLen: Integer;
    lpFileHead: Pointer;
    fileHeadLen: Integer;
    packetType: Integer;//20100111 xuxp �¼ӵİ�����
    routeInfo: Route_Info;//20110302 xuxp ������������·����Ϣ
  end;

  LPRET_DATA = ^RET_DATA;
  RET_DATA = record
    functionID: Integer;
    returnCode: Integer;
    errorNo: Integer;
    errorInfo: PChar;
    issueType: Integer;
     lpKeyInfo: Pointer;
    keyInfoLen: Integer;
    sendInfo: Route_Info ;//20110302 xuxp Ӧ���������ӷ�������Ϣ
end;

  //Ϊ�˷��ͺͷ��ض���������Ϣ�����ӵĽṹ��Ķ���
  LPREQ_DATA = ^REQ_DATA;
  REQ_DATA = record
    sequeceNo: Integer;
    issueType: Integer;
    lpKeyInfo: Pointer;
    keyInfoLen: Integer;
    lpFileHead: Pointer;
    fileHeadLen: Integer;
    packetType: Integer;//20100111 xuxp �¼ӵİ�����
    routeInfo: Route_Info ;//20110302 xuxp ������������·����Ϣ
  end;



  // �ص��ӿ�
  ICallbackInterface = interface(IInterface)
    procedure OnConnect(Connection: IConnectionInterface); stdcall;
    procedure OnSafeConnect(Connection: IConnectionInterface); stdcall;
    procedure OnRegister(Connection: IConnectionInterface); stdcall;
    procedure OnClose(Connection: IConnectionInterface); stdcall;
    procedure OnSent(Connection: IConnectionInterface; hSend: Integer; const lpData: Pointer; nLength: Integer; nQueuingData: Integer); stdcall;
    procedure OnReceiveNotify(Connection: IConnectionInterface; hSend: Integer; const lpData: Pointer; nLength: Integer); stdcall;
    procedure OnReceived(Connection: IConnectionInterface; hSend: Integer; const lpData: Pointer; nLength: Integer); stdcall;
    function OnBulkReceiveStart(Connection: IConnectionInterface; uiLength: Longword; const szComment: PChar; szFileName: PChar; var uiPieceSize: Longword; var iBulkReceiveID: Integer): Integer; stdcall;
    procedure OnBulkReceivePiece(Connection: IConnectionInterface; iBulkReceiveID: Integer; uiLength, uiReceivedLength: Longword); stdcall;
    procedure OnBulkReceiveEnd(Connection: IConnectionInterface; iBulkReceiveID: Integer; const lpData: Pointer; uiLength: Longword); stdcall;
    procedure OnBulkSendPiece(Connection: IConnectionInterface; iBulkSendID: Integer; uiLength, uiSentLength: Longword); stdcall;
    procedure OnBulkSendEnd(Connection: IConnectionInterface; iBulkSendID: Integer; iError: Integer); stdcall;
    procedure OnReceivedBiz(Connection: IConnectionInterface; hSend: Integer; const lpUnPackerOrStr: Pointer; iResult: Integer); stdcall;
    procedure OnReceivedBizEx(Connection: IConnectionInterface; hSend: Integer; lpRetData: LPRET_DATA; const lpUnPackerOrStr: Pointer; iResult: Integer); stdcall;
    procedure OnReceivedBizMsg(Connection: IConnectionInterface; hSend: Integer; lpMsg:Pointer); stdcall;
  end;

  // ����״̬
  TConnectionStatus = (
		Disconnected    = $0000,  // δ����
		Connecting      = $0001,  // socket��������
		Connected       = $0002,  // socket������
		SafeConnecting  = $0004,  // ���ڽ�����ȫ����
		SafeConnected   = $0008,  // �ѽ�����ȫ����
		Registering     = $0010,  // ��ע��
		Registered      = $0020,  // ��ע��
		Rejected        = $0040   // ���ܾ��������ر�
  );

  // ���ͱ�־
  TSendFlag = (
    ReplyCallback = $0001,  // ͨ���ص�ȡӦ��
    IsESBMessage  = $0100,  // ����һ��ESBMessage����ʱSend�����ĵ�һ������ΪESBMessage�ĵ�ַ���ڶ�����������
    ThroughLine   = $0200,  // ���������PacketID����buffer�Դ���PacketIDΪ�˴η��͵�PacketID
    ThirdParty    = $0400   // ͨ���ص�ȡӦ�𣨵�����ר�ã�
  );
  
  // ����ѡ�����ϣ�0��ʾ���ճ�ʱʱ����ɾ����ID���Կ��ٴε���Receive���������Խ��գ�
  TRecvFlags = (
    JustRemoveHandle = $0001  // �����ճ�ʱʱ����packet_idɾ�����Ժ����յ���������첽�ķ�ʽ�յ�����ע�⣬�˲�������Receive�����д��ݣ������Ҫ�Ļ���
  );

  
  IBizMessage = interface(IInterface)
	//���ù��ܺ�
	procedure SetFunction(const nFUnctionNo : Integer ); stdcall;
	//��ȡ���ܺ�
	function GetFunction():Integer; stdcall;

	//���ð�����
	procedure SetPacketType(const nPacketType : Integer); stdcall;
	//��ȡ������
	function GetPacketType():Integer; stdcall;

	//����Ӫҵ����
	procedure SetBranchNo(const nBranchNo : Integer); stdcall;
	//��ȡӪҵ����
	function GetBranchNo():Integer; stdcall;

	//����ϵͳ��
	procedure SetSystemNo(const nSystemNo : Integer); stdcall;
	//��ȡϵͳ��
	function GetSystemNo():Integer; stdcall;

	//������ϵͳ��
	procedure SetSubSystemNo(const nSubSystemNo : Integer); stdcall;
	//��ȡ��ϵͳ��
	function GetSubSystemNo():Integer; stdcall;

	//���÷����߱��
	procedure SetSenderId(const nSenderId : Integer); stdcall;
	//��ȡ�����߱��
	function GetSenderId() :Integer; stdcall;

	//���ð����
	procedure SetPacketId(const nPacketId : Integer); stdcall;
	//��ȡ�����
	function GetPacketId():Integer; stdcall;

	//����Ŀ�ĵ�·��
	procedure SetTargetInfo(const targetInfo : Route_Info); stdcall;
	//��ȡĿ�ĵ�·��
	procedure GetTargetInfo(var targetInfo : Route_Info) ; stdcall;
	
	//���÷�����·��
	procedure SetSendInfo(const sendInfo : Route_Info); stdcall;
	//��ȡ������·��
	procedure GetSendInfo(var sendInfo : Route_Info); stdcall;

	//���ô����
	procedure SetErrorNo(const nErrorNo : Integer); stdcall;
	//��ȡ�����
	function GetErrorNo():Integer; stdcall;
	
	//���ô�����Ϣ
	procedure SetErrorInfo(const strErrorInfo : Pchar) ; stdcall;
	//��ȡ������Ϣ
	function GetErrorInfo(): Pchar; stdcall;
	
	//���÷�����
	procedure SetReturnCode(const nReturnCode : Integer); stdcall;
	//��ȡ������
	function GetReturnCode():Integer; stdcall;

	//����ҵ������
	procedure SetContent(lpContent : pointer; iLen : Integer); stdcall;
	//��ȡҵ������
	function GetContent(var iLen : Integer): Pchar; stdcall;

	//���½ӿ�������Ϣ����1.0�Ķ���
	//���ö�������
	procedure SetIssueType(const nIssueType : Integer); stdcall;
	//��ȡ��������
	function GetIssueType():Integer; stdcall;

	//�������
	procedure SetSequeceNo(const nSequeceNo : Integer); stdcall;
	//��ȡ���
	function GetSequeceNo():Integer; stdcall;

	//���ùؼ��ֶ���Ϣ
	procedure SetKeyInfo(lpKeyData: pointer; iLen : Integer); stdcall;
	//��ȡ�ؼ��ֶ���Ϣ
	function GetKeyInfo(var iLen : Integer): pointer; stdcall;

	//���ø������ݣ���������ʱԭ������
	procedure SetAppData(const lpAppdata: pointer; nAppLen : Integer); stdcall;
	//��ȡ�������ݣ���������ʱԭ������
	function GetAppData(var nAppLen : Integer): pointer; stdcall;

	//����תӦ��
	function ChangeReq2AnsMessage():Integer; stdcall;

	//��ȡ������
	function GetBuff(var nBuffLen : Integer): pointer; stdcall;
	//����������
	function SetBuff(const lpBuff : pointer; nBuffLen : Integer):Integer; stdcall;

	//�����Ϣ�ڵ��ֶΣ������´θ��á�
	procedure ReSet(); stdcall;
	
  end;
  
  //���⼶��
  ReliableLevel = (
    LEVEL_DOBEST = 0, //������Ϊ
    LEVEL_DOBEST_BYSEQ = 1, //��������
    LEVEL_MEM = 2, //�ڴ�
    LEVEL_FILE = 3, //�ļ�
    LEVEL_SYSTEM = 4 //ϵͳ
    );

 // ���������ӿ�
  CFilterInterface = interface(IInterface)
  {�����±��ȡ��������������
  /**
  * @param index ��Ӧ�Ĺ��������±�
  * @return ���ض�Ӧ���±�������������֣����򷵻�NULL��
  **/}
    function GetFilterNameByIndex(index: Integer): PChar; stdcall;

  {�����±��ȡ����������ֵ
  /**
  * @param index ��Ӧ�Ĺ��������±�
  * @return ���ض�Ӧ���±����������ֵ�����򷵻�NULL��
  **/}
    function GetFilterValueByIndex(index: Integer): PChar; stdcall;

  {���ݹ������������ֻ�ȡ����������ֵ
  /**
  * @param fileName ��Ӧ�Ĺ�����������
  * @return ���ض�Ӧ�Ĺ����������ֵ�����ֵ�����򷵻�NULL��
  **/}
    function GetFilterValue(fileName: PChar): PChar; stdcall;

  {��ȡ���������ĸ���
  /**
  * @return ���ض�Ӧ���������ĸ�����û�з���0
  **/}
    function GetCount(): Integer; stdcall;

  {���ù������������ݹ����������ֺ�ֵ
  /**
  * @param filterName ��Ӧ�Ĺ�����������
  * @param filterValue ��Ӧ�Ĺ����������ֵ�ֵ
  **/}
    procedure SetFilter(filterName: PChar; filterValue: PChar); stdcall;
  end;

 //������������
  CSubscribeParamInterface = interface(IInterface)
  {������������
  /**
  * @param szName ��Ӧ����������
  **/}
    procedure SetTopicName(szName: PChar); stdcall;

  {���ø�������
  /**
  * @param lpData �������ݵ��׵�ַ
  * @param iLen �������ݵĳ���
  **/}
    procedure SetAppData(lpData: pointer; iLen: integer); stdcall;

  {��ӹ�������
  /**
  * @param filterName ��������������
  * @param filterValue ����������ֵ
  **/}
    procedure SetFilter(filterName: pchar; filterValue: pchar); stdcall;

  {��ӷ����ֶ�
  /**
  * @param filedName ��Ҫ��ӵķ����ֶ�
  **/}
    procedure SetReturnFiled(filedName: pchar); stdcall;

  {�����Ƿ�ȱ��־
  /**
  * @param bFromNow true��ʾ��Ҫ֮ǰ�����ݣ�Ҳ���ǲ�ȱ��false��ʾ����Ҫ��ȱ
  **/}
    procedure SetFromNow(bFromNow: LongBool); stdcall;

  {���ø��Ƕ��ı�־
  /**
  * @param bReplace true��ʾ���Ƕ��ģ�ȡ��֮ǰ�����ж��ģ�ֻ������ǰ�Ķ��ģ�false��ʾ׷�Ӷ���
  **/}
    procedure SetReplace(bReplace: LongBool); stdcall;

  {���÷��ͼ��
  /**
  * @param nSendInterval ��λ����
  **/}
    procedure SetSendInterval(nSendInterval: integer); stdcall;

  {��ȡ��������
  /**
  * @return ��������������Ϣ
  **/}
    function GetTopicName(): pchar; stdcall;

  {��ȡ��������
  /**
  * @param iLen ���Σ���ʾ�������ݵĳ���
  * @return ���ظ��������׵�ַ��û�з���NULL
  **/}
    function GetAppData(iLen: PInteger): pointer; stdcall;

  {��ȡ��Ӧ�Ĺ����ֶε�����
  /**
  * @param index ��Ӧ�Ĺ��������±�
  * @return ���ض�Ӧ���±�������������֣����򷵻�NULL��
  **/}
    function GetFilterNameByIndex(index: integer): pchar; stdcall;

  {�����±��ȡ����������ֵ
  /**
  * @param index ��Ӧ�Ĺ��������±�
  * @return ���ض�Ӧ���±����������ֵ�����򷵻�NULL��
  **/}
    function GetFilterValueByIndex(index: integer): pchar; stdcall;

  {���ݹ������������ֻ�ȡ����������ֵ
  /**
  * @param fileName ��Ӧ�Ĺ�����������
  * @return ���ض�Ӧ�Ĺ����������ֵ�����ֵ�����򷵻�NULL��
  **/}
    function GetFilterValue(fileName: pchar): pchar; stdcall;

  {��ȡ���������ĸ���
  /**
  * @return ���ض�Ӧ���������ĸ�����û�з���0
  **/}
    function GetFilterCount(): integer; stdcall;

  {��ȡ�����ֶ�
  /**
  * @return ���ض�Ӧ�ķ����ֶ���Ϣ
  **/}
    function GetReturnFiled(): pchar; stdcall;

  {��ȡ�Ƿ�ȱ�ı�־
  /**
  * @return ���ض�Ӧ�Ĳ�ȱ��־
  **/}
    function GetFromNow(): LongBool; stdcall;

  {��ȡ�Ƿ񸲸Ƕ��ĵı�־
  /**
  * @return ���ض�Ӧ�ĸ��Ƕ��ı�־
  **/}
    function GetReplace(): LongBool; stdcall;

  {��ȡ��Ӧ�ķ���Ƶ��
  /**
  * @return ���ض�Ӧ�ķ��ͼ��
  **/}
    function GetSendInterval(): integer; stdcall;
  end;

 //���ĽӿڵĶ���
  CSubscribeInterface = interface(IInterface)
  {/**��������
	* @param lpSubscribeParam ���涨��Ķ��Ĳ����ṹ
	* @param uiTimeout ��ʱʱ��
	* @param lppBizUnPack ҵ��У��ʱ��ʧ�ܷ��ص�ҵ�������Ϣ��������ĳɹ�û�з��أ������������Ҫ�������Release�ͷ�
						  �������ҵ��У��Ĵ�����Ϣ��д�����£�
						  IF2UnPacker* lpBizUnPack =NULL;
						  SubscribeTopic(...,&lpBizUnPack);
						  �����ݷ���ֵ�������ʧ�ܵľ��ж� lpBizUnPack �ǲ���NULL��
						  ��������Ϣ��ȡ��֮��,�ͷ�
						  lpBizUnPack->Release();
	* @param lpBizPack ҵ��У����Ҫ���ӵ�ҵ���ֶ��Լ�ֵ��û�о͸��ݹ���������Ϊҵ��У���ֶ�
	@return ����ֵ����0����ʾ��ǰ���ĳɹ��Ķ��ı�ʶ������Ҫ��ס�����ʶ�Ͷ�����֮���ӳ���ϵ�������ʶ��Ҫ����ȡ�����ĺͽ�����Ϣ�Ļص�����.
	*		  ��������ֵ�����ݴ���Ż�ȡ������Ϣ.
	**/}
    function SubscribeTopic(lpSubscribeParamInter: CSubscribeParamInterface; uiTimeout: Longword; lppBizUnPack : pointer = nil; lpBizPack: pointer = nil): integer; stdcall;

	{/**
    * ȡ����������
    * @param subscribeIndex ��Ϣ��Ӧ�Ķ��ı�ʶ�������ʶ������SubscribeTopic�����ķ���
    * @return ����0��ʾȡ�����ĳɹ�����������ֵ�����ݴ���Ż�ȡ������Ϣ.
    */}
    function CancelSubscribeTopic(subscribeIndex : integer): integer; stdcall;
	
  {/**ȡ����������
  * @param topicName ��������
  * @param lpFilter ��Ӧ�Ĺ�������
  * @return ����0��ʾȡ�����ĳɹ�����������ֵ�����ݴ���Ż�ȡ������Ϣ��
  **/}
    function CancelSubscribeTopicEx(topicName: pchar; lpFilterInterface: CFilterInterface): integer; stdcall;

  {/**��ȡ��ǰ���Ľӿ��Ѿ����ĵ����������Լ�����������Ϣ
  * @param lpPack ���洫��Ĵ����
  *�����ֶΡ�SubcribeIndex IsBornTopic TopicName TopicNo FilterRaw Appdata SendInterval ReturnFileds isReplace isFromNow Stutas QueueCount
  **/}
    procedure GetSubcribeTopic(lpPack: pointer); stdcall;

  {/**
  * ȡ��������ַ
  * @param lpPort ����ķ������˿ڣ�����ΪNULL
  * @return ���ط�������ַ
  */}
    function GetServerAddress(lpPort: pinteger): pchar; stdcall;
  end;

 //�����ӿڵĶ���
  CPublishInterface = interface(IInterface)
  {/**ҵ������ʽ�����ݷ����ӿ�
	* @param topicName �������֣���֪�����־ʹ�NULL
	* @param lpPacker ���������
	* @param iTimeOut ��ʱʱ��
	* @param lppBizUnPack ҵ��У��ʱ��ʧ�ܷ��ص�ҵ�������Ϣ����������ɹ�û�з��أ������������Ҫ�������Release�ͷ�
							�������ҵ��У��Ĵ�����Ϣ��д�����£�
							IF2UnPacker* lpBizUnPack =NULL;
							PubMsgByPacker(...,&lpBizUnPack);
							�����ݷ���ֵ�������ʧ�ܵľ��ж� lpBizUnPack �ǲ���NULL��
							��������Ϣ��ȡ��֮��,�ͷ�
							lpBizUnPack->Release();
	* @param bAddTimeStamp �Ƿ����ʱ�������ϵ������ܲ���
	* @return ����0��ʾ�ɹ�����������ֵ�����ݴ���Ż�ȡ������Ϣ��
	**/}
    function PubMsgByPacker(topicName: pchar; lpUnPacker: pointer; iTimeOut: integer = -1; lppBizUnPack : pointer = nil; bAddTimeStamp: LongBool = false): integer; stdcall;

  {/**��ҵ������ʽ�����ݷ����ӿڣ�һ������Ƹ�ʽ���ķ���
  * @param topicName �������֣���֪�����־ʹ�NULL
  * @param lpFilterInterface ������������Ҫ�ϲ��Լ�ָ��������Ĭ��û�й�������
  * @param lpData ���������
  * @param nLength ���ݳ���
  * @param iTimeOut ��ʱʱ��
  * @return ����0��ʾ�ɹ�����������ֵ�����ݴ���Ż�ȡ������Ϣ��
  **/}
    function PubMsg(topicName: pchar; lpFilterInterface: CFilterInterface; const lpData: pointer; nLength: integer; iTimeOut: integer = -1; lppBizUnPack : pointer = nil; bAddTimeStamp: LongBool = false): integer; stdcall;


  {/**���ص�ǰ����ķ������
  * @param topicName ��������
  * @return ����0��ʾû�ж�Ӧ�����⣬��������ֵ��ʾ�ɹ�
  **/}
    function GetMsgNoByTopicName(topicName: pchar): Longword; stdcall;

  {/**
  * ȡ��������ַ
  * @param lpPort ����ķ������˿ڣ�����ΪNULL
  * @return ���ط�������ַ
  */}
    function GetServerAddress(lpPort: pinteger): pchar; stdcall;
  end;
  
  //���Ļص��ӿڷ��ص����ݶ��壬���˶�����Ҫ��ҵ����֮�⣬����Ҫ���ص�����
  tagSubscribeRecvData = record
    lpFilterData : pchar;//�����ֶε�����ͷָ�룬�ý�������
    iFilterDataLen : integer;//�����ֶε����ݳ���
    lpAppData : pchar;//�������ݵ�����ͷָ��
    iAppDataLen : integer;//�������ݵĳ���
    szTopicName: Array[ 0..259 ] Of char;//��������
  end;
  
  CSubCallbackInterface = interface(IInterface)
  {�յ�������Ϣ�Ļص�
  /**
  * @param lpSub �ص��Ķ���ָ��
  * @param subscribeIndex ��Ϣ��Ӧ�Ķ��ı�ʶ�������ʶ������SubscribeTopic�����ķ���
  * @param lpData ������Ϣ�Ķ�����ָ�룬һ������Ϣ��ҵ��������
  * @param nLength ���������ݵĳ���
  * @param lpRecvData ������Ϣ�������ֶη��أ���Ҫ�����˸������ݣ�������Ϣ���������֣���ϸ�ο�tagSubscribeRecvData�ṹ�嶨��
  * @return
  **/}
    procedure OnReceived(lpSub: CSubscribeInterface; subscribeIndex: integer; const lpData: pointer; nLength: integer; lpRecvData: pointer); stdcall;


  {�յ��޳����������Ϣ�ص���һ����ӵ�����˲��Ե������»�ص�����ӿ�
  /**
  * @param lpSub �ص��Ķ���ָ��
  * @param subscribeIndex ��Ϣ��Ӧ�Ķ��ı�ʶ�������ʶ������SubscribeTopic�����ķ���
  * @param TickMsgInfo ���˵Ĵ�����Ϣ����Ҫ�ǰ��������ظ��Ķ�����λ����Ϣ
  * @return
  **/}
    procedure OnRecvTickMsg(lpSub: CSubscribeInterface; subscribeIndex: integer; const TickMsgInfo: pchar); stdcall;
  end;

  // ���ӽӿ�
  IConnectionInterface = interface(IInterface)
    function Reserved0(): Integer; stdcall;
    function Connect(uiTimeout: Longword): Integer; stdcall;
    function Close: Integer; stdcall;
    function Reserved1(): Integer; stdcall;
    function Reserved2(): Integer; stdcall;
    function Reserved3(): Integer; stdcall;
    function Reserved4(): Integer; stdcall;
    function Reserved5(): Integer; stdcall;
    function Reserved6(): Integer; stdcall;
    function GetServerAddress(lpPort: PInteger): PChar; stdcall;
    function GetStatus: Integer; stdcall;
    function GetServerLoad: Integer; stdcall;
    function GetErrorMsg(iErrorCode: Integer): PChar; stdcall;
    function GetConnectError: Integer; stdcall;
    function SendBiz(iFunID: Integer; lpPacker: Pointer; nAsy: Integer = 0; iSystemNo: Integer = 0; nCompressID: Integer = 1): Integer; stdcall;
    function RecvBiz(hSend: Integer; lppUnPackerOrStr: PPointer; uiTimeout: Longword = 1000; uiFlag: Longword = 0): Integer; stdcall;
    function SendBizEx(iFunID: Integer; lpPacker: Pointer; svrName : PChar; nAsy: Integer = 0; iSystemNo: Integer = 0; nCompressID: Integer = 1; branchNo: Integer = 0; lpRequest: pREQ_DATA = nil): Integer; stdcall;
    function RecvBizEx(hSend: Integer; lppUnPackerOrStr: PPointer; lpRetData: LPRET_DATA; uiTimeout: Longword = 1000; uiFlag: Longword = 0): Integer; stdcall;
    function CreateEx(Callback: ICallbackInterface): Integer; stdcall;
    function GetRealAddress(): PChar; stdcall;
    function CreateByMemCert(lpCallback: ICallbackInterface; lpCertData:pointer; nLength : Integer; const szPWD : PChar): Integer; stdcall;
    function Reserved7(): Integer; stdcall;
    function GetSelfAddress(): PChar; stdcall;
    function GetSelfMac(): PChar; stdcall;
    function NewSubscriber(lpCallback: CSubCallbackInterface; SubScribeName: PChar; iTimeOut: Integer; iInitRecvQLen : Integer=INIT_RECVQ_LEN; iStepRecvQLen : Integer=STEP_RECVQ_LEN) :pointer; stdcall;
    function NewPublisher(PublishName : pchar; msgCount:Integer; iTimeOut:Integer; bResetNo: LongBool= false): pointer; stdcall;
    function GetTopic(byForce : LongBool; iTimeOut : Integer): pointer; stdcall;	
    function GetMCLastError(): PChar; stdcall;
    function Create2BizMsg(Callback: ICallbackInterface): Integer; stdcall;
    function SendBizMsg(lpMsg :Pointer;nAsy : Integer = 0) : Integer; stdcall;
    function RecvBizMsg(hSend: Integer ;lpMsg:Pointer;uiTimeout: Integer = 1000;uiFlag : Integer = 0) : Integer; stdcall;
   end;



  IF2ResultSet = interface(IInterface)
    ///ȡ�ֶ���
    function GetColCount : integer; stdcall;
	
    ///ȡ�ֶ���
    function GetColName(column : integer) : PChar; stdcall;
	
    //ȡ�ֶ���������
    function GetColType(column : integer) : Char; stdcall;
	
    ///ȡ�������ֶ�С��λ��
    function GetColScale(column : integer) : integer; stdcall;
	
    //ȡ�ֶ����������ݵ������.
    function GetColWidth(column : integer) : integer; stdcall;
	
    ///ȡ�ֶ�����Ӧ���ֶ����
    function FindColIndex(const columnName : PChar) : integer; stdcall;

    //���ֶ����(��0Ϊ����)��ȡ�ֶ�ֵ(�ַ���)
    function GetStrByIndex(column : integer) : PChar; stdcall;
	
    //���ֶ�����ȡ�ֶ�ֵ(�ַ���)
    function GetStr(const columnName : PChar) : PChar; stdcall;
	
    //���ֶ����(��0Ϊ����)��ȡ�ֶ�ֵ
    function GetCharByIndex(column : integer) : Char; stdcall;
	
    //���ֶ�����ȡ�ֶ�ֵ
    function GetChar(const columnName : PChar) : Char; stdcall;
	
    //���ֶ���ţ�ȡ�ֶ�ֵ
    function GetDoubleByIndex(column : integer) : Double; stdcall;
	
    ///���ֶ�����ȡ�ֶ�ֵ
    function GetDouble(const columnName : PChar) : Double; stdcall;
	
    ///���ֶ���ţ�ȡ�ֶ�ֵ
    function GetIntByIndex(column : integer) : integer; stdcall;
	
    ///���ֶ�����ȡ�ֶ�ֵ
    function GetInt(const columnName : PChar) : integer; stdcall;
	
    ///���ֶ���Ż���ֶ�ֵ,����������
    function GetRawByIndex(column : integer; lpRawLen : Pinteger) : Pointer; stdcall;
	
    ///���ֶ�����ȡ�ֶ�ֵ
    function GetRaw(const columnName : PChar ; lpRawLen : Pinteger) : Pointer; stdcall;
	
    ///���һ��ȡ���ֶ�ֵ�Ƿ�ΪNULL
    function WasNull : integer; stdcall;

    ///ȡ��һ����¼
    procedure Next ; stdcall;
	
    ///�ж��Ƿ�Ϊ��β
    function IsEOF : integer; stdcall;
	
    ///�ж��Ƿ�Ϊ��
    function IsEmpty : integer; stdcall;
	
    function Destroy : Pointer; stdcall;
  end;
  
  IF2UnPacker = interface(IF2ResultSet)
    //ȡ�����ʽ�汾
    function GetVersion : integer; stdcall;
	
    //ȡ������ݳ���
    function Open(lpBuffer : Pointer; iLen : Longword) : integer; stdcall;
	
    ///ȡ���������(0x20���ϰ汾֧��)
    function GetDatasetCount : integer; stdcall;
	
    ///���õ�ǰ�����(0x20���ϰ汾֧��)
    function SetCurrentDatasetByIndex(nIndex : integer) : integer; stdcall;

    ///���õ�ǰ����� (0x20���ϰ汾֧��)
    function SetCurrentDataset(const szDatasetName : PChar) : integer; stdcall;

    //ȡ���������ָ��
    function GetPackBuf : Pointer; stdcall;

    //ȡ������ݳ���
    function GetPackLen : Longword; stdcall;

    //ȡ������ݼ�¼����,20051207�Ժ�汾֧��
    function GetRowCount : Longword; stdcall;
	
	///������м�¼�α�ӿڣ�ȡ�������������¼
    procedure First(); stdcall;

    ///������м�¼�α�ӿڣ�ȡ����������һ����¼
    procedure Last(); stdcall;

    ///������м�¼�α�ӿڣ�ȡ������ĵ�n����¼��ȡֵ��Χ[1, GetRowCount()]
    procedure Go(nRow : integer) ; stdcall;

	///���ӻ�ȡ��ǰ��������ֵĽӿ�,û�����ַ���""
	function GetDatasetName(): PChar; stdcall;
	
	function OpenAndCopy(lpBuffer:Pointer;iLen : integer): integer; stdcall;
   end;

  IF2Packer = interface(IInterface)

    ///�������ʼ��(ʹ�õ����ߵĻ�����
    procedure SetBuffer(pBuf : Pointer; iBufSize : integer; iDataLen : integer = 0 ) ; stdcall;

    ///��λ�����¿�ʼ����һ����(�ֶ������¼����Ϊ0��0��)
    procedure BeginPack; stdcall;

    ///��ʼ��һ�������
    function  NewDataset(const szDatasetName : PChar; iReturnCode : integer = 0) : integer; stdcall;

     /// ���ܣ��������ֶ�
    function AddField(const szFieldName : PChar ; cFieldType : Char = 'S'; iFieldWidth : integer =255; iFieldScale : integer =4 ) : integer; stdcall;

     //���ܣ��������ַ�������
    function AddStr( const szValue : PChar) : integer; stdcall;

     //���ܣ���������������
    function AddInt(iValue : integer) : integer; stdcall;

     //���ܣ������Ӹ�������
    function AddDouble(fValue : Double) : integer; stdcall;

    //���ܣ�������һ���ַ�
    function AddChar(cValue : Char) : integer; stdcall;

     //���ܣ�������һ�������
    function AddRaw(lpBuff : Pointer; iLen : integer) : integer; stdcall;
	
    ///�������
    procedure EndPack; stdcall;

    //���ܣ�ȡ������ָ��
    function GetPackBuf : Pointer; stdcall;

    //���ܣ�ȡ����������
    function GetPackLen : integer; stdcall;

    //���ܣ�ȡ��������������С
    function GetPackBufSize : integer; stdcall;
        
    //���ܣ�ȡ�����ʽ�汾
    function GetVersion : integer; stdcall;
	
    ///���ý�����ķ�����(0x20������Ҫ��)������������Ҫ����
    procedure SetReturnCode(dwRetCode : Longword); stdcall;
	
    //ֱ�ӷ��ص�ǰ�������Ľ���ӿ�,������EndPack()֮����ܵ���,�ڴ�����ͷ�ʱ��Ӧ�Ľ����ʵ��Ҳ�ͷ�
    function UnPack : pointer; stdcall;
	
    procedure FreeMem(lpBuf : Pointer); stdcall;

    procedure ClearValue; stdcall;

    ///��λ�����¿�ʼ����һ����(�ֶ������¼����Ϊ0��0��)
    procedure BeginPackEx(szName : pchar = nil); stdcall;

    ///��λ��ǰ�����(�ֶ������¼����Ϊ0��0��)����Ӱ�����������
    procedure ClearDataSet(); stdcall;
  end;
  
  function GetVersionInfo: Integer; stdcall; external 'T2SDK.dll'; // 0x01000002 = 1.0.0.2
  function NewConfig: Pointer; stdcall; external 'T2SDK.dll';
  function NewConnection(const Config: IConfigInterface): Pointer; stdcall; external 'T2SDK.dll';
  function NewPacker(iVersion: Integer): Pointer; stdcall; external 'T2SDK.dll';
  function NewUnPacker(lpBuffer: Pointer; iLen: Longword): Pointer; stdcall; external 'T2SDK.dll';
  function NewUnPackerV1(lpBuffer: Pointer; iLen: Longword): Pointer; stdcall; external 'T2SDK.dll';
  // EncodePassΪchar[16]����������ʱ����Ϊɢ��ֵ���ɶ����ַ����� PasswordΪ��Ҫɢ�е����봮��Key������8
  function Encode(EncodePass: PChar; const Password: PChar; Key: Integer): PChar; stdcall; external 'T2SDK.dll';   
  function GetPackVersion(const lpBuffer: Pointer): Integer; stdcall; external 'T2SDK.dll';  
  function NewFilter(): Pointer; stdcall; external 'T2SDK.dll';
  function NewSubscribeParam(): Pointer; stdcall; external 'T2SDK.dll';
  function NewBizMessage(): Pointer; stdcall; external 'T2SDK.dll';
implementation
  
end.

