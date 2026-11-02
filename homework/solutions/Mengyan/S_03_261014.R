# 作业 03 学生答案：Mengyan
# 题目见 homework/questions/Q_03_261014.R（题 1–2）
# 工作目录为项目根目录，逐行带中文注释。

# 题 1

# tidyverse 用来处理数据，rio 专门读 Excel
library(tidyverse)
library(rio)

# 建输出目录，已经有了就跳过
fs::dir_create("homework/outputs/Mengyan")

# 读主表，只要 selected_600 这张，读完转成 tibble
mff <- import("data/01_base_tidyverse/MFF-TDF.xlsx", which = "selected_600") |>
  as_tibble()

# 题 2

# 一条管道走完：筛人 → 删列 → 移列 → 取前 80 → 算 bmi → 分组汇总 → 排序 → 导出
mff |>
  # 男性，收缩压不低于 140
  filter(性别 == "男", 收缩压 >= 140) |>
  # 这两列后面用不上，去掉
  select(-原始图像文件名, -脂肪肝二分类) |>
  # 性别挪到三分类前面
  relocate(性别, .before = 脂肪肝三分类) |>
  # 按收缩压从大到小，取前 80 行
  arrange(desc(收缩压)) |>
  slice_head(n = 80) |>
  # 算 bmi，身高先从 cm 换成 m 再平方
  mutate(bmi = round(体重 / (身高 / 100)^2, 1)) |>
  # 按三分类分组，数人数、算平均 bmi、找最大腰围
  group_by(脂肪肝三分类) |>
  summarise(例数 = n(), 平均bmi = mean(bmi), 最大腰围 = max(腰围)) |>
  # 先解组，不然还带着分组
  ungroup() |>
  # 平均 bmi 从小到大
  arrange(平均bmi) |>
  # 导出
  write_csv("homework/outputs/Mengyan/mff_03_group_first.csv")
