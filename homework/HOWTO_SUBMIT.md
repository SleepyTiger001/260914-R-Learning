# 作业提交指南（Fork + Pull Request）

本仓库 `main` 分支不接受直接推送。学生按下述流程把答案提交为 Pull Request。

## 速览：六个动作

| # | 动作 | 在哪做 |
| --- | --- | --- |
| 1 | Fork 本仓库，得到你自己的副本 | GitHub 网页 |
| 2 | 克隆你的 Fork 到本地 | 终端 |
| 3 | 关联上游（老师）仓库，方便后续同步 | 终端 |
| 4 | 写答案到 `homework/solutions/<你的名字>/S_NN_260914.R` | 本地编辑器 |
| 5 | 提交并推送到你的 Fork | 终端 |
| 6 | 从你的分支向老师仓库发起 Pull Request | GitHub 网页 |

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
3. 逐行实现题目要求，**每一行都能独立运行**，并写中文注释。
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

## 常见问题

| 现象 | 原因与处理 |
| --- | --- |
| 能不能直接 clone 老师仓库再关联 Fork？ | 技术上可行，但**不推荐**。直接 clone 老师仓库时 `origin` 指向老师仓库，你没有写权限；新分支第一次不带远端名推送会被 git 提示 `git push --set-upstream origin <分支>`，照着做就会推到老师仓库并被拒。见下方说明 |
| PR 里出现无关改动 | 分支不是从最新 `main` 切出；先 `git fetch upstream && git merge upstream/main` 再改 |
| 忘记关联 upstream | 重新执行第 3 步的 `git remote add upstream ...` |
| 推送被拒（protected branch） | 不要往 `upstream/main` 推；推到自己 Fork 的分支，再发 PR |
| 本地文件不在 `solutions/<名字>/` | 学生答案必须放在该目录下，文件名 `S_NN_260914.R`，否则不会被批改 |

### 为什么先 clone 自己的 Fork

Pull Request 的 head 必须是**你自己有写权限**的仓库分支，所以答案一定要推送到 Fork，两种做法都合法：

| 做法 | 远端设置 | 推送命令 | 风险 |
| --- | --- | --- | --- |
| A（推荐）先 clone Fork | `origin` = 你的 Fork，`upstream` = 老师仓库 | `git push -u origin <分支>` | 默认推送目标就是自己的仓库，不易推错 |
| B 先 clone 老师仓库 | `origin` = 老师仓库，另加 `fork` = 你的 Fork | `git push fork <分支>`（必须显式指定） | 漏写远端名时 git 会提示推到 `origin`，照做即被拒 |

做法 B 的完整命令：

```bash
git clone https://github.com/shujuecn/260914-R-Learning.git
cd 260914-R-Learning
git remote add fork https://github.com/<你的用户名>/260914-R-Learning.git
git checkout -b hwNN-<你的名字>
# 写答案……
git add homework/solutions/<你的名字>/S_NN_260914.R
git commit -m "作业 NN：<你的名字>"
git push fork hwNN-<你的名字>
gh pr create --repo shujuecn/260914-R-Learning --base main \
  --head <你的用户名>:hwNN-<你的名字> --title "作业 NN：<你的名字>"
```

结论：两种都能交上作业，按本指南先 clone Fork 更省事。

## 提交检查清单

- [ ] 文件路径为 `homework/solutions/<你的名字>/S_NN_260914.R`
- [ ] 每行代码可独立运行，含中文注释
- [ ] 未夹带真实姓名、学号、邮箱、电话等隐私信息
- [ ] `git remote -v` 中 `origin` 是自己的 Fork，`upstream` 是老师仓库
- [ ] Pull Request 的 base 为 `shujuecn/260914-R-Learning:main`，head 为自己的分支
