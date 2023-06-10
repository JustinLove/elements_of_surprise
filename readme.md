# Elements of Surprise

Materials may not be what they seem. Is that real Ambrosia, or will you become a sheep? Is that pool of water safe, or is it Acceleratium... or Lava?

## In-game Options

- Randomized Materials: if on, material relationships are randomized based on what is available in potions. Otherwise a curated list of vanilla materials and what they look like is used. This must be on to use modded materials.
- Potion Mimic Chance: percent chance a potion appears as something else.
- Natural Material Chance: whether and how often naturally occurring pools can be a mimic material.
- Enable Perks: adds some perks that bleed surprising materials
- Enable Spells: adds some spells that create surprising liquids

## Compatable mods:

- Alternate Biomes (mod order dependent, have Elements lower)
- Chemical Curiosities
- Graham's Things
- More Creeps & Weirdos
- Noitavania

Mod materials are only used in random mode.

Other material mods will not be used. Other biome mods may be order dependent.

## Mod integrations

Append to `mods/elements_of_surprise/files/material_xml_list.lua` if you have new material definitions.

Random mode materials-to-shuffle primarily come from the tables in standard potions. If you want something not in potions append to `mods/elements_of_surprise/files/extra_materials.lua`

Mods wishing to know the mapping can

`dofile('mods/elements_of_surprise/files/eos_material_info.lua')`

This file is created in `OnMagicNumbersAndWorldSeedInitialized`, and will not exit until that point. It defines:

```
eos_material_info = {
  wang_colors = {}, -- standard color to the material that looks the same
  name_to_mimic = {}, -- standard material to one that looks the same
  name_to_effect = {}, -- standard material to one that acts the same
}
```

## Thanks

- zatherz [Lua NXML](https://github.com/zatherz/luanxml)
- [Mofobert](https://steamcommunity.com/id/mofobert/) for the cover image
- Atomguy for the mod name
- Part of the [2023 Noita Mimic Mod Jam](https://discord.com/channels/453998283174576133/1110628700086620260)
