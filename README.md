## Shiny App to Code Qualitative ESM data

Here we provide a shiny app that can be used by other researchers to
code qualitative ESM data based on a given coding scheme. It contains
several columns showing the raw observation (see screenshots below
“activity_open”), the given code (“Code”), and additional information
(such as feelings or who the activity was with). Our codes have a
hierarchical structure and are therefore displayed in different colors.

<img src="Example_app1.jpg" width="856" />

The codes appear interactively as you type.

<img src="Example_app2.png" width="326" />

To use this app, please download and open the app.R file. If desired,
you can also download a codebook. We currently provide two options, one
based on Stadel et al. 2024 (see
<https://annalangener.github.io/QualitativeVis/>) and one based on
Skimina et al. 2020 (see
<https://annalangener.github.io/QualitativeVis/Skimina.html>). It is
also possible to use your own codebook.

The app runs locally, so there are no privacy concerns when using it.

## How to use this app?

In the following sections we explain how to set-up this app.

#### 1) Select the folder in which the codebook is stored and the results will be saved

``` r
# 1. Select the folder in which the codebook is stored and the results will be saved
Projectwd <- "/Users/annalangener/Nextcloud/Shared/Testing Methods to Capture Social Context/Qualitative context/3. Coding/QualitativeCoding_Activies/"
```

#### 2) Select the coding scheme that you want to use.

``` r
# 2. Select the coding scheme that you want to use. 
# You can choose our proposed coding scheme, the coding scheme proposed by Skimina et al., or you own by specify the path where the codebook is stored
# IMPORTANT: The codes need to be in a column named "Code" and if levels are included, those need to be in a column called "Level"
#Codebook_Act <- read_excel(paste(Projectwd,"Codebook_shared_activities.xlsx",sep =""), sheet = 1)
Codebook <- "Codebook_Stadeletal.csv" # Needed
Codebook_Act <- read.csv(paste(Projectwd,Codebook,sep =""))
```

#### 3) Select the path where the data is stored.

``` r
# 3. Select the path where the data is stored
Data <- read.csv(paste(Projectwd,"Data/act_coding_ALL.csv",sep = ""))[,-1]
# The dataframe should be sorted by Date, to allow for context coding
#Data <-  Data %>% arrange(ppID, timeStampStart)
#write.csv(Data,paste(Projectwd,"Data/act_coding_ALL.csv",sep = ""))
```

#### 4) Select who is coding.

``` r
# 4. Select who is coding (a folder will be created if this is a new person)
User <- "Anna_TestCoding"  # "Marie_FullCoding", "Marie", "Anna"
```

#### 5) Select the folder in which the codebook is stored and the results will be saved

``` r
# 5. Indicate how you column is named that includes the participant IDs and select the participant of interest
id_column = "ppID" # Change the name of the column here
ppID <- 106 
```

#### 6) Indicate whether your codebook contains different levels?

``` r
# 6. Indicate whether your codebook contains different levels?
Levels = TRUE

# 7. Click "Run App"
```

#### 7) Click “Run App”

``` r
# 7. Click "Run App"
```

#### 
