# 作业 03 学生答案：Xiaonan
# 题目见 homework/questions/Q_03_261014.R（题 1–2）
# 工作目录为项目根目录，逐行带中文注释。

# 题 1
library(tidyverse)  
library(rio)
fs::dir_create("homework/outputs/Xiaonan")   
mff = import("data/01_base_tidyverse/MFF-TDF.xlsx", which = "selected_600") |> 
as_tibble()

#题 2
mff |>
  filter(收缩压 >= 140,性别 == "男") |> 
  select(-原始图像文件名,-脂肪肝二分类) |> 
  relocate(性别, .before = 脂肪肝三分类) |> 
  arrange(desc(收缩压)) |> 
  slice_head(n = 80) |> 
  mutate(bmi = 体重 / (身高/100)^2, 1) |> 
  group_by(脂肪肝三分类) |> 
  summarise(
    例数 = n(),
    mean_bmi = mean(bmi),
    max_腰围 = max(腰围)
    ) |> 
ungroup() |> 
arrange(mean_bmi) |> 
export("homework/outputs/Xiaonan/mff_03_group_first.csv")  
  
  
  

