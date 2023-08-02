library(shiny)
library(tidyverse)
library(sf)
library(plotly)

data_by_dist <- read_rds("data/data_by_dist.rds")
data_by_year <- read_csv("data/data_by_year.csv")

# Define UI for application that draws a histogram
ui <- navbarPage(
    title = "Neighborhood diversity",
    tabPanel(
        title = "Explore metros",
        sidebarLayout(
            sidebarPanel(
                selectInput("metro", label = "Choose a metropolitan area", choices = c(12060L, 12420L)),
                sliderInput("span", label = "Span parameter", min = 0.1, max = 0.9, value = 0.3, step = 0.1),
                p("Directions on using the app")
            ),
            mainPanel(
                fluidRow(
                    plotlyOutput("diversity_dist_scatter")
                ),
                fluidRow(
                    column(plotOutput("diversity_map"), width = 6),
                    column(plotOutput("diversity_bar_chart"), width = 6)
                )
            )
        )
    ),
    tabPanel(
        title = "Compare over time",
        "Content of 'compare over time'"
    ),
    tabPanel(
        title = "About",
        "About this app"
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {
    output$diversity_dist_scatter <- renderPlotly({
        p <- data_by_dist %>%
            filter(metro_id==input$metro) %>%
            ggplot(aes(x = distmiles, y = entropy)) +
                geom_point() + 
                geom_smooth(method = "loess", span = input$span)
        ggplotly(p)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
