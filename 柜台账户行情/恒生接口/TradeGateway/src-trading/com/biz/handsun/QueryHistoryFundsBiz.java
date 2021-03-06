/*
 * FileName: CheckPswBiz.java
 * Copyright: Copyright 2014-6-10 Cfwx Tech. Co. Ltd.All right reserved.
 * Description: [这里用一句话描述]
 *
 */
package com.biz.handsun;

import com.core.handsun.HSDataHandler;
import com.util.FUNConstants;
import com.util.SysConstants;
/**
 * <code>QueryHistoryFundsBiz<code>  查询历史资金证券流水	.
 *
 * @author Colin, Jimmy
 * @since Handsun v0.0.1(June 10,2014)
 *
 */
public class QueryHistoryFundsBiz extends HSDataHandler{
	private static final String sFuncNo = FUNConstants.FUN_HIS_FUNDS;

	@Override
	protected void buildField() {
		asRequestField = new String[][]{
			{"version",SysConstants.HS.version},
			{"identity_type", ""},
			{"op_branch_no", SysConstants.HS.op_branch_no},
			{"op_entrust_way", SysConstants.HS.op_entrust_way},
			{"op_station", null},
			{"function_id", sFuncNo},
			{"branch_no", null },
			{"fund_account", null},
			{"password", null},
			{"start_date", null},
			{"end_date", null},
			//{"query_direction", SysConstants.HS.query_direction }, // 查询方向
			{"request_num", "1000"},
			{"money_type", ""},
		};
		
		asResponseField = new String[]{
		    "serial_no",//流水号
		    "business_date",//交易日期
		    "business_flag",//业务标志
		    "business_name",//业务标志名称
		    "money_type",//币种
		    "occur_balance",//资金发生额
		    "post_balance",//资金本次余额
		    "exchange_type",//市场类别
		    "stock_account",//证券帐号
		    "stock_code",//证券代码
		    "stock_name",//证券名称
		    "entrust_bs",//买卖方向
		    "business_price",//成交价格
		    "occur_amount",//成交数量
		    "position_str",//定位串
		};
		sFunID = sFuncNo;
	}
	
}
