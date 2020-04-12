year[2]
casos<-data.table(read_excel("Class_02/2020-03-17-Casos-confirmados.xlsx",na = "—",trim_ws = TRUE,col_names = TRUE),stringsAsFactors = FALSE)
casos<- casos[Región=="Metropolitana",]
casos[Sexo=="Fememino", Sexo := "Femenino"]
table(casos[,`Centro de salud`])
casos[`Centro de salud`== 'Clínica Alemana',`Centro de salud`:= 'Clinica Alemana']  

