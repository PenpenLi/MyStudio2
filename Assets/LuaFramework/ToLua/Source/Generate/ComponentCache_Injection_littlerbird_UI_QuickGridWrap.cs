﻿//this source code was auto-generated by tolua#, do not modify it
using System;
using LuaInterface;

public class ComponentCache_Injection_littlerbird_UI_QuickGridWrap
{
	public static void Register(LuaState L)
	{
		L.BeginClass(typeof(ComponentCache.Injection<littlerbird.UI.QuickGrid>), typeof(System.Object), "Injection_littlerbird_UI_QuickGrid");
		L.RegFunction("New", _CreateComponentCache_Injection_littlerbird_UI_QuickGrid);
		L.RegFunction("__tostring", ToLua.op_ToString);
		L.RegVar("name", get_name, set_name);
		L.RegVar("value", get_value, set_value);
		L.EndClass();
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int _CreateComponentCache_Injection_littlerbird_UI_QuickGrid(IntPtr L)
	{
		try
		{
			int count = LuaDLL.lua_gettop(L);

			if (count == 0)
			{
				ComponentCache.Injection<littlerbird.UI.QuickGrid> obj = new ComponentCache.Injection<littlerbird.UI.QuickGrid>();
				ToLua.PushObject(L, obj);
				return 1;
			}
			else
			{
				return LuaDLL.luaL_throw(L, "invalid arguments to ctor method: ComponentCache.Injection<littlerbird.UI.QuickGrid>.New");
			}
		}
		catch (Exception e)
		{
			return LuaDLL.toluaL_exception(L, e);
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ComponentCache.Injection<littlerbird.UI.QuickGrid> obj = (ComponentCache.Injection<littlerbird.UI.QuickGrid>)o;
			string ret = obj.name;
			LuaDLL.lua_pushstring(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int get_value(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ComponentCache.Injection<littlerbird.UI.QuickGrid> obj = (ComponentCache.Injection<littlerbird.UI.QuickGrid>)o;
			littlerbird.UI.QuickGrid ret = obj.value;
			ToLua.Push(L, ret);
			return 1;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index value on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_name(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ComponentCache.Injection<littlerbird.UI.QuickGrid> obj = (ComponentCache.Injection<littlerbird.UI.QuickGrid>)o;
			string arg0 = ToLua.CheckString(L, 2);
			obj.name = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index name on a nil value");
		}
	}

	[MonoPInvokeCallbackAttribute(typeof(LuaCSFunction))]
	static int set_value(IntPtr L)
	{
		object o = null;

		try
		{
			o = ToLua.ToObject(L, 1);
			ComponentCache.Injection<littlerbird.UI.QuickGrid> obj = (ComponentCache.Injection<littlerbird.UI.QuickGrid>)o;
			littlerbird.UI.QuickGrid arg0 = (littlerbird.UI.QuickGrid)ToLua.CheckObject<littlerbird.UI.QuickGrid>(L, 2);
			obj.value = arg0;
			return 0;
		}
		catch(Exception e)
		{
			return LuaDLL.toluaL_exception(L, e, o, "attempt to index value on a nil value");
		}
	}
}
