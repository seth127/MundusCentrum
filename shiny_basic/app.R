library(shiny)
library(dplyr)

ui <- fluidPage(

  titlePanel(
    verbatimTextOutput("game_title")
  ),

  sidebarLayout(

    sidebarPanel(
      selectInput("game_name", label = "Game", choices = list_games()),
      textInput("player_name", label = "Player", "big_grizz"),
      tableOutput("map_df")
    ),

    mainPanel(
      plotOutput("map", width = "600px", height = "700px")
    )
  )
)

# ui <- fluidPage(
#   selectInput("game_name", label = "Game", choices = list_games()),
#   textInput("player_name", label = "Player"),
#   plotOutput("map"),
#   tableOutput("map_df")
# )

server <- function(input, output, session) {

  game <- reactive({
    load_game(input$game_name, "005A")
  })
  player <- reactive({
    input$player_name
  })

  game_title <- reactive({
    game()$name
  })

  # # The data we wish to plot
  # plotData <- reactive({
  #   gapminder::gapminder %>%
  #     filter(year == input$year) %>%
  #     filter(continent %in% input$continent)
  # })

  # output$gapminderPlot <- renderPlot({
  #   plotData() %>%
  #     produceGapminderPlot() })

  output$map_df <- renderTable({
    #data.frame(hell = c(1,2,3), naw = c(4,5,6), yall = input$game_name)
    print_map_df(game(), "GLOBAL")
  })

  output$map <- renderPlot({

    draw_map(game(), player())
  })
}

shinyApp(ui, server)
