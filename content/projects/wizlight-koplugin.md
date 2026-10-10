+++
title       = "wizlight.koplugin"
slug        = "wizlight-koplugin"
date        = 2026-03-25
description = "A KOReader plugin for controlling WiZ smart bulbs straight from a Kindle."
summary     = "A KOReader plugin for controlling WiZ smart bulbs straight from a Kindle — brightness, colour temperature, scenes and a one-tap reading mode, without reaching for your phone."
tags        = ["lua", "koreader", "kindle", "smart-home"]
+++

**wizlight.koplugin** is a [KOReader](https://koreader.rocks/) plugin that lets
you control [WiZ](https://www.wizconnected.com/en-us) smart bulbs directly from
a Kindle. Adjust brightness, colour temperature and lighting scenes without
leaving your book — and without picking up your phone.

{{< button href="https://github.com/Tasty-Murder/wizlight.koplugin" target="_blank" rel="noopener" >}}
View on GitHub
{{< /button >}}

## Why

Reading in bed at night usually ends with grabbing a phone to dim the lights,
which is exactly the screen you were trying to avoid. The Kindle is already in
your hands and already on Wi-Fi, so the plugin turns it into the light switch.

## Features

- **Toggle on/off** from the menu or a custom gesture.
- **Reading Mode** — one tap to warm white (3000 K, 70%), and turning it off
  restores exactly what the bulb was doing before.
- **Default Scene** — dial the bulb in however you like it, hold to save, tap to
  recall.
- **Brightness** (10–100%), **colour temperature** (2200–6500 K) and **effect
  speed** (10–200) dials, pre-filled with what the bulb actually reports.
- **11 curated scenes**, split into *Lighting Themes* and *Animated Scenes*
  based on which ones genuinely animate, with per-scene customisation.
- **Multi-bulb registry** — save bulbs by room name and switch between them.
- **Blink-to-verify discovery** — each bulb found on the network flashes so you
  can confirm which physical light you are adding.
- **Automatic DHCP recovery** — if a bulb's IP changes after a router restart,
  the plugin offers to re-discover it.
- **In-app updates** from GitHub releases, keeping your bulbs and settings.

## How it works

There is no cloud, account or app involved. WiZ bulbs speak a small JSON-over-UDP
protocol on the local network (port 38899), and the plugin talks to them
directly. Discovery broadcasts a query and collects replies; control commands
are sent straight to the bulb's IP.

The interesting snag was the Kindle's firewall: commands reach the bulb and take
effect, but the replies get dropped on the way back in, so the plugin never
learns whether anything worked. The plugin therefore adds two `iptables` `ACCEPT`
rules for UDP port 38899 the first time it contacts a bulb, and removes them
again when KOReader closes. A session that never uses the plugin never touches
the firewall.

That root requirement is also why the plugin is **Kindle only** — Android's
security model doesn't allow it.

The protocol implementation was developed with reference to
[pywizlight](https://github.com/sbidy/pywizlight).

## Getting it

1. Download `wizlight.koplugin.zip` from the
   [latest release](https://github.com/Tasty-Murder/wizlight.koplugin/releases/latest).
2. Unzip it and copy the `wizlight.koplugin/` folder into `koreader/plugins/` on
   your Kindle.
3. Restart KOReader — the plugin appears as **WiZ Light** under
   **Tools → More Tools**.

Full setup, usage and troubleshooting docs live in the
[README on GitHub](https://github.com/Tasty-Murder/wizlight.koplugin#readme).
