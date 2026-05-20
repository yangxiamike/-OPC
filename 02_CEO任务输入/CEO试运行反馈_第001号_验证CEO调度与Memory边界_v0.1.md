# CEO 试运行反馈：验证 CEO 调度与 Memory 边界 v0.1

日期：2026-05-18
来源 Kanban：t_23cdcde6
执行角色：Hermes CEO / PM，周成 / Max Zhou
性质：最小试运行反馈，不是董事会制度定稿，不是客户交付件。

## 1. 试运行结论

结论：CEO / PM 可以承接董事会到执行团队之间的经营调度职能。Hermes provider、profile、Holographic Memory、Kanban worker 自动派工链路均已完成最小可运行验证。

已通过事项：

- CEO / PM 角色边界清楚：接收 CEO 输入、拆核心任务、调度 Research / Strategy / Design / Dev-Test / QA Gate、汇总风险和需拍板事项。
- CEO / PM 不改写董事会制度，不替夏董批准报价、收付款、客户承诺、范围变更或重大取舍。
- Holographic Memory 已启用，并按 OPC 规则限制读取、写入、更新、禁区和复盘沉淀。
- OPC 本地文件夹仍是公司事实源；Hermes Memory 只做辅助记忆，不覆盖董事会决议、CEO 输入、治理策略和项目文件。
- Windows 桌面环境下 Kanban dispatcher 曾触发 `NoConsoleScreenBufferError`；已通过本机 Hermes 启动链路修复，改用 `-z` oneshot worker，并补齐 `--skills kanban-worker` 支持。

## 2. CEO 调度链路验证

最小调度链路按以下顺序成立：

1. 董事会 / 托特秘书层形成上位决议、尺度审计和 CEO 任务输入。
2. CEO / PM 接收任务输入，只做经营拆解与调度，不制定底层制度。
3. Research 负责事实、情报、竞品和资料核验。
4. Strategy 负责转化判断、优先级和商业路径。
5. Design / UX 负责体验方案、页面结构和设计资产。
6. Dev / Test 负责实现、测试和可运行交付。
7. QA Gate 负责放行审查、风险拦截和返工要求。
8. CEO / PM 汇总进度、卡点、风险和需夏董拍板事项。

边界判断：

- 对外客户可见内容必须经过 QA Gate。
- CEO 可以调度项目 Kanban，但不能越权承诺客户结果。
- 职能 Agent 之间保持 SOUL / MEMORY 独立，不互相污染。
- 触发报价、收付款、客户承诺、延期、声誉风险、范围变更时，必须上报夏董。

## 3. Hermes CLI 最小试运行记录

- provider：`openai-codex`
- 默认模型：`gpt-5.5`
- sticky profile：`ceopm`
- CEO 会话 ID：`20260518_174039_b5e5f8`
- 同会话续接：`hermes --resume 20260518_174039_b5e5f8 -z ...` 成功。
- Kanban board：`opc-company-os`
- 主验证任务：`t_23cdcde6`，状态 `done`
- worker 修复后复测任务：`t_34bad2de`，状态 `done`
- worker oneshot 复测任务：`t_e20bbf0f`，状态 `done`

本次修复点：

- `cli.py`：控制台输出失败时 fallback 到普通 stdout。
- `oneshot.py` / `main.py`：oneshot 支持预加载 `kanban-worker` skill。
- `kanban_db.py`：worker spawn 改走 `hermes -p <profile> --skills kanban-worker -z <prompt>`。

## 4. Memory 边界验证

允许进入长期记忆的内容：

- 夏董稳定偏好。
- CEO / PM 与其他 Agent 的角色边界。
- 已确认的项目历史摘要。
- 复盘后的有效经验。
- 反复出现的协作问题。
- 已验证且未来仍有用的行业观察。

禁止进入长期记忆的内容：

- token、API key、密码、cookie、私钥、session。
- 客户手机号、身份证、地址、个人隐私和未公开商业秘密。
- 未确认报价、折扣、交付期限、效果承诺。
- `.env`、运行数据库、账号凭证、财务敏感信息。
- 会在 7 天内过期的临时任务进度、PR 号、commit、一次性执行结果。

权威顺序：

1. 夏董当次明确指令。
2. 董事会决议。
3. CEO 任务输入。
4. 治理策略 / 员工守则。
5. OPC 项目库和正式文件。
6. Agent SOUL / MEMORY。
7. Holographic Memory。

## 5. 本次验证未写入的内容

本次试运行没有写入或复制以下敏感内容：

- token / secret / cookie / 私钥。
- 客户隐私。
- 未确认报价、折扣或交付承诺。
- 董事会制度改写内容。

本文件只沉淀试运行判断、修复结果和边界结论。

## 6. 后续观察点

1. worker 自动派工已通过 smoke，但仍应在第 2 号业务决议接入时观察长任务稳定性。
2. CEO 不能直接修改董事会制度、SOUL 或治理蓝图。
3. Memory 写入只沉淀复盘后的稳定经验，不记录一次性执行流水。
4. 对外内容仍必须经 QA Gate 放行。
