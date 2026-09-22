# 作业 02 学生答案：Xiaonan
# 题目见 homework/questions/Q_02_260920.R（题 1–4）
# 工作目录为项目根目录，逐行带中文注释。

#题1
library(tidyverse)
library(rio)
fs::dir_create("homework/outputs/Xiaonan")
mff <- import("data/01_base_tidyverse/MFF-TDF.xlsx", which = "selected_600")

#题2
  mff |>
  select(where(is.numeric)) |>
  select(1:3) |>
  as.matrix() |>
  colMeans(na.rm = TRUE) |>
  round(2) |>
  print()

#题3
  mff |> 
  select("年龄","体重") |> 
  as.matrix() |> 
  as.data.frame() |> 
  as_tibble() |>
  str()  

#题4
mff_top <- mff |>
  select(-contains("血压")) |>           
  mutate(bmi = 体重 / (身高 / 100)^2) |>  
  filter(bmi > mean(bmi)) 
export(mff_top, "homework/outputs/Xiaonan/mff_02_top_bmi.csv")




