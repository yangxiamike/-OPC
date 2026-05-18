# BitzNet 与 Codex 稳定连接诊断

日期：2026-05-18

## 结论

本次故障不是 Codex 本体损坏，也不是单纯 Windows 系统代理页设置问题。

主因有两层：

1. Codex CLI / Codex GUI / Git 主要依赖 `HTTP_PROXY`、`HTTPS_PROXY` 和 Git 代理，当前都指向 `127.0.0.1:8890`。
2. BitzNet 的 `Bitz Net` 代理组原先选中“故障转移”，实际落到的节点会对 `chatgpt.com`、`api.openai.com` 或 `ws.chatgpt.com` 间歇超时；部分低延迟节点又会被 ChatGPT 风控返回 `403 Forbidden`。

最终可用解是：把 BitzNet 的 `Bitz Net` 组固定到：

`台湾-广东专线 STUIX`

## 关键证据

- `127.0.0.1:8890` 当前由 BitzNet/Clash 内核监听。
- Codex 日志里出现过 `codex.exe -> chatgpt.com:443 context deadline exceeded`。
- HKT 节点延迟很低，但访问 Codex 后端返回 `403 Forbidden`，不适合 Codex。
- 台湾 STUIX 节点对 Codex 后端返回 `405 Method Not Allowed`，这是“已到达后端但请求方法不对”的健康信号。
- 固定台湾 STUIX 后，`codex exec --skip-git-repo-check "Reply with exactly: OK"` 连续验证成功，返回 `OK`。

## 当前已执行

- 运行时把 BitzNet 的 `Bitz Net` 组切到 `台湾-广东专线 STUIX`。
- 已更新 BitzNet 本地持久配置里的偏好节点，使 BitzNet 重启后仍倾向使用该节点。
- 修改前已备份原配置到 BitzNet 配置目录，文件名形如 `vortex.json.bak-codex-YYYYMMDD-HHMMSS`。

## 后续恢复口径

若以后 BitzNet 更新订阅、重启或重装后 Codex 又开始断连，优先检查三件事：

1. BitzNet 是否仍监听 `127.0.0.1:8890`。
2. BitzNet 的 `Bitz Net` 组是否仍选中 `台湾-广东专线 STUIX`。
3. Codex CLI 最小验证是否能返回 `OK`。

如果台湾 STUIX 失效，替代候选优先级：

1. 美国-广东专线 GCore
2. 美国-广东专线 BGP 1
3. 美国-广东专线 BGP 2
4. 香港-广东专线 GCore

避免优先使用：

- 香港-广东专线 HKT：快，但会触发 ChatGPT 403。
- 香港-广东专线 NeaRoute / HKBN / HGC：测试中连接失败或严重超时。
- 默认“故障转移”：会把 Codex 流量带回不稳定节点。
