# GitHub 上传和运行说明

1. 解压 `NHANES-Sugar-Depression-GitHub-PPO.zip`，打开里面的 `NHANES-Sugar-Depression` 文件夹。
2. 在 GitHub 仓库首页选择 **Add file → Upload files**。空仓库可以使用页面上的上传现有文件入口。
3. 把该文件夹内的内容上传到仓库根目录。提交前，确认 `README.md`、`code/`、`data/` 和 `docs/` 位于根目录，并保留 `.gitignore` 和 `.gitattributes`。
4. 提交后确认仓库首页显示 README，而且 `data/processed/` 里有三个 `.dta` 文件。若之前上传过旧版，请用新版文件覆盖同名文件。

[GitHub 网页上传说明](https://docs.github.com/en/repositories/working-with-files/managing-files/adding-a-file-to-a-repository)

在 Stata 中运行前，如果尚未安装 `gologit2` 3.2.8，请按根目录 README 下载作者发布的 ZIP，把解压后的文件放入 `vendor/gologit2/`。确认 `gologit2.ado` 和 `gsvy.ado` 就在该目录内。入口会优先使用这份本地副本，并清除旧版命令缓存。用于自己电脑运行的第三方扩展文件不需要上传。

将 Stata 的工作目录设为仓库根目录，然后运行 `do code/00_master.do`。结果写入 `output/logs/analysis.log`。直接分析使用配好的三个数据集中的合并数据。要从原始数据重建，按 `data/README.md` 下载对应的 16 个 XPT 文件，再运行 `do code/00_master.do full`。

本版第 4 项使用调查加权的部分比例优势 Logit，且仅允许糖摄入系数随 PHQ-9 分界线变化。论文表格导出代码仍按作者决定省略。
