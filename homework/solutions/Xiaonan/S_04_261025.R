# 作业 04 学生答案：Xiaonan
# 题目见 homework/questions/Q_04_261025.R（题 1–9）
# 工作目录为项目根目录，逐行带中文注释。

# 题 1
library(tidyverse)
library(rio)
library(showtext)
font_add("SimHei", "C:/Windows/Fonts/simhei.ttf")
showtext_auto() 

fs::dir_create("homework/outputs/Xiaonan")
mff = import("data/01_base_tidyverse/MFF-TDF.xlsx", which = "selected_600") |>
  as_tibble()
lab = import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", sheet = "化验单")
ref = import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", sheet ="参考范围")
bp = import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", sheet ="血压随访") |> as_tibble()
hist = import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", sheet ="既往病史")
# 题 2
mff |> anti_join(lab, by = "原始图像文件名") |> 
  count(脂肪肝三分类, name = "例数") |> 
  arrange(desc(例数)) |> 
  export("homework/outputs/Xiaonan/mff_04_no_lab.csv")
# 题 3
lab |> pivot_longer(
    cols = c(-原始图像文件名),
    names_to = "指标",
    values_to = "结果") |> 
  left_join(ref, by = "指标") |> 
  mutate(偏高 = 结果 > 参考上限) |> 
  count(指标, 偏高, name = "例数") |>
  group_by(指标) |> 
  mutate(占比 = round(例数 / sum(例数) * 100, 2)) |> 
  ungroup() |> 
  export("homework/outputs/Xiaonan/mff_04_high.csv")
# 题 4
bp |> pivot_longer(
    cols = c(-原始图像文件名),
    names_to = "时间点",
    values_to = "收缩压") |> 
  group_by(时间点) |>
  summarise(例数 = n(),
平均收缩压 = round(mean(收缩压), 2),
最大收缩压 = max(收缩压)) |> 
  ungroup() |> 
  export("homework/outputs/Xiaonan/mff_04_bp_summary.csv")
# 题 5
restored = bp |> pivot_longer(
    cols = c(-原始图像文件名),
    names_to = "时间点",
    values_to = "收缩压",
    names_prefix = "收缩压_") |> 
  pivot_wider(
    names_from = 时间点, 
    values_from = 收缩压,
    names_prefix = "收缩压_") 
  all.equal(restored,bp)
# 题 6
mff |> select(原始图像文件名,脂肪肝三分类) |> 
  left_join(hist, by = "原始图像文件名") |> 
  separate_longer_delim(既往疾病, delim = ",") |> 
  filter(既往疾病 != "无") |> 
  count(既往疾病, 脂肪肝三分类, name = "例数") |> 
export("homework/outputs/Xiaonan/mff_04_disease.csv")
# 题 7
mff |> separate_wider_delim(原始图像文件名, delim = ".", names = c("编号", "扩展名")) |> 
  mutate(编号 = as.numeric(编号)) |> 
  arrange(desc(编号)) |> 
  slice_head(n = 5) |> 
  select(编号, 性别, 年龄, 脂肪肝三分类) |> 
  export("homework/outputs/Xiaonan/mff_04_top_id.csv")
# 题 8
p = mff |> group_by(性别) |>
  summarise(平均年龄 = mean(年龄), 平均收缩压 = mean(收缩压), 平均腰围 = mean(腰围)) |> 
  ungroup() |> 
  pivot_longer(
    cols = c(-性别),
    names_to = "指标",
    values_to = "均值") |> 
  ggplot(aes(x = 指标, y = 均值, fill = 性别)) + 
  geom_col() + 
  labs(
    x = "指标",
    y = "均值",
    fill = "性别", 
    title = "嘻嘻"
  ) +
    theme_classic()

ggsave(
  "homework/outputs/Xiaonan/mff_04_plot_sex.pdf",
  p,
  width = 7,
  height = 5,
  dpi = 300
) 

# 题 9
theme_cn <- theme_gray(base_family = "SimHei")
p2 = mff |> left_join(lab, by = "原始图像文件名") |> 
filter(!is.na(谷丙转氨酶)) |> 
ggplot(aes(x = 甘油三酯, y = 谷丙转氨酶, color = 脂肪肝三分类)) + 
  geom_point(size = 1) + 
  labs(x = "甘油三酯", y = "谷丙转氨酶", title = "嘻嘻嘻") +
  theme_cn

ggsave(
  "homework/outputs/Xiaonan/mff_04_plot_tg_alt.pdf",
  p2,
  width = 7,
  height = 5,
  dpi = 300
) 