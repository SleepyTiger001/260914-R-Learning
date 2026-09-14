# =============================================================================
#  R Base + tidyverse 基础语法通识课（单文件 · 逐行执行版）
# -----------------------------------------------------------------------------
#  环境：R 4.5.2 / tidyverse 2.x / rio     编写：2026-09-14
#  用法：用 RStudio 打开本文件，光标停在某一行按 Cmd + Enter 执行该行；
#        或选中若干行后 Cmd + Enter 执行所选代码。自上而下顺序执行。
#  约定：代码右侧或上方的 # 注释即为该行的讲解；所有行可以独立执行。
#  目录：00 环境  01 对象与类型  02 向量与索引  03 四种容器  04 Base 数据框
#        05 函数与循环  06 管道  07 数据读写  08 dplyr 五动词  09 分组与连接
#        10 长宽转换与文本  11 可视化速览  12 综合案例  13 课堂练习
# =============================================================================


# ---- 00 环境检查与包加载 -----------------------------------------------------

getRversion()                        # 查看 R 版本号（本课基于 4.5.2 编写，4.1+ 才有原生管道 |>）
R.version.string                     # 完整版本信息字符串，报错求助时先把这个贴给别人
search()                             # 查看当前"搜索路径"：哪些包已加载、哪些对象可用

# 以下两行仅首次运行需要，装过就跳过；本机已预装，无需执行
# install.packages("tidyverse")      # 安装 tidyverse 全家桶（下载较慢，约 5-10 分钟）
# install.packages("rio")            # 安装 rio：万能读写包，一句话读/写 30 多种格式

library(tidyverse)                   # 一次性加载 8 个核心包：ggplot2 dplyr tidyr readr purrr tibble stringr forcats
library(rio)                         # 单独加载 rio（它不属于 tidyverse）

tidyverse_packages()                 # 列出 tidyverse 包含的子包及版本，看清楚这 8 个包的名字
sessionInfo()                        # 会话快照：R 版本 + 平台 + 已加载包（输出较长，知道有这个命令即可）


# ---- 01 对象与类型：赋值、六种常用类型、强制转换 -------------------------------

x <- 10                              # 赋值：把 10 存进名为 x 的对象（Cmd + Shift + M 可快速输入 <-）
y = 20                               # = 也能赋值，但函数调用里的 = 表示"传参"；函数外统一用 <- 更稳妥
x + y                                # 算术运算，结果是 1 个数值
x <- 99                              # 同名赋值即覆盖旧值，R 不会提示（变量被悄悄改掉是常见坑）
print(x)                             # 查看当前值，确认已被覆盖成 99

num <- 3.14                          # 数值型 double：可以四则运算
int <- 7L                            # 整型 integer：数字后必须加 L，不加一律是 double
chr <- "甘草"                         # 字符型 character：必须用引号包裹
lgl <- TRUE                          # 逻辑型 logical：只写 TRUE / FALSE（大写，写 True 会报错）
fct <- factor(c("寒", "温", "寒", "平"))   # 因子 factor：分类变量，内部存整数编码 + 水平标签
dte <- as.Date("2026-09-14")         # 日期型 Date：内部是"距 1970-01-01 的天数"
class(num); class(chr); class(lgl)   # class() 看"类型"（面向使用者的分类）
typeof(num); typeof(int)             # typeof() 看"底层存储类型"，比 class() 更底层
class(dte); print(dte)               # 日期打印出来是 2026-09-14，但本质是数字
as.numeric(dte)                      # 日期转数值：20697 天（便于算时间差、做回归）
as.Date("2026-10-01") - dte          # 两个日期相减，结果带单位 days（Time difference of 17 days）

levels(fct)                          # 查看因子的"水平"：可能的取值集合
unclass(fct)                         # 剥掉 class 属性看内在：c(2, 1, 2, 3) —— 因子其实是整数
as.character(fct)                    # 因子转字符，拿回原始标签
fct2 <- factor(chr, levels = c("陈皮", "甘草"))   # 建因子时显式给 levels，可控制排序与补齐缺失水平
table(fct2)                          # table() 数频数：未出现的"陈皮"记为 0（水平齐全的好处）

as.numeric("12.5")                   # 字符 → 数值：成功（"12.5" 是可解释的数字字符串）
try(as.numeric("甘草"))               # 转不成功返回 NA + 警告；try() 包住后不中断脚本（这是最常见的隐形 bug）
as.numeric(TRUE)                     # 逻辑 → 数值：TRUE = 1，所以 sum(条件) 能直接数个数
as.logical(0)                        # 数值 → 逻辑：0 为 FALSE，非 0 为 TRUE
is.numeric(num); is.character(chr)   # is.* 系列：判断类型，返回 TRUE / FALSE
is.na(NA); is.null(NULL)             # 判断缺失 / 判断空对象（NA 与 NULL 是两回事，见第 02 节）

ls()                                 # 列出当前环境里的所有对象名
rm(y)                                # 删除对象 y，释放内存
exists("y")                          # 确认 y 已不存在 → FALSE


# ---- 02 向量：R 的最小计算单元，索引与缺失值 -----------------------------------

v <- c(3, 1, 4, 1, 5, 9)             # c() = combine，把多个值拼成一个向量；R 中"一切皆向量"
1:10                                 # 冒号生成等差整数序列，含两端
seq(0, 1, by = 0.25)                 # seq() 更灵活：从 0 到 1，步长 0.25
rep(c("A", "B"), times = 2)          # rep() 重复：times 指整体重复 2 次 → A B A B
rep(c("A", "B"), each = 2)           # each 指每个元素各重复 2 次 → A A B B（和上一行对比着看）

length(v)                            # 向量长度（元素个数）→ 6
sum(v); mean(v); median(v); sd(v)    # 常用统计：和、均值、中位数、标准差
range(v)                             # 最小最大值，返回长度 2 的向量
sort(v)                              # 升序排序（R 默认升序）
sort(v, decreasing = TRUE)           # 改为降序
rev(v)                               # 反转向量顺序（不排序，只是倒过来）

v + 1                                # 向量化运算：每个元素同时 +1，不用写循环
v * 2                                # 每个元素 ×2
v > 2                                # 比较运算返回等长逻辑向量，用于"筛"
which(v > 2)                         # which() 把逻辑向量变成"位置下标"→ 1 3 5 6
v[c(1, 3)]                           # 按位置取第 1、3 个元素（R 下标从 1 开始，不是 0）
v[-1]                                # 负号表示"排除"：去掉第 1 个，返回其余
v[v > 2]                             # 逻辑索引：只保留大于 2 的元素（最常用的一招）
sum(v > 2)                           # 逻辑向量求和 = 统计 TRUE 的个数 → 4
any(v > 8); all(v > 0)               # 有任意一个 / 全部满足吗？常用来做断言检查
v2 <- v * 3                          # 两个等长向量可以整体运算
v + v2                               # 逐元素相加（不是矩阵乘法）
v %in% c(1, 9)                       # %in% 判断"是否属于某个集合"，返回逻辑向量
match(5, v)                          # match() 查元素位置 → 5（找不到返回 NA）

names(v) <- c("a", "b", "c", "d", "e", "f")   # 给向量命名，之后可用名字取值
v["c"]                               # 按名字取，结果仍带名字
v[["c"]]                             # [[ ]] 只取值、不带名字
unname(v)                            # 一次性去掉所有名字

a <- c(1, 2, NA, 4)                  # NA = Not Available：占位的"缺失值"，向量长度不变
mean(a)                              # 只要含 NA，均值就是 NA —— R 的默认保守行为，不是 bug
mean(a, na.rm = TRUE)                # na.rm = TRUE：先剔除缺失再计算（na 的 rm 即 remove）
is.na(a)                             # 判断哪些位置是缺失
sum(is.na(a))                        # 统计缺失个数（数据清洗第一步通常就写这一句）
a[is.na(a)] <- 0                     # 把 NA 替换成 0（最简单的插补；真实分析要谨慎）
b <- c(1, 0, 0) / 0                  # 0/0 得 NaN（Not a Number），是"数学上无意义"，与 NA 含义不同
is.nan(b); is.na(b)                  # is.nan() 只对 NaN 为真；is.na() 对 NaN 也返回 TRUE
lst0 <- list(1, 2)                   # NULL 表示"空对象"，往 list 里塞 NULL 等于删掉该位置
lst0[[1]] <- NULL                    # 删掉第 1 个元素
length(lst0)                         # 长度从 2 变成 1
length(c(1, NULL, 3))                # NULL 在 c() 里被直接忽略，长度是 2（而 NA 会占位）
attr(v, "unit") <- "g"               # 给任意对象挂"自定义属性"，用于存元信息
attributes(v)                        # 查看属性（names 也是一种属性）
as.vector(v)                         # 剥掉属性，退回纯数值向量


# ---- 03 四种容器：矩阵 / 列表 / 数据框 / tibble --------------------------------

m <- matrix(1:6, nrow = 2, ncol = 3) # matrix() 建矩阵：只有一种类型，默认"按列"填充
print(m)                             # 看结果：第 1 列是 1 2，第 2 列是 3 4 —— 确认填充顺序
dim(m)                               # 维度：先行数、后列数 → 2 3
dimnames(m) <- list(c("r1", "r2"), c("c1", "c2", "c3"))   # 给行列命名
m["r1", "c2"]                        # 名字索引：逗号前是行、逗号后是列
m[, 2]                               # 留空表示"全部"；取第 2 列，结果降维成向量
m[, 2, drop = FALSE]                 # drop = FALSE 保持二维结构（不降维）
t(m)                                 # t() 转置：行列互换
rowSums(m); colMeans(m)              # 行和 / 列均值：内置函数比手写 for 循环快几十倍

L <- list(                           # list() 是"集装箱"：每个格子可装不同类型、不同长度
  name = "张三",                       # 元素 1：字符（示例用占位名）
  score = c(88, 92, 79),             # 元素 2：长度 3 的数值向量
  pass = TRUE                        # 元素 3：逻辑
)
L$score                              # $ + 名字取元素（最常用）
L[["name"]]                          # [[ ]] 同效；注意 L[1] 取出的仍是 list，L[[1]] 取出的才是内容本身
str(L)                               # str() 层层展开结构，是最重要的"看数据结构"函数
length(L)                            # 顶层元素个数 → 3
lapply(L$score, sqrt)                # 对每个元素应用函数（第 05 节详讲）

df_old <- data.frame(                 # 老式 data.frame：Base R 产物
  herb = c("人参", "黄芪", "当归"),    # 字符列
  dose = c(9, 30, 12),               # 数值列
  stringsAsFactors = TRUE            # TRUE 会把字符列悄悄转成因子（R 4.x 默认已是 FALSE，老代码常见此参数）
)
class(df_old$herb)                   # 结果 factor —— 想做字符串处理却拿到因子，是最经典的坑之一
df_old                               # data.frame 打印时会把全部行都吐出来，行数多时刷屏

tb <- tibble(                        # tibble 是 tidyverse 的现代数据框（第 08 节的主角）
  herb = c("人参", "黄芪", "当归"),    # 不自动转因子，字符就是字符
  dose = c(9, 30, 12)                # 数值列
)
class(tb$herb)                       # 结果 character，符合直觉
print(tb)                            # 打印只显示前 10 行，并在表头标出每列类型 <chr> <dbl>
as_tibble(df_old)                    # data.frame → tibble 的转换
as.data.frame(tb)                    # 反向转换（需要交给老函数时用）
names(tb); nrow(tb); ncol(tb)        # 列名、行数、列数：两种数据框通用


# ---- 04 Base R 数据框操作：$、[ ]、筛选、排序、分组 ----------------------------

head(iris)                           # iris：R 自带鸢尾花数据集，150 行 5 列，本课全程用来练手
tail(iris, 3)                        # 后 3 行
dim(iris); nrow(iris); ncol(iris)    # 维度 / 行数 / 列数
names(iris); colnames(iris)          # 列名（对数据框而言两者等价）
str(iris)                            # 每列类型 + 前几个取值：拿到新数据第一件事就该看它
summary(iris)                        # 每列描述统计：数值列给分位数，因子列给频数
if (interactive()) View(iris)        # 打开表格式查看器：RStudio 里很好用，命令行环境自动跳过（interactive() 判断运行方式）

iris$Species                         # $ 取一列 → 因子向量
iris[["Sepal.Length"]]               # [[ ]] 取一列 → 数值向量
iris[, "Species"]                    # [行, 列] 取列，等价于 iris$Species
iris[1:5, c("Sepal.Length", "Species")]   # 取前 5 行的两列，列名用 c() 组合
iris[1:5, ]                          # 行有筛选、列留空 = 全部列（逗号不要漏）
iris[iris$Species == "setosa", ]     # 逻辑筛行：只留 setosa（漏掉末尾逗号就变成"筛列"，会报错）
iris[iris$Sepal.Length > 7 & iris$Species == "virginica", ]   # & 是"且"，| 是"或"，条件用小括号分组更清楚
subset(iris, Species == "setosa", select = c(Sepal.Length, Species))   # subset() 一次完成"筛行 + 选列"
iris[order(iris$Sepal.Length, decreasing = TRUE), ][1:3, ]   # order() 返回排序后的行下标；取最长花萼的前 3 行
table(iris$Species)                  # 分类变量频数统计：Base R 最常用的汇总手段
prop.table(table(iris$Species))      # 频数转比例，三种花各占 1/3
with(iris, tapply(Sepal.Length, Species, mean))     # with() + tapply()：分组求均值（对应后面 dplyr 的 group_by）
aggregate(Sepal.Length ~ Species, data = iris, FUN = mean)   # 公式写法做分组汇总，~ 读作"依"
cor(iris$Sepal.Length, iris$Petal.Length)           # 相关系数 → 0.87，强正相关
is.na(iris) |> sum()                 # 检查整个数据框有没有缺失值 → 0（干净数据）


# ---- 05 函数、条件与循环（含 apply / map 家族）---------------------------------

square <- function(x) x^2            # 定义函数：function(参数) 表达式；单行函数可省略花括号
square(5)                            # 调用 → 25
range_stat <- function(x, na.rm = TRUE) {   # 多行函数用 {}；参数可设默认值
  lo <- min(x, na.rm = na.rm)        # 函数体内的对象是"局部变量"，函数外部看不到
  hi <- max(x, na.rm = na.rm)         # 局部变量名不会污染全局环境
  c(min = lo, max = hi, span = hi - lo)     # 最后一行即"返回值"，不必写 return()
}
range_stat(c(3, NA, 8))              # 默认 na.rm = TRUE，自动跳过 NA → min 3 max 8 span 5
range_stat(c(3, NA, 8), na.rm = FALSE)   # 显式传 FALSE：结果变成 NA —— 按名字传参最不容易错

x <- 7                               # 为下面的判断准备一个值
if (x > 5) print("big") else print("small")     # 单行 if-else；注意 else 必须紧跟在上一段结尾，不能另起一行开头
ifelse(iris$Sepal.Length > 6, "long", "short")[1:10]   # ifelse() 是"向量化"判断：一次处理整列，返回等长向量
case_when(                           # case_when() 处理多条件分支，比嵌套 ifelse 清晰得多
  x < 3 ~ "low",                     # 条件 ~ 结果，自上而下匹配，命中即停
  x < 8 ~ "mid",                     # 第二档
  TRUE ~ "high"                      # 兜底写法：TRUE ~ ... 表示"其余情况"
)

for (i in 1:3) print(i^2)            # for 循环：能用向量化就别写循环，这里的 print 是副作用才需要循环
for (s in unique(iris$Species)) cat(s, "有", sum(iris$Species == s), "条\n")   # 遍历分类水平做统计；\n 是换行符
i <- 0                               # while 循环前必须先初始化控制变量，否则死循环
while (i < 3) { i <- i + 1; cat(i, "") }   # 条件为真时反复执行；同一行多个语句用分号分隔

safe_mean <- function(x) {           # 带"前置断言"的函数
  stopifnot(is.numeric(x))           # stopifnot()：不满足条件立刻报错，防止静默算错（比事后查错省时间）
  mean(x, na.rm = TRUE)              # 通过断言后正常计算
}
safe_mean(c(1, 2, 3))                # 正常返回 2
try(safe_mean("a"))                  # try() 包住后，报错不会中断整个脚本，便于批量处理多份数据

lapply(iris[, 1:4], mean)            # lapply：对每列应用函数，返回 list（l = list）
sapply(iris[, 1:4], mean)            # sapply：同样功能但尽量简化成向量，结果更顺手
vapply(iris[, 1:4], mean, numeric(1))     # vapply：需指定返回类型，最安全 —— 类型不符会报错而不是悄悄变
apply(iris[, 1:4], 2, mean)          # apply 用于矩阵/数组：参数 2 表示"按列"（1 表示按行）
mapply(function(a, b) a + b, 1:3, 4:6)    # mapply：多参数"逐元素"配对运算
tapply(iris$Sepal.Length, iris$Species, mean)     # tapply：按分组因子做"分组 apply"
map_dbl(iris[, 1:4], mean)           # purrr::map_dbl：tidyverse 版 lapply，且强制返回 double
map(1:3, ~ .x^2)                     # 公式写法：~ 里的 .x 指当前元素，省去写匿名函数


# ---- 06 管道：让多步操作读起来像一句话 -----------------------------------------

sqrt(mean(c(4, 9, 16)))              # 嵌套写法：由内向外读（3 层以上就很难读懂）
c(4, 9, 16) |> mean() |> sqrt()      # 原生管道 |>（R 4.1+）：左边结果自动成为右边函数的第一个参数
c(4, 9, 16) |> mean() |> sqrt() |> round(2)   # 管道可无限追加步骤，读起来是"先求均值→再开方→再保留两位"
iris |> head(3)                      # 管道同样适用于数据框
iris |> subset(Species == "setosa") |> nrow()     # 先筛后数：一行读完全流程
c(4, 9, 16) %>% mean() %>% sqrt()    # magrittr 的 %>%：旧写法，由 library(tidyverse) 带入，功能与 |> 基本一致
# 三条书写规则（新手最常踩）：
# 1) 管道右侧的括号不能省 —— c(1, 2) |> sum 会报错，必须写 sum()，因为管道传的是"函数调用"
# 2) 原生 |> 不支持占位符 . ；需要把数据放到第二个参数时，改用命名参数或换成 %>%
# 3) 多行管道建议每行以 |> 结尾，方便阅读，也方便逐行执行（RStudio 里能一次执行整段）


# ---- 07 数据的读写：Base / readr / rio ----------------------------------------

fs::dir_create(c("data", "outputs/01_tables", "outputs/02_figures"))   # fs 建目录；已存在则跳过，不会报错
getwd()                              # 确认当前工作目录；若不是项目根目录，用 setwd("项目绝对路径") 切换

write.csv(iris, "data/iris_base.csv", row.names = FALSE)   # Base R 写 CSV；row.names = FALSE 去掉行号列（否则读回来多一列 X）
read.csv("data/iris_base.csv") |> head(3)   # Base R 读 CSV；R 4.x 默认 stringsAsFactors = FALSE，不再乱转因子

write_csv(iris, "data/iris_readr.csv")      # readr 写：UTF-8 编码、默认不写行名、大文件明显更快
read_csv("data/iris_readr.csv")             # readr 读：会打印"列类型推断"结果，这个提示要养成看的习惯
read_csv("data/iris_readr.csv",             # 显式指定列类型：数据大时既能提速、又能避免类型误判
         col_types = cols(Sepal.Length = col_double(),
                          Species = col_character()))
readxl::read_excel  # 只是一个函数名，提醒你：读 Excel 还有 readxl::read_excel() 这条路（先 library(readxl)）
export(iris, "data/iris.xlsx")              # rio 一句话导出 Excel，后端自动选择（本机已装 openxlsx）
import("data/iris.xlsx") |> head(3)         # rio 一句话读回，格式靠文件扩展名自动识别
export(iris, "data/iris.rds")               # rds 是 R 原生单对象格式：读写最快、类型保留最完整，中间结果首选
readRDS("data/iris.rds") |> head(3)         # Base R 读 rds，比 rio::import 更直接
# 选型建议：中间结果用 rds，交付/给同事用 csv 或 xlsx，跨软件交换用 csv


# ---- 08 dplyr 五动词：filter / select / arrange / mutate / summarise -----------

herbs <- tibble(                     # 构造一个 8 味中药的小数据集，后文所有 dplyr 演示都用它
  herb     = c("人参", "黄芪", "当归", "白芍", "甘草", "大黄", "黄连", "桂枝"),   # 中药名
  qi       = c("温", "微温", "温", "微寒", "平", "寒", "寒", "温"),               # 四气
  flavor   = c("甘", "甘", "甘辛", "苦酸", "甘", "苦", "苦", "辛甘"),             # 五味（可多味）
  meridian = c("脾肺", "脾肺", "肝心脾", "肝脾", "心肺脾胃", "脾胃大肠", "心肝胃", "心肺膀胱"),  # 归经
  toxic    = c(FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE, FALSE),           # 是否有毒
  max_dose = c(9, 30, 12, 15, 10, 15, 5, 10),                                     # 药典用量上限（克）
  papers   = c(15200, 9800, 12400, 3600, 21000, 5400, 8800, 4200)                 # 相关文献数
)
print(herbs)                         # 查看数据
glimpse(herbs)                       # 横着看：每列类型 + 取值示例，比 str() 更适合数据框
write_csv(herbs, "data/herbs.csv")   # 顺手存一份，方便你课后再读回来练习

herbs |> filter(qi == "温")                    # filter() 筛"行"：写法与 Base R 逻辑索引一致
herbs |> filter(qi == "温", max_dose >= 10)    # 多个条件用逗号连接 = "且"，比写 & 更易读
herbs |> filter(qi %in% c("温", "寒"))          # %in% 表示"多选一"，等价于 qi == "温" | qi == "寒"
herbs |> filter(!toxic)                        # ! 取反：筛选无毒的药（逻辑列本身就是条件，可省 == TRUE）
herbs |> filter(str_detect(meridian, "脾"))     # 配合 stringr 做"包含"筛选：归经中含"脾"字

herbs |> select(herb, qi, max_dose)            # select() 选"列"：按列名保留
herbs |> select(-toxic, -papers)               # 负号表示"排除"这两列
herbs |> select(where(is.numeric))             # where() 按类型选列：只保留数值列
herbs |> select(starts_with("m"))              # 按名字前缀选列 → max_dose、meridian
herbs |> select(herb, everything())            # everything() 表示"其余所有列"，常用来把关键列提到最前
herbs |> relocate(papers, .before = herb)      # relocate() 调整列顺序：把 papers 移到 herb 前面
rename(herbs, dose_max = max_dose)             # rename() 改列名：新名 = 旧名（顺序与新名相反，注意别写反）

herbs |> arrange(max_dose)                     # arrange() 按列排序，默认升序
herbs |> arrange(desc(papers))                 # desc() 降序：文献最多的排最前
herbs |> arrange(qi, desc(max_dose))           # 多键排序：先按四气升序，同一四气内按用量降序

herbs |> mutate(dose_half = max_dose / 2)      # mutate() 新增列：由已有列计算得到
herbs |> mutate(dose_g = max_dose, dose_mg = max_dose * 1000)   # 一次新增多列，用逗号分隔
herbs |> mutate(is_hot = qi %in% c("温", "微温", "热"))          # 新增逻辑列：是否属温热药
herbs |> mutate(across(where(is.numeric), ~ round(.x, 1)))      # across() 批量套用：所有数值列统一保留 1 位（用 ~ 写匿名函数）
herbs |> mutate(across(c(max_dose, papers), ~ .x / max(.x)))    # 公式写法做"归一化"，.x 代表当前列

herbs |> summarise(n = n(),                    # summarise() 汇总：n() 统计行数，结果是一张"1 行的小表"
                   mean_dose = mean(max_dose), # 均值
                   sd_dose = sd(max_dose),     # 标准差
                   max_paper = max(papers))    # 最大值
herbs |> pull(herb)                            # pull() 把一列抽成向量（等价于 $）
herbs |> slice_max(max_dose, n = 3)             # slice_max()：取某列最大的前 3 行（等价于排序 + head）


# ---- 09 分组汇总与多表连接 -----------------------------------------------------

herbs |> group_by(qi) |> summarise(n = n(), mean_dose = mean(max_dose))   # 先分组再汇总：每个四气出一行
herbs |> group_by(qi) |> mutate(n_qi = n())    # group_by() + mutate()：新增"组内计数"列，行数不变
herbs |> count(qi)                             # count() 是 group_by + summarise(n = n()) 的快捷写法
herbs |> count(flavor, sort = TRUE)            # sort = TRUE 按频数降序排列
herbs |> group_by(qi) |> summarise(mean_dose = mean(max_dose)) |> ungroup()   # ungroup() 取消分组，好习惯
herbs |> group_by(qi) |> filter(max_dose == max(max_dose))    # 分组后 filter：每组取用量最大的那味药
herbs |> group_by(qi) |> slice_head(n = 1)     # slice_* 系列：每组取第 1 行（先排序就是"每组第一名"）
herbs |> distinct(qi)                          # distinct() 去重：看四气一共有哪几种取值
herbs |> distinct(qi, .keep_all = TRUE)        # 每个四气只保留第一行完整记录

qi_ref <- tibble(                    # 造一张"四气参考表"，用来演示多表连接
  qi       = c("寒", "凉", "平", "温", "热"),    # 四气取值
  nature   = c("阴", "阴", "平", "阳", "阳"),    # 阴阳归属
  qi_order = 1:5                     # 从寒到热的排序编号
  # 注意：这里故意不叫 order —— order 是 base::order() 的函数名，列名与函数撞名会让后续调用莫名报错
)
herbs |> left_join(qi_ref, by = "qi")          # left_join：以左表为准补右表信息；"微温"匹配不上 → NA
herbs |> inner_join(qi_ref, by = "qi")         # inner_join：只保留两边都匹配上的行（"微温"被丢掉）
herbs |> full_join(qi_ref, by = "qi")          # full_join：两边全保留，缺失处用 NA 填
herbs |> semi_join(qi_ref, by = "qi")          # semi_join：只用于过滤，不新增列
herbs |> anti_join(qi_ref, by = "qi")          # anti_join：找"右表没有"的行 → 匹配不上的药，排查口径差异用它
herbs |> left_join(qi_ref, by = "qi") |>       # 综合：拼上参考表（"微温"匹配不上 → nature 与 qi_order 都是 NA）
  arrange(qi_order) |>                          # 按"从寒到热"的编号排序，比按汉字排序更符合专业顺序
  select(herb, qi, nature, max_dose)            # 排序后只留要展示的列
# 连接的第一原则：先确认"连接键"在两张表里含义与粒度一致，再做 join —— 不然会静默产生重复行


# ---- 10 长宽转换与文本处理：tidyr / stringr / forcats --------------------------

qi_stat <- herbs |> group_by(qi) |> summarise(papers_mean = mean(papers), dose_mean = mean(max_dose))   # 两个指标
qi_stat |> pivot_longer(cols = c(papers_mean, dose_mean), names_to = "metric", values_to = "value")   # 宽 → 长
qi_long <- qi_stat |> pivot_longer(cols = -qi, names_to = "metric", values_to = "value")   # cols = -qi：除 qi 外全部转长
qi_long |> pivot_wider(names_from = metric, values_from = value)   # 长 → 宽，还原回 qi_stat
# 口诀：一列一个"变量名"是宽表；"指标名"一列、"数值"一列是长表。ggplot 分组绘图、回归建模通常都要长表。
herbs |> mutate(flavor_vec = str_split(flavor, "")) |> unnest_longer(flavor_vec)   # 无分隔符拆单字：str_split 得 list 列，unnest_longer 炸成多行
sep_demo <- tibble(x = c("补气,固脱,生津", "清热,燥湿"))     # 造一个"带分隔符的多值字段"场景（中药功效常见）
sep_demo |> separate_longer_delim(x, delim = ",")            # 有分隔符 → 拆成多行（变长）
sep_demo |> separate_wider_delim(x, delim = ",", names = c("a", "b", "c"), too_few = "align_end")   # 拆成多列（变宽），位数不足填 NA

str_count(herbs$meridian, "脾")           # 数"脾"字出现次数：1 表示只归脾经，让模糊的归经字段可计算
str_detect(herbs$meridian, "^肺")          # 判断是否以"肺"开头（^ 表示开头，$ 表示结尾）
str_replace(herbs$qi, "微", "")            # 替换第一个匹配："微温" → "温"，便于统一口径
str_sub(herbs$herb, 1, 1)                  # 取子串：第 1 个字符
str_pad("3", width = 2, pad = "0")         # 补零 → "03"，做编号或日期拼接时常用
str_c(herbs$herb, "（", herbs$qi, "）")      # 拼接字符串（比 paste0 的向量化行为更可预期）
print(str_glue("{herbs$herb} 用量上限 {herbs$max_dose} 克"))   # 模板字符串：{} 里直接写表达式，比反复拼引号清晰
str_split("补气,固脱", ",")[[1]]            # 按分隔符切分，返回 list，故用 [[1]] 取第一个元素

str_trim("  甘草  ")                        # 去首尾空格（数据清洗必做）
str_replace_all("温温", "温", "热")          # 全部替换："温温" → "热热"（注意 replace 只换第一个）
str_which(herbs$meridian, "脾")             # 返回包含"脾"的位置下标，可直接用于筛选
herbs$qi |> fct_infreq() |> levels()        # fct_infreq 按出现频次重排水平
fct_reorder(herbs$qi, herbs$max_dose) |> levels()   # fct_reorder 按"用量上限中位数"给水平排序，绘图时顺序才对
# 注意：fct_reorder 遇到排序变量含 NA 会丢弃该水平并报长度错 —— 先用 tidyr::drop_na() 或填默认值再排
herbs$qi |> fct_relevel("平") |> levels()   # fct_relevel 手动把"平"提到最前面
fct_lump_n(factor(rep(c("A", "B", "C"), c(5, 3, 1))), n = 2)   # fct_lump_n：只留最多的 n 个水平，其余归为 Other


# ---- 11 可视化速览：Base plot 与 ggplot2 --------------------------------------

boxplot(Sepal.Length ~ Species, data = iris)   # Base R 箱线图：公式 y ~ 分组，一行出图
hist(iris$Petal.Length, main = "Petal length", xlab = "cm")   # 直方图；main / xlab 是标题与轴标签

theme_cn <- theme_minimal() +                  # 自定义一个"中文主题"：先取简洁主题，再叠加字体设置
  theme(text = element_text(family = "PingFang SC"))   # 指定系统中文字体，否则图上汉字会变方块
# 字体名按系统换：macOS 用 "PingFang SC" 或 "STHeiti"；Windows 用 "Microsoft YaHei" 或 "SimHei"

p <- ggplot(herbs, aes(x = qi, y = max_dose, fill = qi)) +   # ggplot 三层结构：数据 → 映射 aes() → 几何对象
  geom_col() +                                               # geom_col 直接画数值；geom_bar 是数频数，别混
  labs(x = "四气", y = "用量上限 (g)", fill = "四气",          # 轴标签与图例标题
       title = "中药四气与用量上限") +
  theme_cn                                                   # 叠加刚定义的中文主题
if (interactive()) print(p)          # 交互式（RStudio）下在 Plot 面板显示；命令行批处理跳过 —— pdf 设备不支持中文字体
ggsave("outputs/02_figures/qi_max_dose.png", p, width = 7, height = 4, dpi = 300)   # 存图：单位英寸，dpi 300 够印刷
# 结论：出图统一用 ggsave 落成 PNG（走 png 设备，中文没问题），屏幕显示才用 print(p)

p2 <- ggplot(herbs, aes(x = max_dose, y = papers, label = herb)) +   # 散点图：看"用药剂量"与"研究热度"的关系
  geom_point(size = 3) +                                       # 点
  geom_text(nudge_y = 800, size = 3) +                          # 点上方标药名，nudge_y 上移避免压住点
  labs(x = "用量上限 (g)", y = "文献数", title = "用量与文献数分布") + theme_cn
if (interactive()) print(p2)         # 交互式下显示
ggsave("outputs/02_figures/dose_vs_papers.png", p2, width = 7, height = 4, dpi = 300)   # 一并存盘

p3 <- ggplot(qi_long, aes(x = qi, y = value, fill = metric)) +        # 长表 + fill = 指标名 → 自动生成并列柱
  geom_col(position = "dodge") + labs(x = "四气", y = "数值", fill = "指标") + theme_cn
if (interactive()) print(p3)         # 交互式下显示：同一四气下两个指标并排对比


# ---- 12 综合案例：一条完整的分析流水线 ------------------------------------------

result <- herbs |>                              # 从原始小表出发
  left_join(qi_ref, by = "qi") |>                # 第 1 步：补上四气的阴阳属性与寒热次序
  filter(!toxic, papers > 5000) |>               # 第 2 步：只要无毒、且文献数超过 5000 的
  mutate(dose_rank = min_rank(desc(max_dose))) |>   # 第 3 步：按用量上限排名（min_rank 能正确处理并列）
  select(herb, qi, nature, max_dose, papers, dose_rank) |>   # 第 4 步：只保留要交付的列
  arrange(dose_rank)                             # 第 5 步：按排名排序
print(result)                                    # 查看结果：黄芪的 nature 为空，是"微温"在参考表里没有对应行，不是代码 bug
stopifnot(nrow(result) > 0)                      # 健全性检查：结果为空说明筛选条件有误，立刻报错而不是白跑后面
export(result, "outputs/01_tables/herbs_filtered.csv")    # rio::export 一句话导出，格式由扩展名决定
export(result, "outputs/01_tables/herbs_filtered.xlsx")   # 同一份结果同时出 Excel，交付给同事更方便

result |>                                        # 对结果再做一次汇总，验证口径
  count(nature, sort = TRUE) |>                  # 统计阴阳归属分布
  mutate(pct = round(n / sum(n) * 100, 1))       # 转成百分比
# 小结这条流水线的公式：filter 筛行 → mutate 造列 → select 选列 → arrange 排序 → group_by + summarise 汇总
#                        → join 拼表 → export 交付。绝大多数分析任务都是这条链的变体。


# ---- 13 课堂练习：先自己写，再看下方参考答案 ------------------------------------
# 全部用 herbs / iris 两个数据集，每题的参考答案都能独立运行。
#
# 练习 1：取 herbs 中"文献数 papers 超过 1 万"的中药名，按文献数降序。
# 练习 2：统计 herbs 中每个四气（qi）的味数、平均用量上限。
# 练习 3：新增一列 dose_level：用量上限 >= 15 记为 "high"，否则 "low"。
# 练习 4：找出归经（meridian）中含"心"的中药，只保留 herb 与 meridian 两列。
# 练习 5：把 iris 的第 1、3、5 列取出来，按 Petal.Length 降序，取前 5 行。
# 练习 6：计算 iris 中每种花的平均花瓣长度，并转成长表（指标名一列、数值一列）。
# 练习 7：把 3 个向量的平均值写成函数 mean3(x)：内部用 stopifnot 断言 x 是数值向量，否则报错。
# 练习 8：把 result 表导出成 rds 与 csv 两种格式，放到 outputs/01_tables/ 下。

# ---------- 参考答案（先自己写，卡住了再看）----------

# 答 1
herbs |> filter(papers > 10000) |> arrange(desc(papers)) |> select(herb, papers)

# 答 2
herbs |> group_by(qi) |> summarise(n = n(), mean_dose = mean(max_dose))

# 答 3
herbs |> mutate(dose_level = ifelse(max_dose >= 15, "high", "low"))

# 答 4
herbs |> filter(str_detect(meridian, "心")) |> select(herb, meridian)

# 答 5
iris[, c(1, 3, 5)] |> arrange(desc(Petal.Length)) |> head(5)

# 答 6
iris |> group_by(Species) |> summarise(mean_petal = mean(Petal.Length)) |>
  pivot_longer(cols = -Species, names_to = "metric", values_to = "value")

# 答 7
mean3 <- function(x) { stopifnot(is.numeric(x)); mean(x, na.rm = TRUE) }
mean3(c(1, 2, 3))          # 正常 → 2
try(mean3("a"))            # 被断言拦下，报错但不中断

# 答 8
export(result, "outputs/01_tables/result.rds")
export(result, "outputs/01_tables/result.csv")


# =============================================================================
#  到这里全部跑通，你就掌握了 R 数据分析 90% 的日常语法。
#  下一课建议方向：数据清洗实战（缺失值 / 异常值 / 类型纠错）或 ggplot2 图形语法。
# =============================================================================
