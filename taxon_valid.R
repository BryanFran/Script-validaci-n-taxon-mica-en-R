#=============================
# Este es un scrip para validar informacion taxonomica de cualquier categoria 
# utilizando 13 fuentes de internet
# Elaborado para la I2D-IAvH por: Juan Carlos Rey
#=============================

# Solo siga estas intrucciones si le tiene el siguiente error, de lo contrario omita:
# Error in data.frame(x[[1]], ldply(if (length(x[[2]]) == 0) { : 
#arguments imply differing number of rows: 1, 0 
# Este paquete puede presentar problemas con el comando gnr_resolve, esto se soluciona de la siguiente manera
# Instale el paquete devtools
#install.packages(devtools)
# Ejecute este comando para solucionar repocitorio 
#devtools::install_github("ropensci/taxize")
# Si no tiene insatalado el paquete "curl" instalelo:
# install.packages(curl)
# Ahora si use el scrip

# Abrir libreria
library(taxize)
# Cargar carpeta desde donde se trabaja
setwd("C:/Users/juan.rey/Desktop/Escritorio")
#Abrir base de datos llamada list, en este caso mi archivo se llama List_SNN.csv, pero puede ser personalizado
list <- read.csv("List_SNN.csv")
# Resuelve nombre con la mejor coincidencia y un solo resultado
li<-gnr_resolve(list$scientificName, resolve_once = TRUE, best_match_only = TRUE, with_context = TRUE,canonical= TRUE)
# Genera un data frame de los resultados
mel<- data.frame(li)
# Comparo columnas mediante comando lógico
logic<- mel$submitted_name==mel$matched_name
# Incluyo esta columna en un data.frame
list_final<- data.frame(mel, logic)
# Adiciono una nueva columna ID
list$ID <- 1:nrow(list)
# Relaciono mi base de datos con los resultados de validación y registros que no coinciden se les asigna NA
mergeDF <- merge(list, list_final, by.x = 'scientificName', by.y = 'submitted_name', all.x = TRUE)
# Establezco el orden inicial de mi base de datos
mergeDF <- mergeDF[order(mergeDF$ID), ]
# Exporto data frame a un archivo tabla
write.table(mergeDF, file = "List_final.csv", sep = ",", col.names = NA,
            qmethod = "double")
