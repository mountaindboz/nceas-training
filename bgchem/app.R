#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)

# Load data from Arctic Data Center
data_url <- "https://arcticdata.io/metacat/d1/mn/v2/object/urn%3Auuid%3A35ad7624-b159-4e29-a700-0c0770419941"
bg_chem <- read.csv(
    url(data_url, method = "libcurl"), 
    stringsAsFactors = FALSE
)

# Define UI for application that draws a histogram
ui <- fluidPage(

    # Application title
    titlePanel("Water Biogeochemistry"),

    # Sidebar with a slider input for number of bins 
    sidebarLayout(
        sidebarPanel(
            sliderInput("depth",
                        "Depth:",
                        min = 1,
                        max = 500,
                        value = c(1, 100)
            ),
            selectInput("yaxis",
                        "Y Axis:",
                        choices = names(bg_chem)[8:19],
                        selected = names(bg_chem)[9]
            ),
            selectInput("pointcolor",
                        "Point Color:",
                        choices = names(bg_chem)[8:19],
                        selected = names(bg_chem)[10]
            )
        ),

        # Show a plot of the generated distribution
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        Yaxis <- sym(input$yaxis)
        pColor <- sym(input$pointcolor)
        ggplot(bg_chem, mapping = aes(x = CTD_Depth, y = !!Yaxis, color = !!pColor)) +
            geom_point(size = 2) +
            xlim(input$depth[1], input$depth[2]) +
            theme_light()
    })
}

# Run the application 
shinyApp(ui = ui, server = server)
