# 作业 04 学生答案：Mengyan
# 题目见 homework/questions/Q_04_261025.R（题 1–9）
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

# 另外四张表：1 化验单、2 参考范围、3 血压随访、4 既往病史
# 这里填序号而不是中文表名，因为中文名有时读不出来
lab  <- import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", which = 1) |> as_tibble()
ref  <- import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", which = 2) |> as_tibble()
bp   <- import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", which = 3) |> as_tibble()
hist <- import("data/01_base_tidyverse/MFF-hw04-extra.xlsx", which = 4) |> as_tibble()

# 题 2

# anti_join 是反着找：只留 mff 里有、lab 里查不到的，也就是没做化验的人
mff |>
  anti_join(lab, by = "原始图像文件名") |>
  # 数各分类有多少人
  count(脂肪肝三分类, name = "例数") |>
  # 人多的排前面
  arrange(desc(例数)) |>
  write_csv("homework/outputs/Mengyan/mff_04_no_lab.csv")

# 题 3

# 三项化验挤在三列，先拉成长表：一列放指标名，一列放结果值
lab |>
  pivot_longer(cols = -原始图像文件名, names_to = "指标", values_to = "结果") |>
  # 按指标名接上参考范围
  left_join(ref, by = "指标") |>
  # 超过参考上限就算偏高
  mutate(偏高 = 结果 > 参考上限) |>
  # 每个指标的偏高、正常各多少例
  count(指标, 偏高, name = "例数") |>
  # 占比要在每个指标内部算，所以先按指标分组
  group_by(指标) |>
  mutate(占比 = round(例数 / sum(例数), 2)) |>
  ungroup() |>
  write_csv("homework/outputs/Mengyan/mff_04_high.csv")

# 题 4

# 三个时间点也是横着排的，同样先转长表
bp |>
  pivot_longer(cols = -原始图像文件名, names_to = "时间点", values_to = "收缩压",
               names_prefix = "收缩压_") |>
  group_by(时间点) |>
  # 每个时间点数人数、算平均和最大值
  summarise(
    例数 = n(),
    平均收缩压 = round(mean(收缩压), 2),
    最大收缩压 = max(收缩压)
  ) |>
  ungroup() |>
  write_csv("homework/outputs/Mengyan/mff_04_bp_summary.csv")

# 题 5

# 先转长表，再还原回宽表，最后跟原来的 bp 比一比
bp |>
  pivot_longer(cols = -原始图像文件名, names_to = "时间点", values_to = "收缩压",
               names_prefix = "收缩压_") |>
  # 还原时前缀得加回来，不然列名和 bp 对不上
  pivot_wider(names_from = 时间点, values_from = 收缩压,
              names_prefix = "收缩压_") |>
  # 返回 TRUE 就是完全一致
  all.equal(bp)

# 题 6

# 既往疾病是一格里塞好几个病、用逗号隔开的，拆成一行一个才好统计
mff |>
  select(原始图像文件名, 脂肪肝三分类) |>
  left_join(hist, by = "原始图像文件名") |>
  separate_longer_delim(既往疾病, delim = ",") |>
  # 「无」不算病，去掉
  filter(既往疾病 != "无") |>
  count(既往疾病, 脂肪肝三分类, name = "例数") |>
  # 先按病名归类，同一种病里再按例数从多到少
  arrange(既往疾病, desc(例数)) |>
  write_csv("homework/outputs/Mengyan/mff_04_disease.csv")

# 题 7

# 文件名是 206489.jpg 这种，按小数点切成编号和扩展名两列
mff |>
  separate_wider_delim(原始图像文件名, delim = ".", names = c("编号", "扩展名")) |>
  # 编号切出来是文本，转成数值才能比大小
  mutate(编号 = as.numeric(编号)) |>
  arrange(desc(编号)) |>
  slice_head(n = 5) |>
  select(编号, 性别, 年龄, 脂肪肝三分类) |>
  write_csv("homework/outputs/Mengyan/mff_04_top_id.csv")

# 题 8

# 中文字体主题，SimHei 在 Windows 上最稳，存 PDF 也不会缺字
cn_theme <- theme(text = element_text(family = "SimHei"))

# 按性别算三个均值 → 转长表让指标变成 x 轴上的柱子 → 画图
p1 <- mff |>
  group_by(性别) |>
  summarise(
    平均年龄 = mean(年龄),
    平均收缩压 = mean(收缩压),
    平均腰围 = mean(腰围)
  ) |>
  ungroup() |>
  pivot_longer(cols = -性别, names_to = "指标", values_to = "均值") |>
  ggplot(aes(x = 指标, y = 均值, fill = 性别)) +
  # dodge 让男女两根柱子并排站
  geom_col(position = "dodge") +
  labs(x = "指标", y = "均值", title = "男女三项指标均值对比") +
  cn_theme

# 宽 7 高 5 英寸、300 dpi；cairo_pdf 才会把中文字体嵌进 PDF
ggsave("homework/outputs/Mengyan/mff_04_plot_sex.pdf", p1,
       width = 7, height = 5, dpi = 300, device = cairo_pdf)

# 题 9

# 连上 lab 之后，那 120 个没化验的人谷丙转氨酶是 NA，画图前先去掉
p2 <- mff |>
  left_join(lab, by = "原始图像文件名") |>
  filter(!is.na(谷丙转氨酶)) |>
  ggplot(aes(x = 甘油三酯, y = 谷丙转氨酶, color = 脂肪肝三分类)) +
  # 半透明，点叠在一起时也看得清
  geom_point(alpha = 0.7) +
  labs(x = "甘油三酯 (mmol/L)", y = "谷丙转氨酶 (U/L)",
       title = "甘油三酯与谷丙转氨酶的关系") +
  cn_theme

ggsave("homework/outputs/Mengyan/mff_04_plot_tg_alt.pdf", p2,
       width = 7, height = 5, dpi = 300, device = cairo_pdf)
