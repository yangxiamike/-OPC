# OPC 基础工作环境安排 v0.1

日期：2026-05-18
定位：一人公司 OPC 的办公室、资料库、Agent 工作区和研发索引。

## 1. 总原则

OPC 文件夹是董事长办公室，不是 Hermes 系统目录。

OPC 保存：

- 公司决策
- CEO 输入
- 项目资料
- 客户资料
- 知识沉淀
- 资产素材
- 产品研发文档
- 运行手册
- 复盘指标
- Hermes 团队蓝图

Hermes 系统目录保存：

- profile
- config
- .env
- token
- SOUL.md 实际启用版
- MEMORY.md
- memory_store.db
- sessions
- logs
- kanban 状态库

原则：Hermes 运行态不污染 OPC；Hermes 结论要沉淀回 OPC。

## 2. 两层架构

```text
Hermes Runtime
= Agent 后台机房
= 记忆、会话、密钥、运行状态、真实 profile

OPC Workspace
= 董事长办公室
= 公司事实源、项目现场、客户档案、资产和复盘
```

Hermes profile 可以把工作目录指向 OPC 或 OPC 子目录。

例：

```text
CEO Agent cwd: 一人公司OPC/
Research Agent cwd: 一人公司OPC/05_经验沉淀/
Dev Agent cwd: 一人公司OPC/03_项目库/某项目/
QA Agent cwd: 一人公司OPC/03_项目库/
```

这是相对隔离，不是安全沙箱。

## 3. 当前目录边界索引

本文件只写当前已经能用的 OPC 办公室边界。要不要改目录、加房间、搬东西，统一放在 `07_等夏董拍板/2026-05-18_OPC_目录整理_请夏董拍板.md`，等夏董一句话后再动。

```text
一人公司OPC/
├─ 01_董事会决议
├─ 02_CEO任务输入
├─ 03_项目库
├─ 04_公司治理策略
├─ 05_经验沉淀
├─ 06_每日复盘记录
└─ 07_等夏董拍板
```

### 01_董事会决议

放重大判断：

- 做不做
- 为什么做
- 风险边界
- 投入原则
- 停止条件

不放 Kanban，不写每日任务。

### 02_CEO任务输入

放给 CEO Agent 的输入：

- 目标
- 背景
- 约束
- 交付标准
- 风险提醒
- 需夏董拍板事项

不替 CEO 拆细任务。

### 03_项目库

放具体战役和客户项目。项目库是战场，不是永久档案馆；结束后可按夏董拍板后的归档规则迁移。

### 04_公司治理策略

放公司规则和 Hermes 团队蓝图：

- Hermes 团队架构
- Agent 权责
- profile 蓝图
- Kanban 使用规则
- Memory 使用边界
- QA Gate 规则
- 公司交付标准
- 报价和审批原则

注意：这里放蓝图，不放真实密钥和运行数据库。

### 05_经验沉淀

放可复用判断、方法论、复盘后的经验和技术笔记。

经验沉淀是“怎么判断、怎么改进”的事实源，不是客户素材仓库。

### 06_每日复盘记录

放日常复盘、运行观察、阶段性问题和改进线索。

复盘记录可提炼为治理策略、交付要求或经验沉淀；未提炼前不直接视为正式制度。

### 07_等夏董拍板

放还没决定、需要夏董一句话的事。

这里的文件不算正式制度；夏董拍板后，我再把确定内容放回治理、项目或运行文件。

## 4. Hermes 记忆规则

每个长期 Agent 使用独立 profile。

建议：

```text
ceo profile
research profile
strategy profile
design profile
dev-test profile
qa profile
```

每个 profile 独立拥有：

```text
SOUL.md
MEMORY.md
memory_store.db
sessions
logs
skills
```

不要让所有 Agent 共用一个 memory_store.db，除非明确需要共享记忆。

## 5. MEMORY.md 与 memory_store.db

```text
MEMORY.md
= Agent 铁律
= 短、稳定、每次启动都要知道
```

适合放：

- 夏董偏好
- 角色边界
- 永久禁区
- 交付原则
- 审批规则

```text
memory_store.db
= Agent 联想记忆
= 可检索事实库
= 可积累，但不透明
```

适合放：

- 客户偏好摘要
- 项目历史事实
- 行业案例
- 复盘结论
- 可信度较高的经验

```text
OPC 文件夹
= 公司权威档案
```

若 memory_store.db 与 OPC 正式文件冲突，以 OPC 为准。

## 6. AGENTS.md 使用规则

根目录 AGENTS.md 是 Codex / 托特董秘的办公室总规则，同时挂接全公司工作纪律。

Hermes 执行团队不从根目录 AGENTS.md 继承董秘身份。CEO、Research、Strategy、Design、Dev/Test、QA 等角色由各自 Hermes profile、SOUL.md、MEMORY.md 和 Kanban 任务约束。

子目录可放局部 AGENTS.md：

```text
03_项目库/某项目/AGENTS.md
04_公司治理策略/AGENTS.md
07_等夏董拍板/AGENTS.md
```

局部 AGENTS.md 用来告诉 Agent：

- 当前区域是什么
- 可以看什么
- 不该碰什么
- 输出放哪里
- 何时上报

## 7. CEO + Kanban 规则

CEO Agent 是 orchestrator，不是执行员。

CEO 负责：

- 读 CEO 输入
- 拆 3-7 张核心 Kanban 卡
- 分配给 worker Agent
- 设置 workspace
- 设置验收标准
- 处理 block
- 汇总给夏董

Worker Agent 负责：

- 读卡
- 进入 workspace
- 执行任务
- 更新 heartbeat
- complete 或 block
- 输出结果到 OPC 对应目录

Kanban 只用于：

- 跨 Agent 协作
- 多步交接
- 需要恢复的任务
- 需要审计的任务
- 需要人类审批的任务

小事直接做，不进 Kanban。

## 8. Board 与 Workspace

Board 按项目或领域分，不按 Agent 分。

建议：

```text
default
opc-company-os
valve-website-growth
client-xxx-redesign
```

不建议：

```text
ceo-board
research-board
dev-board
```

Workspace 选择：

```text
scratch
= 临时探索

dir:<OPC 绝对路径>
= 文档、项目、客户、资产任务

worktree
= 代码任务、并行开发
```

## 9. 一句话定案

OPC 是共同办公室；Hermes profile 是各 Agent 的后台机房。

Agent 从不同入口进办公室，在指定区域工作，结果回到公司事实源。
