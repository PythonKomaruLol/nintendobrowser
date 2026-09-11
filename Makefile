TARGET		:=	MyBrowser
BUILD		:=	build
SOURCES		:=	.
DATA		:=	data
INCLUDES	:=	include

# Строго задаем пути для devkitPro
export DEVKITPRO	?=	/opt/devkitpro
export DEVKITA64	?=	$(DEVKITPRO)/devkitA64
export PATH			:=	$(DEVKITA64)/bin:$(PATH)

# Префикс для инструментов ARM (чтобы вызывался правильный компилятор, а не системный)
PREFIX		:=	aarch64-none-elf-
export CC	:=	$(PREFIX)gcc
export CXX	:=	$(PREFIX)g++
export LD	:=	$(PREFIX)g++
export AS	:=	$(PREFIX)as
export AR	:=	$(PREFIX)ar
export OBJCOPY := $(PREFIX)objcopy
export STRIP := $(PREFIX)strip

ifeq ($(strip $(DEVKITPRO)),)
$(error "Please set DEVKITPRO in your environment. export DEVKITPRO=<path>")
endif

export TOPDIR	:=	$(CURDIR)

# Архитектура и флаги
ARCH		:=	-march=armv8-a -mtune=cortex-a57 -mtp=soft -fPIE

CFLAGS		:=	-g -Wall -O2 -ffunction-sections \
				$(ARCH) $(INCLUDE) -D__SWITCH__

CXXFLAGS	:=	$(CFLAGS) -std=gnu++17 -fno-rtti -fno-exceptions

ASFLAGS		:=	-g $(ARCH)
LDFLAGS		:=	-specs=$(DEVKITPRO)/libnx/switch.specs $(ARCH) -Wl,--gc-sections

LIBS		:=	-lnx -lm

CFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.c)))
CPPFILES	:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.cpp)))
sFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.s)))
SFILES		:=	$(foreach dir,$(SOURCES),$(notdir $(wildcard $(dir)/*.S)))

export OFILES	:=	$(CPPFILES:.cpp=.o) $(CFILES:.c=.o) $(sFILES:.s=.o) $(SFILES:.S=.o)

export INCLUDE	:=	$(foreach dir,$(INCLUDES),-I$(CURDIR)/$(dir)) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include) \
					$(foreach dir,$(LIBDIRS),-I$(dir)/include/switch)

export LIBDIRS	:=	$(DEVKITPRO)/libnx

all: $(TARGET).nro

$(TARGET).nro: $(BUILD)/$(TARGET).elf

include $(DEVKITPRO)/libnx/switch_rules
