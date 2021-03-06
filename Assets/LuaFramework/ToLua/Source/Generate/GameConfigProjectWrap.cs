﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class GameConfigProjectWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(GameConfigProject), typeof(MonoSingletonProject<GameConfigProject>));
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("netClientStateLogShow", get_netClientStateLogShow, set_netClientStateLogShow);
		L.RegVar("netLogSendServerShow", get_netLogSendServerShow, set_netLogSendServerShow);
		L.RegVar("netTransferDataShow", get_netTransferDataShow, set_netTransferDataShow);
		L.RegVar("commonLogShow", get_commonLogShow, set_commonLogShow);
		L.RegVar("warningLogShow", get_warningLogShow, set_warningLogShow);
		L.RegVar("errorLogShow", get_errorLogShow, set_errorLogShow);
		L.RegVar("net", get_net, set_net);
		L.RegVar("developmentMode", get_developmentMode, set_developmentMode);
		L.RegVar("testView", get_testView, set_testView);
		L.RegVar("isIosEnterprise", get_isIosEnterprise, set_isIosEnterprise);
		L.RegVar("channel", get_channel, set_channel);
		L.RegVar("showPackage", get_showPackage, set_showPackage);
		L.RegVar("customData", get_customData, set_customData);
		L.RegVar("assetBundleFilePathEncrypt", get_assetBundleFilePathEncrypt, set_assetBundleFilePathEncrypt);
		L.RegVar("assetLoadType", get_assetLoadType, set_assetLoadType);
		L.RegVar("asyncFileOperationCallback", get_asyncFileOperationCallback, set_asyncFileOperationCallback);
		L.RegVar("loginServerIp", get_loginServerIp, null);
		L.RegVar("loginServerPort", get_loginServerPort, null);
		L.RegVar("httpApiUrl", get_httpApiUrl, null);
		L.RegVar("ipAdressType", get_ipAdressType, null);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int op_Equality(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			UnityEngine.Object arg0 = (UnityEngine.Object)ToLua.ToObject(L, 1);
			UnityEngine.Object arg1 = (UnityEngine.Object)ToLua.ToObject(L, 2);
			bool o = arg0 == arg1;
			LuaDLL.lua_pushboolean(L, o);
			return 1;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_netClientStateLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.netClientStateLogShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netClientStateLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_netLogSendServerShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.netLogSendServerShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netLogSendServerShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_netTransferDataShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.netTransferDataShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netTransferDataShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_commonLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.commonLogShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index commonLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_warningLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.warningLogShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index warningLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_errorLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.errorLogShow;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index errorLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_net(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			GameConfigNet ret = obj.net;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index net on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_developmentMode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.developmentMode;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index developmentMode on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_testView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.testView;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index testView on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_isIosEnterprise(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.isIosEnterprise;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isIosEnterprise on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_channel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string ret = obj.channel;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index channel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_showPackage(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string ret = obj.showPackage;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index showPackage on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_customData(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string ret = obj.customData;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customData on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_assetBundleFilePathEncrypt(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool ret = obj.assetBundleFilePathEncrypt;
			LuaDLL.lua_pushboolean(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index assetBundleFilePathEncrypt on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_assetLoadType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			int ret = obj.assetLoadType;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index assetLoadType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_asyncFileOperationCallback(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			LuaInterface.LuaFunction ret = obj.asyncFileOperationCallback;
			ToLua.PushObject(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index asyncFileOperationCallback on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loginServerIp(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string ret = obj.loginServerIp;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loginServerIp on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_loginServerPort(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			int ret = obj.loginServerPort;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index loginServerPort on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_httpApiUrl(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string ret = obj.httpApiUrl;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index httpApiUrl on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_ipAdressType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			int ret = obj.ipAdressType;
			LuaDLL.lua_pushinteger(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index ipAdressType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_netClientStateLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.netClientStateLogShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netClientStateLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_netLogSendServerShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.netLogSendServerShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netLogSendServerShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_netTransferDataShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.netTransferDataShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index netTransferDataShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_commonLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.commonLogShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index commonLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_warningLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.warningLogShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index warningLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_errorLogShow(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.errorLogShow = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index errorLogShow on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_net(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			GameConfigNet arg0 = (GameConfigNet)ToLua.CheckObject<GameConfigNet>(L, 2);
			obj.net = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index net on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_developmentMode(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.developmentMode = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index developmentMode on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_testView(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.testView = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index testView on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_isIosEnterprise(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.isIosEnterprise = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index isIosEnterprise on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_channel(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.channel = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index channel on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_showPackage(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.showPackage = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index showPackage on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_customData(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.customData = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index customData on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_assetBundleFilePathEncrypt(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			bool arg0 = LuaDLL.luaL_checkboolean(L, 2);
			obj.assetBundleFilePathEncrypt = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index assetBundleFilePathEncrypt on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_assetLoadType(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			int arg0 = (int)LuaDLL.luaL_checknumber(L, 2);
			obj.assetLoadType = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index assetLoadType on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_asyncFileOperationCallback(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameConfigProject obj = (GameConfigProject)o;
			LuaFunction arg0 = ToLua.CheckLuaFunction(L, 2);
			obj.asyncFileOperationCallback = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index asyncFileOperationCallback on a nil value");
		}
	}
}

