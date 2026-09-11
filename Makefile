TARGET		:=	MyBrowser
BUILD		:=	build
SOURCES		:=	.
DATA		:=	data
INCLUDES	:=	include

# Проверяем, задан ли путь к devkitPro
ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path>")
endif

export TOPDIR	:=	$(CURDIR)
include $(DEVKITPRO)/libnx/switch_rules

# Флаги компиляции под процессор Свитча
ARCH		:=	-march=armv8-a -mtune=cortex-a57 -mtp=soft -fPIE

CFLAGS		:=	-g -Wall -O2 -ffunction-sections \
				$(ARCH) $(INCLUDE) -D__SWITCH__

CXXFLAGS	:=	$(CFLAGS) -std=gnu++17 -fno-rtti -fno-exceptions

ASFLAGS		:=	-g $(ARCH)
LDFLAGS		:=	-specs=$(DEVKITPRO)/libnx/switch.specs $(ARCH) -Wl,--gc-sections

LIBS		:=	-lnx -lm

# Правила сборки
include $(DEVKITPRO)/libnx/switch_rules
