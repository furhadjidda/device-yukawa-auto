# Inherit the full_base and device configurations
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/generic_system.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/mainline_system.mk)
$(call inherit-product, device/amlogic/yukawa/device-yukawa.mk)
$(call inherit-product, device/amlogic/yukawa/yukawa-common.mk)
$(call inherit-product,  device/amlogic/yukawa/yukawa.mk)
#
# All components inherited here go to product image
#
$(call inherit-product, $(SRC_TARGET_DIR)/product/aosp_product.mk)

PRODUCT_NAME := yukawa_auto
PRODUCT_DEVICE := yukawa_auto
PRODUCT_MODEL := AOSP on Khadas

# Auto modules
PRODUCT_PACKAGES += \
    android.hardware.broadcastradio@2.0-service \
    android.hardware.automotive.vehicle@2.0-service \


# Additional selinux policy
BOARD_SEPOLICY_DIRS += device/google_car/common/sepolicy \
    device/amlogic/yukawa/auto/sepolicy

# Override heap growth limit due to high display density on device
PRODUCT_PROPERTY_OVERRIDES += \
    dalvik.vm.heapgrowthlimit=256m

# Car init.rc
PRODUCT_COPY_FILES += \
            packages/services/Car/car_product/init/init.bootstat.rc:root/init.bootstat.rc \
            packages/services/Car/car_product/init/init.car.rc:root/init.car.rc

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
	  device/amlogic/yukawa/auto/auto_core_hardware_khadas.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/auto_core_hardware_khadas.xml \
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
PRODUCT_PACKAGES += android.frameworks.automotive.display@1.0-service \
  Vim3CarCalendarApp \
  Vim3LocalMediaPlayer \
  Vim3CarSettings \
  Vim3CarRadioApp

LOCAL_CFLAGS += \
    -Wno-unused-variable \
    -Wno-unused-parameter \

# External Libraries
PRODUCT_PACKAGES += libpaho-mqtt3a \
  MQTTAsync_subscribe \
  MQTTAsync_publish \
  libpaho-mqttpp3 \
  async_publish \
  async_publish_time \
  async_subscribe \
  async_consume \
  sync_publish \
  sync_consume \
  pahocpp_unit_tests \
  libev \
  si4703_test_app \
  gpiodetect \
  gpiofind \
  gpioget \
  gpioinfo \
  gpiomon \
  gpioset \
  message_reader \
  jsonserialze \
  simplereader \
  simplewriter \
  jsontutorial \
  topic_publish \
  mqttpp_chat

