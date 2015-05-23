LOCAL_PATH := $(call my-dir)
ifneq ($(shell str=$(LOCAL_PATH);echo $${str%%/*}),out)
include $(CLEAR_VARS)
PKTLOGCONF_INC := $(LOCAL_PATH)/../../CORE/SERVICES/COMMON
LOCAL_MODULE := pktlogconf
LOCAL_C_INCLUDES := $(PKTLOGCONF_INC)
LOCAL_SRC_FILES := pktlogconf.c
include $(BUILD_EXECUTABLE)
endif