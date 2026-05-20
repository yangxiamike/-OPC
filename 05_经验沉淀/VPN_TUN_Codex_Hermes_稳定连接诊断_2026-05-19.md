# VPN / TUN 与 Codex-Hermes 稳定连接诊断

日期：2026-05-19

## 核心结论

以后遇到 Codex、Hermes、飞书 gateway、Codex provider 间歇断连，优先判断：

`后台进程没有走到稳定 VPN / TUN 路径`

标准路线应是：

`Windows 本机进程 -> VPN TUN / 全局接管 -> 稳定节点 -> ChatGPT / Codex backend`

只看 ChatGPT 网页能不能打开不够。浏览器能连，不代表 Hermes CLI、飞书 gateway、Node/Python 子进程、Codex provider 都走了同一条网络。

## 本次验证结果

开启 TUN 后，不显式设置 `HTTP_PROXY` / `HTTPS_PROXY`，以下链路已验证可用：

- 周成 `max_ceo`：`openai-codex / gpt-5.5` 返回 `【周成TUNCodex可通】`
- 托特 `thoth_sec`：`openai-codex / gpt-5.5` 返回 `【托特TUNCodex可通】`
- Hermes 飞书 gateway 可启动并连接飞书。

因此，当前优先方案是：

`开 TUN -> 重启 Hermes gateway -> 再测飞书真实对话`

## 典型误判

如果只开普通代理、不走 TUN，可能出现：

- ChatGPT 网页正常。
- Codex Desktop 正常。
- 但 Hermes `openai-codex` 超时。
- 飞书里的托特 / 周成不回或像断开。

原因通常不是 Agent 身份、SOUL、Memory 或飞书 Bot 坏了，而是后台进程没有继承到稳定网络路径。

## 标准排查顺序

1. 确认 VPN 已开启 `TUN / 全局接管`。
2. 确认当前节点能稳定访问 ChatGPT / Codex backend。
3. 用 Hermes 分别测试 `max_ceo` 和 `thoth_sec` 的 `openai-codex` 是否能返回短句。
4. 重启 Hermes 飞书 gateway，让后台进程继承当前 TUN 网络。
5. 在飞书私聊里发“测试”，看 gateway 日志是否收到消息并触发 Codex 回复。

## 长期配置口径

- 周成 `max_ceo` 默认模型：`openai-codex / gpt-5.5`
- 托特 `thoth_sec` 默认模型：`openai-codex / gpt-5.5`
- Hermes gateway 启动脚本默认不再强制写入 `127.0.0.1:7897`。
- 如果 TUN 不可用，才临时考虑 `HTTP_PROXY` / `HTTPS_PROXY` 兜底。
- 启动多个 Hermes profile 时不要用互相挤掉的 `--replace` 方式。

## 节点选择提醒

节点仍然重要，但优先级低于 TUN 路径统一。

优先选择：稳定、不频繁换出口、不触发 ChatGPT / Codex 风控的节点。

避免优先选择：

- 只看延迟低但触发 `403 Forbidden` 的节点。
- 自动故障转移但频繁切换出口的策略。
- 浏览器能开网页、但 CLI / WebSocket / 后台进程容易超时的节点。

历史经验：BitzNet 普通代理模式下，`台湾-广东专线 STUIX` 曾较稳；`香港-广东专线 HKT` 曾触发 ChatGPT 403。该经验只作参考，不再作为首要标准。
