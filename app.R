#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinythemes)

# Define UI for application that draws a histogram
ui <- fluidPage(
    #shinythemes::themeSelector(),
    fluidRow(
        navbarPage(NULL,
                   theme = shinytheme("yeti"),
                   tabPanel("Introduction",
                                column(1),
                                column(5,
                                       h3("Introduction"),
                                       br(),
                                       h5("Short Summary"),
                                       p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed sagittis risus quam, ac fringilla quam feugiat at. Aliquam erat volutpat. Phasellus fringilla sapien ac nulla tempor eleifend. Integer ut neque hendrerit, mollis urna in, posuere turpis. Sed id auctor felis, nec consequat nibh. Integer non vulputate urna. In elementum pellentesque facilisis. Sed accumsan elit nisl, suscipit rutrum felis malesuada ac. Duis fringilla nunc at finibus mollis. Nulla facilisi. Fusce tempor, ipsum id viverra fermentum, augue urna porttitor ligula, sit amet mollis lacus diam sed sem."),
                                       br(),
                                       h5("Takeaways"),
                                       p("In gravida porta egestas. Donec in est id urna vulputate egestas sit amet eu lorem. Fusce posuere lacus non nisl interdum, eget accumsan nisl lacinia. Phasellus posuere porttitor nibh et pulvinar. Suspendisse convallis eget nulla ut faucibus. Donec vitae condimentum lacus. Mauris tristique bibendum metus dictum tempor. Aenean vitae eleifend metus.")
                                ),
                                column(5,
                                       br(), br(), br(), br(),
                                       img(src = "vertical-placeholder.jpg",
                                           height = "450", 
                                           width = "100%")  
                                )    
                            ),
                   tabPanel("Design Process",
                            column(1),
                            column(10,
                                   h3("Our Design Process"),
                                   column(5,
                                          br(),
                                          img(src = "placeholder.png",
                                              height = "100%", 
                                              width = "100%"),
                                          h4("Process Map"),
                                          br(),
                                          img(src = "placeholder.png",
                                              height = "100%", 
                                              width = "100%"),
                                          h4("Journey Map"),
                                   ),
                                   column(1),
                                   column(5,
                                          br(),
                                          img(src = "placeholder.png",
                                              height = "100%", 
                                              width = "100%"),
                                          h4("Wireframe"),
                                          br(),
                                          img(src = "placeholder.png",
                                              height = "100%", 
                                              width = "100%"),
                                          h4("Screen Mockup"),
                                   ))
                            
                            ),
                   tabPanel("Visualizations",
                            sidebarPanel(
                                checkboxGroupInput("checkGroup", 
                                                   label = h5("Variables To Show"), 
                                                   choices = list("Aroma" = 1, 
                                                                  "Flavor" = 2, 
                                                                  "Aftertaste" = 3,
                                                                  "Sweetness" = 4,
                                                                  "Acidity" = 5,
                                                                  "Body" = 6,
                                                                  "Balance" = 7,
                                                                  "Uniformity" = 8),
                                                   selected = 1),
                            ),
                            mainPanel(
                                tabsetPanel(type = "tabs",
                                            tabPanel("Map", plotOutput("plot")),
                                            tabPanel("Altitude Graph", plotOutput("plot")),
                                            tabPanel("Coffee World Cup", plotOutput("plot"))
                                )
                            )
                   ),
                   tabPanel("Acknowledgements",
                            column(1),
                            column(10,
                                   h3("Acknowledgements"),
                                   br(),
                                   p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. Orci varius 
                                     natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. 
                                     Morbi eget felis vel ex laoreet lacinia in at odio. Maecenas imperdiet, 
                                     lorem non venenatis elementum, ligula turpis pretium velit, vel facilisis 
                                     nibh risus id elit. Suspendisse ac lorem eu lacus mollis fringilla quis non 
                                     urna. Vivamus condimentum ante mi, vel congue est aliquam vitae. Suspendisse 
                                     tempor molestie volutpat. Suspendisse eu leo et leo sodales ullamcorper ut 
                                     aliquet felis. Pellentesque pretium aliquam tortor at tempus. Mauris nunc felis, 
                                     placerat vitae lorem a, interdum interdum augue. Sed felis dui, posuere ac nisi 
                                     vel, porta tincidunt metus."))),
                   tabPanel("Reflections",
                            column(1),
                            column(10,
                                   h3("Reflections"),
                                   br(),
                                   p("Suspendisse quis magna dignissim, auctor nisi sit amet, rutrum ante. 
                                     Aliquam facilisis risus eget lacus consectetur lacinia. Sed fringilla 
                                     nibh nibh, eu finibus purus egestas non. Suspendisse ipsum ipsum, volutpat 
                                     sagittis commodo sed, lacinia ut lectus. Maecenas lectus mauris, vestibulum 
                                     id accumsan non, feugiat et lorem. Maecenas aliquam sodales elit id vestibulum.
                                     Proin ut mauris volutpat, sodales nisi eu, finibus mauris. Duis euismod, diam a 
                                     semper pretium, nisl augue aliquet purus, vel facilisis dui nisl a mi. Suspendisse 
                                     potenti. Aliquam ultrices urna a nunc finibus bibendum. Maecenas rutrum aliquet ante, 
                                     sit amet pharetra lectus aliquet non. Nulla a quam est. Pellentesque habitant morbi 
                                     tristique senectus et netus et malesuada fames ac turpis egestas.")
                                   )
                            )
                   )
        )
    )

# Define server logic required to draw a histogram
server <- function(input, output) {

   
}

# Run the application 
shinyApp(ui = ui, server = server)
