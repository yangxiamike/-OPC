# Hermes 与项目工作环境分离经验 v0.1

更新时间：2026-05-20

## 背景

OPC 当前同时使用 Hermes 作为后台执行与飞书连接系统，并使用本地项目库承载公司资料、项目交付、脚本和运行记录。

如果把网页开发、爬虫、数据分析、量化、客户项目等依赖都装进 Hermes 自身环境，Hermes 会逐渐变重，后续也更难判断问题来自 Hermes 本身还是某个项目依赖。

## 结论

Hermes 环境和项目工作环境应分开。

- Hermes 专用环境：只放 Hermes 启动、gateway、飞书连接、profile、调度、基础通信等依赖。
- OPC 当前工作环境：放当前项目交付和内部工具会用到的依赖，例如网页资料抓取、轻量脚本、页面分析等。
- 未来项目明显增多或类型分化后，再按项目拆独立环境。

## 当前落地方式

当前先采用两层结构：

```text
C:\Users\hp\AppData\Local\hermes\hermes-agent-fast\.venv
  Hermes 专用环境

C:\Users\hp\Documents\一人公司OPC\.venv
  OPC 当前工作环境
```

OPC 当前工作环境的依赖清单放在：

```text
C:\Users\hp\Documents\一人公司OPC\requirements-opc-work.txt
```

## 使用原则

Hermes 接到任务后，可以进入 OPC 项目文件夹，调用 OPC 工作环境里的 Python 执行脚本。

示例：

```text
C:\Users\hp\Documents\一人公司OPC\.venv\Scripts\python.exe <script>
```

不要为了某个项目临时需要 BeautifulSoup、爬虫、网页开发、数据分析或量化库，就把这些依赖装进 Hermes 专用环境。

## 未来拆分标准

当出现以下情况时，再从 OPC 当前工作环境继续拆出项目独立环境：

- 某个客户项目需要长期维护和独立复现。
- 项目依赖变重，例如量化、机器学习、浏览器自动化、数据库服务。
- 不同项目依赖版本冲突。
- 项目需要交付给外部或迁移到服务器。

届时每个项目可在自己的目录下建立 `.venv`、`requirements.txt` 或 `pyproject.toml`。

## 预期收益

- Hermes 更稳定，不被项目依赖污染。
- 排错边界更清楚：Hermes 问题查 Hermes，项目问题查项目环境。
- 有机会降低 Hermes 启动和常驻运行压力。
- 当前阶段不做过度拆分，先降低判断成本。

## 注意事项

少装包主要减少环境复杂度和误加载风险；是否明显降低内存，取决于 Hermes 启动时实际加载了哪些模块。

OPC 文件夹仍是公司事实源，不等同于 Hermes 运行环境。
