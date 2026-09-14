# R Base + tidyverse 基础语法通识课

一节课、一个脚本、逐行执行。目标是让零基础或半基础的同学在 90 分钟内跑通 R 数据分析的日常语法主干。

## 一、怎么用

1. 用 RStudio 打开项目文件 `260914-R-Learning.Rproj`，工作目录会自动锁定在项目根目录。
2. 打开 `scripts/01_base_tidyverse/01_R_base_tidyverse_basics.R`，把光标停在某一行按 `Cmd + Enter` 执行该行；选中若干行可一次执行所选代码。
3. 从上往下顺序执行即可，不要跳段（后文会用到前文的对象）。

命令行整体跑一遍（用于验证环境，约 4 秒）：

```bash
cd "/Users/cuinuan/Documents/ProgramFiles/R-Source/Programs/R-Learning-Proj/260914-桃园三结义R语言基础训练"
Rscript scripts/01_base_tidyverse/01_R_base_tidyverse_basics.R
```

## 二、目录结构

三个工作目录（`scripts/`、`data/`、`outputs/`）一律按 **「课次_主题」编号子文件夹** 组织，同一课的三处内容编号与主题名保持一致，后续课程依次追加 `02_XXX`、`03_XXX`。

```
260914-R-Learning.Rproj                                  # 项目文件：双击打开，工作目录即项目根目录
README.md                                                # 课程说明与踩坑记录
.gitignore                                               # 版本控制排除规则
scripts/
  01_base_tidyverse/
    01_R_base_tidyverse_basics.R                         # 第 1 课脚本，逐行执行
data/
  01_base_tidyverse/                                     # 第 1 课数据，随仓库提交
    herbs.csv  iris_base.csv  iris_readr.csv  iris.xlsx  iris.rds
outputs/
  01_base_tidyverse/                                     # 第 1 课产出，运行后生成，默认不入库
    tables/    herbs_filtered.csv/.xlsx  result.csv/.rds
    figures/   qi_max_dose.png  dose_vs_papers.png
```

新增一课时，只需同步创建 `scripts/NN_主题/`、`data/NN_主题/`、`outputs/NN_主题/{tables,figures}/` 三处，编号与主题名对齐即可。

脚本内一律使用**相对路径**（`data/01_base_tidyverse/...`、`outputs/01_base_tidyverse/...`），因此工作目录必须是项目根目录 —— 用 `.Rproj` 打开即可满足，别单独打开 `scripts/` 下的文件。

## 三、运行环境

| 项目 | 版本 / 说明 |
| --- | --- |
| R | 4.5.2（原生管道 `|>` 需 4.1+） |
| tidyverse | 2.0.0（dplyr / tidyr / ggplot2 / readr / purrr / tibble / stringr / forcats） |
| rio | 万能读写包，配合 openxlsx、readxl 已在环境内 |
| fs / glue | 随 tidyverse 依赖装好，脚本中直接以 `fs::` `str_glue` 调用 |

脚本首节已给出安装命令（注释状态），本机无需执行。

## 四、课程结构（13 节，建议时间分配）

| 节 | 内容 | 建议用时 |
| --- | --- | --- |
| 00 | 环境检查与包加载 | 5 分钟 |
| 01 | 对象、六种类型、强制转换 | 10 分钟 |
| 02 | 向量：索引、逻辑筛选、NA/NaN/NULL | 12 分钟 |
| 03 | 四种容器：matrix / list / data.frame / tibble | 10 分钟 |
| 04 | Base R 数据框操作（`$` `[ ]` subset order tapply） | 10 分钟 |
| 05 | 函数、条件、循环、apply / map 家族 | 12 分钟 |
| 06 | 管道 `|>` 与 `%>%`，三条书写规则 | 5 分钟 |
| 07 | 数据读写：Base / readr / rio，格式选型 | 6 分钟 |
| 08 | dplyr 五动词 filter / select / arrange / mutate / summarise | 12 分钟 |
| 09 | 分组汇总与五种 join | 10 分钟 |
| 10 | 长宽转换 pivot、stringr、forcats | 10 分钟 |
| 11 | 可视化速览（中文主题设置） | 6 分钟 |
| 12 | 综合案例：一条完整分析流水线 | 8 分钟 |
| 13 | 课堂练习 8 题（含参考答案） | 课后 |

## 五、数据与产出文件

`data/01_base_tidyverse/` 随仓库提交，克隆后即可直接使用（脚本运行时会被覆盖重写，属正常现象）。
`outputs/` 默认不入库，跑一遍脚本即全部重建；如需把运行结果也发布，删掉 `.gitignore` 中 `outputs/` 一行即可。

> 每次运行脚本都会重写 `data/` 下的文件；其中 `iris.xlsx`、`iris.rds` 是二进制格式，即使内容相同字节也可能变化。
> 跑完脚本想保持仓库干净，执行 `git checkout -- data/` 把工作区恢复成已提交的版本即可。

```
data/01_base_tidyverse/                  # 随仓库分发
  iris_base.csv                          # Base write.csv 产出（已去掉行名）
  iris_readr.csv                         # readr::write_csv 产出
  iris.xlsx                              # rio::export 产出
  iris.rds                               # R 原生格式，类型保留最完整
  herbs.csv                              # 中药示例数据（8 味药 7 个字段）
outputs/01_base_tidyverse/               # 默认不入库，运行脚本后生成
  tables/
    herbs_filtered.csv / .xlsx           # 综合案例结果（两种格式）
    result.csv / result.rds              # 练习 8 的答案产出
  figures/
    qi_max_dose.png                      # 四气 × 用量上限柱状图
    dose_vs_papers.png                   # 用量 × 文献数散点图
```

## 六、示例数据说明

脚本用 `herbs` 数据集承载所有 dplyr 演示，字段设计与中医数据挖掘场景对齐：

| 字段 | 含义 | 类型 |
| --- | --- | --- |
| herb | 中药名 | 字符 |
| qi | 四气 | 字符 |
| flavor | 五味（可多味，未加分隔符） | 字符 |
| meridian | 归经（多经） | 字符 |
| toxic | 是否有毒 | 逻辑 |
| max_dose | 药典用量上限（克） | 数值 |
| papers | 相关文献数 | 数值 |

用量与文献数为课堂演示用示意值，**不对应真实药典或文献统计口径**，请勿直接引用。

## 七、运行中会看到的提示（都是有意设计的）

| 提示 | 出处 | 说明 |
| --- | --- | --- |
| `强制改变过程中产生了NA` | 01 节 `as.numeric("甘草")` | 字符转数值失败的警告，演示最常见的隐形 bug |
| `Error in safe_mean("a")` | 05 节 | 被 `try()` 捕获，故意演示断言拦截 |
| `Error in mean3("a")` | 13 节答 7 | 同上 |
| `Column specification` 列类型推断 | 07 节 `read_csv()` | readr 的正常提示，建议读一眼 |
| `fct_reorder() removing N missing values` | 10 节 | 排序变量含 NA 时的提示 |

## 八、已验证的踩坑点（脚本中已规避，可当教学素材）

1. **列名与函数撞名**：把列命名为 `order` 会让 `fct_reorder()` 内部调用错位而报错，改用 `qi_order`。
2. **`fct_reorder()` + NA**：排序变量含 NA 时水平数与索引长度不一致，直接报 `` `idx` must contain one integer for each level of `f` ``；需先 `drop_na()` 或填默认值。
3. **`across()` 传参**：`across(where(is.numeric), round, digits = 1)` 的 `...` 写法在新版 dplyr 已弃用，改 `~ round(.x, 1)`。
4. **空分隔符拆分**：`separate_longer_delim(delim = "")` 与 `separate_wider_delim(delim = "")` 均不接受空字符串；无分隔符的字符串要先 `str_split()` + `unnest_longer()`。
5. **中文图形**：命令行 Rscript 默认图形设备是 pdf，不支持中文，会报「字体类别出错」；因此屏幕显示用 `if (interactive()) print(p)`，出图一律用 `ggsave()` 落 PNG，并在主题里指定 `family = "PingFang SC"`。

## 九、课后延伸建议

- 数据清洗实战：缺失值 / 异常值 / 类型纠错 / 重复记录去重；
- ggplot2 图形语法：分面、坐标轴刻度、配色与图表导出参数；
- 把第四节的 Base R 写法和第八节的 dplyr 写法逐一对照，理解两者等价关系。
