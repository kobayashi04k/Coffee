library(tidyverse)
library(shiny)
library(shinythemes)
library(shinyjs)
library(leaflet)
library(fmsb)
library(rgdal)
library(tigris)

### Read in the dataset
all_data <- read_csv("data/arabica_data_cleaned.csv")

# MAP SETUP
coffee_avgs2 <- read_csv("data/coffee_avgs2.csv")

stack_data <- read_csv("data/stack_data.csv")


# Read world shape file with the rgdal library

world2 <- readOGR( 
    dsn = paste0(getwd(),"/data/world_shape_file"), 
    layer = "TM_WORLD_BORDERS_SIMPL-0.3",
    verbose = FALSE
)

# Add country average data to world2
world2 <- geo_join(world2,
                   coffee_avgs2,
                   by = "FIPS",
                   how = "left")


# Define UI for application that draws a histogram
ui <- fluidPage(
    #shinythemes::themeSelector(),
    fluidRow(

        navbarPage(NULL, 
                   theme = shinytheme("yeti"),
                   
                   tabPanel("Introduction",
                            tags$img(
                              src = "half.jpg",
                              style = 'position: absolute; opacity: 0.7; margin-top: -25px; margin-left: -15px',
                              width = '100%',
                              height = '94%'
                            ),
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
                                # column(5,
                                #        br(), br(), br(), br(),
                                #        img(src = "background.jpg",
                                #            height = "500",
                                #            width = "100%")
                                # )
                            ),
                   tabPanel("Design Process",
                            column(1),
                            column(10,
                                   h3("Design Process"),
                                   br(),
                                   fluidRow(
                                       HTML('<center><h4>Process Map</h4></center>'),
                                       br(),
                                       HTML('<center><img src="Process_Map.png" width="400"></center>'),
                                       br(),
                                       HTML('<center>
                                                <p>
                                                 We began our project by mapping out all of the components in a timeline using a process map. 
                                                  We broke the project up into 4 weeks, and created a visual diagram showing what we would accomplish 
                                                  each week. We didn\'t end up sticking to this timeline exactly, however it provided us with a structure 
                                                  to follow. We spent week 1 making the process map, finding our dataset, and planning for the remaining weeks. 
                                                  During weeks 2 and 3, we planned out how our app would function, what visualizations we would use, and 
                                                  started development. In week 4, we finished development of the visualizations as well as the rest of the app, 
                                                  and documented the project.
                                                </p>
                                            </center>')
                                   ),
                                   br(),br(),
                                   fluidRow(
                                       HTML('<center><h4>Journey Map</h4></center>'),
                                       br(),
                                       HTML('<center><img src="Journey_Map.png" width="400"></center>'),
                                       br(),
                                       HTML('<center>
                                                <p>
                                                 An important step in week 2 was creating a journey map. This table maps out how we 
                                                  expect our users to interact with the app, their feelings along the way, and types of 
                                                  improvement we can make to the app. We defined our target users as researchers or 
                                                  other individuals curious about exploring data on coffee, and we mapped out how 
                                                  their interactions with the app can help them learn about the dataset and gain insight 
                                                  about coffee.
                                                </p>
                                            </center>')
                                   ),
                                   br(),br(),
                                   fluidRow(
                                       HTML('<center><h4>Wireframes</h4></center>'),
                                       br(),
                                       HTML('<center><img src="Wireframe2.jpg" width="400"></center>'),
                                       br(),
                                       HTML('<center>
                                                <p>
                                                 Also in week 2 we created wireframes to roughly sketch out what we wanted our app 
                                                  to look like. The image above is of the wireframe for one of the data visualization tabs. 
                                                  We drew the wireframes on paper, and they show the way we wanted to lay out text, 
                                                  images, visualizations, and interactive elements on the different screens of the app. We 
                                                  broke the content of the app into the 5 outer tabs, and then we added a sub-tab for 
                                                  each visualization under Visualizations.
                                                </p>
                                            </center>')
                                   ),
                                   br(),br(),
                                   fluidRow(
                                       HTML('<center><h4>Screen Mockup</h4></center>'),
                                       br(),
                                       HTML('<center><img src="Slide1.png" width="400"></center>'),
                                       br(),
                                       HTML('<center>
                                                <p>
                                                 The next step was creating the screen mockup. We originally planned to complete this 
                                                  during week 3, however we were able to do it ahead of schedule, in week 2. In the 
                                                  screen mockup, we took the structure and layout from the wireframes and mocked up 
                                                  what we wanted them to visually look like. We chose a color scheme, layed out the text, 
                                                  and added images to make the mockup look similar to our plan for the finished app. 
                                                  The image above is the screen mockup for the Introduction tab.
                                                </p>
                                            </center>')
                                   ),
                                   br(),br(),
                                   fluidRow(
                                       HTML('<center><h4>Accessibility Audit</h4></center>'),
                                       br(),
                                       HTML('<center>
                                                <p>
                                                 Many aspects of the app are reasonably accessible. A major part of this is that using 
                                                  the app does not take a high cognitive load; explanation text by the visualizations 
                                                  helps users understand how they work, section headings and images in the text-heavy 
                                                  tabs help users quickly take in the information, users have as much time as they need 
                                                  to read the content, and the tabs are ordered in a logical progression through the app. 
                                                  The layout is simple and easy to understand, and the app has responsive design. 
                                                  Additionally, the majority of the tabs have good high-contrast text.
                                                </p>
                                                <p>
                                                However, there are also several areas that we could make more accessible. Firstly, the 
                                                Introduction tab uses a background image that reduced the contrast of the text. To 
                                                make this tab more accessible, we could remove the image behind the text so the text 
                                                is on a white background. Next, some of the data visualizations, for example the 
                                                stacked bar chart, use color alone to show information. To avoid this, we could add a 
                                                pattern to each color so the data is encoded multiple ways. Also, the app is not 
                                                navigatable by keyboard, and there is no alternate text for the images. Adding both of 
                                                these functionalities would improve accessibility.
                                                </p>
                                            </center>'),
                                       br()
                                   )
                                )
                            
                            ),
                   tabPanel("Visualizations",
                                tabsetPanel(type = "tabs",
                                            tabPanel("Map",
                                                     br(),
                                                     sidebarPanel(
                                                         width = 2,
                                                         radioButtons("radio_map",
                                                                      label = h5("Review Factors"),
                                                                      choices = list("Aroma" = 1, 
                                                                                     "Flavor" = 2, 
                                                                                     "Aftertaste" = 3, 
                                                                                     "Acidity" = 4, 
                                                                                     "Sweetness" = 5, 
                                                                                     "Total Cup Points" = 6, 
                                                                                     "Total Kg" = 7),
                                                                      selected = 1
                                                         )
                                                     ),
                                                     mainPanel(
                                                       wellPanel(
                                                         leafletOutput("plot_map")
                                                       ),
                                                       p("Use this map to explore how geography affects various factors of the coffee reviews. 
                                                         Select a factor to view each country's average score.")
                                                     )
                                            ),
                                            tabPanel("Altitude Graph", 
                                                     br(),
                                                     sidebarPanel(
                                                         width = 2,
                                                         radioButtons("radio_altitude", 
                                                                      label = h5("Review Factors"),
                                                                      choices = list("Aroma" = 1, 
                                                                                     "Flavor" = 2, 
                                                                                     "Aftertaste" = 3,
                                                                                     "Acidity" = 4, 
                                                                                     "Body" = 5, 
                                                                                     "Balance" = 6,
                                                                                     "Uniformity" = 7, 
                                                                                     "Clean Cup" = 8, 
                                                                                     "Sweetness" = 9), 
                                                                      selected = 1)
                                                     ),
                                                     mainPanel(
                                                       wellPanel(
                                                         plotOutput("plot_altitude")
                                                       ),
                                                       p("Note:")
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
                                                                ),
                                                    checkboxGroupInput("checkbox_stack", 
                                                                       label = h5("Variables To Show"), 
                                                                       choices = list("Aroma" = 1,
                                                                                      "Flavor" = 2,
                                                                                      "Aftertaste" = 3,
                                                                                      "Acidity" = 4,
                                                                                      "Body" = 5,
                                                                                      "Balance" = 6,
                                                                                      "Uniformity" = 7,
                                                                                      "Cleaness" = 8,
                                                                                      "Sweetness" = 9,
                                                                                      "Cup Points" = 10),
                                                                       selected = 1)
                                                ),
                                                mainPanel(
                                                  wellPanel(
                                                    plotOutput("plot_stack")
                                                  ),
                                                  p("Note:")
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
                                                  wellPanel(
                                                    plotOutput("plot_radar",
                                                               height = "450px")
                                                  ),
                                                  p("Note:")
                                                )
                                            ),
                                            
                                            tabPanel("Coffee Trivia",
                                                     br(),
                                                     wellPanel(
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
                                                        uiOutput("question_ten"),
                                                        uiOutput("see_results")
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
        
        # variable name list
        var_names <- c("Aroma", "Flavor", "Aftertaste", "Acidity", "Sweetness",
                          "Total Cup Points", "Total Kg")
        
        # variable list
        vars <- c('aroma', 'flavor', 'aftertaste',
                  'acidity', 'sweetness',
                  'total_cup_points', 'kg')

        ### Take in user input: use integer input from radio and get string value
        # altitude_input <- country_code[parse_number(input$radio_altitude)]
        
        
        # set variable and name
        v <- get(vars[map_input], world2@data)
        
        v_name <- var_names[map_input]
        
        # Create a color palette with handmade bins
        mypalette <- colorBin(palette="YlGn",
                              domain=v,
                              na.color="transparent",
                              bins=6)
        
        # Prepare the text for tooltips
        mytext <- paste(
            world2@data$NAME,"<br/>", 
            v_name, ": ", round(v, 2),
            sep="") %>%
            lapply(htmltools::HTML)
        
        # Initialize the leaflet map
        world_map <- leaflet(world2) %>%
                     addTiles() %>%
                     setView(lat=10, lng=0 , zoom=1) %>%
                     addPolygons(stroke = FALSE,
                                 fillOpacity = 0.5,
                                 smoothFactor = 0.5,
                                 fillColor = ~mypalette(v),
                                 label = mytext ) %>%
                     addLegend(pal = mypalette,
                               values = ~v,
                               opacity = 0.9,
                               title = v_name,
                               position = "bottomleft" )
    })
    
    output$plot_altitude <- renderPlot({

        #########################################################################
        # Altitude Graphs
        #########################################################################

        # Set factor code
        factor_code <- c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body",
                          "Balance", "Uniformity", "Clean.Cup", "Sweetness")

        ### Take in user input: use integer input from radio and get string value
        altitude_input <- factor_code[parse_number(input$radio_altitude)]
        
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
    
    output$plot_stack <- renderPlot({
        
        #########################################################################
        # Stacked Bar Charts
        #########################################################################
        
        factors <- c("Aroma", "Flavor", "Aftertaste", "Acidity", "Body",
                        "Balance", "Uniformity", "Clean", "Sweetness", "Cup Points")
      
        country_list <- input$stack_country
        factor_list <- input$checkbox_stack
        
        for(i in 1:length(factor_list)){
          factor_list[i] <- factors[parse_number(factor_list[i])]
        }
        
        stack_data_filter <- stack_data %>%
                             filter(Country %in% country_list,
                                    Variable %in% factor_list)
        
        ggplot(stack_data_filter, 
               aes(x = Country, 
                   y = Value,
                   fill = Variable)) +
          geom_col() + 
          theme(axis.text.x = element_text(angle = 45, hjust = 1))
        
    })
    
    # Visualization for Trivia Game
    
    #score <- reactiveVal(0)
    #score <- 0
    
    output$question_home <- renderUI({
        div(id = "this_home",
            align = "center",
            h1("Welcome!"),
            p("Test your knowledge of coffee by answering 10 trivia questions!"),
            actionButton("button_start", "Start")
        )
    })
    
    observeEvent(input$button_start, {
        shinyjs::hide(id = "this_home")
        shinyjs::show(id = "one")
    })
    
    
    #########################################################################
    # Question 1
    #########################################################################
    
    output$question_one <- renderUI({
        div(id = "one", hidden = TRUE,
            align = "center",
            h3("Question 1"),
            p("Which country produces the most coffee?"),
            img(src = "coffee_map.jpg",
                height = "300", 
                width = "50%"),
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
            br(),
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
        # if(input$radio_one == 2){
        #   score <<- score + 1
        # }
        output$answer_one <- renderText(
            if(input$radio_one == 2){
                "Correct! Brazil produces 40% of the world's coffee."
            }
            else{
                "Incorrect. The correct answer is Brazil, where 40% of the world's coffee is produced."
            }
            
        )
    })
    
    
    #########################################################################
    # Question 2
    #########################################################################
    
    output$question_two <- renderUI({
        div(id = "two", hidden = TRUE,
            h3("Question 2"),
            align = "center",
            p("What do coffee beans grow on?"),
            img(src = "plant.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_two",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Vines" = 1, 
                                        "A tree" = 2, 
                                        "A bush" = 3,
                                        "The roots of the coffee plant" = 4)
            ),   
            textOutput("answer_two"),
            br(),
            disabled(actionButton("button_two", "Next Question"))
        )
    })
    
    observeEvent(input$button_two, {
        shinyjs::hide(id = "two")
        shinyjs::show(id = "three")
    })
    
    observeEvent(input$radio_two, {
        shinyjs::enable("button_two")
        shinyjs::disable("radio_two")
        # if(input$radio_two == 3){
        #   score <<- score + 1
        # }
        output$answer_two <- renderText(
            if(input$radio_two == 3){
                "Correct! Coffee grows on a bush, and they take around three to four years to grow."   
            }
            else{
                "Incorrect. Coffee beans actually grow on a bush."
            }
            
        )
    })
    
    
    #########################################################################
    # Question 3
    #########################################################################
    
    output$question_three <- renderUI({
        div(id = "three", hidden = TRUE,
            align = "center",
            h3("Question 3"),
            p("This coffee bean shares the same name as a programming language."),
            img(src = "java_coffee.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_three",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Java" = 1, 
                                        "Ruby" = 2, 
                                        "Julia" = 3,
                                        "Rust" = 4)
            ),   
            textOutput("answer_three"),
            br(),
            disabled(actionButton("button_three", "Next Question"))
        )
    })
    
    observeEvent(input$button_three, {
        shinyjs::hide(id = "three")
        shinyjs::show(id = "four")
    })
    
    observeEvent(input$radio_three, {
        shinyjs::enable("button_three")
        shinyjs::disable("radio_three")
        # if(input$radio_three == 1){
        #   score <<- score + 1
        #   print(score)
        # }
        output$answer_three <- renderText(
            if(input$radio_three == 1){
                "Correct. The creators of Java, initially named Oak, renamed their project to be based on the Java coffee bean (an Indonesian coffee)."   
            }
            else{
                "Incorrect. The correct answer is Java, named after the Indonesian coffee bean."
            }
            
        )
    })
    
    
    #########################################################################
    # Question 4
    #########################################################################
    
    output$question_four <- renderUI({
        div(id = "four", hidden = TRUE,
            align = "center",
            h3("Question 4"),
            p("Most coffees are a blend of..."),
            img(src = "arabica_robusta.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_four",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Light and dark roasts" = 1, 
                                        "Caffeine and essential oils" = 2, 
                                        "Arabica and robusta beans" = 3,
                                        "African and South American beans" = 4)
            ),   
            textOutput("answer_four"),
            br(),
            disabled(actionButton("button_four", "Next Question"))
        )
    })
    
    observeEvent(input$button_four, {
        shinyjs::hide(id = "four")
        shinyjs::show(id = "five")
    })
    
    observeEvent(input$radio_four, {
        shinyjs::enable("button_four")
        shinyjs::disable("radio_four")
        # if(input$radio_four == 3){
        #   score <<- score + 1
        # }
        output$answer_four <- renderText(
            if(input$radio_four == 3){
                "Correct. There are many beans out there, but the only two that are processed for drinking are Robusta and Arabica.
              Arabica beans are sweeter and softer with a higher level of acidity, while Robusta beans are stronger and more bitter."   
            }
            else{
                "Incorrect. Robusta and Arabica are the two most common beans processed for drinking."
            }
            
        )
    })
    
    #########################################################################
    # Question 5
    #########################################################################
    
    output$question_five <- renderUI({
        div(id = "five", hidden = TRUE,
            align = "center",
            h3("Question 5"),
            p("The world's most expensive coffee costs around how much?"),
            img(src = "expensive.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_five",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("$250/pound" = 1, 
                                        "$500/pound" = 2, 
                                        "$750/pound" = 3,
                                        "$1,000/pound" = 4)
            ),   
            textOutput("answer_five"),
            br(),
            disabled(actionButton("button_five", "Next Question"))
        )
    })
    
    observeEvent(input$button_five, {
        shinyjs::hide(id = "five")
        shinyjs::show(id = "six")
    })
    
    observeEvent(input$radio_five, {
        shinyjs::enable("button_five")
        shinyjs::disable("radio_five")
        # if(input$radio_five == 2){
        #   score <<- score + 1
        # }
        output$answer_five <- renderText(
            if(input$radio_five == 2){
                "Correct! The Kopi Luwak is the world's most expensive coffee. The bean is plucked from civets' feces."   
            }
            else{
                "Incorrect. The Kopi Luwak is the world's most expensive coffee. The bean is plucked from civets' feces."
            }
            
        )
    })
    
    
    #########################################################################
    # Question 6
    #########################################################################
    
    output$question_six <- renderUI({
        div(id = "six", hidden = TRUE,
            align = "center",
            h3("Question 6"),
            p("Which country drinks the most coffee?"),
            img(src = "drinking_coffee.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_six",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Sweden" = 1, 
                                        "Norway" = 2, 
                                        "Iceland" = 3,
                                        "Finland" = 4)
            ),   
            textOutput("answer_six"),
            br(),
            disabled( actionButton("button_six", "Next Question"))
        )
    })
    
    observeEvent(input$button_six, {
        shinyjs::hide(id = "six")
        shinyjs::show(id = "seven")
    })
    
    observeEvent(input$radio_six, {
        shinyjs::enable("button_six")
        shinyjs::disable("radio_six")
        # if(input$radio_six == 4){
        #   score <<- score + 1
        # }
        output$answer_six <- renderText(
            if(input$radio_six == 4){
                "Correct! Finland consumes the most coffee in the entire world with each person drinking 12.5 kg of coffee."   
            }
            else{
                "Incorrect. The correct answer is Finland, where each person drinks around 12.5 kg of coffee."
            }
            
        )
    })
    
    #########################################################################
    # Question 7
    #########################################################################
    
    output$question_seven <- renderUI({
        div(id = "seven", hidden = TRUE,
            align = "center",
            h3("Question 7"),
            p("Espresso in Italian means..."),
            img(src = "espresso.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_seven",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Forced Out" = 1, 
                                        "Speed Up" = 2, 
                                        "Roast" = 3,
                                        "Heat Up" = 4)
            ),   
            textOutput("answer_seven"),
            br(),
            disabled(actionButton("button_seven", "Next Question"))
        )
    })
    
    observeEvent(input$button_seven, {
        shinyjs::hide(id = "seven")
        shinyjs::show(id = "eight")
    })
    
    observeEvent(input$radio_seven, {
        shinyjs::enable("button_seven")
        shinyjs::disable("radio_seven")
        # if(input$radio_seven == 1){
        #   score <<- score + 1
        #   print(score)
        # }
        output$answer_seven <- renderText(
            if(input$radio_seven == 1){
                "Correct! In Italian, the word espresso literally means \"when something is forced out.\""   
            }
            else{
                "Incorrect. Espresso actually means \"to force out\" in Italian"
            }
            
        )
    })
    
    
    #########################################################################
    # Question 8
    #########################################################################
    
    output$question_eight <- renderUI({
        div(id = "eight", hidden = TRUE,
            align = "center",
            h3("Question 8"),
            p("What percent of American adults consume coffee every day?"),
            img(src = "american_coffee.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_eight",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("20%" = 1, 
                                        "40%" = 2, 
                                        "60%" = 3,
                                        "80%" = 4)
            ),   
            textOutput("answer_eight"),
            br(),
            disabled(actionButton("button_eight", "Next Question"))
        )
    })
    
    observeEvent(input$button_eight, {
        shinyjs::hide(id = "eight")
        shinyjs::show(id = "nine")
    })
    
    observeEvent(input$radio_eight, {
        shinyjs::enable("button_eight")
        shinyjs::disable("radio_eight")
        # if(input$radio_eight == 3){
        #   score <<- score + 1
        #   print(score)
        # }
        output$answer_eight <- renderText(
            if(input$radio_eight == 3){
                "Correct! According to a study conducted by the NCA, 64% of American adults consume coffee every day."   
            }
            else{
                "Incorrect"
            }
            
        )
    })
    
    
    #########################################################################
    # Question 9
    #########################################################################
    
    output$question_nine <- renderUI({
        div(id = "nine", hidden = TRUE,
            align = "center",
            h3("Question 9"),
            p("How old is instant coffee?"),
            img(src = "time.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_nine",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("100 years old" = 1, 
                                        "150 years old" = 2, 
                                        "200 years old" = 3,
                                        "250 years old" = 4)
            ),   
            textOutput("answer_nine"),
            br(),
            disabled(actionButton("button_nine", "Next Question"))
        )
    })
    
    observeEvent(input$button_nine, {
        shinyjs::hide(id = "nine")
        shinyjs::show(id = "ten")
    })
    
    observeEvent(input$radio_nine, {
        shinyjs::enable("button_nine")
        shinyjs::disable("radio_nine")
        # if(input$radio_nine == 4){
        #   score <<- score + 1
        #   print(score)
        # }
        output$answer_nine <- renderText(
            if(input$radio_nine == 4){
                "Correct! Instant coffee is nearly 250 years old, where it made it debuts in England in 1771."   
            }
            else{
                "Incorrect. Instant coffee is actually 250 years old, where it made it debuts in England in 1771."
            }
            
        )
    })
    
    #########################################################################
    # Question 10
    #########################################################################
    
    output$question_ten <- renderUI({
        div(id = "ten", hidden = TRUE,
            align = "center",
            h3("Question 10"),
            p("Which two states produce America's coffee?"),
            img(src = "us_map.jpg",
                height = "300", 
                width = "50%"),
            br(),br(),
            radioButtons("radio_ten",
                         label = NULL,
                         inline = TRUE,
                         selected = character(0),
                         choices = list("Hawaii and California" = 1, 
                                        "Hawaii and Florida" = 2, 
                                        "Arizona and Florida" = 3,
                                        "California and Florida" = 4)
            ),   
            textOutput("answer_ten"),
            br(),
            #actionButton("button_ten", "See Results")
        )
    })
    
    observeEvent(input$radio_ten, {
        shinyjs::enable("button_ten")
        shinyjs::disable("radio_ten")
        # if(input$radio_ten == 1){
        #   score <<- score + 1
        #   print(score)
        # }
        output$answer_ten <- renderText(
            if(input$radio_ten == 1){
                "Correct! Hawaii and California are the only two states that produce coffee. Hawaii used to be the sole producer, but coffee plants were introduced in California in the early 2000s."   
            }
            else{
                "Incorrect. Hawaii and California are the only two states that produce coffee. Hawaii used to be the sole producer, but coffee plants were introduced in California in the early 2000s."
            }
            
        )
    })
    
    # observeEvent(input$button_ten, {
    #     shinyjs::hide(id = "ten")
    #     shinyjs::show(id = "results")
    # })
    
    #########################################################################
    # See Results
    #########################################################################
    
    
    # output$see_results <- renderUI({
    #   
    #   div(id = "results",
    #       hidden = TRUE,
    #       align = "center",
    #       h3("Results"),
    #       p("You scored a"),
    #       h1(gsub(" ", "", paste(score*10,"%"))),
    #       
    #   )
    # })
    
    
}

# Run the application 
shinyApp(ui = ui, server = server)
