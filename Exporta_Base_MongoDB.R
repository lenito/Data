## Diret?rio corrente 
setwd("C:\\Projeto\\LiguagemR\\PipelineAlura")


######################################## 1) Carrega Dados

#MongoDB
# install.packages('mongolite') 
library (mongolite)

# Verifique se voc? tem o  MongoDB instalado e executando:
#mongod --dbpath c:\data\db
# 

m <- mongo("ovnis", url = "mongodb://localhost:27017/ovni")
df_OVNI <- m$find('{}')

######################################## 2) Write Dados

write.csv(rbind(df_OVNI), file="OVNIS_Preparados.csv")