# 作业提交指南（Fork + Pull Request）

本仓库 `main` 分支不接受直接推送。学生按下述流程把答案提交为 Pull Request。

## 速览：六个动作

| # | 动作                                                    | 在哪做      |
| - | ------------------------------------------------------- | ----------- |
| 1 | Fork 本仓库，得到你自己的副本                           | GitHub 网页 |
| 2 | 克隆你的 Fork 到本地                                    | 终端        |
| 3 | 关联上游（老师）仓库，方便后续同步                      | 终端        |
| 4 | 写答案到`homework/solutions/<你的名字>/S_NN_260914.R` | 本地编辑器  |
| 5 | 提交并推送到你的 Fork                                   | 终端        |
| 6 | 从你的分支向老师仓库发起 Pull Request                   | GitHub 网页 |

约定：`NN` 为作业序号（如 `01`），`260914` 为发布批次。学生文件一律命名为 `S_NN_260914.R`，放在自己名字的目录下。

---

## 0. 前置条件

```bash
git --version        # 需已装 git
gh --version         # 可选：用 gh 创建 PR 更省事
```

GitHub 账号需已登录，且能访问 https://github.com/shujuecn/260914-R-Learning 。

---

## 1. Fork 本仓库

打开 https://github.com/shujuecn/260914-R-Learning ，点右上角 **Fork** → **Create fork**。
完成后你会得到 `https://github.com/<你的用户名>/260914-R-Learning`。

## 2. 克隆你的 Fork

```bash
git clone https://github.com/<你的用户名>/260914-R-Learning.git
cd 260914-R-Learning
```

## 3. 关联上游仓库

`upstream` 指向老师仓库，用于后续把老师的新题目同步下来；`origin` 是你自己的 Fork。

```bash
git remote add upstream https://github.com/shujuecn/260914-R-Learning.git
git remote -v          # 确认 origin 与 upstream 都在
git fetch upstream     # 拉取老师仓库最新内容
git merge upstream/main    # 把最新题目合并进本地 main
```

## 4. 写答案

1. 打开 `homework/questions/Q_NN_260914.R` 读题目。
2. 新建目录与文件：`homework/solutions/<你的名字>/S_NN_260914.R`。
3. 逐行实现题目要求，并写中文注释。
4. 提交前自查：文件名是否符合 `S_NN_260914.R`，是否留下真实姓名、学号、邮箱、电话等隐私信息（题目里不要写）。

开发时先切一个分支，便于反复修改：

```bash
git checkout -b hwNN-<你的名字>      # 例：hw01-张三
```

## 5. 提交并推送到你的 Fork

```bash
git add homework/solutions/<你的名字>/S_NN_260914.R
git commit -m "作业 NN：<你的名字>"
git push -u origin hwNN-<你的名字>
```

## 6. 提交 Pull Request

网页方式：打开你的 Fork，GitHub 会提示 **Compare & pull request**，点进去：

- **base repository**：`shujuecn/260914-R-Learning`，base 分支 `main`
- **head repository**：`<你的用户名>/260914-R-Learning`，compare 分支 `hwNN-<你的名字>`
- 标题写「作业 NN：<你的名字>」，简要说明实现思路，然后 **Create pull request**。

命令行方式（已装 `gh`）：

```bash
gh pr create \
  --repo shujuecn/260914-R-Learning \
  --base main \
  --head <你的用户名>:hwNN-<你的名字> \
  --title "作业 NN：<你的名字>" \
  --body "按题目要求实现，逐行可运行。"
```

---

## 提交检查清单

- [ ] 文件路径为 `homework/solutions/<你的名字>/S_NN_260914.R`
- [ ] 每行代码可独立运行，含中文注释
- [ ] 未夹带真实姓名、学号、邮箱、电话等隐私信息
- [ ] `git remote -v` 中 `origin` 是自己的 Fork，`upstream` 是老师仓库
- [ ] Pull Request 的 base 为 `shujuecn/260914-R-Learning:main`，head 为自己的分支
