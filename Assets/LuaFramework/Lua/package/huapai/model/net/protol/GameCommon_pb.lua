--Generated By protoc-gen-lua Do not Edit
local protobuf = require "protobuf.protobuf"
module('package.huapai.model.net.protol.GameCommon_pb')

ACTION_RESTART = protobuf.Descriptor();
ACTION_RESTART_PIAO_FIELD = protobuf.FieldDescriptor();
ACTION_RESTART_PAO_FIELD = protobuf.FieldDescriptor();
ACTION_RESTART_DITUO_FIELD = protobuf.FieldDescriptor();
ACTION_PIAO = protobuf.Descriptor();
ACTION_PIAO_PIAONUM_FIELD = protobuf.FieldDescriptor();
ACTION_PIAO_PAO_FIELD = protobuf.FieldDescriptor();
ACTION_PIAO_DITUO_FIELD = protobuf.FieldDescriptor();
ACTION_INTRUST = protobuf.Descriptor();
ACTION_INTRUST_TYPE_FIELD = protobuf.FieldDescriptor();
READY_STATE = protobuf.Descriptor();
READY_STATE_READY_FIELD = protobuf.FieldDescriptor();
READY_STATE_PIAOTYPE_FIELD = protobuf.FieldDescriptor();
READY_STATE_PIAONUM_FIELD = protobuf.FieldDescriptor();
READY_STATE_SEATID_FIELD = protobuf.FieldDescriptor();
READY_STATE_USERID_FIELD = protobuf.FieldDescriptor();
READY_STATE_PAO_FIELD = protobuf.FieldDescriptor();
READY_STATE_DITUO_FIELD = protobuf.FieldDescriptor();
USER_STATE = protobuf.Descriptor();
USER_STATE_STATE_FIELD = protobuf.FieldDescriptor();
USER_STATE_MSGTYPE_FIELD = protobuf.FieldDescriptor();
USER_STATE_RANDOMSEAT_FIELD = protobuf.FieldDescriptor();
USER_STATE_ZHUANGJIA_FIELD = protobuf.FieldDescriptor();
USER_STATE_DICETYPE_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG = protobuf.Descriptor();
RECORDCONFIG_VERSION_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_GAMERULE_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_SEATMAP_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_ROOMID_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_HALLNUM_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_PIAONUM_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_PAONUM_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_ROUNDCOUNT_FIELD = protobuf.FieldDescriptor();
RECORDCONFIG_DITUO_FIELD = protobuf.FieldDescriptor();

ACTION_RESTART_PIAO_FIELD.name = "Piao"
ACTION_RESTART_PIAO_FIELD.full_name = ".ACTION_RESTART.Piao"
ACTION_RESTART_PIAO_FIELD.number = 1
ACTION_RESTART_PIAO_FIELD.index = 0
ACTION_RESTART_PIAO_FIELD.label = 1
ACTION_RESTART_PIAO_FIELD.has_default_value = false
ACTION_RESTART_PIAO_FIELD.default_value = 0
ACTION_RESTART_PIAO_FIELD.type = 5
ACTION_RESTART_PIAO_FIELD.cpp_type = 1

ACTION_RESTART_PAO_FIELD.name = "Pao"
ACTION_RESTART_PAO_FIELD.full_name = ".ACTION_RESTART.Pao"
ACTION_RESTART_PAO_FIELD.number = 2
ACTION_RESTART_PAO_FIELD.index = 1
ACTION_RESTART_PAO_FIELD.label = 1
ACTION_RESTART_PAO_FIELD.has_default_value = false
ACTION_RESTART_PAO_FIELD.default_value = 0
ACTION_RESTART_PAO_FIELD.type = 5
ACTION_RESTART_PAO_FIELD.cpp_type = 1

ACTION_RESTART_DITUO_FIELD.name = "DiTuo"
ACTION_RESTART_DITUO_FIELD.full_name = ".ACTION_RESTART.DiTuo"
ACTION_RESTART_DITUO_FIELD.number = 3
ACTION_RESTART_DITUO_FIELD.index = 2
ACTION_RESTART_DITUO_FIELD.label = 1
ACTION_RESTART_DITUO_FIELD.has_default_value = false
ACTION_RESTART_DITUO_FIELD.default_value = false
ACTION_RESTART_DITUO_FIELD.type = 8
ACTION_RESTART_DITUO_FIELD.cpp_type = 7

ACTION_RESTART.name = "ACTION_RESTART"
ACTION_RESTART.full_name = ".ACTION_RESTART"
ACTION_RESTART.nested_types = {}
ACTION_RESTART.enum_types = {}
ACTION_RESTART.fields = {ACTION_RESTART_PIAO_FIELD, ACTION_RESTART_PAO_FIELD, ACTION_RESTART_DITUO_FIELD}
ACTION_RESTART.is_extendable = false
ACTION_RESTART.extensions = {}
ACTION_PIAO_PIAONUM_FIELD.name = "PiaoNum"
ACTION_PIAO_PIAONUM_FIELD.full_name = ".ACTION_PIAO.PiaoNum"
ACTION_PIAO_PIAONUM_FIELD.number = 1
ACTION_PIAO_PIAONUM_FIELD.index = 0
ACTION_PIAO_PIAONUM_FIELD.label = 2
ACTION_PIAO_PIAONUM_FIELD.has_default_value = false
ACTION_PIAO_PIAONUM_FIELD.default_value = 0
ACTION_PIAO_PIAONUM_FIELD.type = 5
ACTION_PIAO_PIAONUM_FIELD.cpp_type = 1

ACTION_PIAO_PAO_FIELD.name = "Pao"
ACTION_PIAO_PAO_FIELD.full_name = ".ACTION_PIAO.Pao"
ACTION_PIAO_PAO_FIELD.number = 2
ACTION_PIAO_PAO_FIELD.index = 1
ACTION_PIAO_PAO_FIELD.label = 1
ACTION_PIAO_PAO_FIELD.has_default_value = false
ACTION_PIAO_PAO_FIELD.default_value = 0
ACTION_PIAO_PAO_FIELD.type = 5
ACTION_PIAO_PAO_FIELD.cpp_type = 1

ACTION_PIAO_DITUO_FIELD.name = "DiTuo"
ACTION_PIAO_DITUO_FIELD.full_name = ".ACTION_PIAO.DiTuo"
ACTION_PIAO_DITUO_FIELD.number = 3
ACTION_PIAO_DITUO_FIELD.index = 2
ACTION_PIAO_DITUO_FIELD.label = 1
ACTION_PIAO_DITUO_FIELD.has_default_value = false
ACTION_PIAO_DITUO_FIELD.default_value = false
ACTION_PIAO_DITUO_FIELD.type = 8
ACTION_PIAO_DITUO_FIELD.cpp_type = 7

ACTION_PIAO.name = "ACTION_PIAO"
ACTION_PIAO.full_name = ".ACTION_PIAO"
ACTION_PIAO.nested_types = {}
ACTION_PIAO.enum_types = {}
ACTION_PIAO.fields = {ACTION_PIAO_PIAONUM_FIELD, ACTION_PIAO_PAO_FIELD, ACTION_PIAO_DITUO_FIELD}
ACTION_PIAO.is_extendable = false
ACTION_PIAO.extensions = {}
ACTION_INTRUST_TYPE_FIELD.name = "type"
ACTION_INTRUST_TYPE_FIELD.full_name = ".ACTION_INTRUST.type"
ACTION_INTRUST_TYPE_FIELD.number = 1
ACTION_INTRUST_TYPE_FIELD.index = 0
ACTION_INTRUST_TYPE_FIELD.label = 2
ACTION_INTRUST_TYPE_FIELD.has_default_value = false
ACTION_INTRUST_TYPE_FIELD.default_value = 0
ACTION_INTRUST_TYPE_FIELD.type = 5
ACTION_INTRUST_TYPE_FIELD.cpp_type = 1

ACTION_INTRUST.name = "ACTION_INTRUST"
ACTION_INTRUST.full_name = ".ACTION_INTRUST"
ACTION_INTRUST.nested_types = {}
ACTION_INTRUST.enum_types = {}
ACTION_INTRUST.fields = {ACTION_INTRUST_TYPE_FIELD}
ACTION_INTRUST.is_extendable = false
ACTION_INTRUST.extensions = {}
READY_STATE_READY_FIELD.name = "Ready"
READY_STATE_READY_FIELD.full_name = ".READY_STATE.Ready"
READY_STATE_READY_FIELD.number = 1
READY_STATE_READY_FIELD.index = 0
READY_STATE_READY_FIELD.label = 2
READY_STATE_READY_FIELD.has_default_value = false
READY_STATE_READY_FIELD.default_value = false
READY_STATE_READY_FIELD.type = 8
READY_STATE_READY_FIELD.cpp_type = 7

READY_STATE_PIAOTYPE_FIELD.name = "PiaoType"
READY_STATE_PIAOTYPE_FIELD.full_name = ".READY_STATE.PiaoType"
READY_STATE_PIAOTYPE_FIELD.number = 2
READY_STATE_PIAOTYPE_FIELD.index = 1
READY_STATE_PIAOTYPE_FIELD.label = 2
READY_STATE_PIAOTYPE_FIELD.has_default_value = false
READY_STATE_PIAOTYPE_FIELD.default_value = 0
READY_STATE_PIAOTYPE_FIELD.type = 5
READY_STATE_PIAOTYPE_FIELD.cpp_type = 1

READY_STATE_PIAONUM_FIELD.name = "PiaoNum"
READY_STATE_PIAONUM_FIELD.full_name = ".READY_STATE.PiaoNum"
READY_STATE_PIAONUM_FIELD.number = 3
READY_STATE_PIAONUM_FIELD.index = 2
READY_STATE_PIAONUM_FIELD.label = 2
READY_STATE_PIAONUM_FIELD.has_default_value = false
READY_STATE_PIAONUM_FIELD.default_value = 0
READY_STATE_PIAONUM_FIELD.type = 5
READY_STATE_PIAONUM_FIELD.cpp_type = 1

READY_STATE_SEATID_FIELD.name = "SeatID"
READY_STATE_SEATID_FIELD.full_name = ".READY_STATE.SeatID"
READY_STATE_SEATID_FIELD.number = 4
READY_STATE_SEATID_FIELD.index = 3
READY_STATE_SEATID_FIELD.label = 2
READY_STATE_SEATID_FIELD.has_default_value = false
READY_STATE_SEATID_FIELD.default_value = 0
READY_STATE_SEATID_FIELD.type = 5
READY_STATE_SEATID_FIELD.cpp_type = 1

READY_STATE_USERID_FIELD.name = "UserID"
READY_STATE_USERID_FIELD.full_name = ".READY_STATE.UserID"
READY_STATE_USERID_FIELD.number = 5
READY_STATE_USERID_FIELD.index = 4
READY_STATE_USERID_FIELD.label = 2
READY_STATE_USERID_FIELD.has_default_value = false
READY_STATE_USERID_FIELD.default_value = 0
READY_STATE_USERID_FIELD.type = 4
READY_STATE_USERID_FIELD.cpp_type = 4

READY_STATE_PAO_FIELD.name = "Pao"
READY_STATE_PAO_FIELD.full_name = ".READY_STATE.Pao"
READY_STATE_PAO_FIELD.number = 6
READY_STATE_PAO_FIELD.index = 5
READY_STATE_PAO_FIELD.label = 1
READY_STATE_PAO_FIELD.has_default_value = false
READY_STATE_PAO_FIELD.default_value = 0
READY_STATE_PAO_FIELD.type = 5
READY_STATE_PAO_FIELD.cpp_type = 1

READY_STATE_DITUO_FIELD.name = "DiTuo"
READY_STATE_DITUO_FIELD.full_name = ".READY_STATE.DiTuo"
READY_STATE_DITUO_FIELD.number = 7
READY_STATE_DITUO_FIELD.index = 6
READY_STATE_DITUO_FIELD.label = 1
READY_STATE_DITUO_FIELD.has_default_value = false
READY_STATE_DITUO_FIELD.default_value = false
READY_STATE_DITUO_FIELD.type = 8
READY_STATE_DITUO_FIELD.cpp_type = 7

READY_STATE.name = "READY_STATE"
READY_STATE.full_name = ".READY_STATE"
READY_STATE.nested_types = {}
READY_STATE.enum_types = {}
READY_STATE.fields = {READY_STATE_READY_FIELD, READY_STATE_PIAOTYPE_FIELD, READY_STATE_PIAONUM_FIELD, READY_STATE_SEATID_FIELD, READY_STATE_USERID_FIELD, READY_STATE_PAO_FIELD, READY_STATE_DITUO_FIELD}
READY_STATE.is_extendable = false
READY_STATE.extensions = {}
USER_STATE_STATE_FIELD.name = "State"
USER_STATE_STATE_FIELD.full_name = ".USER_STATE.State"
USER_STATE_STATE_FIELD.number = 1
USER_STATE_STATE_FIELD.index = 0
USER_STATE_STATE_FIELD.label = 3
USER_STATE_STATE_FIELD.has_default_value = false
USER_STATE_STATE_FIELD.default_value = {}
USER_STATE_STATE_FIELD.message_type = READY_STATE
USER_STATE_STATE_FIELD.type = 11
USER_STATE_STATE_FIELD.cpp_type = 10

USER_STATE_MSGTYPE_FIELD.name = "msgtype"
USER_STATE_MSGTYPE_FIELD.full_name = ".USER_STATE.msgtype"
USER_STATE_MSGTYPE_FIELD.number = 2
USER_STATE_MSGTYPE_FIELD.index = 1
USER_STATE_MSGTYPE_FIELD.label = 1
USER_STATE_MSGTYPE_FIELD.has_default_value = false
USER_STATE_MSGTYPE_FIELD.default_value = 0
USER_STATE_MSGTYPE_FIELD.type = 5
USER_STATE_MSGTYPE_FIELD.cpp_type = 1

USER_STATE_RANDOMSEAT_FIELD.name = "randomseat"
USER_STATE_RANDOMSEAT_FIELD.full_name = ".USER_STATE.randomseat"
USER_STATE_RANDOMSEAT_FIELD.number = 3
USER_STATE_RANDOMSEAT_FIELD.index = 2
USER_STATE_RANDOMSEAT_FIELD.label = 1
USER_STATE_RANDOMSEAT_FIELD.has_default_value = false
USER_STATE_RANDOMSEAT_FIELD.default_value = 0
USER_STATE_RANDOMSEAT_FIELD.type = 5
USER_STATE_RANDOMSEAT_FIELD.cpp_type = 1

USER_STATE_ZHUANGJIA_FIELD.name = "ZhuangJia"
USER_STATE_ZHUANGJIA_FIELD.full_name = ".USER_STATE.ZhuangJia"
USER_STATE_ZHUANGJIA_FIELD.number = 4
USER_STATE_ZHUANGJIA_FIELD.index = 3
USER_STATE_ZHUANGJIA_FIELD.label = 1
USER_STATE_ZHUANGJIA_FIELD.has_default_value = false
USER_STATE_ZHUANGJIA_FIELD.default_value = 0
USER_STATE_ZHUANGJIA_FIELD.type = 13
USER_STATE_ZHUANGJIA_FIELD.cpp_type = 3

USER_STATE_DICETYPE_FIELD.name = "DiceType"
USER_STATE_DICETYPE_FIELD.full_name = ".USER_STATE.DiceType"
USER_STATE_DICETYPE_FIELD.number = 5
USER_STATE_DICETYPE_FIELD.index = 4
USER_STATE_DICETYPE_FIELD.label = 1
USER_STATE_DICETYPE_FIELD.has_default_value = false
USER_STATE_DICETYPE_FIELD.default_value = false
USER_STATE_DICETYPE_FIELD.type = 8
USER_STATE_DICETYPE_FIELD.cpp_type = 7

USER_STATE.name = "USER_STATE"
USER_STATE.full_name = ".USER_STATE"
USER_STATE.nested_types = {}
USER_STATE.enum_types = {}
USER_STATE.fields = {USER_STATE_STATE_FIELD, USER_STATE_MSGTYPE_FIELD, USER_STATE_RANDOMSEAT_FIELD, USER_STATE_ZHUANGJIA_FIELD, USER_STATE_DICETYPE_FIELD}
USER_STATE.is_extendable = false
USER_STATE.extensions = {}
RECORDCONFIG_VERSION_FIELD.name = "version"
RECORDCONFIG_VERSION_FIELD.full_name = ".RecordConfig.version"
RECORDCONFIG_VERSION_FIELD.number = 1
RECORDCONFIG_VERSION_FIELD.index = 0
RECORDCONFIG_VERSION_FIELD.label = 2
RECORDCONFIG_VERSION_FIELD.has_default_value = false
RECORDCONFIG_VERSION_FIELD.default_value = 0
RECORDCONFIG_VERSION_FIELD.type = 5
RECORDCONFIG_VERSION_FIELD.cpp_type = 1

RECORDCONFIG_GAMERULE_FIELD.name = "gamerule"
RECORDCONFIG_GAMERULE_FIELD.full_name = ".RecordConfig.gamerule"
RECORDCONFIG_GAMERULE_FIELD.number = 2
RECORDCONFIG_GAMERULE_FIELD.index = 1
RECORDCONFIG_GAMERULE_FIELD.label = 2
RECORDCONFIG_GAMERULE_FIELD.has_default_value = false
RECORDCONFIG_GAMERULE_FIELD.default_value = ""
RECORDCONFIG_GAMERULE_FIELD.type = 9
RECORDCONFIG_GAMERULE_FIELD.cpp_type = 9

RECORDCONFIG_SEATMAP_FIELD.name = "seatmap"
RECORDCONFIG_SEATMAP_FIELD.full_name = ".RecordConfig.seatmap"
RECORDCONFIG_SEATMAP_FIELD.number = 3
RECORDCONFIG_SEATMAP_FIELD.index = 2
RECORDCONFIG_SEATMAP_FIELD.label = 3
RECORDCONFIG_SEATMAP_FIELD.has_default_value = false
RECORDCONFIG_SEATMAP_FIELD.default_value = {}
RECORDCONFIG_SEATMAP_FIELD.type = 5
RECORDCONFIG_SEATMAP_FIELD.cpp_type = 1

RECORDCONFIG_ROOMID_FIELD.name = "roomid"
RECORDCONFIG_ROOMID_FIELD.full_name = ".RecordConfig.roomid"
RECORDCONFIG_ROOMID_FIELD.number = 4
RECORDCONFIG_ROOMID_FIELD.index = 3
RECORDCONFIG_ROOMID_FIELD.label = 1
RECORDCONFIG_ROOMID_FIELD.has_default_value = false
RECORDCONFIG_ROOMID_FIELD.default_value = 0
RECORDCONFIG_ROOMID_FIELD.type = 5
RECORDCONFIG_ROOMID_FIELD.cpp_type = 1

RECORDCONFIG_HALLNUM_FIELD.name = "hallnum"
RECORDCONFIG_HALLNUM_FIELD.full_name = ".RecordConfig.hallnum"
RECORDCONFIG_HALLNUM_FIELD.number = 5
RECORDCONFIG_HALLNUM_FIELD.index = 4
RECORDCONFIG_HALLNUM_FIELD.label = 1
RECORDCONFIG_HALLNUM_FIELD.has_default_value = false
RECORDCONFIG_HALLNUM_FIELD.default_value = 0
RECORDCONFIG_HALLNUM_FIELD.type = 5
RECORDCONFIG_HALLNUM_FIELD.cpp_type = 1

RECORDCONFIG_PIAONUM_FIELD.name = "piaonum"
RECORDCONFIG_PIAONUM_FIELD.full_name = ".RecordConfig.piaonum"
RECORDCONFIG_PIAONUM_FIELD.number = 6
RECORDCONFIG_PIAONUM_FIELD.index = 5
RECORDCONFIG_PIAONUM_FIELD.label = 3
RECORDCONFIG_PIAONUM_FIELD.has_default_value = false
RECORDCONFIG_PIAONUM_FIELD.default_value = {}
RECORDCONFIG_PIAONUM_FIELD.type = 13
RECORDCONFIG_PIAONUM_FIELD.cpp_type = 3

RECORDCONFIG_PAONUM_FIELD.name = "paonum"
RECORDCONFIG_PAONUM_FIELD.full_name = ".RecordConfig.paonum"
RECORDCONFIG_PAONUM_FIELD.number = 7
RECORDCONFIG_PAONUM_FIELD.index = 6
RECORDCONFIG_PAONUM_FIELD.label = 3
RECORDCONFIG_PAONUM_FIELD.has_default_value = false
RECORDCONFIG_PAONUM_FIELD.default_value = {}
RECORDCONFIG_PAONUM_FIELD.type = 13
RECORDCONFIG_PAONUM_FIELD.cpp_type = 3

RECORDCONFIG_ROUNDCOUNT_FIELD.name = "roundcount"
RECORDCONFIG_ROUNDCOUNT_FIELD.full_name = ".RecordConfig.roundcount"
RECORDCONFIG_ROUNDCOUNT_FIELD.number = 8
RECORDCONFIG_ROUNDCOUNT_FIELD.index = 7
RECORDCONFIG_ROUNDCOUNT_FIELD.label = 1
RECORDCONFIG_ROUNDCOUNT_FIELD.has_default_value = false
RECORDCONFIG_ROUNDCOUNT_FIELD.default_value = 0
RECORDCONFIG_ROUNDCOUNT_FIELD.type = 5
RECORDCONFIG_ROUNDCOUNT_FIELD.cpp_type = 1

RECORDCONFIG_DITUO_FIELD.name = "dituo"
RECORDCONFIG_DITUO_FIELD.full_name = ".RecordConfig.dituo"
RECORDCONFIG_DITUO_FIELD.number = 9
RECORDCONFIG_DITUO_FIELD.index = 8
RECORDCONFIG_DITUO_FIELD.label = 3
RECORDCONFIG_DITUO_FIELD.has_default_value = false
RECORDCONFIG_DITUO_FIELD.default_value = {}
RECORDCONFIG_DITUO_FIELD.type = 8
RECORDCONFIG_DITUO_FIELD.cpp_type = 7

RECORDCONFIG.name = "RecordConfig"
RECORDCONFIG.full_name = ".RecordConfig"
RECORDCONFIG.nested_types = {}
RECORDCONFIG.enum_types = {}
RECORDCONFIG.fields = {RECORDCONFIG_VERSION_FIELD, RECORDCONFIG_GAMERULE_FIELD, RECORDCONFIG_SEATMAP_FIELD, RECORDCONFIG_ROOMID_FIELD, RECORDCONFIG_HALLNUM_FIELD, RECORDCONFIG_PIAONUM_FIELD, RECORDCONFIG_PAONUM_FIELD, RECORDCONFIG_ROUNDCOUNT_FIELD, RECORDCONFIG_DITUO_FIELD}
RECORDCONFIG.is_extendable = false
RECORDCONFIG.extensions = {}

ACTION_INTRUST = protobuf.Message(ACTION_INTRUST)
ACTION_PIAO = protobuf.Message(ACTION_PIAO)
ACTION_RESTART = protobuf.Message(ACTION_RESTART)
READY_STATE = protobuf.Message(READY_STATE)
RecordConfig = protobuf.Message(RECORDCONFIG)
USER_STATE = protobuf.Message(USER_STATE)
