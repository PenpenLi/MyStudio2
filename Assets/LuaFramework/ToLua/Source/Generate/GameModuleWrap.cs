﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class GameModuleWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(GameModule), typeof(UnityEngine.MonoBehaviour));
		L.RegFunction("InitComponent", InitComponent);
		L.RegFunction("SetLayers", SetLayers);
		L.RegFunction("__eq", op_Equality);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("packageName", get_packageName, set_packageName);
		L.RegVar("moduleName", get_moduleName, set_moduleName);
		L.RegVar("canvasRoot", get_canvasRoot, set_canvasRoot);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int InitComponent(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 2);
			GameModule obj = (GameModule)ToLua.CheckObject<GameModule>(L, 1);
			LuaTable arg0 = ToLua.CheckLuaTable(L, 2);
			obj.InitComponent(arg0);
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int SetLayers(IntPtr L)
	{
		try
		{
			ToLua.CheckArgsCount(L, 1);
			GameModule obj = (GameModule)ToLua.CheckObject<GameModule>(L, 1);
			obj.SetLayers();
			return 0;
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
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
	static int get_packageName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			string ret = obj.packageName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index packageName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_moduleName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			string ret = obj.moduleName;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index moduleName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_canvasRoot(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			UnityEngine.Canvas ret = obj.canvasRoot;
			ToLua.PushSealed(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index canvasRoot on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_packageName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.packageName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index packageName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_moduleName(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.moduleName = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index moduleName on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_canvasRoot(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			GameModule obj = (GameModule)o;
			UnityEngine.Canvas arg0 = (UnityEngine.Canvas)ToLua.CheckObject(L, 2, typeof(UnityEngine.Canvas));
			obj.canvasRoot = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index canvasRoot on a nil value");
		}
	}
}
