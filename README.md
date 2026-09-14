# 260914-R-Learning

R Base + tidyverse 基础语法通识课的教学仓库。一节课、一个脚本、逐行执行，配套课后作业。

## 一、这是什么

- **教学脚本**：`scripts/NN_主题/` 下每课一个 `.R` 文件，从第 1 课开始逐行向下执行。
- **随仓库数据**：`data/NN_主题/` 随仓库分发，克隆后直接可用。
- **课后作业**：`homework/questions/` 放题目，学生把答案写进 `homework/solutions/<你的名字>/`，用 Fork + Pull Request 提交。

## 二、怎么用

1. 用 RStudio 打开项目文件 `260914-R-Learning.Rproj`，工作目录会自动锁定在项目根目录。
2. 打开 `scripts/01_base_tidyverse/01_R_base_tidyverse_basics.R`。
3. 把光标停在某一行按 `Cmd + Enter` 执行该行；选中若干行可一次执行所选代码。
4. 从上往下顺序执行，不要跳段（后文会用到前文的对象）。

命令行整体跑一遍（验证环境，约 4 秒）：

```bash
Rscript scripts/01_base_tidyverse/01_R_base_tidyverse_basics.R
```

## 三、目录结构

`scripts/`、`data/`、`outputs/` 一律按 **「课次_主题」编号子文件夹** 组织，同一课三处编号与主题名保持一致，后续课程依次追加 `02_XXX`、`03_XXX`。

```
260914-R-Learning.Rproj                       # 双击打开，工作目录即项目根目录
scripts/01_base_tidyverse/                    # 第 1 课脚本（逐行执行）
data/01_base_tidyverse/                       # 第 1 课数据（随仓库分发）
outputs/01_base_tidyverse/{tables,figures}/   # 第 1 课产出（运行后生成，默认不入库）
homework/
  questions/Q_NN_260914.R                     # 题目（NN 为作业序号）
  answers/A_NN_260914.R                       # 参考答案（不对外发布）
  solutions/<学生名>/S_NN_260914.R             # 学生答案（Fork + Pull Request 提交）
```

新增一课时，同步创建 `scripts/NN_主题/`、`data/NN_主题/`、`outputs/NN_主题/{tables,figures}/` 三处即可。
脚本内使用**相对路径**，因此工作目录必须是项目根目录 —— 用 `.Rproj` 打开即可满足，不要单独打开 `scripts/` 下的文件。

## 四、运行环境

| 项目 | 版本 / 说明 |
| --- | --- |
| R | 4.5.2（原生管道 `|>` 需 4.1+） |
| tidyverse | 2.0.0（dplyr / tidyr / ggplot2 / readr / purrr / tibble / stringr / forcats） |
| rio | 万能读写包，配合 openxlsx、readxl |

脚本首节已给出安装命令（注释状态），本机无需执行。

## 五、作业怎么交

见 [`homework/HOWTO_SUBMIT.md`](homework/HOWTO_SUBMIT.md)：Fork 本仓库 → 克隆你的 Fork → 关联上游 → 写答案 → 推送 → 提交 Pull Request。
