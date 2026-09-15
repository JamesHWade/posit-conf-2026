# Shinychat visual walkthrough

These PNGs are browser captures of shinychat 0.4.0.9000, installed build `b14edbcf1e4d8df2dd290b3b21cdc164b60edfd6`. They show real components with scripted sample content, separately from the Rill demo. The sample uses no API keys or model calls.

The four images show streaming with a stop control, the expanded tool request and result, a source aside with highlighted grounding, and a new conversation with history and a local text attachment. The deck advances through them with normal slide controls.

`app.R` contains the capture app. It follows shinychat's installed page-chat example for its local client and uses an in-memory conversation store. The interface uses larger text for projection. Run it with a compatible development version of shinychat:

```r
shiny::runApp("assets/demo/shinychat", launch.browser = TRUE)
```

The answer and tool result are scripted display examples. The short source quotation comes from the [shinychat tool calling UI article](https://posit-dev.github.io/shinychat/r/articles/tool-ui.html). The source aside uses the public markup described in `?shinychat::chat_append`. This app is for showing the interface; it is not a reading agent or an evaluation of answer quality.
