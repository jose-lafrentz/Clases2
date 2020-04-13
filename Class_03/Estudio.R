# ---- Scrip clase 03 mio ----

casos <- data.table(read_excel("Class_02/2020-03-17-Casos-confirmados.xlsx",na = "—",trim_ws = TRUE,col_names = TRUE),stringsAsFactors = FALSE)
names(casos)
class(casos[,Edad])    
str(casos)

# dejar solo casos de la RM 
casos<- casos[Región=='Metropolitana']

# Lo pasamos a csv

write.csv(casos,file = 'Class_03/Casos_covid_rm_mio.csv',fileEncoding = 'UTF-8')

# Ahora lo importamos como data frame para trabajar 

casosRM <- fread("Class_03/Casos_covid_rm_mio.csv",header = T,showProgress = T,data.table = T)
casosRM[,table(Sexo)]
casosRM[Sexo== 'Fememino', Sexo:= 'Femenino']
casosRM[`Centro de salud` == 'Clínica Alemana', `Centro de salud` := 'Clinica ALemana']
casosRM[,.N, by = .(`Centro de salud`)]
casosRM[,table(`Centro de salud`)]

# Creando factores

class(casosRM$Sexo) # vemos que es clase character, lo pasamos a factor
casosRM[,Sexo:= factor(Sexo)]
class(casosRM$Sexo) # vemos que es clase factor

head(casosRM$Sexo)
table(casosRM$Sexo)
# ahora lo vemos como numeros
head(as.numeric(casosRM$Sexo))
table(casosRM$Sexo)
casosRM[,.N, by= Sexo]

# Colapsar por centro de salud y edad, tambien pueden ser ambos

obj1 <- casosRM[,.N, by= .(`Centro de salud`)]
obj2 <- casosRM[,.N, by= .(Edad)]
obj1[, sum(N, na.rm = T)]
obj1[,porcentaje:= N/sum(N, na.rm = T)]    # Aquí vemos que porcentaje del total corresponde a cada centro

# Colapsar por edad promedio

A <- casosRM[,.(AvAge = mean(Edad, na.rm= T)), by= .(`Centro de salud`)]
B <- casosRM[,.(Total_centro= .N), by= .(`Centro de salud`)]

# Colapsar por sexo por centro de salud

C <- casosRM[Sexo == 'Femenino', .(Total_centro_mujeres= .N), by= .(`Centro de salud`)]
D <- casosRM[Sexo == 'Masculino', .(Total_centro_hombres = .N), by= .(`Centro de salud`)]

dim(A)
dim(B)
dim(C)
dim(D)

# Merging 

AB <- merge(A,B, by = "Centro de salud", all = T, sort = F)
ABC <- merge(AB,C, by= 'Centro de salud', all = T, sort = F)
ABCD <- merge (ABC, D, by = 'Centro de salud', all = T, sort = F)


# Reshape 

E <- casosRM[,.(AvAge= mean(Edad, na.rm = T),`Casos confirmados`= .N), by= .(`Centro de salud`, Sexo)]
G <- reshape(E, direction = 'wide', timevar = 'Sexo', v.names = c('AvAge', 'Casos confirmados'), idvar = 'Centro de salud') 

# Plotting 

  # Base de R 

plot(x = G$`Casos confirmados.Femenino`,y = G$`Casos confirmados.Masculino`)
text(x = G$`Casos confirmados.Femenino`, y = G$`Casos confirmados.Masculino`, G$`Centro de salud`, cex = 0.5)

# ggplot2 

G1 <- ggplot(data = G, aes(x = `Casos confirmados.Femenino`, y = `Casos confirmados.Masculino`))+geom_point(aes(size= AvAge.Femenino, colour= AvAge.Masculino))+geom_text(aes(label= `Centro de salud`), size = 2, check_overlap = T)
G1
