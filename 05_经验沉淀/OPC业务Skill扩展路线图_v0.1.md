# OPC 业务 Skill 扩展路线图：从阀门到工业品与出海品牌 v0.1

日期：2026-05-19
来源：第002号阀门官网3套demo战役讨论沉淀
状态：长期路线图，非战役级

---

## 一、核心思路

OPC 的业务能力建设，不试图一次建成覆盖所有行业的通用 skill。

而是：

> **先做一个行业做深，把阀门做成样板；
> 再按相同骨架复制到相邻行业；
> 最后根据业务方向区分“工业品询盘型”和“电商品牌转化型”两条线。**

同一个业务模型内的行业可以共享 skill 骨架，不同业务模型之间不混用。

---

## 二、当前阶段：阀门专项（2026年5月）

正在做的：

> **opc-valve-inquiry-website**

服务范围：

- 阀门官网 demo 验收；
- 阀门网站 DESIGN.md 审核；
- 中小外贸阀门工厂旧官网诊断；
- 阀门网站询盘路径判断；
- 基础/标准/增强版报价档位判断；
- 阀门行业 AI 味/白板感/大厂错位识别。

这是 OPC 工业品询盘型网站能力的第一个行业样板。

---

## 三、第二阶段：工业品询盘型扩展（预计后续 3-6 个月）

当阀门专项跑稳后，按相同结构复制到其他出海工厂产品行业。

可扩展的行业：

- 泵（pump）；
- 管件（pipe fittings/flanges）；
- 电机（motor）；
- 五金制造（hardware manufacturing）；
- 机械设备（machinery & equipment）；
- 仪器仪表（instruments & meters）；
- 工业耗材（industrial consumables）。

每个行业复制阀门专项的 skill 结构：

```text
opc-pump-inquiry-website
opc-pipe-fitting-inquiry-website
opc-motor-inquiry-website
opc-machinery-inquiry-website
opc-instruments-inquiry-website
opc-industrial-hardware-inquiry-website
```

每个新行业 skill 只需替换：

- 行业产品分类和术语；
- 采购决策关键参数；
- 应用场景和证书；
- 竞品网站模式；
- 旧站常见问题。

骨架（中小外贸工厂定位、询盘路径、DESIGN.md 方法、AI味识别、白板感识别、大厂错位识别、三档复杂度）可复用。

---

## 四、工业品通用 skill 的诞生时机

当积累了 3-5 个工业品行业专项 skill 后，再从中抽取共性，形成工业品通用 skill：

> **opc-industrial-inquiry-website**

这个通用 skill 在遇到新工业品行业时，可以简化起步流程：先用通用部分建立基本判断，再补充行业专项细节。

但不建议在第一阶段就做泛行业通用 skill，那样会不够锋利。

---

## 五、另一条线：中小出海电商品牌转化型

这一条线和工业品询盘型的能力要求完全不同。

### 核心差异

| 维度 | 工业品询盘型 | 电商品牌转化型 |
|---|---:|---:|
| 网站目标 | 询盘 / RFQ / B2B 信任建立 | 下单 / 加购 / DTC 品牌转化 |
| 转化路径 | 产品分类 → 参数 → RFQ → 联系 | 首屏卖点 → 商品页 → 加购 → 结账 |
| 信任来源 | 工厂照片、参数、证书、定制能力 | 评价、UGC、品牌故事、退换货承诺 |
| 设计风格 | 稳定、清楚、工程感 | 情绪化、场景化、生活方式感 |
| CTA | Get a Quote / Send Inquiry / WhatsApp | Add to Cart / Buy Now / Subscribe |
| 页面结构 | Products → Applications → Factory → RFQ | Hero → Product Detail → Reviews → Checkout |
| 旧站诊断 | 产品难找、参数缺失、询盘路径长 | 首屏不清、商品页弱、加购阻力大 |

### 可覆盖的行业

- 宠物用品（pet supplies）；
- 家居（home & living）；
- 户外（outdoor & camping）；
- 美妆个护（beauty & personal care）；
- 小家电（small appliances）；
- 消费电子配件（consumer electronics accessories）；
- Shopify / DTC 品牌。

### 建议的专项 skill

将来形成：

> **opc-cross-border-ecommerce-website**

或在有更具体行业时先做行业专项：

```text
opc-pet-products-ecommerce
opc-home-goods-ecommerce
opc-beauty-ecommerce
```

### 重要边界

**电商品牌线不能直接套用工业品询盘型 skill。**

因为两者的判断标准、转化路径、页面结构、信任来源、CTA 逻辑完全不同。混用会导致 QA 判断失效、设计方向偏差、诊断错误。

---

## 六、扩展路线图总览

```
                    OPC 出海网站 Skill 体系

          工业品询盘型线                    电商品牌转化型线
               │                                │
        opc-valve-inquiry-website       （未启动，视业务需要）
               │
      ┌───────┼────────┐                (视业务方向决定启动时机)
  opc-pump   opc-motor  ...
               │
   （积累3-5个行业后）
               │
  opc-industrial-inquiry-website（通用母skill）
```

---

## 七、什么时候启动新行业

新行业启动条件：

1. 当前阀门专项 skill 已沉淀完成（战役结束、判断基准可用）；
2. OPC 有明确的新行业业务目标或客户意向；
3. 夏董确认新行业方向；
4. 按“巨人参照 → 业务提炼 → Skill 固化”方法论起步。

不盲目扩张。

---

## 八、什么时候启动电商品牌线

电商品牌线启动条件：

1. OPC 有明确的出海电商品牌业务方向或客户需求；
2. 工业品询盘型线已稳定运行至少一个完整项目周期；
3. 夏董确认进入该方向；
4. 不挪用工业品询盘型 skill，另起专项。

---

## 九、版本记录

| 版本 | 日期 | 变更说明 |
|---|---:|---:|
| v0.1 | 2026-05-19 | 初始沉淀，基于阀门战役讨论的扩展路线规划 |
