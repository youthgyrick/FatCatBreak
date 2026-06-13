"use strict";

/* ------------------------------ Unified data ------------------------------ */
const elements = [
  ["H", "氢"], ["He", "氦"], ["Li", "锂"], ["Be", "铍"], ["B", "硼"],
  ["C", "碳"], ["N", "氮"], ["O", "氧"], ["F", "氟"], ["Ne", "氖"],
  ["Na", "钠"], ["Mg", "镁"], ["Al", "铝"], ["Si", "硅"], ["P", "磷"],
  ["S", "硫"], ["Cl", "氯"], ["Ar", "氩"], ["K", "钾"], ["Ca", "钙"]
].map(([symbol, name], index) => ({
  id: `element-${symbol}`, symbol, name, atomicNumber: index + 1,
  category: "element", subgroup: "fixed"
}));

const valences = [
  ["K", "钾", ["+1"], "fixed"], ["Na", "钠", ["+1"], "fixed"],
  ["Ag", "银", ["+1"], "fixed"], ["Ca", "钙", ["+2"], "fixed"],
  ["Mg", "镁", ["+2"], "fixed"], ["Ba", "钡", ["+2"], "fixed"],
  ["Zn", "锌", ["+2"], "fixed"], ["Al", "铝", ["+3"], "fixed"],
  ["H", "氢", ["+1"], "fixed"], ["F", "氟", ["-1"], "fixed"],
  ["Br", "溴", ["-1"], "fixed"], ["O", "氧", ["-2"], "fixed"],
  ["Si", "硅", ["+4"], "fixed"],
  ["Cu", "铜", ["+1", "+2"], "variable"], ["Fe", "铁", ["+2", "+3"], "variable"],
  ["Mn", "锰", ["+2", "+4", "+6", "+7"], "variable"],
  ["S", "硫", ["-2", "+4", "+6"], "variable"], ["C", "碳", ["+2", "+4"], "variable"],
  ["N", "氮", ["-3", "+2", "+3", "+4", "+5"], "variable"],
  ["P", "磷", ["-3", "+3", "+5"], "variable"],
  ["Cl", "氯", ["-1", "+1", "+5", "+7"], "variable"],
  ["OH", "氢氧根", ["-1"], "radical"], ["NO3", "硝酸根", ["-1"], "radical"],
  ["SO4", "硫酸根", ["-2"], "radical"], ["CO3", "碳酸根", ["-2"], "radical"],
  ["NH4", "铵根", ["+1"], "radical"]
].map(([symbol, name, values, subgroup]) => ({
  id: `valence-${symbol}`, symbol, name, category: "valence", subgroup, valences: values
}));

const formulas = [
  ["H2O", "水"], ["CO2", "二氧化碳"], ["NO2", "二氧化氮"], ["FeO", "氧化亚铁"],
  ["MgO", "氧化镁"], ["HgO", "氧化汞"], ["SO3", "三氧化硫"], ["P2O5", "五氧化二磷"],
  ["SO2", "二氧化硫"], ["Fe2O3", "氧化铁"], ["ZnO", "氧化锌"], ["Al2O3", "氧化铝"],
  ["CO", "一氧化碳"], ["H2O2", "过氧化氢"], ["CaO", "氧化钙"],
  ["Fe3O4", "四氧化三铁"], ["MnO2", "二氧化锰"], ["CuO", "氧化铜"]
].map(([symbol, name]) => ({
  id: `formula-${symbol}`, symbol, name, category: "formula", subgroup: "formula"
}));

const chemistryData = [...elements, ...valences, ...formulas];
const mnemonics = [
  ["一价氢氯钾钠银", "H（氢）、Cl（氯）、K（钾）、Na（钠）、Ag（银）常见一价"],
  ["二价氧钙钡镁锌", "O（氧）、Ca（钙）、Ba（钡）、Mg（镁）、Zn（锌）常见二价"],
  ["三铝四硅五价磷", "Al（铝）+3，Si（硅）+4，P（磷）+5"],
  ["二三铁，二四碳", "Fe（铁）常见 +2、+3；C（碳）常见 +2、+4"],
  ["二四六硫都齐全", "S（硫）常见 -2、+4、+6"],
  ["铜汞二价最常见", "Cu（铜）、Hg（汞）的 +2 价最常见；铜也有 +1 价"]
];

const LABELS = {
  fixed: "固定价", variable: "可变价", radical: "原子团", formula: "化学式",
  valence: "化合价", element: "元素", formulaType: "化学式"
};
const STORAGE = { mistakes: "chem-memory-mistakes-v2", stats: "chem-memory-stats-v2" };
const REVIEW_INTERVALS = [
  10 * 60 * 1000, 24 * 60 * 60 * 1000, 3 * 86400000,
  7 * 86400000, 14 * 86400000, 30 * 86400000
];

/* ---------------------------- Storage service ----------------------------- */
const StorageService = {
  load(key, fallback) {
    try {
      const value = JSON.parse(localStorage.getItem(key));
      return value && typeof value === "object" ? value : fallback;
    } catch {
      return fallback;
    }
  },
  save(key, value) {
    localStorage.setItem(key, JSON.stringify(value));
  }
};

let mistakes = StorageService.load(STORAGE.mistakes, {});
let stats = StorageService.load(STORAGE.stats, {});

function todayKey() {
  const date = new Date();
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

/* ------------------------- Questions and evaluation ----------------------- */
function valenceQuestion(item) {
  return {
    id: `quiz-valence-${item.symbol}`, type: "valence", itemId: item.id,
    prompt: `请填写 ${item.symbol}（${item.name}）的常见化合价`,
    answers: item.valences, displayAnswer: item.valences.join(" / "),
    help: "可变价可用 “/”、逗号或空格分隔"
  };
}

function buildQuizBank() {
  const valenceQuestions = valences.map(valenceQuestion);
  const elementQuestions = elements.flatMap((item) => [
    {
      id: `quiz-element-number-${item.atomicNumber}`, type: "element", itemId: item.id,
      prompt: `第 ${item.atomicNumber} 号元素是？`, answers: [item.symbol, item.name],
      displayAnswer: `${item.symbol}（${item.name}）`, help: "元素符号或中文名称均可"
    },
    {
      id: `quiz-element-name-${item.symbol}`, type: "element", itemId: item.id,
      prompt: `${item.symbol} 的中文名是？`, answers: [item.name],
      displayAnswer: item.name, help: "请填写中文名称"
    },
    {
      id: `quiz-element-symbol-${item.symbol}`, type: "element", itemId: item.id,
      prompt: `${item.name}的元素符号是？`, answers: [item.symbol],
      displayAnswer: item.symbol, help: "元素符号大小写必须正确"
    }
  ]);
  const formulaQuestions = formulas.flatMap((item) => [
    {
      id: `quiz-formula-forward-${item.symbol}`, type: "formula", itemId: item.id,
      prompt: `${item.name}的化学式是？`, answers: [item.symbol],
      displayAnswer: item.symbol, help: "请正确填写元素符号和数字"
    },
    {
      id: `quiz-formula-reverse-${item.symbol}`, type: "formula", itemId: item.id,
      prompt: `${item.symbol} 是什么物质？`, answers: [item.name],
      displayAnswer: item.name, help: "请填写物质的中文名称"
    }
  ]);
  return [...valenceQuestions, ...elementQuestions, ...formulaQuestions];
}

const quizBank = buildQuizBank();
const questionMap = new Map(quizBank.map((question) => [question.id, question]));

function normalizeText(value) {
  return value.trim().replace(/\s+/g, "").toLowerCase();
}

function parseValences(value) {
  return value.trim().replace(/[，、；;]/g, ",").replace(/\s+/g, ",").split(/[\/,]+/)
    .map((part) => part.trim()).filter(Boolean)
    .map((part) => {
      const number = Number(part.replace(/^\+/, ""));
      return Number.isNaN(number) ? part : number > 0 ? `+${number}` : `${number}`;
    });
}

function evaluate(question, answer) {
  if (question.type !== "valence") {
    const normalized = normalizeText(answer);
    return question.answers.some((value) => normalizeText(value) === normalized) ? "correct" : "incorrect";
  }
  const submitted = [...new Set(parseValences(answer))];
  const correct = [...new Set(question.answers)];
  if (!submitted.length) return "incorrect";
  const onlyCorrectValues = submitted.every((value) => correct.includes(value));
  const hasAllValues = correct.every((value) => submitted.includes(value));
  if (onlyCorrectValues && hasAllValues) return "correct";
  if (correct.length > 1 && onlyCorrectValues) return "partial";
  return "incorrect";
}

/* ------------------------------ Queue service ----------------------------- */
function shuffle(items) {
  const output = [...items];
  for (let index = output.length - 1; index > 0; index -= 1) {
    const target = Math.floor(Math.random() * (index + 1));
    [output[index], output[target]] = [output[target], output[index]];
  }
  return output;
}

function createQueue(getItems) {
  let items = [];
  let total = 0;
  return {
    next() {
      if (!items.length) {
        items = shuffle(getItems());
        total = items.length;
      }
      return { item: items.shift(), done: total - items.length, total };
    },
    reset() { items = []; total = 0; },
    remove(id) { items = items.filter((item) => item.id !== id); }
  };
}

const flashcards = [
  ...valences.map((item) => ({
    id: `flash-${item.id}`, front: item.symbol, hint: item.name,
    answer: item.valences.join(" / "), label: item.subgroup === "radical" ? "原子团" : "化合价",
    reviewQuestionId: `quiz-valence-${item.symbol}`
  })),
  ...formulas.map((item) => ({
    id: `flash-${item.id}`, front: item.name, hint: "常见化学式",
    answer: item.symbol, label: "化学式", reviewQuestionId: `quiz-formula-forward-${item.symbol}`
  }))
];

const flashcardQueue = createQueue(() => flashcards);
const quizQueue = createQueue(() => quizBank.filter((question) => !dueQuestionIds().has(question.id)));
const reviewQueue = createQueue(() => dueRecords().map((record) => questionMap.get(record.id)).filter(Boolean));
const elementPracticeQueue = createQueue(buildElementPractice);
const sequenceQueue = createQueue(buildSequenceChallenges);

/* --------------------------- Spaced review logic -------------------------- */
function dueRecords() {
  return Object.values(mistakes).filter((record) => !record.mastered && record.nextReviewAt <= Date.now());
}

function dueQuestionIds() {
  return new Set(dueRecords().map((record) => record.id));
}

function saveMistakes() {
  StorageService.save(STORAGE.mistakes, mistakes);
  updateDashboard();
}

function markWrong(question) {
  const previous = mistakes[question.id];
  mistakes[question.id] = {
    id: question.id, type: question.type, itemId: question.itemId,
    question: question.prompt, answer: question.displayAnswer,
    wrongCount: (previous?.wrongCount || 0) + 1,
    reviewLevel: 0, nextReviewAt: Date.now() + REVIEW_INTERVALS[0],
    lastReviewedAt: Date.now(), mastered: false
  };
  saveMistakes();
}

function markCorrect(question) {
  const record = mistakes[question.id];
  if (!record || record.mastered) return;
  const level = record.reviewLevel + 1;
  record.lastReviewedAt = Date.now();
  if (level > 5) {
    record.reviewLevel = 6;
    record.nextReviewAt = null;
    record.mastered = true;
  } else {
    record.reviewLevel = level;
    record.nextReviewAt = Date.now() + REVIEW_INTERVALS[level];
  }
  saveMistakes();
}

function recordDaily(result) {
  const key = todayKey();
  stats[key] ||= { total: 0, correct: 0 };
  stats[key].total += 1;
  if (result === "correct") stats[key].correct += 1;
  StorageService.save(STORAGE.stats, stats);
  updateDashboard();
}

/* ------------------------------- Rendering -------------------------------- */
function switchTab(tabId) {
  document.querySelectorAll(".tab").forEach((tab) => tab.classList.toggle("active", tab.dataset.tab === tabId));
  document.querySelectorAll(".page").forEach((page) => page.classList.toggle("active", page.id === tabId));
  if (tabId === "mistakes") renderMistakes();
  if (tabId === "quiz" && !currentQuizQuestion) nextQuizQuestion();
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function renderReference(filter = "all", search = "") {
  const query = normalizeText(search);
  const searchable = [...valences, ...formulas];
  const matched = searchable.filter((item) => {
    const categoryMatch = filter === "all" || item.subgroup === filter;
    const textMatch = !query || normalizeText(`${item.symbol}${item.name}`).includes(query);
    return categoryMatch && textMatch;
  });
  const errorSymbols = new Set(["Fe", "Cu", "Mn", "Cl", "SO4", "NH4", "Fe3O4", "H2O2"]);
  const frequent = matched.filter((item) => errorSymbols.has(item.symbol));
  const groups = [
    ["高频易错", frequent, "frequent"],
    ["固定价元素", matched.filter((item) => item.subgroup === "fixed"), "fixed"],
    ["可变价元素", matched.filter((item) => item.subgroup === "variable"), "variable"],
    ["常见原子团", matched.filter((item) => item.subgroup === "radical"), "radical"],
    ["常见化学式", matched.filter((item) => item.subgroup === "formula"), "formula"]
  ].filter(([, items]) => items.length);

  document.querySelector("#reference-content").innerHTML = groups.map(([title, items, group]) => `
    <section class="reference-section">
      <div class="category-title"><h3>${title}</h3><span>${items.length} 项</span></div>
      <div class="reference-grid">
        ${items.map((item) => `
          <article class="reference-card ${group}">
            <span class="reference-tag">${group === "frequent" ? "易错" : LABELS[item.subgroup]}</span>
            <div class="reference-symbol">${item.symbol}</div>
            <div class="reference-name">${item.name}</div>
            <div class="valence">${item.category === "formula" ? item.symbol : item.valences.join(" / ")}</div>
          </article>`).join("")}
      </div>
    </section>`).join("");
  document.querySelector("#reference-empty").hidden = groups.length > 0;
}

function renderElementCards() {
  const hide = {
    number: document.querySelector("#hide-number").checked,
    symbol: document.querySelector("#hide-symbol").checked,
    name: document.querySelector("#hide-name").checked
  };
  document.querySelector("#element-grid").innerHTML = elements.map((item) => `
    <article class="element-card">
      <span class="${hide.number ? "memory-hidden" : ""}">${item.atomicNumber}</span>
      <strong class="${hide.symbol ? "memory-hidden" : ""}">${item.symbol}</strong>
      <small class="${hide.name ? "memory-hidden" : ""}">${item.name}</small>
    </article>`).join("");
}

function renderMnemonics() {
  document.querySelector("#mnemonic-list").innerHTML = mnemonics.map(([line, explanation], index) => `
    <article class="mnemonic-card">
      <div class="mnemonic-number">${index + 1}</div>
      <div><p class="mnemonic-line">${line}</p><p class="mnemonic-explanation">${explanation}</p></div>
      <button class="button ghost explanation-toggle" aria-expanded="true">隐藏解释</button>
    </article>`).join("");
}

function updateDashboard() {
  const today = stats[todayKey()] || { total: 0, correct: 0 };
  const active = Object.values(mistakes).filter((record) => !record.mastered);
  const due = dueRecords();
  document.querySelector("#today-total").textContent = today.total;
  document.querySelector("#today-accuracy").textContent = today.total ? `${Math.round(today.correct / today.total * 100)}%` : "0%";
  document.querySelector("#mistake-total").textContent = active.length;
  document.querySelector("#due-count").textContent = due.length;
  document.querySelector("#due-review-card").hidden = due.length === 0;
  const badge = document.querySelector("#mistake-badge");
  badge.textContent = active.length;
  badge.hidden = active.length === 0;
}

/* -------------------------- Element memory trainer ------------------------ */
function buildElementPractice() {
  return elements.flatMap((item, index) => {
    const previous = index > 0 ? elements[index - 1] : null;
    return [
      { prompt: `第 ${item.atomicNumber} 号元素是？`, answers: [item.symbol, item.name], display: `${item.symbol}（${item.name}）` },
      { prompt: `${item.symbol} 的中文名是？`, answers: [item.name], display: item.name },
      { prompt: `${item.name}的元素符号是？`, answers: [item.symbol], display: item.symbol },
      ...(previous ? [{ prompt: `${item.symbol} 前面的元素是？`, answers: [previous.symbol, previous.name], display: `${previous.symbol}（${previous.name}）` }] : [])
    ];
  });
}

function buildSequenceChallenges() {
  return elements.slice(1, -1).map((item, index) => {
    const start = elements[index];
    const end = elements[index + 2];
    return { prompt: `${start.symbol} → ___ → ${end.symbol}`, answers: [item.symbol], display: item.symbol };
  });
}

let elementCurrent;
let sequenceCurrent;

function showMiniQuestion(kind) {
  const isElement = kind === "element";
  const result = (isElement ? elementPracticeQueue : sequenceQueue).next();
  if (isElement) elementCurrent = result.item; else sequenceCurrent = result.item;
  document.querySelector(`#${kind}-question`).textContent = result.item.prompt;
  document.querySelector(`#${kind}-progress`).textContent = `本轮进度：${result.done} / ${result.total}`;
  const input = document.querySelector(`#${kind}-answer`);
  input.value = "";
  input.disabled = false;
  document.querySelector(`#${kind}-feedback`).hidden = true;
  document.querySelector(`#${kind}-submit`).hidden = false;
  document.querySelector(`#${kind}-next`).hidden = true;
}

function submitMiniQuestion(kind) {
  const question = kind === "element" ? elementCurrent : sequenceCurrent;
  const input = document.querySelector(`#${kind}-answer`);
  const correct = question.answers.some((answer) => normalizeText(answer) === normalizeText(input.value));
  const feedback = document.querySelector(`#${kind}-feedback`);
  feedback.textContent = correct ? "回答正确！" : `回答错误，正确答案是：${question.display}`;
  feedback.className = `feedback ${correct ? "correct" : "incorrect"}`;
  feedback.hidden = false;
  input.disabled = true;
  document.querySelector(`#${kind}-submit`).hidden = true;
  document.querySelector(`#${kind}-next`).hidden = false;
}

/* ------------------------------ Flashcards -------------------------------- */
let currentFlashcard;
let flashRated = false;

function nextFlashcard() {
  const result = flashcardQueue.next();
  currentFlashcard = result.item;
  flashRated = false;
  document.querySelector("#flash-progress").textContent = `本轮进度：${result.done} / ${result.total}`;
  document.querySelector("#flash-front").textContent = currentFlashcard.front;
  document.querySelector("#flash-hint").textContent = currentFlashcard.hint;
  document.querySelector("#flash-type").textContent = currentFlashcard.label;
  document.querySelector("#flash-answer strong").textContent = currentFlashcard.answer;
  document.querySelector("#flash-answer").hidden = true;
  document.querySelector("#flash-prompt").hidden = false;
  document.querySelector("#show-answer").hidden = false;
  document.querySelector("#flash-actions").hidden = true;
  document.querySelector("#flash-feedback").textContent = "";
}

/* --------------------------------- Quiz ----------------------------------- */
let currentQuizQuestion = null;
let forcedQuestion = null;
let quizAnswered = false;
const quizSession = { total: 0, correct: 0, streak: 0 };

function nextQuizQuestion() {
  let result;
  let source;
  if (forcedQuestion) {
    result = { item: forcedQuestion, done: 1, total: 1 };
    forcedQuestion = null;
    source = "forced";
  } else if (dueRecords().length) {
    result = reviewQueue.next();
    source = result.item ? "review" : "normal";
    if (!result.item) {
      reviewQueue.reset();
      result = quizQueue.next();
    }
  } else {
    reviewQueue.reset();
    result = quizQueue.next();
    source = "normal";
  }
  currentQuizQuestion = result.item;
  quizAnswered = false;
  document.querySelector("#quiz-round-label").textContent =
    source === "review" ? "到期复习" : source === "forced" ? "立即复习" : "普通测验";
  document.querySelector("#quiz-progress").textContent = `${result.done} / ${result.total}`;
  document.querySelector("#quiz-source").textContent =
    source === "review" ? "正在优先完成到期错题。" : "每轮覆盖全部题型，同一题不会重复。";
  document.querySelector("#quiz-type").textContent = LABELS[currentQuizQuestion.type === "formula" ? "formulaType" : currentQuizQuestion.type];
  document.querySelector("#quiz-question").textContent = currentQuizQuestion.prompt;
  document.querySelector("#quiz-help").textContent = currentQuizQuestion.help;
  const input = document.querySelector("#quiz-input");
  input.value = "";
  input.disabled = false;
  document.querySelector("#quiz-feedback").hidden = true;
  document.querySelector("#submit-answer").hidden = false;
  document.querySelector("#next-question").hidden = true;
  setTimeout(() => input.focus(), 50);
}

function submitQuiz() {
  if (quizAnswered) return;
  const result = evaluate(currentQuizQuestion, document.querySelector("#quiz-input").value);
  const feedback = document.querySelector("#quiz-feedback");
  quizAnswered = true;
  quizSession.total += 1;
  if (result === "correct") {
    feedback.textContent = "回答正确！";
    quizSession.correct += 1;
    quizSession.streak += 1;
    markCorrect(currentQuizQuestion);
  } else if (result === "partial") {
    const submitted = parseValences(document.querySelector("#quiz-input").value);
    const missing = currentQuizQuestion.answers.filter((answer) => !submitted.includes(answer));
    feedback.textContent = `部分正确，${currentQuizQuestion.prompt.match(/填写 (.+?)（/)?.[1] || "该元素"}常见化合价还有 ${missing.join("、")}`;
    quizSession.streak = 0;
    markWrong(currentQuizQuestion);
  } else {
    feedback.textContent = `回答错误，正确答案是：${currentQuizQuestion.displayAnswer}`;
    quizSession.streak = 0;
    markWrong(currentQuizQuestion);
  }
  feedback.className = `feedback ${result}`;
  feedback.hidden = false;
  recordDaily(result);
  document.querySelector("#quiz-input").disabled = true;
  document.querySelector("#submit-answer").hidden = true;
  document.querySelector("#next-question").hidden = false;
  document.querySelector("#quiz-streak").textContent = quizSession.streak;
  document.querySelector("#quiz-total").textContent = quizSession.total;
  document.querySelector("#quiz-accuracy").textContent =
    `${Math.round(quizSession.correct / quizSession.total * 100)}%`;
}

/* ------------------------------ Mistake book ------------------------------ */
function remainingTime(timestamp) {
  if (!timestamp || timestamp <= Date.now()) return "现在可以复习";
  const difference = timestamp - Date.now();
  if (difference < 3600000) return `${Math.ceil(difference / 60000)} 分钟后`;
  if (difference < 86400000) return `${Math.ceil(difference / 3600000)} 小时后`;
  return `${Math.ceil(difference / 86400000)} 天后`;
}

function renderMistakes() {
  const active = Object.values(mistakes).filter((record) => !record.mastered)
    .sort((a, b) => a.nextReviewAt - b.nextReviewAt);
  const list = document.querySelector("#mistakes-list");
  list.hidden = active.length === 0;
  document.querySelector("#empty-mistakes").hidden = active.length > 0;
  list.innerHTML = active.map((record) => `
    <article class="mistake-card ${record.nextReviewAt <= Date.now() ? "is-due" : ""}">
      <div class="mistake-type">${LABELS[record.type === "formula" ? "formulaType" : record.type]}</div>
      <div class="mistake-info">
        <h3>${record.question}</h3>
        <p>正确答案：<strong>${record.answer}</strong> · 错误 ${record.wrongCount} 次</p>
        <div class="review-progress">
          <div class="level-bar"><div class="level-fill" style="width:${Math.min(record.reviewLevel / 5 * 100, 100)}%"></div></div>
          <span>Level ${record.reviewLevel} · ${remainingTime(record.nextReviewAt)}</span>
        </div>
      </div>
      <div class="mistake-actions">
        <button class="button secondary review-now" data-id="${record.id}">立即复习</button>
        <button class="button danger-ghost master-now" data-id="${record.id}">已掌握</button>
      </div>
    </article>`).join("");
}

/* ------------------------------- UI events -------------------------------- */
function bindEvents() {
  document.querySelectorAll(".tab").forEach((tab) => tab.addEventListener("click", () => switchTab(tab.dataset.tab)));
  document.querySelectorAll("[data-go-tab]").forEach((button) => button.addEventListener("click", () => switchTab(button.dataset.goTab)));
  document.querySelector("#start-review").addEventListener("click", () => switchTab(dueRecords().length ? "quiz" : "mistakes"));

  let referenceFilter = "all";
  const refreshReference = () => renderReference(referenceFilter, document.querySelector("#reference-search").value);
  document.querySelector("#reference-search").addEventListener("input", refreshReference);
  document.querySelector("#reference-filters").addEventListener("click", (event) => {
    const button = event.target.closest(".filter");
    if (!button) return;
    referenceFilter = button.dataset.filter;
    document.querySelectorAll(".filter").forEach((item) => item.classList.toggle("active", item === button));
    refreshReference();
  });

  ["number", "symbol", "name"].forEach((field) =>
    document.querySelector(`#hide-${field}`).addEventListener("change", renderElementCards));
  ["element", "sequence"].forEach((kind) => {
    document.querySelector(`#${kind}-submit`).addEventListener("click", () => submitMiniQuestion(kind));
    document.querySelector(`#${kind}-next`).addEventListener("click", () => showMiniQuestion(kind));
    document.querySelector(`#${kind}-answer`).addEventListener("keydown", (event) => {
      if (event.key === "Enter") {
        document.querySelector(`#${kind}-next`).hidden ? submitMiniQuestion(kind) : showMiniQuestion(kind);
      }
    });
  });

  document.querySelector("#toggle-explanations").addEventListener("click", (event) => {
    const explanations = [...document.querySelectorAll(".mnemonic-explanation")];
    const hide = explanations.some((item) => !item.hidden);
    explanations.forEach((item) => { item.hidden = hide; });
    document.querySelectorAll(".explanation-toggle").forEach((button) => {
      button.textContent = hide ? "显示解释" : "隐藏解释";
      button.setAttribute("aria-expanded", !hide);
    });
    event.currentTarget.textContent = hide ? "显示全部解释" : "隐藏全部解释";
  });
  document.querySelector("#mnemonic-list").addEventListener("click", (event) => {
    const button = event.target.closest(".explanation-toggle");
    if (!button) return;
    const explanation = button.closest(".mnemonic-card").querySelector(".mnemonic-explanation");
    explanation.hidden = !explanation.hidden;
    button.textContent = explanation.hidden ? "显示解释" : "隐藏解释";
  });

  document.querySelector("#show-answer").addEventListener("click", () => {
    document.querySelector("#flash-answer").hidden = false;
    document.querySelector("#flash-prompt").hidden = true;
    document.querySelector("#show-answer").hidden = true;
    document.querySelector("#flash-actions").hidden = false;
  });
  document.querySelector("#flash-known").addEventListener("click", () => {
    if (flashRated) return;
    flashRated = true;
    const question = questionMap.get(currentFlashcard.reviewQuestionId);
    markCorrect(question);
    document.querySelector("#flash-feedback").textContent = "很好，继续保持！";
  });
  document.querySelector("#flash-unknown").addEventListener("click", () => {
    if (flashRated) return;
    flashRated = true;
    markWrong(questionMap.get(currentFlashcard.reviewQuestionId));
    document.querySelector("#flash-feedback").textContent = "已加入错题本，10 分钟后安排复习。";
  });
  document.querySelector("#flash-next").addEventListener("click", nextFlashcard);

  document.querySelector("#submit-answer").addEventListener("click", submitQuiz);
  document.querySelector("#next-question").addEventListener("click", nextQuizQuestion);
  document.querySelector("#quiz-input").addEventListener("keydown", (event) => {
    if (event.key === "Enter") quizAnswered ? nextQuizQuestion() : submitQuiz();
  });
  document.querySelector("#mistakes-list").addEventListener("click", (event) => {
    const review = event.target.closest(".review-now");
    const master = event.target.closest(".master-now");
    if (review) {
      forcedQuestion = questionMap.get(review.dataset.id);
      currentQuizQuestion = null;
      switchTab("quiz");
    }
    if (master) {
      mistakes[master.dataset.id].mastered = true;
      mistakes[master.dataset.id].nextReviewAt = null;
      mistakes[master.dataset.id].lastReviewedAt = Date.now();
      reviewQueue.remove(master.dataset.id);
      saveMistakes();
      renderMistakes();
    }
  });
}

function initialize() {
  renderReference();
  renderElementCards();
  renderMnemonics();
  bindEvents();
  showMiniQuestion("element");
  showMiniQuestion("sequence");
  nextFlashcard();
  updateDashboard();
  document.querySelector("#today-date").textContent =
    new Intl.DateTimeFormat("zh-CN", { month: "long", day: "numeric", weekday: "short" }).format(new Date());
  setInterval(updateDashboard, 60000);
}

initialize();
