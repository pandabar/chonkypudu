# Load the file with the helper functions
source("helpers.R", local = TRUE)

library(shiny)
library(DT)
library(highcharter)


ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      tags$h3("Urgencias 2024"),
      tags$hr(),
      # User can select a month in 2024
      selectInput(inputId = "inMonth", label = "Mes", choices = c("enero", "febrero", "marzo", "abril", "mayo", "junio", "julio", "agosto", "septiembre", "octubre", "noviembre", "diciembre"), selected = "enero"),
      selectInput(inputId = "Var", label = "Variable", choices = c("region", "tipo_establecimiento", "rango_edad"), selected = "region"),
      tags$hr()
  #    tags$h5("Data load time:"),
  #    textOutput(outputId = "outTextDuration")
    ),
    mainPanel(
      DTOutput(outputId = "outTable"),
      highchartOutput(outputId = "outBarChart", height = 500)
      #highchartOutput(outputId = "outChartPorTipo", height = 500)
    )
  )
)


server <- function(input, output) {
  # get table and runtime
  data <- reactive({
    getdata(
      mth = input$inMonth,
      var = input$Var
    )
  })
  
  # Duration text
 # output$outTextDuration <- renderText({
#    paste0(round(data$runtime, 2), " seconds.")
 # })
  
  # Table
  output$outTable <- renderDT({
  datatable(data = data()$data,
  colnames = c("Causa", input$Var, "n (en miles)"),
  caption = paste0("Emergencias año 2024 por ", input$Var, ", mes de ", input$inMonth, "."),
  filter = "top")})
  
  # Chart - causa x edad
 output$outBarChart <- renderHighchart({
    hchart(data()$data, "column", hcaes(x = GlosaCausa, y = n, group=!!sym(input$Var)), stacking = "normal") |>
      hc_title(text = paste0("Número de pacientes atendidos por ", input$Var), align = "left") |>
      hc_xAxis(title = list(text = "Causa")) |>
      hc_yAxis(title = list(text = paste0(input$Var, " (en miles)")))
  })
}
shinyApp(ui = ui, server = server)