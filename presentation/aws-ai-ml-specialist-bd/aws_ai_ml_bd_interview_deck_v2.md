# AWS AI/ML Specialist BD Interview Deck

> 使用说明：  
> - 正文说明尽量使用中文短句，减少口号化表达。  
> - AI / Cloud / Architecture 相关专业词汇保留英文。  
> - 架构图建议在 HTML/PPT 中重新绘制，不要直接使用 ASCII 图。  
> - 建议输出顺序：Emotibot → Convertlab → XiaoIce → Summary。

---

## PAGE 1 — Title

# Enterprise AI Adoption & AI/ML Business Development Journey

### 用客户场景、架构方案和 POC 推动企业 AI/ML 落地

Yang Long  
Sr. Specialist BD – AI/ML  
Amazon Web Services

---

## Core Focus Areas

- Enterprise AI Platform
- AI/ML GTM & Competitive Positioning
- AI Contact Center & Voice AI
- Data + AI / Predictive Intelligence
- Conversational AI / Agentic AI
- RAG / Knowledge Base / Workflow
- Executive Briefing & AI Adoption Strategy

---

## Key Message

我过去的工作重点不是单纯做 AI 产品，  
而是把 AI 能力放进客户业务流程里，  
通过方案设计、POC 和竞争策略，推动客户完成采纳。

---

## PAGE 2 — Why I Fit AWS AI/ML Specialist BD

# Why I Fit AWS AI/ML Specialist BD

## 这个岗位需要的不是单点 AI 能力

它需要能同时理解：

- 客户业务问题
- AI/ML 产品能力
- 企业 IT 环境
- GTM 和竞争策略
- 从 Pilot 到 Production 的路径

---

## Capability Mapping

| AWS Requirement | Relevant Experience |
|---|---|
| Drive AI Adoption | 50+ enterprise AI projects |
| Senior Customer Engagement | Architecture workshop / Executive communication |
| AI/ML GTM | Competitive strategy vs IBM / Azure / Alibaba / Sensors Data |
| Enterprise AI Platform | BotFactory / AI Hub / Conversational AI Platform |
| AI Modernization | SageMaker / RAG / Agentic AI / Workflow |
| Cross-functional Collaboration | Product + BD + Delivery + Partner coordination |

---

## My Positioning

我适合这个岗位的原因是：  
我既能和客户高管讨论业务价值，  
也能和技术团队讨论架构、数据、模型和落地风险。

---

# SECTION 1 — Emotibot

---

## PAGE 3 — Emotibot Overview

# Emotibot — Enterprise AI Platform & AI Contact Center

## Role

Product Director / AICC & Voice AI Solutions

---

## 这段经历为什么重要

竹间的项目更接近 AWS AI/ML BD 的核心场景：

- 企业级 AI Platform
- AI Contact Center
- Voice AI
- Workflow Integration
- SaaS + Private Deployment
- 大客户售前和交付
- 与 IBM / Microsoft / Alibaba 等方案竞争

---

## Core Capabilities

- BotFactory Platform
- FAQ Engine
- Multi-turn Dialogue
- Entity Extraction
- Knowledge Graph
- Voice Bot
- Agent Assist
- Smart QA
- Long-text Understanding

---

## Enterprise AI Platform Architecture

```text
Enterprise Users
        │
        ▼
Omnichannel Access Layer
(Web / Voice / Mobile / WeChat)
        │
        ▼
BotFactory AI Platform
        ├── FAQ Engine
        ├── Multi-turn Dialogue
        ├── Entity Extraction
        ├── Knowledge Graph
        └── Workflow Engine
        │
        ▼
Enterprise Systems
HR / ITSM / CRM / ERP
```

---

## PAGE 4 — Emotibot STAR Case

# STAR Case — BotFactory Enterprise AI Platform

## Situation

客户想引入 AI，但常见问题很明显：

- FAQ Bot 很难扩展
- NLP 能力分散在不同团队
- 私有化部署要求高
- 对接企业系统成本高
- 多场景上线速度慢

---

## Task

目标不是做一个单独 Bot。  
而是做一个可复用的平台。

平台需要支持：

- SaaS
- Private Deployment
- 多行业场景
- 多算法能力统一接入
- 面向大客户的快速 POC

---

## Action

我们把多个算法能力整合成 BotFactory Platform。

核心模块包括：

- FAQ Engine
- Dialogue Engine
- Entity Extraction
- Knowledge Graph
- Workflow Orchestration
- Admin Console
- Scenario Template

---

## Competitive Strategy

当时对手包括：

- iFlytek
- Alibaba Cloud XiaoMi
- Microsoft Azure Bot Service

我们没有和大厂比品牌。  
而是用现场 POC 比效果。

重点放在：

- 中文 NLP 理解能力
- 多轮对话可定制
- 私有化部署
- 更短交付周期
- 可量化的识别准确率

---

## Result

- 年度订单突破 RMB 100M
- 成为国内同类产品领先方案
- 识别准确率较行业基线提升约 15%
- 支撑金融、银行、制造等行业客户落地

---

## PAGE 5 — Emotibot AI Contact Center

# AI Contact Center Transformation

## 从传统 Call Center 升级为 AI-supported Customer Service

---

## 当下客户的新刚需

### 1. 客户不再接受生硬的 IVR

过去的 IVR 和 FAQ Bot 交互割裂。  
客户现在希望对话更自然。

需要：

- Natural Conversation
- Context Memory
- Multi-turn Dialogue
- Personalized Response

---

### 2. 企业希望 AI 帮助坐席，而不是替代一切

很多客户不敢一次性全自动化。  
更可行的路径是先增强坐席能力。

典型场景：

- Real-time Agent Assist
- Knowledge Retrieval
- Auto Summary
- Smart QA
- Next Best Action

---

### 3. AI 必须接入业务系统

客户真正关心的是：  
AI 能不能完成动作。

例如：

- 查询订单
- 创建工单
- 修改客户信息
- 发起审批
- 推送短信或邮件

这需要 AI Agent + Tool Use。

---

## Proposed AWS AI Contact Center Architecture

```text
Customer Voice / Chat Channels
              │
              ▼
Amazon Connect
              │
 ┌────────────┼────────────┐
 ▼            ▼            ▼
Transcribe    Bedrock      Polly
ASR           Agent        TTS
              │
              ▼
Knowledge Bases for Bedrock
              │
              ▼
Amazon OpenSearch
              │
              ▼
CRM / ERP / Ticket / Order Systems
```

---

## AWS Service Mapping

| Capability | AWS Service |
|---|---|
| Contact Center | Amazon Connect |
| ASR | Amazon Transcribe |
| TTS | Amazon Polly |
| AI Agent | Amazon Bedrock Agents |
| Knowledge Retrieval | Knowledge Bases for Bedrock |
| Vector Search | Amazon OpenSearch |
| System Integration | Lambda / API Gateway |
| Monitoring | CloudWatch |

---

## PAGE 6 — Emotibot AWS Modernization

# AWS Modernization — From Bot Platform to Agentic AI Platform

## 传统 Bot 平台的问题

很多企业已经做过 Bot。  
但继续扩展时会遇到三个问题：

- 只能回答，不能执行
- 每个场景都要重复开发
- 缺少统一治理和监控

---

## 当前必须升级的刚需

### 1. 从 Chatbot 升级到 AI Agent

客户不只要问答。  
他们需要 AI 能调用工具、处理流程。

---

### 2. 从单场景升级到平台化

企业不可能为每个部门单独建一套 AI。  
需要统一平台，复用知识、权限和 Workflow。

---

### 3. 从 Demo 升级到 Production

客户已经做了很多 Pilot。  
真正难的是上线、治理、监控和持续优化。

---

## Proposed AWS Agentic AI Platform

```text
Enterprise Users
        │
        ▼
Web / App / Amazon Connect
        │
        ▼
Amazon Bedrock AgentCore
        │
 ┌──────┼────────┬────────┐
 ▼      ▼        ▼        ▼
Memory  Workflow Tool Use Evaluation
        │
        ▼
Knowledge Bases for Bedrock
        │
        ▼
Amazon OpenSearch
        │
        ▼
Enterprise Systems
ITSM / HR / ERP / CRM
```

---

## Transformation Path

```text
Traditional Workflow Bot
        ↓
RAG Assistant
        ↓
AI Copilot
        ↓
AI Worker / AI Agent
```

---

## Business Value

- 让 AI 进入真实业务流程
- 降低重复场景开发成本
- 提升从 Pilot 到 Production 的成功率
- 支持跨部门扩展
- 保留企业治理和安全边界

---

## PAGE 7 — Enterprise AI Adoption Insight

# Enterprise AI Adoption Insight

## 我在企业项目中的一个判断

客户的问题通常不是：  
“哪个模型最好”。

更常见的问题是：

- 现有系统怎么接进去
- 谁负责数据和权限
- 怎么从 POC 进入生产
- 如何证明 ROI
- 后续如何持续运营

---

## 企业 AI 项目常见卡点

### 1. Pilot 很多，但很难 Scale

原因通常是：

- 每个项目单独做
- 缺少统一平台
- 没有标准评估方法
- 没有统一权限和日志

---

### 2. AI 能回答，但不能进入 Workflow

很多项目停在问答。  
但真正的业务价值在动作。

例如：

- 调系统
- 发通知
- 建工单
- 触发审批
- 写回业务系统

---

### 3. 业务部门期待很高，IT 部门担心风险

AI 项目要落地，必须同时解决：

- 业务效果
- 安全
- 合规
- 权限
- 稳定性
- 成本

---

## AWS 的机会

AWS 的价值不是只提供一个模型。  
而是提供企业可落地的一整套能力：

- Amazon Bedrock
- Amazon SageMaker
- Bedrock AgentCore
- Knowledge Bases for Bedrock
- OpenSearch
- IAM / Guardrails / CloudWatch
- Lambda / Step Functions

---

# SECTION 2 — Convertlab

---

## PAGE 8 — Convertlab Overview

# Convertlab — Data + AI + Predictive Intelligence

## Role

Product Director / AI HUB

---

## 这段经历为什么重要

Convertlab 的项目更贴近 AWS AI/ML 中的 Data + AI 场景。

重点不是“做一个模型”。  
而是把企业已有数据转成可执行的营销决策。

---

## Core Capabilities

- CDP + AI
- Feature Engineering
- Predictive AI
- Precision Marketing
- Customer Segmentation
- Campaign Optimization
- Dashboard
- AWS SageMaker

---

## AI Hub Platform Architecture

```text
Customer Data Sources
(App / CRM / CDP / Ads)
            │
            ▼
Feature Engineering Layer
            │
            ▼
AI Prediction Models
 ├── Purchase Intent
 ├── Churn Prediction
 ├── User Segmentation
 └── Campaign Optimization
            │
            ▼
Marketing Dashboard / Campaign Engine
```

---

## PAGE 9 — Convertlab STAR Case

# STAR Case — CIE Precision Marketing Platform

## Situation

客户已经有大量数据：

- App 行为数据
- 会员数据
- 交易数据
- Campaign 数据
- CDP 平台

但营销效果提升进入瓶颈。

问题不在“有没有数据”。  
而在“数据能不能变成预测”。

---

## Task

项目目标是帮助客户建立预测能力：

- 谁更可能购买
- 谁可能流失
- 谁对折扣敏感
- 哪类人群适合哪种 Campaign
- 如何监控营销效果

---

## Action

我负责：

- 需求分析
- 业务流程设计
- Dashboard 规划
- 特征列表梳理
- POC 场景设计
- 与数据科学团队协同

模型训练和 Feature Pipeline 基于 AWS SageMaker 构建。

---

## Competitive Strategy

主要竞争对手是 Sensors Data。

对方已经在 App 行为埋点上有优势。  
所以我们没有继续比“谁的数据更多”。

我们把客户问题重新定义为：

# “谁能把数据变成预测能力”

---

## Result

- Campaign 转化率提升约 11%
- 帮助客户从 CDP 走向 Predictive AI
- 用 POC 证明 AI/ML 对业务指标的价值
- 形成可复用的零售 AI 场景模板

---

## PAGE 10 — Convertlab AWS Modernization

# AWS Modernization — Real-time AI Marketing Platform

## 当前客户的新刚需

### 1. 从历史分析走向实时预测

过去看报表。  
现在客户希望在用户行为发生后，马上做判断。

例如：

- 推荐内容
- 推送优惠
- 流失提醒
- 客群调整

---

### 2. 从人工配置 Campaign 走向 AI-assisted Campaign

营销团队希望 AI 帮助完成：

- Audience Segment
- Campaign Strategy
- Content Suggestion
- Personalization
- Performance Analysis

---

### 3. 从 CDP 走向 Predictive Intelligence

很多客户已经有数据平台。  
下一步要回答的是：

- 这个用户接下来可能做什么
- 我现在应该触达谁
- 应该给什么权益
- 哪个动作最可能带来转化

---

## Proposed AWS Architecture

```text
Customer App / CRM / CDP
             │
             ▼
Amazon Kinesis
             │
             ▼
Amazon S3 Data Lake
             │
             ▼
AWS Glue ETL
             │
             ▼
SageMaker Feature Store
             │
             ▼
SageMaker Training Pipeline
             │
             ▼
Real-time Inference Endpoint
             │
             ▼
Campaign / Recommendation Engine
```

---

## AWS Service Mapping

| Capability | AWS Service |
|---|---|
| Streaming Data | Amazon Kinesis |
| Data Lake | Amazon S3 |
| ETL | AWS Glue |
| Feature Management | SageMaker Feature Store |
| Model Training | SageMaker Training Pipeline |
| Real-time Prediction | SageMaker Real-time Inference |
| Dashboard | Amazon QuickSight |
| GenAI Marketing Assistant | Amazon Bedrock |

---

## Future Expansion

```text
Predictive AI
      ↓
AI Recommendation
      ↓
Marketing Copilot
      ↓
Autonomous Campaign Agent
```

---

## PAGE 11 — Data + AI BD Insight

# Data + AI BD Insight

## 一个重要判断

很多企业已经建了 CDP、Data Lake 或 BI。  
但业务部门仍然觉得“不够有用”。

原因是：

数据系统经常停在“解释过去”。  
业务更需要“判断下一步”。

---

## 从 BD 角度看，客户容易被打动的点

### 1. 用业务指标讲 AI

不要先讲模型。  
先讲：

- 转化率
- 留存率
- 客单价
- 营销成本
- 人群命中率

---

### 2. 用 POC 缩短决策周期

客户不一定相信大方案。  
但愿意看一个清晰 POC：

- 一个场景
- 一组数据
- 一个模型
- 一个业务指标
- 一个对照结果

---

### 3. 把 AI 做成可复用能力

单个模型价值有限。  
更大的价值来自：

- Feature Store
- MLOps
- Reusable Pipeline
- Dashboard
- Campaign Integration

---

## AWS Opportunity

AWS 可以把客户从“数据平台”带到“预测平台”：

- S3 / Glue / Kinesis 负责数据基础
- SageMaker 负责训练、特征和推理
- QuickSight 负责业务可见性
- Bedrock 负责新的营销 Copilot 和内容生成

---

# SECTION 3 — XiaoIce

---

## PAGE 12 — XiaoIce Overview

# XiaoIce — Conversational AI & Brand Experience

## Role

Director of Products & Solutions

---

## 这段经历为什么重要

小冰项目代表的是 AI 在客户体验层的应用。

它不是后台系统，  
而是直接面对终端用户。

这类项目的关键不是“能不能回答”，  
而是“是否符合品牌体验”。

---

## Core Capabilities

- Virtual Human
- Multi-turn Dialogue
- Knowledge Q&A
- Intent Recognition
- Emotional Interaction
- TTS / Brand Voice
- Intelligent Customer Service

---

## Conversational AI Platform

```text
Users
   │
   ▼
Voice / Chat / Avatar
   │
   ▼
Dialogue Management Engine
   ├── Intent Recognition
   ├── Context Memory
   ├── Emotion Detection
   └── Multi-turn Conversation
   │
   ▼
Knowledge Base / FAQ / CRM
   │
   ▼
TTS / Virtual Human Rendering
```

---

## PAGE 13 — XiaoIce STAR Case

# STAR Case — European Beauty Brand AI Customer Service

## Situation

客户是一家欧洲美妆品牌。  
他们希望升级智能客服体验。

传统客服系统的问题是：

- FAQ 感太强
- 回复不够自然
- 很难体现品牌调性
- 多轮对话能力有限
- 缺少有记忆感的互动体验

竞争对手包括：

- Alibaba Cloud
- Ronglian
- Huanxin

---

## Task

我的任务是主导售前过程：

- 方案撰写
- 技术演示
- 招投标支持
- Demo 设计
- 客户需求澄清
- 与技术团队协同落地

---

## Action

我们没有把它定义成普通客服 Bot。  
而是定义为：

# AI Brand Assistant

核心设计包括：

- 品牌语气
- 情绪化交互
- 多轮对话
- 定制 TTS
- 虚拟人体验
- 知识问答

---

## Competitive Strategy

竞争对手更偏传统客服系统。  
他们强调工单、FAQ 和坐席流程。

我们的差异化是：

- 品牌声音一致性
- 情绪化互动
- 多轮对话体验
- 虚拟人能力
- 更强的客户感知

---

## Result

- 赢得客户签约
- 与传统客服 SaaS 形成差异化
- 帮助客户看到 AI 在品牌体验中的价值
- 验证了“AI + Brand Experience”的商业可行性

---

## PAGE 14 — XiaoIce AWS Modernization

# AWS Modernization — AI Engagement Platform

## 当前客户的新刚需

### 1. 客户期待更自然的互动

用户已经习惯 ChatGPT-like Experience。  
企业客服如果仍然像 FAQ，会显得落后。

---

### 2. 企业需要统一管理知识和品牌表达

品牌方不只关心答案是否正确。  
还关心语气、边界和一致性。

---

### 3. 企业需要 Multi-model Strategy

不同场景可能适合不同模型。  
客户不希望被单一模型绑定。

---

## Proposed AWS Architecture

```text
Customer Channels
(Web / App / Voice / Avatar)
           │
           ▼
Amazon API Gateway
           │
           ▼
Amazon Bedrock Agents
           │
 ┌─────────┼─────────┐
 ▼         ▼         ▼
Claude     Nova      Titan
           │
           ▼
Knowledge Bases for Bedrock
           │
           ▼
Amazon OpenSearch Vector Store
           │
           ▼
CRM / Product / Marketing Systems
```

---

## Governance Side Rail

- Guardrails
- IAM
- CloudWatch
- Brand Policy
- Safety Rules
- Human Review

---

## AWS Service Mapping

| Capability | AWS Service |
|---|---|
| Foundation Model | Amazon Bedrock |
| Agent Workflow | Bedrock Agents |
| Knowledge Retrieval | Knowledge Bases for Bedrock |
| Vector Search | Amazon OpenSearch |
| Voice Output | Amazon Polly |
| API Integration | API Gateway / Lambda |
| Governance | Guardrails / IAM |
| Monitoring | CloudWatch |

---

## Business Value

- 提升客户互动体验
- 支持品牌一致性
- 降低模型切换成本
- 更容易接入 CRM 和营销系统
- 为后续 AI Agent 扩展打基础

---

# SECTION 4 — Summary

---

## PAGE 15 — Enterprise AI Modernization Framework

# Enterprise AI Modernization Framework

## 企业 AI 正在从单点功能走向平台化

---

## Evolution Path

```text
Traditional Software
          ↓
Rule-based Automation
          ↓
AI Assistant
          ↓
RAG Platform
          ↓
Agentic AI Platform
          ↓
AI-supported Enterprise
```

---

## 我的三个项目对应的企业 AI 层次

| Company | Core Scenario | AWS Relevance |
|---|---|---|
| Emotibot | Enterprise AI Platform / Contact Center | Bedrock AgentCore / Connect / Knowledge Bases |
| Convertlab | Data + AI / Predictive Marketing | SageMaker / S3 / Glue / Kinesis |
| XiaoIce | Conversational AI / Brand Experience | Bedrock / Agents / OpenSearch / Polly |

---

## 共同结论

企业真正需要的不是一个孤立 AI 功能。  
而是一条清楚的落地路径：

- 从业务问题开始
- 用 POC 验证价值
- 用平台承接规模化
- 用治理保证可控
- 用指标证明 ROI

---

## PAGE 16 — AI/ML BD Methodology

# How I Drive Enterprise AI Adoption

## 我的 AI/ML BD 方法论

```text
Business Challenge
        ↓
AI Opportunity Discovery
        ↓
Architecture Workshop
        ↓
POC Validation
        ↓
Executive Alignment
        ↓
Migration Strategy
        ↓
Enterprise Scale Adoption
```

---

## 1. Business Reframing

帮助客户重新定义问题。

例如：

从：
- “我们要做一个客服 Bot”

转向：
- “我们要降低服务成本，同时提升客户体验”

---

## 2. Competitive Positioning

避免陷入单纯功能对比。

重点讲：

- 业务结果
- 架构可扩展性
- 部署路径
- 安全和治理
- 后续运营成本

---

## 3. POC Validation

用小范围 POC 帮客户降低决策风险。

一个好的 POC 应该有：

- 明确业务场景
- 明确成功指标
- 明确数据边界
- 明确上线路径

---

## 4. Executive Alignment

高管通常不关心技术细节。  
他们关心：

- 为什么现在必须做
- 不做有什么风险
- 需要投入多少
- 能带来什么变化
- 如何分阶段落地

---

## PAGE 17 — Why Me

# Why Me for AWS AI/ML Specialist BD

## Enterprise AI Experience

- 50+ enterprise AI projects
- 8+ years AI/ML product and solution experience
- Voice AI / NLP / Agent platform
- Retail / Finance / Manufacturing / Government

---

## Business Development Experience

- Executive-level communication
- Architecture workshop
- POC design
- Competitive strategy
- Deal support
- Partner coordination

---

## AI Platform Perspective

我不是只看单个模型或单个功能。  
我更关注：

- AI 如何进入业务流程
- 如何进入生产环境
- 如何跨部门复用
- 如何持续优化
- 如何形成客户长期价值

---

## AWS AI Alignment

我的经历和 AWS AI 方向高度一致：

- Amazon Bedrock
- Amazon SageMaker
- Bedrock AgentCore
- Knowledge Bases for Bedrock
- Amazon Connect
- Multi-model Strategy
- Enterprise AI Governance

---

## Closing Statement

I help enterprises move from isolated AI pilots to scalable AI platforms that deliver measurable business value.
