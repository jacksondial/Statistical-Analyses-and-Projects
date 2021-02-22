datatable(iris, rownames = FALSE, class = 'cell-border stripe', list(lengthMenu = c(25,50,100)),
          extensions = "Responsive")
library(tidyquant)

myticker <- c("AAPL", "AMZN", "TSLA", "BA")
tq_get(myticker,
       from = "2020-05-01")

price_data %>% 
  tq_transmute(select = adjusted, 
               mutate_fun = periodReturn,
               period = "daily",
               type = "log")


return_data %>% 
  tq_portfolio(assets_col = symbol,
               returns_col = daily.returns,
               weights = tibble(asset.names = c("AAPL", "AMZN", "TSLA", "BA",
                                                weight = c(0.259,.534,.207)),
                                wealth.index = T))

PerformanceAnalytics::Return.portfolio()

