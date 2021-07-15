# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/mainline_system.mk)
$(call inherit-product, device/amlogic/yukawa/device_auto-yukawa.mk)
$(call inherit-product, device/amlogic/yukawa/yukawa-common.mk)

#
# All components inherited here go to system_ext image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_system_ext.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_system_ext.mk)

#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

PRODUCT_NAME := yukawa_auto
PRODUCT_DEVICE := yukawa_auto
PRODUCT_MODEL := AOSP on Khadas

MOD_DIR = device/amlogic/yukawa-kernel/$(TARGET_KERNEL_USE)

#
# Put all the modules in the rootfs...
#
BOARD_VENDOR_KERNEL_MODULES := $(wildcard $(MOD_DIR)/*.ko)

ifneq ($(BOARD_VENDOR_KERNEL_MODULES),)

#
# ...and only a subset on the ramdisk.
#
# core clock providers
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/axg.ko \
  $(MOD_DIR)/axg-audio.ko \
  $(MOD_DIR)/axg-aoclk.ko \
  $(MOD_DIR)/clk-cpu-dyndiv.ko \
  $(MOD_DIR)/clk-regmap.ko \
  $(MOD_DIR)/clk-phase.ko \
  $(MOD_DIR)/gxbb-aoclk.ko \
  $(MOD_DIR)/clk-dualdiv.ko \
  $(MOD_DIR)/clk-pll.ko \
  $(MOD_DIR)/clk-mpll.ko \
  $(MOD_DIR)/meson-eeclk.ko \
  $(MOD_DIR)/sclk-div.ko \
  $(MOD_DIR)/g12a-aoclk.ko \
  $(MOD_DIR)/g12a.ko \
  $(MOD_DIR)/meson-aoclk.ko \
  $(MOD_DIR)/vid-pll-div.ko \
  $(MOD_DIR)/gxbb.ko

# pinctrl
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/pinctrl-meson-a1.ko \
  $(MOD_DIR)/pinctrl-meson-axg-pmx.ko \
  $(MOD_DIR)/pinctrl-meson-g12a.ko \
  $(MOD_DIR)/pinctrl-meson-axg.ko \
  $(MOD_DIR)/pinctrl-meson-gxl.ko \
  $(MOD_DIR)/pinctrl-meson.ko \
  $(MOD_DIR)/pinctrl-meson-gxbb.ko \
  $(MOD_DIR)/pinctrl-meson8-pmx.ko

# reset
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/reset-meson.ko \
  $(MOD_DIR)/reset-meson-audio-arb.ko

# misc.
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/meson-ee-pwrc.ko \
  $(MOD_DIR)/pwm-meson.ko \
  $(MOD_DIR)/pwm-regulator.ko

# SD/eMMC
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += \
  $(MOD_DIR)/meson-gx-mmc.ko \
  $(MOD_DIR)/pwrseq_simple.ko \
  $(MOD_DIR)/pwrseq_emmc.ko

#
# ...and only a subset of those to explicitly load, mainly to get
# SD/eMMC up so the main rootfs can be loaded
#
# NOTE: this list is G12/SM1 specific
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += \
  $(MOD_DIR)/g12a_aoclk.ko \
  $(MOD_DIR)/g12a.ko \
  $(MOD_DIR)/meson-eeclk.ko \
  $(MOD_DIR)/pinctrl-meson-g12a.ko \
  $(MOD_DIR)/reset-meson.ko \
  $(MOD_DIR)/pwm-meson.ko \
  $(MOD_DIR)/pwrseq_simple.ko \
  $(MOD_DIR)/pwrseq_emmc.ko \
  $(MOD_DIR)/meson-gx-mmc.ko

#
# serial console (may be built-in, so check if present)
#
UART_MOD=$(MOD_DIR)/meson_uart.ko
ifneq (,$(wildcard $(UART_MOD)))
BOARD_VENDOR_RAMDISK_KERNEL_MODULES += $(UART_MOD)
BOARD_VENDOR_RAMDISK_KERNEL_MODULES_LOAD += $(UART_MOD)
endif

endif


# Auto modules
PRODUCT_PACKAGES += \
    android.hardware.broadcastradio@2.0-service \
    android.hardware.automotive.vehicle@2.0-service \


# Additional selinux policy
BOARD_SEPOLICY_DIRS += device/google_car/common/sepolicy

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m

# Car init.rc
PRODUCT_COPY_FILES += \
            packages/services/Car/car_product/init/init.bootstat.rc:root/init.bootstat.rc \
            packages/services/Car/car_product/init/init.car.rc:root/init.car.rc

# Pre-create users
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    android.car.number_pre_created_users=1 \
    android.car.number_pre_created_guests=1 \
    android.car.user_hal_enabled=true

# Enable landscape
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.screen.landscape.xml:system/etc/permissions/android.hardware.screen.landscape.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.type.automotive.xml \

# Vendor Interface Manifest
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.broadcastradio.xml:system/etc/permissions/android.hardware.broadcastradio.xml

TARGET_USES_CAR_FUTURE_FEATURES := true

# frameworks/native/data/etc/car_core_hardware.xml:system/etc/permissions/car_core_hardware.xml \

PRODUCT_COPY_FILES += \
	  device/amlogic/yukawa/auto_core_hardware_khadas.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/auto_core_hardware_khadas.xml \
    frameworks/native/data/etc/android.hardware.type.automotive.xml:system/etc/permissions/android.hardware.type.automotive.xml \
    frameworks/native/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
    frameworks/native/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
    frameworks/native/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
    frameworks/native/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
    frameworks/native/data/etc/android.hardware.touchscreen.multitouch.jazzhand.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.jazzhand.xml \
    frameworks/native/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:system/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
    frameworks/native/data/etc/android.hardware.sensor.gyroscope.xml:system/etc/permissions/android.hardware.sensor.gyroscope.xml \
    frameworks/native/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml \
    frameworks/native/data/etc/android.hardware.usb.host.xml:system/etc/permissions/android.hardware.usb.host.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:system/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:system/etc/permissions/android.hardware.bluetooth_le.xml

# broadcast radio feature
 PRODUCT_COPY_FILES += \
        frameworks/native/data/etc/android.hardware.broadcastradio.xml:system/etc/permissions/android.hardware.broadcastradio.xml

# EVS v1.1
PRODUCT_PACKAGES += android.automotive.evs.manager@1.1 \
                    android.hardware.automotive.evs@1.1-sample \
                    evs_app
PRODUCT_PRODUCT_PROPERTIES += persist.automotive.evs.mode=0

# Automotive display service
PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service

#
# All components inherited here go to vendor image
#
# TODO(b/136525499): move *_vendor.mk into the vendor makefile later
$(call inherit-product, $(SRC_TARGET_DIR)/product/handheld_vendor.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/telephony_vendor.mk)