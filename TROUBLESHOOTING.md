# Robot Dog Troubleshooting Guide

## 🔧 Hardware Connection Checklist

### Step 1: Basic Hardware Check
- [ ] Robot dog is powered ON (check LED indicators)
- [ ] USB cable is connected to computer
- [ ] USB cable is connected to robot dog
- [ ] Try a different USB cable (ensure it's a DATA cable, not just charging)
- [ ] Try a different USB port on your computer

### Step 2: Device Manager Check
1. Press `Win + X` and select "Device Manager"
2. Connect your robot dog while Device Manager is open
3. Look for:
   - **New COM ports** under "Ports (COM & LPT)"
   - **New devices** under "Universal Serial Bus controllers"
   - **Unknown devices** with yellow warning triangles
   - **Any new entries** when you connect/disconnect

### Step 3: Common Robot Dog Connection Types

#### Type A: Direct STM32 Connection
- Device appears as: "STM32 Virtual COM Port" or "ST-Link"
- Best for programming - can use STM32CubeProgrammer directly

#### Type B: USB-to-Serial Bridge
- Device appears as: "USB Serial Device", "CH340", "CP210x", "FTDI"
- Common in hobby robot dogs
- Programming requires setting BOOT pins

#### Type C: Custom USB Device
- Device appears with manufacturer-specific name
- May need special drivers from manufacturer

### Step 4: Driver Installation
If device appears with yellow warning triangle:
1. Right-click on the device
2. Select "Update driver"
3. Choose "Search automatically for drivers"
4. Or download specific drivers from manufacturer

### Step 5: Alternative Methods

#### Method A: Use STM32CubeIDE GUI
1. Open STM32CubeIDE
2. Create new STM32 project
3. Import your test code
4. Use built-in programming tools

#### Method B: Check BOOT Pin Settings
Some robot dogs need BOOT pins set for programming:
- BOOT0 = 1 (High)
- BOOT1 = 0 (Low)
- Power cycle after setting pins

#### Method C: Try Different Programming Interface
- SWD (Serial Wire Debug) - needs 4 wires
- UART (Serial) - needs 2 wires + BOOT pin setting
- USB DFU - built-in bootloader

## 🎯 Next Steps Based on Results

### If COM Port Found:
```powershell
# Check COM port details
mode COM3  # Replace COM3 with your port
```

### If STM32 Device Found:
```powershell
# Test with STM32CubeProgrammer
STM32_Programmer_CLI -c port=SWD -list
```

### If No Device Found:
1. Check robot dog documentation for programming instructions
2. Contact manufacturer for specific programming method
3. Check if special programming adapter is needed

## 📞 Manufacturer-Specific Information

### Common Robot Dog Brands:
- **Petoi Bittle/Nybble**: USB-C, CH340 chip
- **XGO series**: USB-C, often CP210x
- **Boston Dynamics style clones**: Various chips
- **DIY kits**: Check assembly instructions

### Programming Modes:
- **Normal mode**: Regular operation
- **Programming mode**: BOOT pins set, or special key sequence
- **DFU mode**: Built-in USB bootloader

## 🔄 Final Steps
1. Complete hardware checklist above
2. Run: `.\simple_device_check.ps1` after each change
3. If device detected, proceed with flashing
4. If still no device, check robot dog manual for specific programming instructions
