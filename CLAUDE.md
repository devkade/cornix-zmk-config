# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a ZMK firmware configuration for the Cornix split ergonomic keyboard. The repository manages custom firmware configurations, keymap definitions, and build automation for the Cornix keyboard using the ZMK (Zephyr Mechanical Keyboard) framework.

## Architecture & Key Components

### Module Dependencies

- **zmk**: Core ZMK firmware (from zmkfirmware/zmk)
- **zmk-keyboard-cornix**: Cornix-specific keyboard shield definitions (from hitsmaxft/zmk-keyboard-cornix)
- **zmk-helpers**: Helper macros and utilities (from urob/zmk-helpers)

### Configuration Structure

- `config/west.yml`: West manifest defining module dependencies and versions
- `build.yaml`: GitHub Actions matrix configuration defining build targets
- `zmk-keyboard-cornix/config/`: Contains sample keymap configurations
- `zmk-keyboard-cornix/boards/shields/`: Shield definitions for different Cornix variants

### Build Targets (from build.yaml)

- `cornix_left`: Left half without dongle
- `cornix_right`: Right half without dongle
- `reset`: Settings reset firmware for troubleshooting

## Common Commands

### West (ZMK Package Manager)

```bash
# Initialize ZMK environment
just init
# or manually:
west init -l config/
west update --fetch-opt=--filter=blob:none
west zephyr-export

# Update dependencies
just update
# or manually:
west update --fetch-opt=--filter=blob:none
```

### Build Commands (using Justfile)

```bash
# List all available build targets
just list

# Build specific target
just build <target_name>
# Example: just build cornix_left

# Build all targets
just build all

# Clean build artifacts
just clean

# Clean all generated files
just clean-all
```

### Manual ZMK Build

```bash
# Build left half
west build -s zmk/app -b cornix_left -- -DZMK_CONFIG=config/

# Build right half  
west build -s zmk/app -b cornix_right -- -DZMK_CONFIG=config/

# Build reset firmware
west build -s zmk/app -b cornix_right -- -DZMK_CONFIG=config/ -DSHIELD=settings_reset
```

## Development Workflow

### Adding New Keymaps

1. Create keymap files in `config/` directory following ZMK keymap syntax
2. Include necessary headers from zmk-helpers for advanced macros
3. Use shield definitions from `zmk-keyboard-cornix/boards/shields/`

### Configuration Files

- Keymap files use `.keymap` extension with devicetree syntax
- Configuration files use `.conf` extension for ZMK settings (CONFIG_XYZ=value format)
- Board overlays use `.overlay` extension for hardware-specific configurations
- All configuration is compile-time - requires rebuilding firmware after changes

### ZMK-Helpers Usage

The project includes urob's zmk-helpers for simplified keymap configuration:

- Include `zmk-helpers/helper.h` for core helper macros
- Available macros: `ZMK_BEHAVIOR`, `ZMK_COMBO`, `ZMK_LAYER`, `ZMK_HOLD_TAP`, etc.
- Key position labels available for standardized keymap definitions

## Hardware Variants

### Cornix Without Dongle (Default)

- Use `cornix_left` and `cornix_right` boards
- Standard split keyboard configuration

### Cornix With Dongle

- Use `cornix_dongle` with `cornix_dongle_eyelash` shield
- Use `cornix_ph_left` for left half when using dongle
- Requires different build configuration in `build.yaml`

### Optional Features

- `cornix_indicator`: RGB LED support (high power consumption)
- `settings_reset`: Factory reset firmware

## Deployment

Firmware builds automatically via GitHub Actions on push/PR. Built `.uf2` files are available in GitHub Actions artifacts.

### Manual Flashing

1. Build firmware using above commands
2. Generated `.uf2` files located in `firmware/` directory after build
3. Flash files to respective keyboard halves:
   - `cornix_left.uf2` → Left half
   - `cornix_right.uf2` → Right half
   - `reset.uf2` → Either half for factory reset

### Troubleshooting

- Flash `reset.uf2` to both halves if experiencing connection issues
- Reset both halves simultaneously after flashing new firmware
- Since v2.3, no SoftDevice recovery needed - can flash directly
- Test keyboard over USB first before Bluetooth pairing
- For Bluetooth issues, try mobile devices if laptop connection fails

## ZMK Framework Key Concepts

### Keymap Structure

- Uses devicetree syntax with `/` root node structure
- Behaviors define key press/release actions
- Layers provide different key mappings activated conditionally
- Supports advanced features like hold-tap, tap-dance, sticky keys, combos, and macros

### Build System

- Based on Zephyr RTOS and West workspace management
- Must build from ZMK `app/` directory or use `-DZMK_CONFIG` flag
- External modules supported via `-DZMK_EXTRA_MODULES`
- Split keyboards require separate builds for each half