library(tidyverse)
library(shiny)
library(shinythemes)
library(shinyjs)
library(leaflet)
library(fmsb)
library(rgdal)

### Read in the dataset
all_data <- read_csv("data/arabica_data_cleaned.csv")

# MAP SETUP
coffee_avgs2 <- read_csv("data/coffee_avgs2.csv")

# Read world shape file with the rgdal library

world2 <- readOGR( 
    dsn = paste0(getwd(),"/data/world_shape_file"), 
    layer = "TM_WORLD_BORDERS_SIMPL-0.3",
    verbose = FALSE
)

# Add country average data to world2
library(tigris)
world2 = geo_join(world2,
                  coffee_avgs2,
                  # "FIPS",
                  # "FIPS",
                  by = "FIPS",
                  how = "left")


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
                                   fluidRow(
                                       h4("Process Map"),
                                       img(src = "placeholder.png",
                                           height = "100%", 
                                           width = "100%"),
                                       p("Place text here")
                                   ),
                                   fluidRow(
                                       h4("Journey Map"),
                                       img(src = "placeholder.png",
                                           height = "100%", 
                                           width = "100%"),
                                       p("Place text here")
                                   ),
                                   fluidRow(
                                       h4("Wireframe"),
                                       img(src = "placeholder.png",
                                           height = "100%", 
                                           width = "100%"),
                                       p("Place text here")
                                   ),
                                   fluidRow(
                                       h4("Screen Mockup"),
                                       img(src = "placeholder.png",
                                           height = "100%", 
                                           width = "100%"),
                                       p("Place text here")
                                   ),
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
                                          h4("Journey Map")
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
                                          h4("Screen Mockup")
                                   ))
                            
                            ),
                   tabPanel("Visualizations",
                                tabsetPanel(type = "tabs",
                                            tabPanel("Map",
                                                     br(),
                                                     sidebarPanel(
                                                         width = 2,
                                                         radioButtons("radio_map",
                                                                      label = h5("Variable to show"),
                                                                      choices = list("Aroma" = 1, "Flavor" = 2) #Add Rest Here
                                                         )
                                                     ),
                                                     mainPanel(
                                                         plotOutput("plot_map")
                                                     )
                                            ),
                                            tabPanel("Altitude Graph", 
                                                     br(),
                                                     sidebarPanel(
                                                         width = 2,
                                                         radioButtons("radio_altitude", label = h5("Review Factors"),
                                                                      choices = list("Aroma" = 1, "Flavor" = 2, "Aftertaste" = 3,
                                                                                     "Acidity" = 4, "Body" = 5, "Balance" = 6,
                                                                                     "Uniformity" = 7, "Clean Cup" = 8, "Sweetness" = 9), 
                                                                      selected = 1)
                                                     ),
                                                     mainPanel(
                                                         plotOutput("plot_altitude")
                                                     )
                                            ),

                                            tabPanel(
                                                "Stacked Graph",
                                                br(),
                                                sidebarPanel(
                                                    width = 3,
                                                    selectizeInput("stack_country",
                                                                label = h5("Country"),
                                                                choices = list("Brazil",
                                                                               "Burundi",
                                                                               "China",
                                                                               "Colombia",
                                                                               "Costa Rica",
                                                                               "Cote d'Ivoire",
                                                                               "Ecuador",
                                                                               "El Salvador",
                                                                               "Ethiopia",
                                                                               "Guatemala",
                                                                               "Haiti",
                                                                               "Honduras",
                                                                               "India",
                                                                               "Indonesia",
                                                                               "Japan",
                                                                               "Kenya",
                                                                               "Laos",
                                                                               "Malawi",
                                                                               "Mauritius",
                                                                               "Mexico",
                                                                               "Myanmar",
                                                                               "Nicaragua",
                                                                               "Panama",
                                                                               "Papua New Guinea",
                                                                               "Peru",
                                                                               "Philippines",
                                                                               "Puerto Rico",
                                                                               "Rwanda",
                                                                               "Taiwan",
                                                                               "Tanzania",
                                                                               "Thailand",
                                                                               "Uganda",
                                                                               "United States",
                                                                               "Hawaii",
                                                                               "Vietnam",
                                                                               "Zambia"),
                                                                multiple = TRUE,
                                                                options = list(plugins= list('remove_button'))
                                                                )
                                                ),
                                                mainPanel(
                                                    plotOutput("plot_stack")
                                                )
                                            ),
                                            
                                            tabPanel(
                                                "Radar Graph",
                                                br(),
                                                sidebarPanel(
                                                    width = 3,
                                                    selectInput("radar_country", 
                                                                label = h5("Select Country"), 
                                                                choices = list("Brazil",
                                                                               "Burundi",
                                                                               "China",
                                                                               "Colombia",
                                                                               "Costa Rica",
                                                                               "Cote d'Ivoire",
                                                                               "Ecuador",
                                                                               "El Salvador",
                                                                               "Ethiopia",
                                                                               "Guatemala",
                                                                               "Haiti",
                                                                               "Honduras",
                                                                               "India",
                                                                               "Indonesia",
                                                                               "Japan",
                                                                               "Kenya",
                                                                               "Laos",
                                                                               "Malawi",
                                                                               "Mauritius",
                                                                               "Mexico",
                                                                               "Myanmar",
                                                                               "Nicaragua",
                                                                               "Panama",
                                                                               "Papua New Guinea",
                                                                               "Peru",
                                                                               "Philippines",
                                                                               "Puerto Rico",
                                                                               "Rwanda",
                                                                               "Taiwan",
                                                                               "Tanzania",
                                                                               "Thailand",
                                                                               "Uganda",
                                                                               "United States",
                                                                               "Hawaii",
                                                                               "Vietnam",
                                                                               "Zambia"),
                                                                selected = 1)
                                                ),
                                                mainPanel(
                                                    plotOutput("plot_radar",
                                                               height = "600px")
                                                )
                                            ),
                                            
                                            tabPanel("Coffee Trivia",
                                                     br(),
                                                     fluidPage(
                                                        useShinyjs(),
                                                        uiOutput("question_home"),
                                                        uiOutput("question_one"),
                                                        uiOutput("question_two"),
                                                        uiOutput("question_three"),
                                                        uiOutput("question_four"),
                                                        uiOutput("question_five"),
                                                        uiOutput("question_six"),
                                                        uiOutput("question_seven"),
                                                        uiOutput("question_eight"),
                                                        uiOutput("question_nine"),
                                                        uiOutput("question_ten")
                                                     )
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
server <- function(input, output, session) {
    
    output$plot_map <- renderLeaflet({

        #########################################################################
        # Map
        #########################################################################
        
        # input = string of number of choice. ex. "1" for aroma, "2" for flavor
        # now it is that number. ex. 1 for aroma
        ### Take in user input: use integer input from radio selection
        map_input <- parse_number(input$radio_map)
        
        # variable name
        var_name <- c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body",
                          "Balance", "Uniformity", "Clean.Cup", "Sweetness")
        #FIX TO RIGHT LIST
        
        ### Take in user input: use integer input from radio and get string value
        # altitude_input <- country_code[parse_number(input$radio_altitude)]
        
        #put graph here, Amber
        
        # variable
        # aroma, flavor, aftertaste, acidity, sweetness, total_cup_points, kg
        v <- world2@data$flavor
        
        # Create a color palette with handmade bins
        mypalette <- colorBin( palette="YlGn",
                               domain=v,
                               na.color="transparent",
                               bins=6)
        
        # Prepare the text for tooltips:
        mytext <- paste(
            world2@data$NAME,"<br/>", 
            round(v, 2),
            # "Rating: ", round(v, 2), 
            sep="") %>%
            lapply(htmltools::HTML)
        
        # Initialize the leaflet map
        leaflet(world2) %>% 
            # Then we Add default OpenStreetMap map tiles
            addTiles() %>%
            setView( lat=10, lng=0 , zoom=1) %>%
            addPolygons( stroke = FALSE,
                         fillOpacity = 0.5,
                         smoothFactor = 0.5,
                         fillColor = ~mypalette(v),
                         label = mytext ) %>%
            addLegend( pal=mypalette,
                       values=~v,
                       opacity=0.9,
                       title = "Rating",
                       position = "bottomleft" )
    })
    
    output$plot_altitude <- renderPlot({

        #########################################################################
        # Altitude Graphs
        #########################################################################

        # Set country code
        country_code <- c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body",
                          "Balance", "Uniformity", "Clean.Cup", "Sweetness")

        ### Take in user input: use integer input from radio and get string value
        altitude_input <- country_code[parse_number(input$radio_altitude)]
        
        ### Filter out outliers, insignificant data points
        df2 <- filter(all_data, 
                    all_data$altitude_mean_meters <= 2000,
                    all_data[altitude_input] > 6)

        ### Refine data to plot 
        names(df2)[names(df2) == altitude_input] <- "x"


        ### Scatterplot
        ggplot(df2, aes(x=df2$altitude_mean_meters, y=df2$x)) +
        
        geom_point(size= 2, color="darkslateblue", alpha=0.8) +
        geom_smooth(method=lm, color="black") +
        
        ggtitle(label = paste("Effect of Altitude on Arabica", altitude_input),
                subtitle = "Project Coffee") +
        
        theme_bw() +
        
        xlab("Altitude (meters)") + ylab(paste(altitude_input, "Reviews")) +
        
        theme(plot.title = element_text(hjust = 0.5, 
                                        margin=margin(10,0,5,0), size=18),
                
                plot.subtitle = element_text(hjust = 0.5, 
                                            margin=margin(0,0,15,0)),
                legend.position = "none",
                
                axis.title.x = element_text(family = "sans", 
                                            size = 11, 
                                            margin=margin(15,0,0,0)), 
                
                axis.title.y = element_text(family = "sans", 
                                            size = 11, 
                                            margin=margin(0,15,0,0)))
    })
    
    output$plot_radar <- renderPlot({
        
        #########################################################################
        # Radar Charts
        #########################################################################

        radar_country <- input$radar_country

        ### Attain mean values for each variable for every country
        df_mean <- aggregate(all_data[21:29], 
                            list(all_data$Country.of.Origin), 
                            FUN=mean)

        ### Take in user input: country of interest (string value)
        cntry_oi <- radar_country

        ### Select and filter the data for the cntry_oi
        cnt_mean <- filter(df_mean, df_mean$Group.1 == cntry_oi) %>%
        select(-Group.1)

        ### Prepare df
        cnt_mean <- rbind(rep(10,10) , rep(6,10) , cnt_mean)

        ### Radar Chart
        radarchart(cnt_mean, axistype=1,
                
                #custom polygon
                pcol=rgb(0.25,0.1,0.1,0.8), 
                pfcol=rgb(0.3,0.1,0.1,0.5) , 
                plwd=3 , 
                
                #custom the grid
                cglcol="grey", 
                cglty=1, 
                axislabcol="grey", 
                caxislabels=seq(6,10,1), 
                cglwd=0.8,
                
                #custom labels
                vlcex=0.6 ,
                cex.main = 1.5,
                title=cntry_oi)
    })
    
    output$plot_stacked <- renderPlot({
        
        #########################################################################
        # Stacked Bar Charts
        #########################################################################
        
        country_list <- input$stack_country
        factor_list <- input$checkbox_stack
        
        # data <- filter(BarAvg,
        #                )
        # put graph here, Tae  
    })
    
    # Visualization for Trivia Game
    output$question_home <- renderUI({
        div(id = "this_home",
            h1("Welcome!"),
            p("Test your knowledge of coffee by answering 10 trivia questions!"),
            #br(),
            actionButton("button_start", "Start")
        )
    })
    
    observeEvent(input$button_start, {
        shinyjs::hide(id = "this_home")
        shinyjs::show(id = "one")
    })
    
    
    # Question 1
    output$question_one <- renderUI({
        div(id = "one", hidden = TRUE,
            h3("Question 1"),
            p("Which country produces the most coffee?"),
            img(src = "coffee_map.jpg",
                height = "300", 
                width = "100%"),
            br(), br(),
            radioButtons("radio_one",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Colombia" = 1, 
                                        "Brazil" = 2, 
                                        "Jamaica" = 3,
                                        "Ethiopia" = 4)
                         ),   
            textOutput("answer_one"),
            disabled(actionButton("button_one", "Next Question"))
            
        )
    })
    
    observeEvent(input$button_one, {
        shinyjs::hide(id = "one")
        shinyjs::show(id = "two")
    })
    
    observeEvent(input$radio_one, {
        shinyjs::enable("button_one")
        shinyjs::disable("radio_one")
        output$answer_one <- renderText(
            if(input$radio_one == 2){
                "Correct"   
            }
            else{
                "Incorrect"
            }
            
        )
    })
    
    
    # Question 2
    output$question_two <- renderUI({
        div(id = "two", hidden = TRUE,
            h3("Question 2"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_two", "Next Question")
        )
    })
    
    observeEvent(input$button_two, {
        shinyjs::hide(id = "two")
        shinyjs::show(id = "three")
    })
    
    
    # Question 3
    output$question_three <- renderUI({
        div(id = "three", hidden = TRUE,
            h3("Question 3"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_three", "Next Question")
        )
    })
    
    observeEvent(input$button_three, {
        shinyjs::hide(id = "three")
        shinyjs::show(id = "four")
    })
    
    
    # Question 4
    output$question_four <- renderUI({
        div(id = "four", hidden = TRUE,
            h3("Question 4"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_four", "Next Question")
        )
    })
    
    observeEvent(input$button_four, {
        shinyjs::hide(id = "four")
        shinyjs::show(id = "five")
    })
    
    
    # Question 5
    output$question_five <- renderUI({
        div(id = "five", hidden = TRUE,
            h3("Question 5"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_five", "Next Question")
        )
    })
    
    observeEvent(input$button_five, {
        shinyjs::hide(id = "five")
        shinyjs::show(id = "six")
    })
    
    
    # Question 6
    output$question_six <- renderUI({
        div(id = "six", hidden = TRUE,
            h3("Question 6"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_six", "Next Question")
        )
    })
    
    observeEvent(input$button_six, {
        shinyjs::hide(id = "six")
        shinyjs::show(id = "seven")
    })
    
    
    # Question 7
    output$question_seven <- renderUI({
        div(id = "seven", hidden = TRUE,
            h3("Question 7"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_seven", "Next Question")
        )
    })
    
    observeEvent(input$button_seven, {
        shinyjs::hide(id = "seven")
        shinyjs::show(id = "eight")
    })
    
    
    # Question 8
    output$question_eight <- renderUI({
        div(id = "eight", hidden = TRUE,
            h3("Question 8"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_eight", "Next Question")
        )
    })
    
    observeEvent(input$button_eight, {
        shinyjs::hide(id = "eight")
        shinyjs::show(id = "nine")
    })
    
    
    # Question 9
    output$question_nine <- renderUI({
        div(id = "nine", hidden = TRUE,
            h3("Question 9"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br(),
            actionButton("button_nine", "Next Question")
        )
    })
    
    observeEvent(input$button_nine, {
        shinyjs::hide(id = "nine")
        shinyjs::show(id = "ten")
    })
    
    # Question 10
    output$question_ten <- renderUI({
        div(id = "ten", hidden = TRUE,
            h3("Question 10"),
            p("Lorem ipsum dolor sit amet, consectetur adipiscing elit. "),
            br()
            #actionButton("button_ten", "Next Question")
        )
    })
    
    # observeEvent(input$button_ten, {
    #     shinyjs::hide(id = "two")
    #     shinyjs::show(id = "three")
    # })
    
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
