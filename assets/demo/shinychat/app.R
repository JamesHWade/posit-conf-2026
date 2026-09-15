library(shiny)
library(shinychat)
library(ellmer)
library(coro)

Sys.setenv(SHINYCHAT_ASIDE_FAVICON = "false")

methods::setClass(
  "SlideSampleProvider",
  representation(name = "character", model = "character")
)

question <- "What does this article demonstrate, and what is still unresolved?"
answer <- paste0(
  "## The work is visible\n\n",
  "You can inspect each tool call and its result.",
  '<shiny-aside label="shinychat docs" grounded-span="You can inspect each tool call and its result.">',
  "**Tool calling UI**\n\n",
  "The article shows how tool requests and results appear in the conversation.\n\n",
  "**Source excerpt**\n\n",
  '> "displays the tool requests and results in the chat interface"',
  '</shiny-aside>\n\n',
  "## Still a question\n\n",
  "An inspectable tool result does not establish that an answer is correct. ",
  "We still need to check whether the source supports the claim."
)
read_article <- tool(
  function() {
    "Tool calling UI: requests and results are visible in the conversation."
  },
  name = "read_article",
  description = "Read the selected article.",
  annotations = tool_annotations(
    title = "Reading the article",
    read_only_hint = TRUE
  )
)
request <- ContentToolRequest("article-1", "read_article", tool = read_article)
result <- ContentToolResult(
  value = read_article(),
  request = request,
  extra = list(
    display = tool_result_display(
      title = "Read the article",
      label = "Tool calling UI",
      value_preview = "Source text available",
      show_request = TRUE,
      markdown = "### Tool calling UI\n\nTool requests and results appear in the conversation, where the reader can expand them.\n\nSource: shinychat documentation."
    )
  )
)

make_sample_client <- function() {
  turns <- list()
  client <- list()
  stream_sample <- async_generator(function(user_text, controller) {
    turns <<- c(turns, list(UserTurn(contents = list(ContentText(user_text)))))
    await(async_sleep(0.3))
    yield(request)
    await(async_sleep(1.6))
    yield(result)
    await(async_sleep(0.6))
    pieces <- strsplit(answer, "(?<= )", perl = TRUE)[[1]]
    emitted <- character()
    for (piece in pieces) {
      if (!is.null(controller) && controller$cancelled) {
        break
      }
      emitted <- c(emitted, piece)
      yield(ContentText(piece))
      await(async_sleep(0.055))
    }
    turns <<- c(
      turns,
      list(
        AssistantTurn(contents = list(request)),
        UserTurn(contents = list(result)),
        AssistantTurn(
          contents = list(ContentText(paste(emitted, collapse = "")))
        )
      )
    )
    invisible(NULL)
  })
  client <- list(
    get_turns = function() turns,
    set_turns = function(value) {
      turns <<- value
      invisible(client)
    },
    get_tools = function() list(read_article),
    set_tools = function(value) invisible(client),
    get_system_prompt = function() "",
    set_system_prompt = function(value) invisible(client),
    get_provider = function() {
      methods::new(
        "SlideSampleProvider",
        name = "Local sample",
        model = "sample"
      )
    },
    get_model = function() "sample",
    last_turn = function() tail(turns, 1)[[1]],
    stream_async = function(..., stream = "content", controller = NULL) {
      values <- rlang::list2(...)
      text <- vapply(
        values,
        function(x) {
          if (inherits(x, "ellmer::ContentText")) {
            x@text
          } else if (is.character(x)) {
            x
          } else {
            "Attached file"
          }
        },
        ""
      )
      stream_sample(paste(text, collapse = " "), controller)
    },
    clone = function() make_sample_client()
  )
  class(client) <- c("Chat", "R6")
  client
}

ui <- page_chat(
  "Reading notes",
  id = "reader",
  theme = bslib::bs_theme(
    version = 5,
    bg = "#ffffff",
    fg = "#182033",
    primary = "#3f67f3",
    base_font = "Avenir Next",
    base_font_size = "24px"
  ),
  width = "min(880px, 100%)",
  sidebar = chat_sidebar(history = TRUE, width = 285, open = "always"),
  toolbar_global = NULL,
  greeting = chat_greeting(
    "## Read with the source\n\nAsk a question about the selected article.",
    persistent = FALSE
  ),
  placeholder = "Ask about this article…",
  allow_attachments = TRUE,
  footer = "Sample conversation · shinychat development build"
)
ui <- htmltools::tagList(tags$head(tags$style("html { font-size: 22px; }")), ui)
server <- function(input, output, session) {
  client <- make_sample_client()
  handle <- chat_server(
    "reader",
    client,
    history = history_options(
      store = "memory",
      title = function(recorded_turns) "Tool UI",
      restore_mode = "none"
    )
  )
}
shinyApp(ui, server)
