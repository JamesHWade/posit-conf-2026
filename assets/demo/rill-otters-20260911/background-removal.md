# Transparent otters for the main deck

Edited with the built-in `image_gen` tool on September 11, 2026. The main deck and [gallery](index.html) use these transparent PNGs. Original images remain in this directory.

| Slide | Transparent image | Original |
|---|---|---|
| Rill | [01-rill-reader-transparent.png](01-rill-reader-transparent.png) | [01-rill-reader.png](01-rill-reader.png) |
| Orientation | [02-orientation-choices-transparent.png](02-orientation-choices-transparent.png) | [02-orientation-choices.png](02-orientation-choices.png) |
| A reason to read it | [03-source-evidence-transparent.png](03-source-evidence-transparent.png) | [03-source-evidence.png](03-source-evidence.png) |
| Was this Orientation useful? | [04-reader-feedback-transparent.png](04-reader-feedback-transparent.png) | [04-reader-feedback.png](04-reader-feedback.png) |
| Questions while reading | [05-question-while-reading-transparent.png](05-question-while-reading-transparent.png) | [05-question-while-reading.png](05-question-while-reading.png) |

## File checks

All five outputs are 1254 × 1254 RGBA PNGs with zero alpha at all four corners. The cream foreground areas remain visible. Exact alpha statistics and file hashes are recorded in [background-removal.json](background-removal.json).

## Edit prompts

### Rill

```text
Use case: background-extraction. Edit target: the supplied otter illustration for a presentation slide. Remove only the opaque warm paper background and export a PNG with real transparent alpha outside the illustration. Preserve the existing otter, open cream booklet, teal water ripples, dark outlines, whiskers, colors, shape, scale, pose, placement, and all foreground detail. Preserve the square canvas and generous margin. Keep the cream muzzle, chest and book pages opaque. Remove background in the gaps between whiskers and ripples too. Do not redraw, restyle, add or remove foreground details. No checkerboard pixels, no white or colored matte, no new shadow, no border, no text. The background must actually be transparent, not an image of transparency.
```

### Orientation

```text
Remove the background from this existing illustration. Return the same foreground artwork as a transparent PNG cutout with a real alpha channel. Preserve the otter and all its props exactly. Keep the cream muzzle, chest, book and paper areas opaque. Remove the background only. Do not draw a checkerboard or replace the background with another color.
```

### A reason to read it

```text
Use case: background-extraction. Edit target: this exact otter illustration. Remove its background to genuine transparency. Export an RGBA PNG whose empty background has alpha 0 and whose otter, book, ribbon, highlight, and held note remain opaque. Preserve the original artwork, pose, dimensions, scale, position and margins. This is background removal only. Previous attempts incorrectly painted gray-and-white squares; that is not transparency. Do not draw any checkerboard, paper, color or scene behind the otter. Keep the cream-colored muzzle, chest, book pages and note intact.
```

### Was this Orientation useful?

```text
Remove the background from this existing illustration. Return the same foreground artwork as a transparent PNG cutout with a real alpha channel. Preserve the otter and all its props exactly. Keep the cream muzzle, chest, book and paper areas opaque. Remove the background only. Do not draw a checkerboard or replace the background with another color.
```

### Questions while reading

```text
Use case: background-extraction. Edit target: the supplied otter illustration used on a conference slide. Remove only the opaque warm paper background and its ground shadow, and export a PNG with real transparent alpha outside the illustration. Preserve the otter with one raised paw and a curious expression, the open cream book, teal ribbon bookmark, and every foreground detail. Preserve the existing character exactly: facial expression, pose, body and tail shape, dark outlines, whiskers, fur and muzzle colors, composition, scale, placement, square canvas and margins. Keep all cream-colored foreground areas such as muzzle, chest and pages opaque. Remove background in internal gaps as well. Do not redraw, restyle, change any foreground object, add a shadow, add a border, or add any text. No checkerboard pixels and no white or colored matte; actual transparent alpha is required.
```
