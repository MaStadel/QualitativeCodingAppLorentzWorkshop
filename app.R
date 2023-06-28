###### Load Packages

library(shiny)
library(DT)
library(readxl)
library(stringr)
library(bslib)
library(shinycssloaders)

#####################################################
########## Shiny App for Activity Coding ############

# This shiny app can be used for coding the Activities

# 1. Select the folder in which the codebook is stored and the results will be saved
Projectwd <- "/Users/annalangener/Nextcloud/Shared/Testing Methods to Capture Social Context/Qualitative context/3. Coding/QualitativeCoding_Activies/"

# 2. Select the path where the codebook is stored
Codebook_Act <- read_excel(paste(Projectwd,"Codebook_shared_activities.xlsx",sep =""), sheet = 1)

# 3. Select the path where the data is stored
Act <- read.csv(paste(Projectwd,"Data/act_coding_ALL.csv",sep = ""))[,-1]

# 4. Select who is coding
User <- "Anna"  # "Marie"

# 5. Select the participant of interest
ppID <- 103

#####################################################
#####################################################

# Here we check if the specified user already has a subfolder
if(!file.exists(paste(Projectwd,User, sep = ""))){
  dir.create(paste(Projectwd,User, sep = ""))
}

# Next we prepare the dataframe for the selected participant
Act_participant <- Act[Act$ppID == ppID,] # 326, 317, 318, 316, 309

# If the participant is selected the first time we create an empty dataframe
if(!file.exists(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))){
Empty <- data.frame(Code = rep(NA,nrow(Act_participant)), OtherComments = rep(NA,nrow(Act_participant)))
write.csv(Empty, paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))
}


# A lot of the code is copied from following github question
## https://github.com/rstudio/shiny/issues/1246


ui <- navbarPage("Qualitative Coding",
                 theme = bs_theme(version = 5, bootswatch = "minty"),
                 header = "IMPORTANT: After switching the page, don't go back to the previous page without reloading the app. Otherwise the codes will NOT BE SAVED.",
                 #Code for JS I don't understand
                 tags$head(
                   tags$script('
                  Shiny.addCustomMessageHandler("unbinding_table_elements", function(x) {                
                  Shiny.unbindAll($(document.getElementById(x)).find(".dataTable"));
                  });'
                   )
                 ),
                 tabPanel("Output",id = "Week",
                          # navlistPanel(widths = c(10, 2), "SidebarMenu",
                          #              tabPanel(selectizeInput('case', 'Pick a case', selected="A", choices = c("A", "B"), multiple = FALSE)),
                          #              tabPanel(numericInput('num', 'Number', min = 1, max = 10, value = 1, step = 1))),
                                     withSpinner(DT::dataTableOutput('Act_participant'))),
                
                 
)


server <- function(session, input, output){
  
  # Code for JS (I don't understand)
  session$sendCustomMessage(type = "unbinding_table_elements", "my_table")
  
  # Read existing Code/ Comments
  Act <- read.csv(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))[-1]
  
  ###################### Create Datatable #####################
  #############################################################
  output$Act_participant <- DT::renderDataTable({
    a <- Act_participant
    a$Code <- sapply(paste0("selectize_wrap_code",1:nrow(Act_participant)), function(x) as.character(uiOutput(x)))
    a$'Additional Information' <- sapply(paste0("selectize_wrap_additionalinfo",1:nrow(Act_participant)), function(x) as.character(uiOutput(x)))
    a$'Other/Comments' <- sapply(paste0("selectize_wrap_other",1:nrow(Act_participant)), function(x) as.character(uiOutput(x)))
    a <- datatable(a,
                   escape = F, selection = "single", 
                   options = list(paging = TRUE, ordering = FALSE, searching = FALSE, pageLength = 20,dom = 'tp',
                                  preDrawCallback = JS('function() { Shiny.unbindAll(this.api().table().node());}'),
                                  drawCallback = JS('function() { Shiny.bindAll(this.api().table().node()); } '))
    )
    return(a)
  })
  
  ################ rendering fancy selectize widgets ###############
  ##################################################################
  
  for (i in 1:nrow(Act_participant)) {
    subs_widget <- substitute({selectizeInput(paste0("selectize_code",i), NULL, choices=as.list(Codebook_Act[,1]),selected = c(unlist(str_split(Act[i,1]," ; "))),multiple = T)
    }, list(i = i))
    output[[paste0("selectize_wrap_code",i)]] <- renderUI(subs_widget, quoted = T)
    
  }
  
  for (i in 1:nrow(Act_participant)) {
    subs_widget2 <- substitute({textInput(paste0("selectize_other",i), NULL,value = c(unlist(str_split(Act[i,2]," ; "))))
    }, list(i = i))
    output[[paste0("selectize_wrap_other",i)]] <- renderUI(subs_widget2, quoted = T)
  }
  
  for (i in 1:nrow(Act_participant)) {
    subs_widget3 <- substitute({tagList(
      textInput(paste0("selectize_feelings",i), NULL, placeholder = "Feelings/ Valence",value = c(unlist(str_split(Act[i,3]," ; ")))),
      textInput(paste0("selectize_whom",i),NULL, placeholder ="With whom?",value = c(unlist(str_split(Act[i,4]," ; "))))
    )
    }, list(i = i))
    output[[paste0("selectize_wrap_additionalinfo",i)]] <- renderUI(subs_widget3, quoted = T)
  }
  
  
  
  
  ########### Save Code and Comments as soon as something changes ###########
  ###########################################################################
  
  lapply(
    X = 1:nrow(Act_participant),
    FUN = function(i){
      observeEvent(input[[paste0("selectize_code", i)]], {
        CodeNew <-  read.csv(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))[,-1]
        CodeNew[i,1] <- paste(input[[paste0("selectize_code", i)]], collapse = " ; ")
        write.csv(CodeNew, file = paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""),row.names=TRUE)
      })
    })
  
  lapply(
    X = 1:nrow(Act_participant),
    FUN = function(i){
      observeEvent(input[[paste0("selectize_feelings", i)]], {
        Feelings <- read.csv(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))[,-1]
        Feelings[i,3] <- paste(input[[paste0("selectize_feelings", i)]], collapse = " ; ")
        write.csv(Feelings, file = paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""),row.names=TRUE)
      })
    })
  
  lapply(
    X = 1:nrow(Act_participant),
    FUN = function(i){
      observeEvent(input[[paste0("selectize_whom", i)]], {
        Whom <- read.csv(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))[,-1]
        Whom[i,4] <- paste(input[[paste0("selectize_whom", i)]], collapse = " ; ")
        write.csv(Whom, file = paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""),row.names=TRUE)
      })
    })
  
  
  
  lapply(
    X = 1:nrow(Act_participant),
    FUN = function(i){
      observeEvent(input[[paste0("selectize_other", i)]], {
        Other_Comments <- read.csv(paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""))[,-1]
        Other_Comments[i,2] <- paste(input[[paste0("selectize_other", i)]], collapse = " ; ")
        write.csv(Other_Comments, file = paste(Projectwd,User,"/Act_",ppID,".csv",sep = ""),row.names=TRUE)
      })
    })
  
  
}

shinyApp(ui, server)


