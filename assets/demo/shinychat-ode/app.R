library(shiny)
library(shinychat)
library(ellmer)
library(coro)

# Real shinychat components, deterministic sample content, no model requests.
# Capture version: posit-dev/shinychat@826c799994c32611629236bbc73516dbc14ff2ab.
Sys.setenv(SHINYCHAT_ASIDE_FAVICON = "false")

methods::setClass(
  "OdeSampleProvider",
  representation(name = "character", model = "character")
)

thinking <- paste0(
  "<topic>Reading the source</topic>",
  "Checking which features the package supplies.\n\n",
  "<topic>Preparing a note</topic>",
  "Keeping one idea to try in an existing Shiny app."
)
answer <- paste0(
  "## A chat interface that fits your app\n\n",
  "Keep the conversation beside the work.",
  '<shiny-aside label="Package docs" grounded-span="Keep the conversation beside the work.">',
  "**shinychat · Page layout**\n\n",
  "The page combines a chat with navigation, a history sidebar, ",
  "and a drawer for application content.\n\n",
  "A drawer can contain ordinary Shiny inputs and outputs.\n\n",
  "[Read the documentation](https://posit-dev.github.io/shinychat/r/reference/page_chat.html)",
  '</shiny-aside>\n\n',
  "History, tool activity, and your own commands can live in one Shiny page.\n\n",
  "I drafted a reading note. Type **/note** to open it."
)
read_article <- tool(
  function() {
    "page_chat() combines chat, navigation, sidebars, and a drawer. The drawer accepts Shiny UI."
  },
  name = "read_article",
  description = "Read the selected package documentation.",
  annotations = tool_annotations(title = "Reading the article", read_only_hint = TRUE)
)

make_sample_client <- function() {
  turns <- list()
  client <- list()
  stream_sample <- async_generator(function(user_text, controller) {
    turns <<- c(turns, list(UserTurn(contents = list(ContentText(user_text)))))
    request <- ContentToolRequest(paste0("article-", length(turns)), "read_article", tool = read_article)
    result <- ContentToolResult(
      value = read_article(),
      request = request,
      extra = list(display = tool_result_display(
        title = "Read the article",
        label = "shinychat · Page layout",
        value_preview = "Source available",
        show_request = TRUE,
        markdown = paste0(
          "### Page layout\n\n",
          "Chat, conversation history, and an artifact drawer share one page.\n\n",
          "**Extension point:** the drawer accepts ordinary Shiny inputs and outputs."
        )
      ))
    )
    yield(ContentThinking(thinking))
    await(async_sleep(2.5))
    yield(request)
    await(async_sleep(1.4))
    yield(result)
    await(async_sleep(0.35))
    pieces <- strsplit(answer, "(?<= )", perl = TRUE)[[1]]
    emitted <- character()
    for (piece in pieces) {
      if (!is.null(controller) && controller$cancelled) break
      emitted <- c(emitted, piece)
      yield(ContentText(piece))
      await(async_sleep(0.04))
    }
    turns <<- c(turns, list(
      AssistantTurn(contents = list(ContentThinking(thinking), request)),
      UserTurn(contents = list(result)),
      AssistantTurn(contents = list(ContentText(paste(emitted, collapse = ""))))
    ))
    invisible(NULL)
  })
  client <- list(
    get_turns = function() turns,
    set_turns = function(value) { turns <<- value; invisible(client) },
    get_tools = function() list(read_article),
    set_tools = function(value) invisible(client),
    get_system_prompt = function() "",
    set_system_prompt = function(value) invisible(client),
    get_provider = function() methods::new("OdeSampleProvider", name = "Scripted sample", model = "sample"),
    get_model = function() "sample",
    last_turn = function() tail(turns, 1)[[1]],
    stream_async = function(..., stream = "content", controller = NULL) {
      values <- rlang::list2(...)
      text <- vapply(values, function(x) {
        if (inherits(x, "ellmer::ContentText")) x@text
        else if (is.character(x)) x
        else "Attached reading notes"
      }, "")
      stream_sample(paste(text, collapse = " "), controller)
    },
    clone = function() make_sample_client()
  )
  class(client) <- c("Chat", "R6")
  client
}

note_ui <- tags$section(
  class = "reading-note",
  textAreaInput("note_text", "My reading note", "Add /note to open a Shiny drawer.", rows = 2),
  selectInput("next_step", "Next step", c("Try it in my app", "Read the documentation", "Discuss with my team")),
  tags$div(class = "note-preview", textOutput("note_preview")),
  actionButton("save_note", "Save note", class = "btn-primary"),
  tags$div(class = "note-saved", textOutput("saved_note"))
)

ui <- page_chat(
  "Reading desk",
  id = "reader",
  theme = bslib::bs_theme(version = 5, bg = "#ffffff", fg = "#182033", primary = "#3f67f3", base_font = "Avenir Next", base_font_size = "16px"),
  width = "min(620px, 100%)",
  sidebar = chat_sidebar(history = TRUE, width = 260, open = "closed"),
  toolbar = bslib::toolbar(bslib::toolbar_input_button("open_note", "Reading note")),
  toolbar_global = NULL,
  drawer = chat_drawer(note_ui, title = "Reading note", width = 350, open = FALSE),
  greeting = chat_greeting(paste0(
    "## A place to think with the source\n\n",
    "Read an article. Keep an idea. Try it in your work.\n\n",
    '- <span class="suggestion" title="Read together">What should I keep from this article?</span>\n',
    '- <span class="suggestion" title="Bring your notes">Help me connect this to my work.</span>'
  ), persistent = FALSE),
  placeholder = "Ask a question, or type / for commands…",
  allow_attachments = TRUE,
  footer = "Real shinychat UI · scripted sample"
)
ui <- htmltools::tagList(tags$head(tags$style(HTML("
  /* Capture native proportions; enlarge the complete capture on the slide. */
  html { font-size: 16px; }
  .reading-note { padding: 12px 8px; }
  .reading-note h2 { font-size: 1.65rem; line-height: 1.1; font-weight: 700; margin: 0 0 16px; }
  .reading-note p { line-height: 1.35; }
  .reading-note label { font-weight: 650; }
  .note-preview { margin: 16px 0; color: #4e596c; font-size: .95rem; }
  .note-saved { margin-top: 12px; color: #25745f; font-size: .95rem; }
"))), ui)

server <- function(input, output, session) {
  handle <- chat_server(
    "reader", make_sample_client(),
    history = history_options(store = "memory", title = NULL)
  )
  handle$slash_command("note", "Open my reading note", function() chat_drawer_show("reader"), echo = FALSE)
  handle$slash_command("new", "Start a new conversation", function() handle$new_chat(), echo = FALSE)
  handle$slash_command("source", "Read the package documentation", function() {
    showModal(modalDialog(title = "Package documentation", tags$p("shinychat · Page layout"), tags$a(href = "https://posit-dev.github.io/shinychat/r/reference/page_chat.html", target = "_blank", "Open the documentation"), easyClose = TRUE))
  }, echo = FALSE)
  observeEvent(input$open_note, chat_drawer_show("reader"))
  output$note_preview <- renderText(paste("Next step:", input$next_step))
  saved <- reactiveVal(NULL)
  observeEvent(input$save_note, saved(list(text = input$note_text, next_step = input$next_step)))
  output$saved_note <- renderText(if (!is.null(saved())) "Saved in this session.")
}
shinyApp(ui, server)
