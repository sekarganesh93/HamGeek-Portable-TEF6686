@echo off
echo -----------------------------
echo - Update tool ESP32 TEF6686 -
echo -       Version 2.0.0        -
echo -----------------------------
echo.
echo Available COM-ports:
chgport
echo.
set /p COM=Enter Comport number (example: 3):
esptool.exe --chip esp32 --port COM%COM% --baud 921600 --before default_reset --after hard_reset write_flash -z --flash_mode dio --flash_freq 80m --flash_size 4MB 0x1000 TEF6686_ESP32_ST7789.ino.bootloader.bin 0x8000 TEF6686_ESP32_ST7789.ino.partitions.bin 0xe000 boot_app0.bin 0x10000 TEF6686_ESP32_ST7789.ino.bin 
@pause