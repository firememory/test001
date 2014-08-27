using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Text;
using System.Windows.Forms;
using hundsun.t2sdk;
using hundsun.mcapi;
using System.Runtime.InteropServices;

namespace extT2sdkTest
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();


            button3.Enabled = true;

            button1.Enabled = false;
            button2.Enabled = false;
            button4.Enabled = false;
            button5.Enabled = false;
            button6.Enabled = false;
            button7.Enabled = false;
        }

        private CT2Configinterface config = null;
        private CT2Connection conn = null;
        private callbacktest callback = null;
        private CSubCallback subscriberCallback = null;
        private CT2SubscribeInterface lpSub = null;
        private int subIndex = -1;
        private CT2PublishInterface lpPub = null;
        private delegate void UpdateStatusDelegate(string status);

        private void UpdateStatus(string status)
        {
            this.textBox1.Text = string.Format("{0}\r\n{1}", status, textBox1.Text);
        }

        public void DisplayText(string szText)
        {
            this.BeginInvoke(new UpdateStatusDelegate(UpdateStatus), new object[] { szText });
        }

    
        //ͬ������Ӧ��
        private void button1_Click(object sender, EventArgs e)
        {
            CT2BizMessage BizMessage = new CT2BizMessage();//������Ϣ
            BizMessage.SetFunction(8);//���ù��ܺ�
            BizMessage.SetPacketType(0);//������Ϣ����Ϊ����
            //���������
            CT2Packer packer = new CT2Packer(2);
            sbyte strType = Convert.ToSByte('S');
            sbyte intType = Convert.ToSByte('I');
            packer.BeginPack();
            //������
            packer.AddField("plugin_id", strType, 255, 4);
            //�����ܺ�
            packer.AddField("function_id", intType, 255, 4);
            packer.AddStr("com.hundsun.fbase.f2core");
            packer.AddInt(100);
            packer.EndPack();
            unsafe
            {
                BizMessage.SetContent(packer.GetPackBuf(), packer.GetPackLen());
            }

            int iRet = conn.SendBizMsg(BizMessage, 0);
            if (iRet < 0)
            {
                DisplayText(conn.GetErrorMsg(iRet));
            }
            else
            {
                CT2BizMessage AnsBizMessage = null;
                iRet = conn.RecvBizMsg(iRet,out AnsBizMessage, 5000, 0);
                if (iRet < 0)
                {
                    DisplayText(conn.GetErrorMsg(iRet));
                }
                else
                {
                    int iRetCode = BizMessage.GetErrorNo();//��ȡ������
                    int iErrorCode = BizMessage.GetErrorNo();//��ȡ������
                    if (iRetCode != 0)
                    {
                        DisplayText("ͬ�����ճ���" + BizMessage.GetErrorNo().ToString() + BizMessage.GetErrorInfo());
                    }
                    else
                    {
                        CT2UnPacker unpacker = null;
                        unsafe
                        {
                            int iLen = 0;
                            void* lpdata = BizMessage.GetContent(&iLen);
                            unpacker = new CT2UnPacker(lpdata, (uint)iLen);
                        }
                        //����ҵ�����
                        if(iErrorCode!=0)
                        {
                            DisplayText("ͬ������ҵ�����\n");
                            PrintUnPack(unpacker);
                        }
                        //����ҵ�񷵻�
                        else
                        {
                            DisplayText("ͬ������ҵ��ɹ���\n");
                            PrintUnPack(unpacker);
                        }

                        if (unpacker != null)
                        {
                            unpacker.Dispose();
                        }
                        
                    }

                }
            }

            packer.Dispose();
            BizMessage.Dispose();
        }

        //�첽����Ӧ��
        private void button2_Click(object sender, EventArgs e)
        {
            CT2BizMessage BizMessage = new CT2BizMessage();//������Ϣ
            BizMessage.SetFunction(8);//���ù��ܺ�
            BizMessage.SetPacketType(0);//������Ϣ����Ϊ����
            //���������
            CT2Packer packer = new CT2Packer(2);
            sbyte strType = Convert.ToSByte('S');
            sbyte intType = Convert.ToSByte('I');
            packer.BeginPack();
            //������
            packer.AddField("plugin_id", strType, 255, 4);
            //�����ܺ�
            packer.AddField("function_id", intType, 255, 4);
            packer.AddStr("com.hundsun.fbase.f2core");
            packer.AddInt(100);
            packer.EndPack();
            unsafe
            {
                BizMessage.SetContent(packer.GetPackBuf(), packer.GetPackLen());
            }

            int iRet = conn.SendBizMsg(BizMessage, 1);
            if (iRet < 0)
            {
                DisplayText(conn.GetErrorMsg(iRet));
            }
            else
            {
                DisplayText("�첽�����ͳɹ���\n");
            }

            packer.Dispose();
            BizMessage.Dispose();
        }

        //��������
        private void button3_Click(object sender, EventArgs e)
        {
                config = new CT2Configinterface();
                config.Load("t2sdk.ini");
                conn = new CT2Connection(config);
                callback = new callbacktest(this);
                conn.Create2BizMsg(callback);
                int iret = conn.Connect(5000);
                textBox1.Text = "����" + conn.GetErrorMsg(iret) + "\r\n" + textBox1.Text;
                if (iret == 0)//���ӳɹ�֮��������ť���Ե����
                {
                    button3.Enabled = false;

                    button1.Enabled = true;
                    button2.Enabled = true;
                    button4.Enabled = true;
                    button5.Enabled = true;
                    button6.Enabled = true;
                    button7.Enabled = true;
                    button8.Enabled = true;
                    button9.Enabled = true;
                    button10.Enabled = true;
                }

        }

        //�Ͽ�����
        private void button4_Click(object sender, EventArgs e)
        {
            config.Dispose();
            conn.Dispose();
            config = null;
            conn = null;
            textBox1.Text = "";


            button3.Enabled = true;

            button1.Enabled = false;
            button2.Enabled = false;
            button4.Enabled = false;
            button5.Enabled = false;
            button6.Enabled = false;
            button7.Enabled = false;

        }

        public void PrintUnPack(CT2UnPacker lpUnPack)
        {
            String strInfo = String.Format("��¼������           {0}\n", lpUnPack.GetRowCount());
            DisplayText(strInfo);
            strInfo = String.Format("��������			 {0}\n", lpUnPack.GetColCount());
            DisplayText(strInfo);
            while (lpUnPack.IsEOF() != 1)
            {
                for (int i = 0; i < lpUnPack.GetColCount(); i++)
                {
                    String colName = lpUnPack.GetColName(i);
                    sbyte colType = lpUnPack.GetColType(i);
                    if (!colType.Equals('R'))
                    {
                        String colValue = lpUnPack.GetStrByIndex(i);
                        String str = String.Format("{0}:			[{1}]\n", colName, colValue);
                        DisplayText(str);
                    }
                    else
                    {
                        int colLength = 0;
                        unsafe
                        {
                            void* colValue = (char*)lpUnPack.GetRawByIndex(i, &colLength);
                            string str = String.Format("{0}:			[{1}]({2})\n", colName, Marshal.PtrToStringAuto(new IntPtr(colValue)), colLength);
                        }
                    }
                }
                lpUnPack.Next();
            }

        }
        
        //����
        private void button5_Click_1(object sender, EventArgs e)
        {
            
            //�������������
            if (subscriberCallback == null)
            {
                subscriberCallback = new CSubCallback(this);
            }
            if (lpSub == null)
            {
                lpSub = conn.NewSubscriber(subscriberCallback, "test", 5000, 2000, 100);
            }
            if (lpSub == null)
            {
                DisplayText(conn.GetMCLastError());
                return;
            }
            //���Ĳ�����ȡ
            CT2SubscribeParamInterface lpSubscribeParam = new CT2SubscribeParamInterface();
            string topicName = config.GetString("subcribe", "topic_name", "");//��������
            lpSubscribeParam.SetTopicName(topicName);
            string isFromNow = config.GetString("subcribe", "is_rebulid", "");//�Ƿ�ȱ
            if (isFromNow.Equals("true"))
            {
                lpSubscribeParam.SetFromNow(true);
            }
            else
            {
                lpSubscribeParam.SetFromNow(false);
            }
            string isReplace = config.GetString("subcribe", "is_replace", "");//�Ƿ񸲸�
            if (isReplace.Equals("true"))
            {
                lpSubscribeParam.SetReplace(true);
            }
            else
            {
                lpSubscribeParam.SetReplace(false);
            }

            string lpApp = "xuxinpeng";
            unsafe
            {
                lpSubscribeParam.SetAppData(Marshal.StringToBSTR(lpApp).ToPointer(), 9);//��Ӹ�������
            }
            //��ӹ����ֶ�
            int nCount = config.GetInt("subcribe", "filter_count", 0);
            for (int i = 1; i <= nCount; i++)
            {
                String lName = String.Format("filter_name{0}", i);
                string filterName = config.GetString("subcribe", lName, "");
                String lValue = String.Format("filter_value{0}", i);
                string filterValue = config.GetString("subcribe", lValue, "");
                lpSubscribeParam.SetFilter(filterName, filterValue);
            }
            //��ӷ���Ƶ��
            lpSubscribeParam.SetSendInterval(config.GetInt("subcribe", "send_interval", 0));
            //��ӷ����ֶ�
            nCount = config.GetInt("subcribe", "return_count", 0);
            for (int k = 1; k <= nCount; k++)
            {
                String lName = String.Format("return_filed{0}", k);
                string filedName = config.GetString("subcribe", lName, "");
                lpSubscribeParam.SetReturnFiled(filedName);
            }
            DisplayText("��ʼ����\n");
            int iRet = -1;  
            CT2UnPacker unpack = null;
            iRet = lpSub.SubscribeTopicEx(lpSubscribeParam, 5000, out unpack, null);

            if (unpack != null)
            {
                unpack.Dispose();
            }
            lpSubscribeParam.Dispose();
  
            if (iRet > 0)
            {
                subIndex = iRet;
                String strInfo = String.Format("SubscribeTopic info:{0} �ɹ�\n", iRet);
                DisplayText(strInfo);
            }
            else
            {
                String strInfo = String.Format("SubscribeTopic info:[{0}] {1}\n", iRet, conn.GetErrorMsg(iRet));
                DisplayText(strInfo);
                return;
            }

        }

        //����
        private void button6_Click(object sender, EventArgs e)
        {
            //ȡ��������Ϣ
            string topicName = config.GetString("publish", "topic_name", "");//��ȡ������������
            //��ȡ�����ֶ����ֺ�ֵ
            int nCount = config.GetInt("publish", "filter_count", 0);
            string[] strFilterName = new String[6];
            string[] strFilterValue = new String[6];
            for (int i = 1; i <= nCount; i++)
            {
                String str = String.Format("filter_name{0}", i);
                strFilterName[i - 1] = config.GetString("publish", str, "");
                str = String.Format("filter_value{0}", i);
                strFilterValue[i - 1] = config.GetString("publish", str, "");
            }
            DisplayText("���췢����\n");
            if (lpPub == null)
            {
                lpPub = conn.NewPublisher("test", 200, 5000, false);
            }
            if (lpPub == null)
            {
                String strInfo = String.Format("NewPublish Error: {0}\n", conn.GetMCLastError());
                DisplayText(strInfo);
                return;
            }
            DisplayText("��ʼ����\n");
            //���췢����ҵ�������
            CT2Packer lpOnePack = new CT2Packer(2);
            lpOnePack.BeginPack();
            for (int j = 0; j < nCount; j++)
            {
                lpOnePack.AddField(strFilterName[j], (sbyte)'S', 255, 4);
            }

            for (int k = 0; k < nCount; k++)
            {
                lpOnePack.AddStr(strFilterValue[k]);
            }

            lpOnePack.EndPack();
            CT2UnPacker lpUnPack = lpOnePack.UnPack();
            //ҵ����������
            //����ҵ��ķ��ͽӿڽ��з���
            int iRet = -1;
            unsafe
            {
                iRet = lpPub.PubMsgByPacker(topicName, lpUnPack, 5000, null, false);

                //��ӡ������Ϣ
                String strErr = String.Format("Next {0},{1},MsgID:{2}\n", iRet, conn.GetErrorMsg(iRet), lpPub.GetMsgNoByTopicName(topicName));
                DisplayText(strErr);
                lpOnePack.Dispose();
            }
            lpPub.Dispose();
            lpPub = null;
        }

        //ȡ������
        private void button7_Click(object sender, EventArgs e)
        {
            if (lpSub != null && subIndex > 0)
            {
                int iRet = lpSub.CancelSubscribeTopic(subIndex);
                String strInfo = String.Format("CancelSubscribeTopic:{0} {1}\n", iRet, conn.GetErrorMsg(iRet));
                DisplayText(strInfo);
                lpSub.Dispose();
                lpSub = null;
                subIndex = -1;
            }
        }


        private void button8_Click(object sender, EventArgs e)
        {

            CT2BizMessage msg = new CT2BizMessage();
            //��ʼ��ESBMessage��REQUEST_PACKETΪ�����ͣ��������,620001:��Ϣ����
            msg.SetPacketType(CT2tag_def.REQUEST_PACKET);
            msg.SetFunction(620001);
            //���� 1: �����������Ϊ1
            msg.SetIssueType(1);
            //��������
            CT2Packer pack = new CT2Packer(2);
            pack.BeginPack();
            pack.AddField("pub_no", Convert.ToSByte('S'), 255, 4);
            pack.AddStr("*");
            pack.EndPack();
            unsafe
            {
                msg.SetKeyInfo(pack.GetPackBuf(), pack.GetPackLen());
                conn.SendBizMsg(msg,1);
            }

            pack.Dispose();
            msg.Dispose();
        }

        private void button9_Click(object sender, EventArgs e)
        {


            CT2BizMessage msg = new CT2BizMessage();
            //��ʼ��ESBMessage��REQUEST_PACKETΪ�����ͣ��������,620002:ȡ����Ϣ����
            msg.SetPacketType(CT2tag_def.REQUEST_PACKET);
            msg.SetFunction(620002);
            //���� 1: �����������Ϊ1
            msg.SetIssueType(1);
            //��������
            CT2Packer pack = new CT2Packer(2);
            pack.BeginPack();
            pack.AddField("pub_no", Convert.ToSByte('S'), 255, 4);
            pack.AddStr("*");
            pack.EndPack();
            unsafe
            {
                msg.SetKeyInfo(pack.GetPackBuf(), pack.GetPackLen());
                conn.SendBizMsg(msg, 1);
            }

            pack.Dispose();
            msg.Dispose();
        }

        private void button10_Click(object sender, EventArgs e)
        {


            CT2BizMessage msg = new CT2BizMessage();
            //��ʼ��ESBMessage��REQUEST_PACKETΪ�����ͣ��������,620003��620020~620099:Ϊ������Ϣ���ܺ�
            msg.SetPacketType(CT2tag_def.REQUEST_PACKET);
            msg.SetFunction(620003);
            //���� 1: �����������Ϊ1
            msg.SetIssueType(1);
            //��������
            CT2Packer pack = new CT2Packer(2);
            pack.BeginPack();
            pack.AddField("pub_no", Convert.ToSByte('S'), 255, 4);
            pack.AddStr("1");
            pack.EndPack();
            unsafe
            {
                msg.SetKeyInfo(pack.GetPackBuf(), pack.GetPackLen());
            }
            //ҵ����
            pack.BeginPack();
            pack.AddField("fund_no", Convert.ToSByte('S'), 255, 4);
            pack.AddStr("123456");
            pack.EndPack();
            unsafe
            {
                msg.SetContent(pack.GetPackBuf(), pack.GetPackLen());
                conn.SendBizMsg(msg, 1);
            }
            pack.Dispose();
            msg.Dispose();
        }

    }

    public unsafe class callbacktest : CT2CallbackInterface
    {
        public callbacktest(Form1 form1) { m_lpOwner = form1; }

        private Form1 m_lpOwner;

        public override void OnConnect(CT2Connection lpConnection)
        {
            System.Console.WriteLine("OnConnect");
        }
        public override void OnSafeConnect(CT2Connection lpConnection)
        {
            System.Console.WriteLine("OnSafeConnect");
        }
        public override void OnRegister(CT2Connection lpConnection)
        {
            System.Console.WriteLine("OnRegister");
        }
        public override void OnClose(CT2Connection lpConnection)
        {
            System.Console.WriteLine("OnClose");
        }

        public override void OnReceivedBiz(CT2Connection lpConnection, int hSend, String lppStr, CT2UnPacker lppUnPacker, int nResult)
        {
            
        }

        public override void OnReceivedBizEx(CT2Connection lpConnection, int hSend, CT2RespondData lpRetData, String lppStr, CT2UnPacker lppUnPacker, int nResult)
        {
        }

        public override void OnSent(CT2Connection lpConnection, int hSend, void* lpData, int nLength, int nQueuingData)
        {

        }

        public override void OnReceivedBizMsg(CT2Connection lpConnection, int hSend, CT2BizMessage lpMsg)
        {
            int iRetCode = lpMsg.GetErrorNo();//��ȡ������
            int iErrorCode = lpMsg.GetReturnCode();//��ȡ������
            int iFunction = lpMsg.GetFunction();
            if (iRetCode != 0)
            {
                m_lpOwner.DisplayText("�첽���ճ���" + lpMsg.GetErrorNo().ToString() + lpMsg.GetErrorInfo());
            }
            else
            {
                if (iFunction == 620000)//1.0��Ϣ��������
                {
                    lpMsg.ChangeReq2AnsMessage();
                    lpConnection.SendBizMsg(lpMsg, 1);
                    return;
                }
                else if (iFunction == 620003 || iFunction == 620025) //�յ���������������
                {
                        m_lpOwner.DisplayText("�յ�������Ϣ��");
                        int iKeyInfo = 0;
                        void* lpKeyInfo = lpMsg.GetKeyInfo(&iKeyInfo);
                        CT2UnPacker unPacker = new CT2UnPacker(lpKeyInfo, (uint)iKeyInfo);
                        m_lpOwner.PrintUnPack(unPacker);
                        unPacker.Dispose();
                }
                else if (iFunction == 620001)
                {
                    m_lpOwner.DisplayText("�յ�����Ӧ��");
                    return;
                }
                else if (iFunction == 620002)
                {
                    m_lpOwner.DisplayText("�յ�ȡ������Ӧ��");
                    return;
                }
                CT2UnPacker unpacker = null;
                unsafe
                {
                    int iLen = 0;
                    void* lpdata = lpMsg.GetContent(&iLen);
                    unpacker = new CT2UnPacker(lpdata, (uint)iLen);
                }
                //����ҵ�����
                if (iErrorCode != 0)
                {
                    m_lpOwner.DisplayText("�첽����ҵ�����\n");
                    m_lpOwner.PrintUnPack(unpacker);
                }
                //����ҵ�񷵻�
                else
                {
                    m_lpOwner.DisplayText("�첽����ҵ��ɹ���\n");
                    m_lpOwner.PrintUnPack(unpacker);
                }
                if (unpacker != null)
                {
                    unpacker.Dispose();
                }
            }
        }
    };
    public unsafe class CSubCallback : CT2SubCallbackInterface
    {
        private Form1 m_lpOwner;
        public CSubCallback(Form1 form1)
        {
            m_lpOwner = form1;
        }
        public override void OnReceived(CT2SubscribeInterface lpSub, int subscribeIndex, void* lpData, int nLength, tagSubscribeRecvData lpRecvData)
        {
            m_lpOwner.DisplayText("�����յ�����***************************\n");
            String strInfo = String.Format("�������ݳ��ȣ�       {0}\n", lpRecvData.iAppDataLen);
            m_lpOwner.DisplayText(strInfo);
            if (lpRecvData.iAppDataLen > 0)
            {
                unsafe
                {
                    strInfo = String.Format("�������ݣ�           {0}\n", Marshal.PtrToStringAuto(new IntPtr(lpRecvData.lpAppData)));
                    m_lpOwner.DisplayText(strInfo);
                }
            }
            m_lpOwner.DisplayText("�����ֶβ��֣�\n");
            if (lpRecvData.iFilterDataLen > 0)
            {
                CT2UnPacker lpUnpack = new CT2UnPacker(lpRecvData.lpFilterData, (uint)lpRecvData.iFilterDataLen);
                m_lpOwner.PrintUnPack(lpUnpack);
                lpUnpack.Dispose();
            }
            CT2UnPacker lpUnPack1 = new CT2UnPacker((void*)lpData, (uint)nLength);
            if (lpUnPack1 != null)
            {
                m_lpOwner.PrintUnPack(lpUnPack1);
                lpUnPack1.Dispose();
            }
            m_lpOwner.DisplayText("***************************\n");
        }
        public override void OnRecvTickMsg(CT2SubscribeInterface lpSub, int subscribeIndex, string TickMsgInfo)
        {

        }

    };
}