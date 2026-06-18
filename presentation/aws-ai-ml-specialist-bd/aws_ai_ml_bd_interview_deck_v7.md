# AWS AI/ML Specialist BD Interview Deck

> 使用说明：  
> - 正文说明尽量使用中文短句，减少口号化表达。  
> - AI / Cloud / Architecture 相关专业词汇保留英文。  
> - 架构图建议在 HTML/PPT 中重新绘制，不要直接使用 ASCII 图。  
> - 建议输出顺序：按Page顺序输出。

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

- 客户业务问题 （需求分析）
- AI/ML 产品 （带过产研）
- 企业 IT 环境 （一直深耕2B）
- GTM 和竞争策略 （竞品分析，AI趋势，售前策略）
- 从 Pilot 到 Production 的路径 （蹲过很多现场）

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

## PAGE 3 — Emotibot Overview
# Emotibot — Enterprise AI Platform & AI Contact Center

## Role

Product Director / AICC & Voice AI Solutions

---

## 竹间的产品线

- BotFactory Platform （训练平台+Agent平台）
- AI Contact Center （行业应用）
- Voice Assitant （客户定制应用） 
- SaaS + Private Deployment （交付方式）
- KA行业，包括银行、保险、手机、汽车、互联网、IT管理等

--

## Core Capabilities

- BotFactory Platform
- FAQ Engine
- Task Engine
- NLP （Intent、NER、Emotion）
- Knowledge Graph
- Voice Assistant Skill
- AICC（外呼、坐席助手、陪练、质检）
- Long-text Understanding（知识库检索、VOC舆情分析、长文本或表单理解）

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
        ├── Orchestrator
        ├── FAQ Engine
        ├── Task Engine
        ├── Entity Extraction
        ├── Knowledge Graph
        └── Human in the loop
        │
        ▼
Enterprise Systems
HR / ITSM / CRM / ERP
```

---

## PAGE 4 — Emotibot Customer Case
# Customer Case — 某为 Enterprise AI Platform

## Situation

客户IT流程部门想引入 AI，考察了多家供应商后，关键需求指标：

- 支持私有部署
- 支持内部员工持续运营知识+AI流程
- FAQ的准确率
- NER的准确率
- 支持二次开发

---

## Task

目标不是做一个单独 Bot。  
而是做一个可复用的平台。

平台需要支持：
- Private Deployment
- 多行业场景（IT Helpdesk，财务，行政，人事，销售，客服）
- 多算法能力统一接入
- 面向大客户的快速 POC
- 客户技术人员能上手亲自配置
- QA、意图、NER，识别准确率要求高

---

## Action

1，客户现场私有部署全套Botfactory
2，培训客户如何扩写语料提升模型精度
3，设计有难度的Task（比如报销、会议预约中的抽取实体）
4，指导客户如何调用外部系统数据

---

## Competitive Strategy

当时对手包括：

- iFlytek
- Alibaba Cloud XiaoMi
- Microsoft Azure Bot Service

我们没有和大厂比品牌。  
而是用现场 POC 比效果。

重点放在：

- 中文 NLP 理解能力（QA和NER，引导测试集）
- 多轮对话可定制（在对话流中打通某为内部系统数据）
- 私有化部署（并商定按年付租用费）
- 更短交付周期 （POC做完，客户已经可以上线查工资/查报销/预约会议室）
- 可量化的识别准确率

---

## Result
- 成功拿下项目，采用年订阅制计费
- 在之后的 2.5 年中，客户持续运营平台
- 扩展了 200+ 内部 Bot
- 客户在内部持续推荐我们公司
- 最终帮助公司获得了某为 B 轮领投

---

## PAGE 5 — Emotibot AI Contact Center
# Emotibot AICC Solution

## 核心能力

### 1. Task-oriented AI Voicebot

支持：

- outbound campaign
- inbound customer service
- intent routing
- FAQ automation
- workflow interaction

适用于：

- 电销
- 回访
- 催收
- 客服热线
- 预约确认

---

### 2. Agent Assist

AI 实时辅助人工坐席：

- real-time speech-to-text
- answer recommendation
- dialogue tagging
- compliance checking
- call summarization

帮助：

- 缩短响应时间
- 提升坐席一致性
- 降低培训成本
- 提升客服质量

---

### 3. AI Quality Inspection

事后全量 AI 质检：

- compliance violation detection
- sensitive phrase detection
- workflow compliance checking
- conversation scoring
- risk identification

重点价值：

# 避免人工抽检导致的违规漏检。

---

### 4. AI Coaching

AI 陪练与培训：

- simulated customer conversation
- objection handling practice
- process evaluation
- capability scoring
- training assessment

由 AI 自动判断：

# 坐席能力是否达到上线标准。

---

## AWS AI Opportunity

如果今天重新设计 AICC 平台，我会更强调：

- Amazon Bedrock
- Real-time Agent Assist
- AI Quality Inspection
- AI Coaching Workflow
- Multi-model Routing
- Knowledge-driven Contact Center

重点不是单点 Chatbot。

而是：

# AI-native Contact Center Platform。

## PAGE 6 — Emotibot AWS Modernization
# AWS Modernization — From Bot Platform to Agentic AI Platform

## 传统 Bot 平台的问题

很多企业已经做过 Bot。  
但继续扩展时会遇到三个问题：

- Workflow开发成本太高，Tool Calling不灵活
- 对于小模型来说，当意图到达500以上后，存在准确率下降问题
- QA是预设定的，无法像LLM+知识库那样即时生成答案
- 缺少企业级的Agentic框架，来支持任务的计划、执行、检查、回复


---

## 当前必须升级的刚需

### 1. 从 Chatbot 升级到 AI Agent
客户不只要问答。  
他们需要 AI 能调用工具、处理流程

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


## PAGE 7 — Convertlab Overview
# Convertlab — Data + AI + Predictive Intelligence

## Role

Product Director / AI HUB

---

## Convertlab 的核心产品和解决方案
AI Hub（Industry based FeatureStore和自动训练）

---

## Core Capabilities

- CDP + AI
- Feature Engineering
- Predictive AI
- Precision Marketing
- Customer Segmentation
- Campaign Optimization
- Dashboard
- AWS SageMaker（某项目使用）

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

## PAGE 8 — Convertlab Customer Case
# Customer Case — 某迪 CIE Platform

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

## PAGE 9 — Convertlab AWS Modernization
# AWS Modernization — Real-time AI Marketing Platform

## 当前客户的新刚需

### 从人工 ETL 开发走向 AI-assisted Data Workflow

过去：字段 mapping，Transformation rule，SQL 编写，Pipeline 调试
大量依赖 Data Engineer 手工完成。

现在客户开始希望：
AI 能帮助生成和维护数据流程。
例如：
根据字段说明生成 mapping
根据自然语言生成 transformation logic
自动生成 SQL / ETL code
自动识别字段关系
加速数据迁移和 pipeline 开发

---

### 2. 从人工 Campaign Workflow 走向 AI-assisted Journey Orchestration

过去：Campaign 配置高度依赖人工：
Audience Selection，Tag Mapping，Channel Configuration，Branch Logic，Wait Strategy，Engagement Workflow
大量流程需要运营和工程师协同完成。

现在客户开始希望：
AI 能帮助生成和优化营销流程。

例如：
根据自然语言生成 Campaign
自动推荐 Audience Segment
自动生成 Workflow Logic
动态调整 Engagement Strategy
根据用户行为实时优化 Journey

---

### 3. 从历史分析走向 Real-time Prediction

过去：
系统主要分析历史数据。

现在客户希望：

实时预测用户行为
动态调整推荐和优惠
根据实时状态触发 Engagement

---

## Proposed AWS Architecture

```text
Business User / Marketing Ops
             │
             ▼
Natural Language Requirement
(ELT rules / Campaign goal / Journey rule)
             │
             ▼
Amazon Bedrock Agent
             │
 ┌───────────┼────────────────┐
 ▼           ▼                ▼
ELT Code     Campaign         Validation
Generator    Workflow         & Review
             Generator
             │
             ▼
Metadata / Schema / Rule Repository
             │
             ▼
Customer App / CRM / CDP
             │
             ▼
Amazon Kinesis
             │
             ▼
Amazon S3 Data Lake
             │
             ▼
AWS Glue / Generated ELT Jobs
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
AI-assisted Journey Orchestration
             │
             ▼
Campaign / Recommendation / Engagement Channels
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
Manual Workflow
      ↓
AI-assisted Data Workflow
      ↓
Real-time Decision
      ↓
AI-assisted Campaign Journey
```

---

## PAGE 10 — XiaoIce Overview
# XiaoIce — Conversational AI & Brand Experience

## Role

Director of Products & Solutions

---

## 小冰的核心产品
数字人产品，应用于口播短视频，24小时直播，企业品牌宣传，企业数字人名片


---

## Core Capabilities

- Virtual Human
- Multi-turn Dialogue
- Knowledge Q&A
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

## PAGE 11 — XiaoIce Customer Case
# Customer Case — Florasis AI Brand Experience Project

## Situation

某西子希望尝试新的品牌展示方式。

传统广告和宣传视频成本高，制作周期长。
同时，品牌希望在直播、电商和社交媒体场景中，探索更数字化的互动体验。

客户当时关注几个方向：

* 品牌声音的一致性
* 更年轻化的互动形式
* 虚拟形象展示
* 更低的视频制作成本
* 更高频的内容生产能力

---

## Task

我的职责是负责整体方案设计和售前推进，包括：

* 客户需求沟通
* AI 方案设计
* Demo 演示
* 虚拟形象方向讨论
* AI Voice Clone 展示方案
* 展示视频脚本和体验设计
* 与算法和交付团队协同

项目目标不是做一个普通 AI 客服。
而是让客户看到：

# AI 如何进入品牌内容和互动体验。

---

## Action

项目核心包括三个部分：

### 1. Voice Clone

基于品牌声音素材，生成可复用的 AI Voice。

重点关注：

* 声音相似度
* 情绪表达
* 中文语气自然度
* 品牌风格一致性

---

### 2. Virtual Human Experience

设计虚拟形象展示方案。

包括：

* 虚拟人形象方向
* 对话体验
* 展示动作
* 品牌风格适配

---

## Competitive Strategy

当时很多方案仍然偏传统数字人展示：

* 动作固定（口播视频为主）
* 互动性弱
* 更像预录视频

我们的重点在如何设计面向某西子在社交媒体宣传方向，具有审美要求的数字人。

# 品牌体验的一致性。

我们更强调：

* 声音风格
* 品牌表达
* 更多、更自然的动作
* 内容生成能力
* 更低的内容生产成本

---

## Result

* 完成客户 Demo 和方案展示
* 帮助客户验证 AI 品牌互动方向
* 让客户看到 AI 在内容生产和品牌体验中的潜力
* 积累了 Voice Clone 和 Virtual Human 的项目经验
* 为后续 AI Engagement 场景提供参考

---
## PAGE 12 — How I Would Rebuild This with AWS Agentic AI Framework
## 一个新的变化

过去：数字人项目通常是：

* 单次制作
* 人工流程
* 多工具手工协作

例如：

* 文案团队写脚本
* 视频团队做素材
* 配音团队处理声音
* 运营团队修改内容
* 外包团队负责剪辑

整个流程高度依赖人工协同。

---

## 当前客户的新刚需

### 1. 从单次内容制作走向 AI-assisted Content Pipeline

客户希望：

* 更低的视频制作成本
* 更快的内容生成速度
* 多平台内容复用
* 更高频的营销内容产出

---

### 2. 从固定工作流走向 Agentic Workflow

过去：每一步都需要人工切换工具。

现在客户开始希望：

# AI 能自动协调整个内容生产流程。

例如：

* 自动生成脚本
* 自动拆分镜头
* 自动生成配音
* 自动生成数字人视频
* 自动完成内容审核
* 自动发布到不同渠道

---

### 3. 从单工具能力走向 Multi-tool Orchestration

企业已经开始使用很多 AI 工具：

* Voice Clone
* Avatar Generation
* Video Rendering
* Image Generation
* Subtitle Generation

问题不在“有没有工具”。而在：

# 如何把这些工具串成可运营的平台。

---

## Proposed AWS Agentic Content Production Architecture

```text
Marketing / Content Team
              │
              ▼
Natural Language Campaign Request
              │
              ▼
Amazon Bedrock Agent
              │
 ┌────────────┼─────────────┬─────────────┐
 ▼            ▼             ▼             ▼
Script        Storyboard    Review        Publishing
Generation    Planning      Workflow      Workflow
              │
              ▼
Agentic Tool Orchestration Layer
              │
 ┌────────────┼─────────────┬─────────────┐
 ▼            ▼             ▼             ▼
Voice Clone   Avatar        Video         Subtitle
Tool          Tool          Rendering     Tool
              │
              ▼
Brand Knowledge / Product / Campaign Assets
              │
              ▼
Amazon S3 + Metadata Repository
```

---

## AWS Service Mapping

| Capability                 | AWS Service                        |
| -------------------------- | ---------------------------------- |
| Agent Workflow             | Amazon Bedrock Agents              |
| Multi-step Orchestration   | Bedrock AgentCore / Step Functions |
| Knowledge & Prompt Context | Knowledge Bases for Bedrock        |
| Asset Storage              | Amazon S3                          |
| Metadata & Search          | Amazon OpenSearch                  |
| API Integration            | Lambda / API Gateway               |
| Monitoring                 | CloudWatch                         |
| Security & Governance      | IAM / Guardrails                   |

---

## 这个方向更适合 AWS

AWS 不一定提供最强的数字人生成工具。但 AWS 很适合做：

# AI Content Orchestration Platform

核心价值包括：

* Agent Workflow
* Multi-tool Coordination
* Scalable Pipeline
* Enterprise Governance
* Asset Management
* API Integration
* Multi-model Strategy

---

## Business Value

* 大幅降低内容生产成本
* 缩短视频制作周期
* 支持大规模内容生成
* 降低对人工流程的依赖
* 更容易接入企业营销系统
* 支持未来 AI-native Content Operation


---


---

## PAGE 13 — Knowledge System POC
# Product Design + Technical Architecture

## Project Overview

这是一个 Limited-domain AI Knowledge System POC。

项目目标不是做通用 Chatbot。  
而是验证：

# AI 如何进入真实学习过程。

PoC 重点包括：

- Lecture + Socratic Hybrid
- Validator-based Mode Routing
- Learning Interaction Design
- Knowledge Boundary Control
- Evaluation-first Workflow

---

## 一个核心判断

很多 AI Learning 产品：

更像搜索引擎。  
或者 FAQ Bot。

但真实学习过程需要：

- explanation
- reflection
- guided discussion
- misconception correction

所以系统不是简单回答问题。

而是：

# 判断应该如何教学。

---

## Core Interaction Design

### Lecture Mode

当用户缺少背景知识时：

系统提供：

- structured explanation
- terminology clarification
- historical context
- direct teaching

---

### Socratic Mode

当用户带有：

- popular interpretation
- modern misunderstanding
- meme-style assumption

系统通过问题引导用户重新思考。

---

## Validator-based Routing

在主模型回复前：

validator model 会判断：

- question type
- lecture or socratic mode
- refusal boundary
- knowledge scope

这让 AI 不只是“回答”。

而是：

# 决定 interaction workflow。

---

## Technical Architecture

```text
                        ┌──────────────────────────────┐
                        │        Local Dev             │
                        │ build / test / eval scripts  │
                        └──────────────┬───────────────┘
                                       │
                                       ▼
                ┌──────────────────────────────────────────┐
                │          PoC App @ AWS SG               │
                │ frontend + API + session routing        │
                │ Region: ap-southeast-1                  │
                └──────────────┬───────────────────────────┘
                               │
             ┌─────────────────┴──────────────────┐
             ▼                                    ▼

┌──────────────────────────────┐     ┌──────────────────────────────┐
│        Knowledge Layer       │     │        Validator Layer       │
│ topic corpus                 │     │ lecture / socratic routing   │
│ concept cards                │     │ refusal boundary control     │
│ source boundary              │     │ mode decision logic          │
└──────────────┬───────────────┘     └──────────────┬───────────────┘
               │                                     │
               └────────────────┬────────────────────┘
                                ▼

                 ┌──────────────────────────────┐
                 │         OpenRouter           │
                 │ LLM / SLM Gateway            │
                 │ model routing & benchmark    │
                 └──────────────┬───────────────┘
                                │
            ┌───────────────────┼────────────────────┐
            ▼                   ▼                    ▼

┌──────────────────┐  ┌──────────────────┐  ┌──────────────────┐
│ Lecture Model    │  │ Socratic Model   │  │ Refusal Workflow │
│ structured       │  │ guided questions │  │ out-of-scope     │
│ explanation      │  │ reflection flow  │  │ interception      │
└─────────┬────────┘  └─────────┬────────┘  └─────────┬────────┘
          └─────────────────────┼─────────────────────┘
                                ▼

                 ┌──────────────────────────────┐
                 │      Evaluation Pipeline     │
                 │ quality / pedagogy / logs    │
                 └──────────────────────────────┘
```

---

## Technical Decisions

### OpenRouter as Model Gateway

PoC 使用 OpenRouter：

- fast model switching
- benchmark comparison
- low infra overhead

---

### AWS Singapore Deployment

PoC App 部署在：

# AWS ap-southeast-1

重点是：

- fast iteration
- lightweight deployment
- evaluation-first workflow

---

## AWS AI Opportunity

这个项目适合：

- Amazon Bedrock
- Bedrock Agents
- Knowledge Bases
- OpenSearch
- Step Functions
- CloudWatch

AWS 的价值不只是模型。

而是：

# 可评估、可运营、可治理的 AI Workflow。

---

## PAGE 14 — Knowledge Operations + AI Governance
## 一个重要问题

很多 AI Knowledge System 的问题不是模型。

而是：

# 知识如何持续维护。

---

## Zero-barrier Knowledge Operations

项目设计了一套：

# non-technical knowledge ingestion workflow

SME 不需要：

- Python
- Fine-tuning
- Prompt Engineering

只需要维护：

- lecture material
- socratic question chain
- terminology
- refusal boundary
- evaluation examples

---

## Knowledge Structure Example

```text
Core Work
        │
 ┌──────┼────────────┐
 ▼      ▼            ▼
Lecture Socratic     Terminology
Knowledge Questions  Mapping
```

---

## Domain Boundary Control

系统明确区分：

- in-scope questions
- indirect questions
- out-of-scope questions

例如：

- literary analysis
- modern reinterpretation
- IELTS tactics
- essay writing request

不同问题进入不同 workflow。

---

## Evaluation-first Design

系统不仅评估：

# answer correctness

还评估：

- pedagogy
- mode fit
- textual evidence
- academic rigor
- boundary control

重点是：

# 让 AI interaction 可测量。

---

## Key Product Insight

这个项目最大的变化是：

过去：
AI 只是 information retrieval。

现在：
AI 开始参与：

- learning workflow
- teaching strategy
- knowledge operation
- interaction orchestration

---

## Business Value

- 降低知识维护成本
- 支持 SME 持续运营
- 提升 AI interaction quality
- 支持 domain-specific AI deployment
- 为 future AI-native education system 提供基础框架
---

## PAGE 15 — Labubu Hunter Agent Demo
# Spec-driven Multi-Agent Application Design

## Project Overview

这是一个 Labubu / Popmart 限量潮玩监控 Demo。

项目目标不是做恶意抢购 Bot。  
而是验证：

# 在 Spec 阶段，如何把一个复杂业务拆成多个 Agent 协作。

同时，这个项目也用于探索：

# 腾讯 WorkBuddy 是否适合构建复杂 Agent 应用。

---

## 为什么选择这个场景

Labubu 抢购场景虽然看起来轻量，  
但其实包含很多复杂应用要素：

- 多平台数据源
- 高频状态变化
- 社媒信号判断
- 用户偏好配置
- AI 决策
- 浏览器自动化
- 通知系统
- 人工确认边界

这比普通 Todo App 更适合测试 AI Coding 工具。

---

## Spec 阶段的设计重点

### 1. Agent 边界

每个 Agent 只负责一类任务：

- StockAgent：库存监控
- SocialIntelligenceAgent：社媒信号分析
- DecisionAgent：机会判断
- BrowserAgent：浏览器辅助
- NotificationAgent：通知
- SchedulerAgent：任务编排

---

### 2. Agent 之间如何通信

不是让 Agent 随意调用彼此。  
而是通过统一 JSON Event 传递状态。

如果用 AWS，可以对应为：

- Amazon EventBridge：事件总线
- Amazon SQS：异步任务队列
- AWS Step Functions：多步骤流程编排
- DynamoDB：事件状态存储

---

### 3. 哪些动作必须 Human-in-the-loop

系统可以辅助：

- 打开商品页
- 刷新页面
- 选择 SKU
- 加入购物车
- 打开 checkout 页面

但必须禁止：

- automatic payment
- captcha bypass
- account abuse
- illegal anti-bot bypass

最终付款必须人工确认。

如果用 AWS，可以用：

- Amazon Bedrock Guardrails：约束 Agent 行为边界
- IAM：限制 Agent 可调用的工具权限
- CloudWatch：记录自动化动作日志
- SNS / SES：发送需要人工确认的通知

---

## 7 个面板仪表盘

| 面板 | 功能 |
|---|---|
| 🛰 Restock Feed | 实时补货事件流，每 3 秒自动推送 |
| 📦 Stock Monitor | 多平台库存状态 |
| 🔍 Social Intel | 社媒信号分析，含置信度 |
| 🧠 AI Decisions | Attempt / Watch / Skip 时间轴 |
| 🤖 Auto Assist | 浏览器辅助任务状态 |
| 🎯 Watchlist | 产品关键词 / 平台 / 地区 / 价格上限 |
| 🔔 Alerts | Telegram / Discord / 飞书 / 桌面通知历史 |

---

## Key Product Insight

这个 Demo 的价值不在 Labubu 本身。

而在于验证：

# 一个复杂 Agent 应用，能否在 Spec 阶段被清楚拆解。

如果 Spec 足够清楚，  
AI Coding 工具才有可能稳定生成可维护系统。

---

## PAGE 16 — Labubu Hunter Agent Architecture
# Multi-Agent Workflow + AWS Rebuild Direction

## Technical Architecture

```text
labubu-hunter/
├── backend/
│   ├── index.js
│   ├── core/
│   │   ├── eventBus.js
│   │   └── logger.js
│   ├── db/database.js
│   ├── agents/
│   │   ├── BaseAgent.js
│   │   ├── SchedulerAgent.js
│   │   ├── StockAgent.js
│   │   ├── SocialIntelligenceAgent.js
│   │   ├── DecisionAgent.js
│   │   ├── BrowserAgent.js
│   │   └── NotificationAgent.js
│   └── routes/api.js
│
└── frontend/
    └── index.html
```

---

## Agent Collaboration Model

```text
SchedulerAgent
      │
      ▼
StockAgent ───────────────┐
      │                   │
      ▼                   ▼
SocialIntelligenceAgent   EventBus
      │                   │
      ▼                   ▼
DecisionAgent ───────► BrowserAgent
      │                   │
      ▼                   ▼
NotificationAgent     Manual Checkout
```

---

## Agent Responsibility Design

| Agent | Responsibility |
|---|---|
| SchedulerAgent | 统一调度 polling interval 和任务优先级 |
| StockAgent | 监控 Popmart / TikTok Shop / Shopee / Taobao 等平台库存 |
| SocialIntelligenceAgent | 分析 Discord / Telegram / Reddit / 小红书 / 微博补货信号 |
| DecisionAgent | 根据用户偏好判断 Attempt / Watch / Skip |
| BrowserAgent | 辅助打开商品页、选 SKU、加入购物车、进入 checkout |
| NotificationAgent | 发送 Telegram / Discord / 飞书 / Email / Desktop alert |

---

## Why WorkBuddy Is Useful Here

这个项目适合用 WorkBuddy 测试复杂应用生成能力。

原因是：

- 前后端都有
- 有 WebSocket 实时推送
- 有 SQLite 数据模型
- 有多 Agent 类结构
- 有 Browser Automation
- 有 Dashboard
- 有规则边界
- 有持续扩展空间

---

## Spec Quality Matters

如果只说：

# “帮我做一个抢购工具”

AI Coding 工具很容易生成一个不可维护脚本。

但如果 Spec 明确：

- 模块边界
- Agent 责任
- Event Schema
- UI 面板
- 安全约束
- 分阶段优先级
- AWS 产品映射

它就更容易生成一个干净的应用框架。

---

## Key AWS AI Narrative

这个 Demo 更适合强调：

# AWS 如何作为 Agent Orchestration Layer。

重点不是：

- 抢购脚本
- 浏览器自动化

而是：

- multi-agent coordination
- event-driven workflow
- AI decision routing
- human-in-the-loop automation
- scalable agent framework

---

## Why This Is Relevant to AWS AI/ML

这个项目可以映射到很多真实企业场景：

- supply chain monitoring
- commerce intelligence
- operational copilots
- real-time event analysis
- AI-assisted workflow orchestration

重点展示的是：

# 如何在 Spec 阶段定义 Agent 边界、Workflow 和 AI 调度逻辑。

---

## Business Value

这个 Demo 可以延展到更严肃的企业场景：

- 库存监控
- 价格监控
- 供应链预警
- 舆情信号分析
- 实时商业机会发现
- 自动化运营助手

---

## PAGE 17 — Closing
# Why These Projects Matter for AWS AI/ML Specialist BD

## 共同主线

这些项目不是为了展示“我做过很多 AI 功能”。

而是为了说明：

# 我能把客户问题拆成可落地的 AI/ML 方案。

---

## Four Capabilities Demonstrated

| Capability | Evidence |
|---|---|
| Enterprise AI Platform | Emotibot BotFactory / AICC |
| Data + AI / ML Adoption | Convertlab CIE / SageMaker |
| Agentic Workflow | Knowledge System POC / Labubu Hunter |
| AI Experience Layer | XiaoIce Florasis digital human case |

---

## My BD Working Style

- 先理解客户业务问题
- 再定义 POC 成功标准
- 用架构图对齐技术路径
- 用竞争策略帮助客户做决策
- 用阶段路线降低落地风险
- 最后推动从 Pilot 走向 Production

---

## Closing Statement

I help enterprises move from isolated AI pilots  
to scalable AI platforms  
that deliver measurable business value.
