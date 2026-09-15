# Ode to shinychat

## The point of this section

Thank the people who built shinychat, then show the features that save you UI work. Point to specific details: the old question is still there after an edit; a tool call opens to show its result; a Shiny input works inside the drawer.

The six slides follow “that was an R program” and lead into the ellmer tool example. The full deck has 30 slides. Allow about three minutes: thank the contributors, show history, thinking and tools, then commands and the drawer. Finish with the R code that connects the chat to the app.

## Speaking path

| Slide | Time | What to say and show |
|---|---:|---|
| Ode to shinychat | 25 s | “I want to take a minute to thank the people behind shinychat.” Credit Carson, Garrick, Joe, Barret, and everyone who contributes. |
| Conversation history | 25 s | Show search, then point to `2 / 2`. “See that little two-of-two control? I can use it to go back to the first version.” |
| Thinking traces and tool calls | 35 s | Show the thinking panel and stop button. Advance once. “I can open one to see the request and what came back.” |
| Slash commands | 25 s | “Type slash and your commands show up.” Point to `/note` and the R function that opens the drawer. |
| And it’s still Shiny | 35 s | Point to the form and its output. “Shinychat provides the drawer; I wrote the form inside it.” |
| Add it to your Shiny app | 25 s | Show the UI and server calls. “That's a lot of UI code I don't have to write.” Continue: “What was behind that tool call? An R function.” |

That adds up to 2:50; check it aloud in rehearsal. For a 90-second cut, use about 10 seconds on the title, 15 on history, 20 on thinking/tools, 15 on commands, 20 on the drawer, and 10 on the R code. Keep the drawer in the short version so the audience sees that they can add their own Shiny UI.

The speaker notes in `index.qmd` contain the narration and sources. Paragraphs marked “Technical note” are reference material for questions. There are also source-aside and attachment captures if you want to show more.

## Source snapshot

Inspected upstream `posit-dev/shinychat` main on September 11, 2026 at [826c799994c32611629236bbc73516dbc14ff2ab](https://github.com/posit-dev/shinychat/tree/826c799994c32611629236bbc73516dbc14ff2ab). The R package identifies itself as **0.5.0**. Its checked-in web-asset marker is `1f2b21ed833e3c730a7ae44118850086fc2e2625`. The screenshots run the R package installed from this source, including its distributed web assets, in an isolated library.

The talk is about the R interface. The repository also has a Python package and shared JavaScript components; do not infer exact API or version parity between the languages from a shared feature description. The earlier deck's `0.4.0.9000` / `b14edbc` captures were replaced in this section. “Development source” identifies the inspected snapshot; it does not assert what version the audience currently has installed from CRAN.

Credit **Carson Sievert, Garrick Aden-Buie, Joe Cheng, and Barret Schloerke**, in that order, followed by everyone who contributes to shinychat. These authors are listed in [DESCRIPTION](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/DESCRIPTION), which also identifies Garrick as maintainer and Posit as copyright holder/funder. The slide order follows James's requested emphasis.

## Feature inventory and the useful distinctions

| Capability | What is actually supplied | R connection and source |
|---|---|---|
| Basic chat and full page | Embedded chat, or a full-window page with persistent conversation, responsive sidebars, navigation, and toolbars. | `chat_ui()` + `chat_server()`; `page_chat()` for the page. [Page layout](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/page_chat.R) |
| History | New conversations, titles, search, rename, delete, and return to prior conversations. Storage and scope are configurable. | `history_options()`, `chat_enable_history()`, and the returned history interface. [History](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat_history.R) |
| Storage and restore | Pluggable conversation storage; restore by browser state, URL, or Shiny bookmarking. The active ID is distinct from the stored transcript. | The actual `auto` resolver uses memory in Shiny dev mode and files otherwise. Browser local storage holds the active ID, not the complete transcript. [Store implementation](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat_history_store.R) |
| Edit and branch | Editing/resending a message keeps the original as a sibling; version controls select between branches. Requires history. | [Message controls](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/js/src/chat/ChatMessage.tsx) and the R history implementation. The demo actually switches back to the first branch. |
| Streaming and stop | Incremental responses, an automatic stop control through `chat_server()`, and an editor that remains usable while a response streams. | `enable_cancel`, `submit_key`, and the server's stream controller. [Server lifecycle](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat_app.R) |
| Thinking traces | Streaming/collapsible thinking panels, optional topic labels, and a configurable delay before showing short thinking blocks. | Ellmer `ContentThinking`, or supported `<thinking>` markup; `show_thinking_after_s`. These display reasoning content provided to the UI, not necessarily every internal reasoning step. [Thinking contract](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat.R) |
| Tool activity | Compact activity rows, grouped calls, request/result drill-down, per-call labels/previews, and rich result displays. | `tool_grouping`, tool annotations, and `tool_result_display()`. Display customization preserves the value sent to the model. [Tool display adapter](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/contents_shinychat.R) |
| Rich tool results | Markdown/HTML, images, PDF representations, footers, and fullscreen cards; custom result UI is another extension point. | `tool_result_display()` for the existing card; `contents_shinychat()` for a custom renderer. [Official tool UI guide](https://posit-dev.github.io/shinychat/r/articles/tool-ui.html) |
| Source asides | A source can open beside a claim; `grounded-span` associates the source with answer text. Supported ellmer web content also has citation displays. | `<shiny-aside>` and the content adapters. The application/provider supplies the source and association; displaying them does not establish the claim's correctness. [Asides contract](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat.R) |
| Slash commands | A keyboard command palette with registered names, descriptions, argument handling, and configurable message echo. Handlers can run R actions, arrange a prompt, or delegate to a client-side event. | `chat$slash_command(...)`, where `chat` is the result of `chat_server()`. Use `echo = FALSE` for a UI-only action such as opening a drawer. [Registration and dispatch](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat_app.R) |
| Artifact drawer | A configurable, resizable panel next to the conversation, with server functions to show, update, hide, or toggle it. Content can include ordinary bound Shiny UI. | `chat_drawer()` and `chat_drawer_show/update/hide/toggle()`. The panel is a UI container; artifact generation, identity, storage, and versioning belong to the application. [Drawer](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat_drawer.R) |
| Greetings and suggestions | A real empty-chat greeting lifecycle, dismissal, server updates/streaming, and clickable suggestion cards with keyboard navigation. | `chat_greeting()`, `chat_set_greeting()`, and suggestion spans in a contiguous Markdown list. [Chat UI](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/chat.R) |
| Attachments | Image, PDF, and text uploads, staging/removal, and conversion to ellmer content objects. | `allow_attachments`; the default combined size budget is approximately 30 MB. Actual model support depends on the client/provider. [Attachment handling](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/attachments.R) |
| Navigation and app controls | Additional pages with per-page sidebars/toolbars, persistent global controls, and a toolbar below the composer. | `chat_nav_panel()`, `chat_sidebar()`, `toolbar`, `toolbar_global`, `toolbar_input`, and standard bslib navigation helpers. [Page API](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/page_chat.R) |
| Theming and custom content | Bslib themes, public CSS properties, customizable icons, ordinary Shiny UI, and S7 content rendering extensions. | `page_chat_theme()`, `contents_shinychat()`, and `tool_result_display()`. [S7 extension contract](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/contents_shinychat.R) |
| Markdown beyond a chat | Streaming Markdown can be used elsewhere in a Shiny application. | `output_markdown_stream()` and `markdown_stream()`. [Markdown streaming](https://github.com/posit-dev/shinychat/blob/826c799994c32611629236bbc73516dbc14ff2ab/pkg-r/R/markdown-stream.R) |

## Ways to extend it

You can configure the theme, history, controls, tool grouping, and result labels. You can put your own Shiny UI in the page, toolbar, drawer, or tool result. For a custom content type, you can write an S7 `contents_shinychat()` method. Show the drawer form in the talk; keep the S7 details for questions.

Use “source aside” for the panel that shows supporting material and “drawer” for the panel that holds the form. Use “conversation history” for the saved chats and their branches.

## Screenshot proportions

The earlier capture app used 25px text with a 25px root font, while its composer buttons retained fixed 24px dimensions and a 6px bottom inset. In the measured layout, that pushed the control about 10px below the center of the single-line composer.

The revised app uses the native 16px typography proportions. High-resolution screenshots of the actual components are enlarged uniformly on the slides. The capture browser requests higher contrast and reduced motion; these use the package's built-in styles. No image retouching or button repositioning is involved. This is also why tight close-ups work better than shrinking an entire app screenshot onto a slide.

## Rehearsal checks

Open `shinychat-ode.html` for the section alone, or `index.html#/ode-to-shinychat` for context. Advance normally; the activity slide has one internal step, from thinking to tool inspection. All images are local.

Mention once that the screenshots use a sample conversation written for the talk. The controls are real shinychat components. Show these as shinychat features; only attribute a feature to Rill if its integration has been verified.
