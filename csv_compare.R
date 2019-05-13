# csv compare program
# Created date: 2019/5/13
# Author: mariko ohtsuka
# library, function section ------
if(!require("here")){
  install.packages("here")
  library("here")
}
if(!require("tidyverse")){
  install.packages("tidyverse")
  library("tidyverse")
}
Sys.setenv("TZ" = "Asia/Tokyo")
source(file.path(here(), "common_function.R"))
ConstAssign("kOutput_csv_fileEncoding", "cp932")
ConstAssign("kOutput_csv_eol", "\r\n")  # output_csv's line feed code
input_path <- c(file.path(here(), "input", "r_ads"), file.path(here(), "input", "sas_ads")) 
path_r <- list.files(input_path[1], pattern="*csv$", full.names=F)
path_r <- path_r[-which(path_r %in% c("output_option_csv.csv", "output_sheet_csv.csv"))]
path_sas <- list.files(input_path[2], pattern="*csv$", full.names=F)
path_sas <- path_sas[-which(path_sas %in% str_subset(path_sas, pattern="contents.csv"))]
if (all(path_r == path_sas)) {
  for (i in 1:length(path_r)) {
    temp_csv_name <- path_r[i]
    r_csv <- read.csv(file.path(input_path[1], temp_csv_name), as.is=T, fileEncoding="cp932", stringsAsFactors=F, na.strings="")
    sas_csv <- read.csv(file.path(input_path[2], temp_csv_name), as.is=T, fileEncoding="cp932", stringsAsFactors=F, na.strings="")
    # 列をソートしてチェックする
    r_colnames <- colnames(r_csv)
    r_colnames <- sort(r_colnames)
    sas_colnames <- colnames(sas_csv)
    if (length(which(r_colnames=="group")) == 0) {
      sas_colnames <- sas_colnames[-which(sas_colnames %in% c("group", "VAR3", "VAR4", "VAR5", "VAR6"))]
    }
    sas_colnames <- sort(sas_colnames)
    print(temp_csv_name)
    if (all(r_colnames == sas_colnames)) {
      # 列の並び替え
      r_csv <- select(r_csv, r_colnames)
      sas_csv <- select(sas_csv, sas_colnames)
      for (j in 1:length(r_colnames)) {
        temp_col_1 <- as.character(r_csv[j])
        temp_col_2 <- as.character(sas_csv[j])
        if (all(temp_col_1 == temp_col_2)) {
        } else {
          print("!!! value_ng !!!")
          print(temp_col_1)
          print(temp_col_2)
        }
      }
    } else {
      print("!!! colnames_ng !!!")
      print(temp_csv_name)
      print(r_colnames)
      print(sas_colnames)
    }
  }
} else {
  stop("!!! csv_count_error !!!")
}
