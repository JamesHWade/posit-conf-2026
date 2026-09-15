# AI Agents Deserve R

Slides and speaker notes for James Wade's talk at posit::conf(2026). The rendered deck is at [jameshwade.github.io/posit-conf-2026](https://jameshwade.github.io/posit-conf-2026/).

The argument: agents do not need the largest ecosystem. They need a coherent one. R already has the pieces, and when something is missing, a smaller map makes the gap visible enough to build.

## The deck

- [`index.qmd`](index.qmd) is the source, including speaker notes. Technical notes and sources for each slide sit in HTML comments beside it.
- [`styles.scss`](styles.scss) holds the Reveal.js theme and the slide animations.

Render with [Quarto](https://quarto.org), then open `index.html` and press `S` for the speaker view:

```sh
quarto render index.qmd
```

The published copy is built from the same source and pushed to the `gh-pages` branch:

```sh
quarto publish gh-pages index.qmd
```

## The demo

The talk walks through [Rill](https://github.com/JamesHWade/rill), a personal feed reader, and the R packages underneath it: [Shiny](https://shiny.posit.co/), [shinychat](https://posit-dev.github.io/shinychat/), [ellmer](https://ellmer.tidyverse.org/), [Deputy](https://github.com/jameshwade/deputy), and [dsprrr](https://jameshwade.github.io/dsprrr/).

The Rill slides are redrawn in HTML at slide scale so they project legibly. The shinychat slides use real components with scripted content and no model calls. The capture apps are in [`assets/demo/shinychat`](assets/demo/shinychat) and [`assets/demo/shinychat-ode`](assets/demo/shinychat-ode), each with a README that says how to run it.

## Supporting material

- [`notes/accepted-submission.md`](notes/accepted-submission.md) is the accepted abstract.
- [`notes/shinychat-ode.md`](notes/shinychat-ode.md) covers the shinychat section in more depth, with the development-source features it inspects.

## Artwork

Hex stickers in [`assets/hex`](assets/hex) belong to their respective packages. The otter illustrations for Rill are in [`assets/demo/rill-otters-20260911`](assets/demo/rill-otters-20260911) with their generation notes. The Dow logo appears on the title and closing slides at the presenter's request and remains Dow's property; see [`assets/brand/README.md`](assets/brand/README.md).

## License

The deck source, styles, notes, and demo apps are released under the [MIT License](LICENSE). Package hex stickers and the Dow logo are excluded and remain the property of their owners.
