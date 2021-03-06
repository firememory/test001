/** @file
* 演示T2_SDK进行打包、发包、收包、解包
* @author  T2小组
* @author  恒生电子股份有限公司
* @version 1.0
* @date    20090327
*/

#include <Include/t2sdk_interface.h>

void ShowPacket(IF2UnPacker *lpUnPacker)
{
    int i = 0, t = 0, j = 0, k = 0;

    for (i = 0; i < lpUnPacker->GetDatasetCount(); ++i)
    {
        // 设置当前结果集
        lpUnPacker->SetCurrentDatasetByIndex(i);

        // 打印字段
        for (t = 0; t < lpUnPacker->GetColCount(); ++t)
        {
            printf("%20s", lpUnPacker->GetColName(t));
        }

        putchar('\n');

        // 打印所有记录
        for (j = 0; j < (int)lpUnPacker->GetRowCount(); ++j)
        {
            // 打印每条记录
            for (k = 0; k < lpUnPacker->GetColCount(); ++k)
            {
                switch (lpUnPacker->GetColType(k))
                {
                case 'I':
                    printf("%20d", lpUnPacker->GetIntByIndex(k));
                    break;

                case 'C':
                    printf("%20c", lpUnPacker->GetCharByIndex(k));
                    break;

                case 'S':
                    printf("%20s", lpUnPacker->GetStrByIndex(k));
                    break;

                case 'F':
                    printf("%20f", lpUnPacker->GetDoubleByIndex(k));
                    break;

                case 'R':
                    {
                        int nLength = 0;
                        void *lpData = lpUnPacker->GetRawByIndex(k, &nLength);

                        // 对2进制数据进行处理
                        break;
                    }

                default:
                    // 未知数据类型
                    printf("未知数据类型。\n");
                    break;
                }
            }

            putchar('\n');

            lpUnPacker->Next();
        }

        putchar('\n');
    }
}

int main()
{
    //通过T2SDK的引出函数，来获取一个新的CConfig对象
    //此对象在创建连接对象时被传递，用于配置所创建的连接对象的各种属性（比如服务器IP地址、安全模式等）
    //值得注意的是，在向配置对象设置配置信息时，配置信息既可以从ini文件中载入，
    //也可以在程序代码中设定，或者是2者的混合，如果对同一个配置项设不同的值，则以最近一次设置为准
    CConfigInterface * lpConfig = NewConfig();

    //通过T2SDK的引出函数NewXXXX返回的对象，需要调用对象的Release方法释放，而不能直接用delete
    //因为t2sdk.dll和调用程序可能是由不同的编译器、编译模式生成，delete可能会导致异常
    //为了适合Delphi等使用（Delphi对接口自动调用AddRef方法），用C/C++开发的代码，需要在NewXXXX之后调用一下AddRef
    //以保证引用计数正确
    lpConfig->AddRef();

    //[t2sdk] servers指定需要连接的IP地址及端口，可配置多个，中间以“;”间隔
    lpConfig->SetString("t2sdk", "servers", "192.168.94.30:9999");

    //[t2sdk] license_file指定许可证文件路径
    lpConfig->SetString("t2sdk", "license_file", "license.dat");

    //[t2sdk] lang指定错误信息的语言号（缺省为简体中文2052），1033为英文
    lpConfig->SetString("t2sdk", "lang", "1033");

    //[t2sdk] send_queue_size指定T2_SDK的发送队列大小
    lpConfig->SetString("t2sdk", "send_queue_size", "100");

    //[safe] safe_level指定连接的安全模式，需要和T2通道的安全模式一致，否则连接失败
    lpConfig->SetString("safe", "safe_level", "none");

    //通过T2SDK的引出函数，来获取一个新的CConnection对象指针
    CConnectionInterface *lpConnection = NewConnection(lpConfig);

    lpConnection->AddRef();

    int ret = 0;

    //初始化连接对象，返回0表示初始化成功，注意此时并没开始连接服务器
    if (0 == (ret = lpConnection->Create(NULL)))
    {
        //正式开始连接，参数1000为超时参数，单位毫秒
        if (ret = lpConnection->Connect(1000))
        {
            puts(lpConnection->GetErrorMsg(ret));
        }
        else
        {
            //获取打包器
            IF2Packer* pack = NewPacker(2);

            pack->AddRef();

            //创建一个业务包
            pack->BeginPack();

            pack->AddField("packSize", 'I');

            pack->AddInt(0);

            pack->EndPack();

            void *Pointer = NULL;

            // 76是功能号
            if ((ret = lpConnection->SendBiz(76, pack)) < 0)
            {
                puts(lpConnection->GetErrorMsg(ret));
            }
            else
            {
                // 默认超时时间为1秒
                ret = lpConnection->RecvBiz(ret, &Pointer);

                switch (ret)
                {
                case 0:
                    {
                        puts("业务操作成功。");
                        ShowPacket((IF2UnPacker *)Pointer);
                        break;
                    }

                case 1:
                    {
                        puts("业务操作失败。");
                        ShowPacket((IF2UnPacker *)Pointer);
                        break;
                    }

                case 2:
                    {
                        puts((char *)Pointer);
                        break;
                    }

                case 3:
                    {
                        puts("业务包解包失败。");
                        break;
                    }

                default:
                    {
                        puts(lpConnection->GetErrorMsg(ret));
                        break;
                    }
                }
            }

            pack->FreeMem(pack->GetPackBuf());
            pack->Release();
        }
    }
    else
    {
        puts(lpConnection->GetErrorMsg(ret));
    }

    //通过getchar阻塞线程，等待服务端应答包到达
    getchar();

    lpConnection->Release();
    lpConfig->Release();

    return 0;
}
