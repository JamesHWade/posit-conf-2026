# Ode to shinychat captures

Actual shinychat components, scripted content, no API keys or model calls. The sample includes history, message editing and branches, thinking content, tool displays, source asides, slash commands, file attachments, greetings/suggestions, and a drawer containing live Shiny controls.

Source: [posit-dev/shinychat@826c799](https://github.com/posit-dev/shinychat/tree/826c799994c32611629236bbc73516dbc14ff2ab), R version 0.5.0. The checked-in JS asset marker is `1f2b21ed833e3c730a7ae44118850086fc2e2625`.

## Run

With that R development-source version installed:

```r
shiny::runApp("assets/demo/shinychat-ode", port = 4348)
```

`app.R` uses native font proportions. The slides enlarge complete high-resolution screenshots; enlarging only the theme's text had misaligned the fixed-size composer controls. The history store is in memory and the reading note is saved only within the current session.

## Capture

`capture.mjs` drives a separate local browser, captures the real components, and verifies composer centering in empty, ready, and stop states; search; preservation of the original branch after editing; file attachment staging; and reactive drawer updates. It requests reduced motion and higher contrast for projection. `PLAYWRIGHT_MODULE` and `CHROME_PATH` can override the local browser paths.

```sh
node assets/demo/shinychat-ode/capture.mjs
```

The numbered files are complete browser states. The `*-detail.png` files and `composer-detail.png` are direct browser crops for slide legibility. `capture-checks.json` records the last capture run. Source asides and attachment images are retained as supporting material even though the six-slide main sequence does not show every state.

The scripted provider follows the structure of shinychat's no-credentials page-chat example. It is a capture fixture, not a general-purpose model client or a production application. The drawer uses the public `chat_drawer*()` API and ordinary Shiny inputs/outputs. The tool result uses `tool_result_display()` and retains the underlying tool value.
