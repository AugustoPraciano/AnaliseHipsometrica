rm(list = ls(all = TRUE)) # Limpar área de Trabalho
# Definir diretorio de trabalho
setwd ("C:/analise_hidrologica/curva_hipsometrica/")
getwd()

# Carregar os pacotes necessários
library(dplyr) # mutate function 

###################################################################################
########################### Preparação dos dados ##################################
###################################################################################

# Listar arquivos .csv no diretório
files <- list.files(pattern = "*.csv", full.names = TRUE)

# definir a pasta de saída
output <- "C:/analise_hidrologica/curva_hipsometrica/processados"

# Função para processar cada arquivo
PrepData <- function(Hicsv) {
  # Ler o arquivo CSV
  data <- read.csv(Hicsv, stringsAsFactors = FALSE)
  
  # Criar a coluna 'AreaPercent' para extrair frequência simples em % de área
  data <- data %>%
    mutate(AreaPercent = Area - lead(Area, default = last(Area)))
  # subitituir o último valor da coluna 'AreaPercent' pelo valor correspondente de 'Area'
  data$AreaPercent[nrow(data)] <- data$Area[nrow(data)]
  # Criar a coluna 'W' (multiplicação da coluna 'AreaPercent' pela coluna 'Elevacao')
  data <- data %>%
    mutate(W = Elevacao * AreaPercent)
  
  # Definir o nome do arquivo de saída
  output_name <- file.path(output, basename(Hicsv))
  
  # Salvar o arquivo com as novas colunas na pasta de saída
  write.csv(data, output_name, row.names = FALSE)
}

# Aplicar a função a todos os arquivos .csv
lapply(files, PrepData)

cat("Processamento concluído!")

###################################################################################
###################### Cálculo da Integral e Curva Hipsométrica ###################
###################################################################################

# Listar arquivos .csv no diretório
basins <- list.files(path = output, pattern = "*.csv", full.names = TRUE)

# Criar Dataframe vazio para armazenar resultados de Hi
Hiresults <- data.frame(Nome_Arquivo = character(),
                         Hi = numeric(),
                         stringsAsFactors = FALSE)

# Defir número de elemento no gráfico vertical e horizontal
par(mfrow = c(2, 3))

# Loop sobre os arquivos .csv
for (b in basins[1:6]) {  # Limitado a 6 arquivos para gerar 6 gráficos simultaneamente
  # Ler cada arquivo .csv
  basin <- read.csv(b)

  # Calcular altitude média (Zm), altura média(Hm)), variação da altitude(Hvar) 
  # e integral hipsometrica(Hi)
  Zm <- sum(basin$W) / 100
  Hm <- Zm - min(basin$Elevacao)
  Hvar <- max(basin$Elevacao) - min(basin$Elevacao)
  Hi <- round(Hm / Hvar, 2)  # Arredondando Hi para duas casas decimais
 
  # Nome do arquivo para título do gráfico
  nome_arquivo <- strsplit(basename(b), ".csv")[[1]][1]
  
  # Adicionar os resultados no dataframe
  Hiresults <- rbind(Hiresults, data.frame(Nome_Arquivo = nome_arquivo, Hi = Hi))
  
  # Plotar o gráfico para cada arquivo
  plot(basin$Area, basin$Elevacao, 
       main = paste(nome_arquivo, "\nHi =", Hi),  # Nome do arquivo + valor de Hi
       cex = 0.8, 
       pch = 16, 
       ylab = "Elevação", 
       xlab = "Área Acumulada",
       type = "l",   # Gráfico de linha contínua
	   col = "red",
	   lwd = 3)  
	   
  # Adicionar grades ao gráfico
  grid()
}

# Salvar os resultados de Hi no arquivo .csv
write.csv(Hiresults, file = "resultados_Hi.csv", row.names = FALSE)

###################################################################################
################################# Fim do Codigo ###################################
###################################################################################