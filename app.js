"use strict";

const valenceData = [
  { symbol: "H", name: "氢", valences: ["+1"], type: "common" },
  { symbol: "O", name: "氧", valences: ["-2"], type: "common" },
  { symbol: "Na", name: "钠", valences: ["+1"], type: "common" },
  { symbol: "K", name: "钾", valences: ["+1"], type: "common" },
  { symbol: "Ag", name: "银", valences: ["+1"], type: "common" },
  { symbol: "Cl", name: "氯", valences: ["-1"], type: "common" },
  { symbol: "Ca", name: "钙", valences: ["+2"], type: "common" },
  { symbol: "Ba", name: "钡", valences: ["+2"], type: "common" },
  { symbol: "Mg", name: "镁", valences: ["+2"], type: "common" },
  { symbol: "Zn", name: "锌", valences: ["+2"], type: "common" },
  { symbol: "Al", name: "铝", valences: ["+3"], type: "common" },
  { symbol: "Si", name: "硅", valences: ["+4"], type: "common" },
  { symbol: "P", name: "磷", valences: ["+5"], type: "common" },
  { symbol: "Fe", name: "铁", valences: ["+2", "+3"], type: "variable" },
  { symbol: "Cu", name: "铜", valences: ["+1", "+2"], type: "variable" },
  { symbol: "C", name: "碳", valences: ["+2", "+4"], type: "variable" },
  { symbol: "S", name: "硫", valences: ["-2", "+4", "+6"], type: "variable" },
  { symbol: "N", name: "氮", valences: ["-3", "+2", "+4", "+5"], type: "variable" },
  { symbol: "OH", name: "氢氧根", valences: ["-1"], type: "group" },
  { symbol: "NO3", name: "硝酸根", valences: ["-1"], type: "group" },
  { symbol: "SO4", name: "硫酸根", valences: ["-2"], type: "group" },
  { symbol: "CO3", name: "碳酸根", valences: ["-2"], type: "group" },
  { symbol: "PO4", name: "磷酸根", valences: ["-3"], type: "group" },
  { symbol: "NH4", name: "铵根", valences: ["+1"], type: "group" }
];

const mnemonics = [
  ["一价氢氯钾钠银", "H（氢）、Cl（氯）、K（钾）、Na（钠）、Ag（银）常见一价"],
  ["二价氧钙钡镁锌", "O（氧）、Ca（钙）、Ba（钡）、Mg（镁）、Zn（锌）常见二价"],
  ["三铝四硅五价磷", "Al（铝）+3，Si（硅）+4，P（磷）+5"],
  ["二三铁，二四碳", "Fe（铁）常见 +2、+3；C（碳）常见 +2、+4"],
  ["二四六硫都齐全", "S（硫）常见 -2、+4、+6"],
  ["铜汞二价最常见", "Cu（铜）、Hg（汞）的 +2 价最常见；铜也有 +1 价"],
  ["莫忘单质都为零", "元素以单质形式存在时，化合价为 0，例如 H₂、O₂、Fe"],
  ["负一氢氧硝酸根", "OH（氢氧根）、NO₃（硝酸根）都是 -1 价"],
  ["负二硫酸碳酸根", "SO₄（硫酸根）、CO₃（碳酸根）都是 -2 价"],
  ["负三记住磷酸根", "PO₄（磷酸根）是 -3 价"],
  ["正一价的是铵根", "NH₄（铵根）是 +1 价"]
];

const STORAGE = {
  mistakes: "valence-helper-mistakes-v1",
  stats: "valence-helper-stats-v1"
};
const REVIEW_INTERVALS = [
  10 * 60 * 1000,
  24 * 60 * 60 * 1000,
  3 * 24 * 60 * 60 * 1000,
  7 * 24 * 60 * 60 * 1000,
  14 * 24 * 60 * 60 * 1000,
  30 * 24 * 60 * 60 * 1000
];
const typeNames = { common: "常见元素", variable: "可变价元素", group: "常见原子团" };

let mistakes = loadJSON(STORAGE.mistakes, {});
let stats = loadJSON(STORAGE.stats, {});
let currentFlashcard = null;
let currentQuestion = null;
let forcedQuestionSymbol = null;
let quizAnswered = false;
let flashRated = false;
let session = { total: 0, correct: 0, streak: 0 };
let flashcardQueue = [];
let flashcardDueMistakeQueue = [];
let quizQueue = [];
let dueMistakeQueue = [];
let flashRound = { normalTotal: 0, normalDone: 0, dueTotal: 0, dueDone: 0 };
let quizRound = { normalTotal: 0, normalDone: 0, dueTotal: 0, dueDone: 0 };

function loadJSON(key, fallback) {
  try {
    const value = JSON.parse(localStorage.getItem(key));
    return value && typeof value === "object" ? value : fallback;
  } catch {
    return fallback;
  }
}

function saveMistakes() {
  localStorage.setItem(STORAGE.mistakes, JSON.stringify(mistakes));
  updateDashboard();
}

function saveStats() {
  localStorage.setItem(STORAGE.stats, JSON.stringify(stats));
  updateDashboard();
}

function dateKey() {
  const now = new Date();
  return `${now.getFullYear()}-${String(now.getMonth() + 1).padStart(2, "0")}-${String(now.getDate()).padStart(2, "0")}`;
}

function itemBySymbol(symbol) {
  return valenceData.find((item) => item.symbol === symbol);
}

function displayValences(valences) {
  return valences.join(" / ");
}

function switchTab(tabId) {
  document.querySelectorAll(".tab").forEach((tab) => {
    const selected = tab.dataset.tab === tabId;
    tab.classList.toggle("active", selected);
    tab.setAttribute("aria-selected", selected);
  });
  document.querySelectorAll(".page").forEach((page) => page.classList.toggle("active", page.id === tabId));
  if (tabId === "mistakes") renderMistakes();
  if (tabId === "quiz" && !currentQuestion) nextQuestion();
  window.scrollTo({ top: 0, behavior: "smooth" });
}

function renderReference() {
  const sections = [
    ["common", "常见元素", "固定化合价，优先记牢"],
    ["variable", "可变价元素", "在不同化合物中可能呈现不同价态"],
    ["group", "常见原子团", "作为一个整体参与反应"]
  ];
  document.querySelector("#reference-content").innerHTML = sections.map(([type, title, subtitle]) => `
    <section class="reference-section">
      <div class="category-title"><h3>${title}</h3><span>${subtitle}</span></div>
      <div class="reference-grid">
        ${valenceData.filter((item) => item.type === type).map((item) => `
          <article class="reference-card">
            ${type === "variable" ? '<span class="variable-label">可变价</span>' : ""}
            <div class="reference-symbol">${item.symbol}</div>
            <div class="reference-name">${item.name}</div>
            <div class="valence">${displayValences(item.valences)}</div>
          </article>`).join("")}
      </div>
    </section>`).join("");
}

function renderMnemonics() {
  document.querySelector("#mnemonic-list").innerHTML = mnemonics.map(([line, explanation], index) => `
    <article class="mnemonic-card">
      <div class="mnemonic-number">${index + 1}</div>
      <div>
        <p class="mnemonic-line">${line}</p>
        <p class="mnemonic-explanation">${explanation}</p>
      </div>
      <button class="button ghost explanation-toggle" aria-expanded="true">隐藏解释</button>
    </article>`).join("");
}

function shuffle(items) {
  const shuffled = [...items];
  for (let index = shuffled.length - 1; index > 0; index -= 1) {
    const swapIndex = Math.floor(Math.random() * (index + 1));
    [shuffled[index], shuffled[swapIndex]] = [shuffled[swapIndex], shuffled[index]];
  }
  return shuffled;
}

function buildLearningRound(mode) {
  const dueItems = shuffle(dueMistakes().map((record) => itemBySymbol(record.symbol)).filter(Boolean));
  const dueSymbols = new Set(dueItems.map((item) => item.symbol));
  const normalItems = shuffle(valenceData.filter((item) => !dueSymbols.has(item.symbol)));
  const round = {
    normalTotal: normalItems.length,
    normalDone: 0,
    dueTotal: dueItems.length,
    dueDone: 0
  };

  if (mode === "flashcard") {
    flashcardDueMistakeQueue = dueItems;
    flashcardQueue = normalItems;
    flashRound = round;
  } else {
    dueMistakeQueue = dueItems;
    quizQueue = normalItems;
    quizRound = round;
  }
}

function takeFromQueue(mode) {
  if (mode === "flashcard") {
    if (!flashcardDueMistakeQueue.length && !flashcardQueue.length) buildLearningRound("flashcard");
    if (flashcardDueMistakeQueue.length) {
      flashRound.dueDone += 1;
      return { item: flashcardDueMistakeQueue.shift(), source: "due" };
    }
    flashRound.normalDone += 1;
    return { item: flashcardQueue.shift(), source: "normal" };
  }

  if (!dueMistakeQueue.length && !quizQueue.length) buildLearningRound("quiz");
  if (dueMistakeQueue.length) {
    quizRound.dueDone += 1;
    return { item: dueMistakeQueue.shift(), source: "due" };
  }
  quizRound.normalDone += 1;
  return { item: quizQueue.shift(), source: "normal" };
}

function showRoundProgress(mode, source) {
  const round = mode === "flashcard" ? flashRound : quizRound;
  const isDue = source === "due";
  const label = isDue ? "到期错题复习" : "普通学习";
  const done = isDue ? round.dueDone : round.normalDone;
  const total = isDue ? round.dueTotal : round.normalTotal;
  document.querySelector(`#${mode === "flashcard" ? "flash" : "quiz"}-round-label`).textContent = label;
  document.querySelector(`#${mode === "flashcard" ? "flash" : "quiz"}-progress`).textContent =
    mode === "flashcard" ? `本轮进度：${done} / ${total}` : `${done} / ${total}`;
}

function nextFlashcard() {
  const next = takeFromQueue("flashcard");
  currentFlashcard = next.item;
  flashRated = false;
  showRoundProgress("flashcard", next.source);
  document.querySelector("#flash-type").textContent = typeNames[currentFlashcard.type];
  document.querySelector("#flash-symbol").textContent = currentFlashcard.symbol;
  document.querySelector("#flash-name").textContent = currentFlashcard.name;
  document.querySelector("#flash-answer strong").textContent = displayValences(currentFlashcard.valences);
  document.querySelector("#flash-answer").hidden = true;
  document.querySelector("#flash-prompt").hidden = false;
  document.querySelector("#show-answer").hidden = false;
  document.querySelector("#flash-actions").hidden = true;
  document.querySelector("#flash-feedback").textContent = "";
}

function createMistake(item) {
  const old = mistakes[item.symbol];
  return {
    symbol: item.symbol,
    name: item.name,
    valences: item.valences,
    wrongCount: old?.wrongCount || 0,
    reviewLevel: old?.reviewLevel ?? 0,
    nextReviewAt: old?.nextReviewAt || Date.now(),
    lastReviewedAt: old?.lastReviewedAt || null,
    mastered: false
  };
}

function markWrong(item) {
  const record = createMistake(item);
  record.wrongCount += 1;
  record.reviewLevel = 0;
  record.lastReviewedAt = Date.now();
  record.nextReviewAt = Date.now() + REVIEW_INTERVALS[0];
  record.mastered = false;
  mistakes[item.symbol] = record;
  saveMistakes();
}

function markCorrect(item) {
  const record = mistakes[item.symbol];
  if (!record || record.mastered) return;
  const newLevel = record.reviewLevel + 1;
  record.lastReviewedAt = Date.now();
  if (newLevel > 5) {
    record.reviewLevel = 6;
    record.mastered = true;
    record.nextReviewAt = null;
  } else {
    record.reviewLevel = newLevel;
    record.nextReviewAt = Date.now() + REVIEW_INTERVALS[newLevel];
  }
  saveMistakes();
}

function dueMistakes() {
  return Object.values(mistakes).filter((item) => !item.mastered && item.nextReviewAt <= Date.now());
}

function nextQuestion() {
  let source;
  if (forcedQuestionSymbol) {
    currentQuestion = itemBySymbol(forcedQuestionSymbol);
    forcedQuestionSymbol = null;
    source = "review";
  } else {
    const next = takeFromQueue("quiz");
    currentQuestion = next.item;
    source = next.source;
  }
  quizAnswered = false;
  if (source === "review") {
    document.querySelector("#quiz-round-label").textContent = "立即复习";
    document.querySelector("#quiz-progress").textContent = "单题";
  } else {
    showRoundProgress("quiz", source);
  }
  document.querySelector("#quiz-type").textContent = typeNames[currentQuestion.type];
  document.querySelector("#quiz-symbol").textContent = currentQuestion.symbol;
  document.querySelector("#quiz-name").textContent = currentQuestion.name;
  document.querySelector("#quiz-source").textContent =
    source === "normal" ? "本轮题目已洗牌，每个项目只出现一次。" :
    source === "due" ? "优先复习到期错题，加深记忆。" : "正在立即复习这道错题。";
  const input = document.querySelector("#quiz-input");
  input.value = "";
  input.disabled = false;
  document.querySelector("#quiz-feedback").hidden = true;
  document.querySelector("#submit-answer").hidden = false;
  document.querySelector("#next-question").hidden = true;
  setTimeout(() => input.focus(), 100);
}

function parseAnswer(answer) {
  return answer
    .trim()
    .replace(/[，、；;]/g, ",")
    .replace(/\s+/g, ",")
    .split(/[\/,]+/)
    .map((part) => part.trim())
    .filter(Boolean)
    .map((part) => {
      const normalized = part.replace(/^\+?(-?\d+)$/, "$1");
      return Number(normalized) > 0 ? `+${Number(normalized)}` : `${Number(normalized)}`;
    })
    .filter((part) => part !== "NaN");
}

function evaluateAnswer(answer, correctValences) {
  const submitted = [...new Set(parseAnswer(answer))];
  const correct = [...new Set(correctValences)];
  if (!submitted.length) return "incorrect";
  const allSubmittedCorrect = submitted.every((value) => correct.includes(value));
  const allCorrectSubmitted = correct.every((value) => submitted.includes(value));
  if (allSubmittedCorrect && allCorrectSubmitted) return "correct";
  if (correct.length > 1 && allSubmittedCorrect && submitted.length < correct.length) return "partial";
  return "incorrect";
}

function recordDaily(result) {
  const key = dateKey();
  stats[key] ||= { total: 0, correct: 0 };
  stats[key].total += 1;
  if (result === "correct") stats[key].correct += 1;
  saveStats();
}

function submitAnswer() {
  if (quizAnswered) return;
  const input = document.querySelector("#quiz-input");
  const result = evaluateAnswer(input.value, currentQuestion.valences);
  const feedback = document.querySelector("#quiz-feedback");
  const answer = displayValences(currentQuestion.valences);
  quizAnswered = true;
  session.total += 1;

  if (result === "correct") {
    feedback.textContent = "回答正确！";
    feedback.className = "feedback correct";
    session.correct += 1;
    session.streak += 1;
    markCorrect(currentQuestion);
  } else if (result === "partial") {
    feedback.textContent = `部分正确，请记住完整化合价：${answer}`;
    feedback.className = "feedback partial";
    session.streak = 0;
    markWrong(currentQuestion);
  } else {
    feedback.textContent = `回答错误，正确答案是：${answer}`;
    feedback.className = "feedback incorrect";
    session.streak = 0;
    markWrong(currentQuestion);
  }
  recordDaily(result);
  updateQuizStats();
  input.disabled = true;
  feedback.hidden = false;
  document.querySelector("#submit-answer").hidden = true;
  document.querySelector("#next-question").hidden = false;
}

function updateQuizStats() {
  document.querySelector("#quiz-streak").textContent = session.streak;
  document.querySelector("#quiz-total").textContent = session.total;
  document.querySelector("#quiz-accuracy").textContent =
    session.total ? `${Math.round(session.correct / session.total * 100)}%` : "0%";
}

function remainingTime(timestamp) {
  if (!timestamp || timestamp <= Date.now()) return "现在可以复习";
  const diff = timestamp - Date.now();
  const minutes = Math.ceil(diff / 60000);
  if (minutes < 60) return `${minutes} 分钟后复习`;
  const hours = Math.ceil(diff / 3600000);
  if (hours < 24) return `${hours} 小时后复习`;
  return `${Math.ceil(diff / 86400000)} 天后复习`;
}

function renderMistakes() {
  const active = Object.values(mistakes)
    .filter((item) => !item.mastered)
    .sort((a, b) => a.nextReviewAt - b.nextReviewAt);
  const list = document.querySelector("#mistakes-list");
  document.querySelector("#empty-mistakes").hidden = active.length > 0;
  list.hidden = active.length === 0;
  list.innerHTML = active.map((item) => {
    const due = item.nextReviewAt <= Date.now();
    return `
      <article class="mistake-card ${due ? "is-due" : ""}">
        <div class="mistake-symbol">${item.symbol}</div>
        <div class="mistake-info">
          <h3>${item.name} · <span class="valence">${displayValences(item.valences)}</span></h3>
          <p>错误 ${item.wrongCount} 次 · ${remainingTime(item.nextReviewAt)}</p>
          <div class="review-progress">
            <div class="level-bar"><div class="level-fill" style="width:${Math.min(item.reviewLevel / 6 * 100, 100)}%"></div></div>
            <span>复习等级 ${item.reviewLevel} / 5</span>
          </div>
        </div>
        <div class="mistake-actions">
          <button class="button secondary review-now" data-symbol="${item.symbol}">立即复习</button>
          <button class="button danger-ghost remove-mistake" data-symbol="${item.symbol}">已掌握，移除</button>
        </div>
      </article>`;
  }).join("");
}

function updateDashboard() {
  const today = stats[dateKey()] || { total: 0, correct: 0 };
  const active = Object.values(mistakes).filter((item) => !item.mastered);
  const due = active.filter((item) => item.nextReviewAt <= Date.now());
  document.querySelector("#today-total").textContent = today.total;
  document.querySelector("#today-accuracy").textContent =
    today.total ? `${Math.round(today.correct / today.total * 100)}%` : "0%";
  document.querySelector("#mistake-total").textContent = active.length;
  document.querySelector("#due-count").textContent = due.length;
  document.querySelector("#due-review-card").hidden = due.length === 0;
  const badge = document.querySelector("#mistake-badge");
  badge.textContent = active.length;
  badge.hidden = active.length === 0;
}

function initializeEvents() {
  document.querySelectorAll(".tab").forEach((tab) => tab.addEventListener("click", () => switchTab(tab.dataset.tab)));
  document.querySelectorAll("[data-go-tab]").forEach((button) =>
    button.addEventListener("click", () => switchTab(button.dataset.goTab)));
  document.querySelector("#start-quiz").addEventListener("click", () => switchTab("quiz"));
  document.querySelector("#review-due").addEventListener("click", () => switchTab("quiz"));

  document.querySelector("#toggle-explanations").addEventListener("click", (event) => {
    const explanations = [...document.querySelectorAll(".mnemonic-explanation")];
    const shouldHide = explanations.some((item) => !item.hidden);
    explanations.forEach((item) => { item.hidden = shouldHide; });
    document.querySelectorAll(".explanation-toggle").forEach((button) => {
      button.textContent = shouldHide ? "显示解释" : "隐藏解释";
      button.setAttribute("aria-expanded", !shouldHide);
    });
    event.currentTarget.textContent = shouldHide ? "显示全部解释" : "隐藏全部解释";
  });
  document.querySelector("#mnemonic-list").addEventListener("click", (event) => {
    const button = event.target.closest(".explanation-toggle");
    if (!button) return;
    const explanation = button.closest(".mnemonic-card").querySelector(".mnemonic-explanation");
    explanation.hidden = !explanation.hidden;
    button.textContent = explanation.hidden ? "显示解释" : "隐藏解释";
    button.setAttribute("aria-expanded", !explanation.hidden);
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
    markCorrect(currentFlashcard);
    document.querySelector("#flash-feedback").textContent = "很好！记忆等级已更新。";
  });
  document.querySelector("#flash-unknown").addEventListener("click", () => {
    if (flashRated) return;
    flashRated = true;
    markWrong(currentFlashcard);
    document.querySelector("#flash-feedback").textContent = "已加入错题本，10 分钟后会提醒复习。";
  });
  document.querySelector("#flash-next").addEventListener("click", nextFlashcard);

  document.querySelector("#submit-answer").addEventListener("click", submitAnswer);
  document.querySelector("#next-question").addEventListener("click", nextQuestion);
  document.querySelector("#quiz-input").addEventListener("keydown", (event) => {
    if (event.key !== "Enter") return;
    quizAnswered ? nextQuestion() : submitAnswer();
  });
  document.querySelector("#mistakes-list").addEventListener("click", (event) => {
    const review = event.target.closest(".review-now");
    const remove = event.target.closest(".remove-mistake");
    if (review) {
      forcedQuestionSymbol = review.dataset.symbol;
      currentQuestion = null;
      switchTab("quiz");
    }
    if (remove) {
      mistakes[remove.dataset.symbol].mastered = true;
      mistakes[remove.dataset.symbol].lastReviewedAt = Date.now();
      mistakes[remove.dataset.symbol].nextReviewAt = null;
      saveMistakes();
      renderMistakes();
    }
  });
}

function initialize() {
  renderReference();
  renderMnemonics();
  initializeEvents();
  nextFlashcard();
  updateDashboard();
  updateQuizStats();
  document.querySelector("#today-date").textContent =
    new Intl.DateTimeFormat("zh-CN", { month: "long", day: "numeric", weekday: "short" }).format(new Date());
  setInterval(updateDashboard, 60000);
}

initialize();
