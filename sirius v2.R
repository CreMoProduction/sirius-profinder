packages <- c("readr",
              "dplyr", 
              "readxl", 
              "tidyverse", #использую для определния пути к этому скрипту
              "yaml",      #для импорта настроек
              "progress",  #делаю progress bar
              "rio",       #экспорт xlsx файл
              "xml2"

)
install.packages(setdiff(packages, rownames(installed.packages())), repos = "http://cran.us.r-project.org")

#-----------
lapply(packages, require, character.only = TRUE)




rt_diff= 0.15 #макс RT лимит разницы в мин 
folder_path= 'E:\\sirius-profinder'

folder_path=choose.dir(caption= "Select input folder")
start_time= Sys.time()
cef = list.files(folder_path, pattern="\\.cef$", all.files=FALSE, full.names=TRUE)
cef = list.files(folder_path, pattern="\\.cef$", all.files=FALSE, full.names=FALSE)[which.max(file.info(cef)$size)] #получаю cef с наибольшим размером
csv = list.files(folder_path, pattern="\\.csv$", all.files=FALSE, full.names=FALSE)


#datapath_adducts_list= file.path(folder_path,paste("adducts_list",".xlsx", sep=""))
#adducts_list= read_excel(datapath_adducts_list, sheet = paste("positive", sep=""))



mass_tsv= file.path(folder_path,paste("compound_identifications",".tsv", sep=""))     #sirius
compound_tsv= file.path(folder_path,paste("canopus_compound_summary",".tsv", sep=""))     #sirius
#datapath_csv= file.path(folder_path,paste("Group 1 6284",".csv", sep=""))                 #profinder
#xml_doc <- read_xml(file.path(folder_path,paste("Ga_QC",".cef", sep="")))         #xml profinder
datapath_csv= file.path(folder_path,paste(csv, sep=""))                                #profinder
xml_doc <- read_xml(file.path(folder_path,paste(cef, sep="")))                         #xml profinder


df_tsv<-readr::read_tsv(mass_tsv)
compound_tsv<-readr::read_tsv(compound_tsv)
df_csv<-readr::read_csv(datapath_csv)

df_1= data.frame()
sorted_df_csv <- df_csv[order(df_csv[, 4]), ]

#RT
df_tsv[,20]
df_csv[,4]
#mass
df_tsv[,19]
df_csv[,1]

#кол-во строк
nrow(df_tsv)
nrow(df_csv)

#target_rt =target_rt_floor
#target_x =target_x_floor

i=28


df_1 = data.frame()
for (i in 1:nrow(df_tsv)) {
  df_0 = data.frame()
  print(i)
  target_rt = round(as.numeric(df_tsv[i,20]/60),1)
  target_x = round(as.numeric(df_tsv[i,19]),0)
  #target_rt_ceiling = ceiling(round(as.numeric(df_tsv[i,20]/60), 2)*100)/100+0.01
  #target_x_ceiling = ceiling(round(as.numeric(df_tsv[i,19]), 2)*10)/10
  target_rt_ceiling = as.numeric(df_tsv[i,20]/60) %/% 0.01 /100
  target_x_ceiling = as.numeric(df_tsv[i,19]) %/% 0.1 /10
  target_rt_floor = as.numeric(df_tsv[i,20]/60) %/% 0.001 /1000
  target_x_floor = as.numeric(df_tsv[i,19]) %/% 0.1 /10
  #target_rt_floor = floor(round(as.numeric(df_tsv[i,20]/60), 3)*100)/100-0.01
  #target_x_floor = floor(round(as.numeric(df_tsv[i,19]), 3)*100)/100
  
  Search_compound = function(target_rt, target_x) {
    target_p <- xml_find_all(xml_doc, paste0(".//*[@x = '",target_x,"' or starts-with(@x, '",target_x,"')]"))
    target_p
    adduct= xml_attr(target_p, "s")
    parent_compound=xml_parent(xml_parent(xml_parent(target_p)))   
    location <- xml_find_first(parent_compound, xpath = "Location")
    m_value <- xml_attr(location, "m")
    rt_value <- xml_attr(location, "rt")
    
    #match_rt_index = match(target_rt, round(as.numeric(rt_value), 1))
    
    
    
    abs_diff_rt <- abs(as.numeric(rt_value) - target_rt)
    abs_diff_rt = as.numeric(unlist(abs_diff_rt))
    if (min(abs_diff_rt)<=rt_diff) {
      min_difference_index <- which.min(abs_diff_rt)
      closest_rows <- rt_value[min_difference_index]
      closest_rows = as.numeric(closest_rows)
      match_rt_index = match(closest_rows, as.numeric(rt_value))
      
      match_rt = xml_attr(location, "rt")[match_rt_index]
      match_rt = round(as.numeric(match_rt), 3)
      match_m = xml_attr(location, "m")[match_rt_index]
      match_m = round(as.numeric(match_m), 3)
      match_adduct = xml_attr(target_p, "s")[match_rt_index]
      
      abs_diff <- abs(sorted_df_csv[,1] - match_m)
      abs_diff = as.numeric(unlist(abs_diff))
      closest_indices <- order(abs_diff)[1:10]
      closest_rows <- sorted_df_csv[closest_indices, ]
      values = closest_rows
      reference_value_rt = match_rt
      reference_value = match_m
      if (is.na(reference_value) || length(reference_value)==0) {
        return(df_0)
      } else {
        differences <- abs(values[,4] - reference_value_rt)
        differences = as.numeric(unlist(differences))
        min_difference_index <- which.min(differences)
        csv_row = values[min_difference_index,]
        tsv_row = df_tsv[i,]
        df_0=cbind(tsv_row, csv_row)
        return(df_0)
      }
    } else {
      return(df_0)
    }
  }
  
  df_0 = Search_compound(target_rt_floor, target_x_floor)
  if (nrow(df_0)==0) {
    #print("exception 1")
    df_0 = Search_compound(target_rt_ceiling, target_x_ceiling)
  }
  if (nrow(df_0)==0) {
    #print("exception 2")
    df_0 = Search_compound(target_rt, target_x)
  }
  if (nrow(df_0)==0) {
    #print("exception 3")
    print(paste(i, "not found", sep=" "))
    df_0=cbind(df_tsv[i,], setNames(data.frame(matrix(ncol = ncol(sorted_df_csv), nrow = 1)), c( names(sorted_df_csv))))
    ncol(df_0)
  }
  
  df_1= rbind(df_1, df_0)
}

df_1$retentionTimeInSeconds = df_1$retentionTimeInSeconds/60
colnames(df_1)[colnames(df_1) == "retentionTimeInSeconds"] <- "RT, min"

end_time =Sys.time()
print(paste("Elapsed Time:", round(as.numeric(gsub("Time difference of ", "", difftime(end_time, start_time, units="secs")/60)), 2), "min"))



#remove_columns = c(1:9, 11:18, 23:24)
remove_columns = c(1:4, 176:dim(df_1)[2])
df_1 = df_1[, -remove_columns]




#добавляю класс вещества к итоговой таблице
df_2 = data.frame()
for (i in 1:nrow(df_1)) {
match_row_index = min(match(df_1$id[i], unlist(compound_tsv[,1])))
df_2_row = cbind(compound_tsv[match_row_index,c(10, 11)], df_1[i,])
df_2 = rbind(df_2, df_2_row)
}




#экспорт excel 
File_1= df_1
File_1= df_2
filepath=file.path(folder_path,paste("script_compiled_output",".xlsx", sep=""))
export(list(File_1), filepath)

