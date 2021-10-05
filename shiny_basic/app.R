library(shiny)
library(dplyr)
devtools::load_all()
library(MundusCentrum)

ui <- fluidPage(

  titlePanel(
    verbatimTextOutput("game_title")
  ),

  sidebarLayout(

    sidebarPanel(
      style = "overflow-y:scroll; max-height: 1200px; max-width: 400px; position:relative;",
      tableOutput("map_df")
    ),

    mainPanel(
      # inputs
      selectInput("game_name", label = "Game", choices = list_games()),
      textInput("player_code", label = "Player Code", ""),
      selectInput("turn", label = "Select Turn", choices = "001A"),
      actionButton("input_moves", "Input Moves", style="simple"),
      verbatimTextOutput(outputId = "moves_preview"),
      # map
      #plotOutput("map", width = "750px", height = "800px")
      imageOutput("map_png", width = "750px", height = "800px")
    )
  )
)


server <- function(input, output, session) {

  l <- reactiveValues()

  game <- reactive({
    load_game(input$game_name, input$turn)
  })
  player <- reactive({
    # stop the cheaters
    if(input$player_code %in% names(game()$players)) {
      stop("Please specify player code, not player name")
    }

    # load the name
    winner <- names(which(game()$players == input$player_code))
    if (length(winner) == 0) return(input$player_code)
    return(winner)
  })

  game_title <- reactive({
    game()$name
  })

  # output
  output$map_df <- renderTable({
    if (is.null(player())) {
      return("Please pass valid player")
    }
    print_shiny_df(game(), player())
  })

  # output$map <- renderPlot({
  #   draw_map(game(), player())
  # })
  output$map_png <- renderImage({
    # Return a list containing the filename
    list(src = game_img_path(game(), player()),
         contentType = 'image/png',
         width = 800,
         height = 750,
         units = "px",
         alt = "game map")
  }, deleteFile = FALSE)

  # filling in the options for turn
  observe({
    all_turns <- list_turns(input$game_name)
    updateSelectInput(
      session,
      "turn",
      choices = all_turns,
      selected = all_turns[length(all_turns)]
    )
  })

  # submitting moves
  observeEvent(input$input_moves, {
    # display a modal dialog with a header, textinput and action buttons
    showModal(modalDialog(
      tags$h2('Enter moves'),
      textInput('units', 'Unit(s)'),
      footer=tagList(
        actionButton('submit', 'Submit'),
        modalButton('cancel')
      )
    ))
  })

  observeEvent(input$submit, {
    removeModal()
    l$units <- unlist(stringr::str_split(input$units, "[, ]+"))
  })

  # display whatever is listed in l
  output$moves_preview <- renderPrint({
    if (is.null(l$units)) return(NULL)
    paste('Units:', paste(l$units, collapse = " :: "))
  })
}

shinyApp(ui, server)
