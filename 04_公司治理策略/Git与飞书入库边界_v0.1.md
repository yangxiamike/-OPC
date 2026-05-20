# Git 与飞书入库边界 v0.1

更新时间：2026-05-20
适用范围：OPC 本地事实源、Hermes/Feishu 网关配置、战情/报告/工作群相关资料。

## 1. 结论

- Git 仓库只收录：制度、流程、模板、脱敏后的配置说明、可复用脚本、项目事实源文件。
- Git 仓库不得收录：密钥、token、cookie、真实 session、私钥、原始运行日志、未脱敏的用户/群/消息标识映射表。
- 飞书群名、用途、通知规则、卡片模板结构可以入库。
- 飞书真实 `open_id / chat_id / message_id / card_id / tenant_key` 等外部系统标识默认不入库；必须用于文档示例时，用占位符或脱敏形态。
- `.git` 写入异常或工作区混杂时，先做审计和分组，不 push。

## 2. 可入库

### 2.1 飞书配置类

可以入库，但必须不含密钥：

- 群用途、路由规则、消息类型说明。
- `FEISHU_REQUIRE_MENTION=true` 这类布尔/策略项。
- 卡片 JSON 模板结构、按钮文案、字段名称。
- 启停脚本中不含真实密钥的通用逻辑。
- profile 名称、岗位名、职责边界。

要求：

- 示例中的 user_id/chat_id 使用 `OPEN_ID_OF_xxx`、`CHAT_ID_OF_xxx`、`MESSAGE_ID_OF_xxx`。
- 本地路径如必须出现，只能作为运行示例，不能作为唯一事实源。

## 3. 脱敏后才可入库

以下内容可用于复盘/排错，但必须处理后入库：

- 飞书 open_id / chat_id / message_id / card_id：保留前缀和用途，不保留完整值。
  - 示例：`oc_****战情群`、`ou_****周成CEO`。
- 网关报错日志：只保留错误类型、时间、影响、修复动作；删除 token、header、payload 原文。
- 外部服务 URL：公开官网/API 域名可保留；带签名、token、一次性参数的 URL 必须删除参数。
- 运行截图/审计记录：只保留业务判断需要的字段。

## 4. 仅本地保存，禁止入库

- `.env`、`.env.*`。
- app_secret、verification_token、encrypt_key、access_token、refresh_token、cookie、Authorization header。
- 私钥、SSH key、证书、OAuth 凭证。
- 原始 gateway/session 日志、PID、SQLite 状态库、缓存目录。
- 未脱敏的飞书成员列表、用户 open_id 与真实姓名的完整映射。
- 客户隐私、财务敏感原文、未确认报价/折扣/交付承诺。

## 5. Git 清场流程

当工作区出现大量未提交/未跟踪变更：

1. `git status --porcelain=v1` 先盘点数量，不直接 `git add .`。
2. 按三组处理：
   - A：制度/事实源/模板，可入库。
   - B：含外部标识或运行细节，先脱敏再入库。
   - C：日志/缓存/密钥/本地状态，仅本地或加入 `.gitignore`。
3. 对 `.git` 做写入测试：能创建并删除临时文件，且无 `index.lock`，才允许 commit。
4. commit 前跑一次敏感词扫描：`token|secret|password|cookie|private_key|authorization|app_secret|verification_token|encrypt_key`。
5. push 前必须确认：本次 commit 无 C 组文件、无完整飞书外部标识、无密钥。

## 6. 当前 OPC 工作区初步分类

### A. 倾向可入库

- 董事会/CEO 输入/公司治理/经验沉淀类 Markdown。
- `requirements-opc-work.txt`。
- 已脱敏的飞书规范、审批卡片规范、卡片模板。

### B. 需脱敏或复核后入库

- `04_公司治理策略/Feishu_@提及触发规范_v0.1.md`：示例 user_id 已改为占位符。
- `02_CEO任务输入/feishu_group_audit.md`：可保留失败审计摘要；真实 ChatId 如后续补充，必须脱敏。
- `04_公司治理策略/start_hermes_feishu_gateways_v0.1.ps1`：当前未见密钥，但属于运行脚本，入库前确认只含通用逻辑。
- `04_公司治理策略/manage_feishu_group_v0.1.ps1`：入库前确认无真实 token、成员 ID 明细。

### C. 仅本地/忽略

- `*.bak-*` 备份文件。
- 原始飞书运行快照、gateway 日志、PID、SQLite 状态库。
- profile `.env` 与任何 credential 文件。

## 7. 禁止动作

- 禁止在混杂状态下 `git add . && git commit && git push`。
- 禁止为了“看起来干净”删除未知变更。
- 禁止把真实外部系统 ID 当作普通配置长期入库。
- 禁止在 `.git` 写入异常未复测前继续提交或 push。
