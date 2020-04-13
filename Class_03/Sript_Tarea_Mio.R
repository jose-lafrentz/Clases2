#cargar los datos preinstalados "Chile"
?Chile
Chile
plebicito<-Chile

plot(Chile)

# 0. ¿De qué clase es el objeto Chile?
class(Chile)

# 1. ¿De qué clase es cada variable?
str(Chile)

# 2. Cree una nueva variable que se llame income1000, que sea igual al ingreso en miles de pesos
plebicito$income1000 = plebicito$income/1000

# 3. Cuente cuántas personas votaron por el si, y cuántas por el no

table(Chile[,"vote"])

# 4. Cree un nuevo objeto tipo data.table en base al objeto Chile, que se llame Chile2

Chile2 <- data.table(plebicito)
class(Chile2)
# 5. Borre la variable statusquo
Chile2[,statusquo := NULL]

# 7. Cree una nueva variable de ingreso per cápita
# 7.1. Reemplace los NAs de income por ceros
Chile2$ingresopercapita <- Chile2$income/Chile2$population

table(is.na(Chile2$income))
Chile2[is.na(income), income := 0]
# 8. Cree una variable que tenga un 1 si age>65 y 0 en el caso contrario

Chile2[age>65, esviejo := 1]
Chile2[is.na(esviejo), esviejo := 0]
Chile2$viejito <- as.numeric(Chile2$age>65)
# 9. Cree un nuevo objeto que muestre los valores promedio de ingreso y edad por region y sexo
#     Nota: Si tiene observaciones con NA, por qué es esto? Cómo lo arreglamos?
obj1 <- Chile2[,.(proming = mean(income,na.rm = TRUE), promedad = mean(age,na.rm = TRUE)), by = .(region,sex)]
obj1


# ObjetoDataTable[<cosas por filas aqui>,<cosas por columnas>,<by>]


