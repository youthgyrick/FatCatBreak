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
  ["H2O", "水"], ["CO2", "二氧化碳", ["干冰"]], ["NO2", "二氧化氮"], ["FeO", "氧化亚铁"],
  ["MgO", "氧化镁"], ["HgO", "氧化汞"], ["SO3", "三氧化硫"], ["P2O5", "五氧化二磷"],
  ["SO2", "二氧化硫"], ["Fe2O3", "氧化铁"], ["ZnO", "氧化锌"], ["Al2O3", "氧化铝"],
  ["CO", "一氧化碳", ["有毒气体"]], ["H2O2", "过氧化氢"], ["CaO", "氧化钙", ["生石灰"]],
  ["Fe3O4", "四氧化三铁"], ["MnO2", "二氧化锰"], ["CuO", "氧化铜"],
  ["Ca(OH)2", "氢氧化钙", ["熟石灰", "石灰水"]],
  ["CaCO3", "碳酸钙", ["石灰石", "大理石"]],
  ["CH4", "甲烷", ["天然气主要成分", "沼气主要成分"]],
  ["C2H5OH", "乙醇", ["酒精"]],
  ["H2", "氢气", ["最轻气体", "可燃气体"]],
  ["O2", "氧气", ["供给呼吸气体", "助燃气体"]],
  ["N2", "氮气", ["空气中最多的气体"]],
  ["HCl", "盐酸", ["氢氯酸"]],
  ["CH3COOH", "乙酸", ["醋酸", "冰醋酸"]],
  ["KMnO4", "高锰酸钾", ["灰锰氧"]]
].map(([symbol, name, aliases = []]) => ({
  id: `formula-${symbol}`, formula: symbol, symbol, name, aliases,
  category: "formula", subgroup: "formula"
}));

function normalizeSubstanceKey(value) {
  return String(value || "").trim().replace(/\s+/g, "").toUpperCase();
}

// Formula, standard name and every alias all resolve to this same object.
const substanceAliasMap = new Map();
formulas.forEach((item) => {
  [item.formula, item.name, ...item.aliases].forEach((key) => {
    substanceAliasMap.set(normalizeSubstanceKey(key), item);
  });
});

function findSubstance(value) {
  const key = normalizeSubstanceKey(value);
  return substanceAliasMap.get(key) || substanceAliasMap.get(key.replace(/0/g, "O")) || null;
}

function substanceNames(item) {
  return [item.name, ...item.aliases];
}

function randomSubstanceName(item) {
  const names = substanceNames(item);
  return names[Math.floor(Math.random() * names.length)];
}

function substanceDetails(item) {
  return item.aliases.length
    ? `标准名称：${item.name}\n俗名：${item.aliases.join("、")}\n化学式：${item.formula}`
    : `标准名称：${item.name}\n化学式：${item.formula}`;
}

const equations = [
  [1, "镁在氧气中燃烧", "2Mg + O2 → 2MgO", "点燃", "发出耀眼白光，生成白色固体"],
  [1, "铁在氧气中燃烧", "3Fe + 2O2 → Fe3O4", "点燃", "剧烈燃烧、火星四射，生成黑色固体"],
  [1, "红磷在氧气中燃烧", "4P + 5O2 → 2P2O5", "点燃", "产生大量白烟，放出热量"],
  [1, "硫在氧气中燃烧", "S + O2 → SO2", "点燃", "发出明亮蓝紫色火焰，生成有刺激性气味的气体"],
  [1, "氢气在氧气中燃烧", "2H2 + O2 → 2H2O", "点燃", "发出淡蓝色火焰，放出热量"],
  [1, "水的电解", "2H2O → 2H2 + O2", "通电", "正、负极产生气泡，气体体积比约为 1∶2"],
  [1, "二氧化碳使澄清石灰水变浑浊", "CO2 + Ca(OH)2 → CaCO3↓ + H2O", "无", "澄清石灰水变浑浊，产生白色沉淀"],
  [1, "过氧化氢分解制氧气", "2H2O2 → 2H2O + O2", "MnO2 作催化剂", "产生大量气泡，带火星木条复燃"],
  [2, "碳在氧气中充分燃烧", "C + O2 → CO2", "点燃", "发出白光，放出热量"],
  [2, "碳在氧气中不充分燃烧", "2C + O2 → 2CO", "点燃", "生成无色有毒气体"],
  [2, "生石灰与水反应", "CaO + H2O → Ca(OH)2", "无", "放出大量热，生成白色固体"],
  [2, "二氧化碳与水反应", "CO2 + H2O → H2CO3", "无", "生成碳酸，溶液呈酸性"],
  [2, "碳酸分解", "H2CO3 → H2O + CO2", "无", "产生二氧化碳气体"],
  [2, "二氧化碳与碳反应", "CO2 + C → 2CO", "高温", "生成一氧化碳"],
  [2, "碳酸钙分解", "CaCO3 → CaO + CO2", "高温", "生成氧化钙并放出二氧化碳"],
  [2, "碳还原氧化铜", "C + 2CuO → 2Cu + CO2", "高温", "黑色粉末逐渐变红，生成能使石灰水变浑浊的气体"],
  [3, "一氧化碳还原氧化铜", "CO + CuO → Cu + CO2", "加热", "黑色氧化铜逐渐变红，生成二氧化碳"],
  [3, "氢气还原氧化铜", "H2 + CuO → Cu + H2O", "加热", "黑色氧化铜逐渐变红，管壁出现水珠"],
  [3, "高锰酸钾制氧气", "2KMnO4 → K2MnO4 + MnO2 + O2", "加热", "产生能使带火星木条复燃的气体"],
  [3, "氯酸钾制氧气", "2KClO3 → 2KCl + 3O2", "加热，MnO2 作催化剂", "产生能使带火星木条复燃的气体"],
  [3, "碳酸钙与盐酸反应", "CaCO3 + 2HCl → CaCl2 + H2O + CO2", "无", "固体逐渐溶解，产生大量气泡"],
  [3, "甲烷在氧气中燃烧", "CH4 + 2O2 → CO2 + 2H2O", "点燃", "发出明亮蓝色火焰，放出热量"],
  [3, "硫酸铜与氢氧化钠反应", "CuSO4 + 2NaOH → Na2SO4 + Cu(OH)2", "无", "产生蓝色沉淀"]
].map(([level, name, equation, condition, phenomenon], index) => ({
  id: `equation-${index + 1}`, category: "equation", subgroup: `level-${level}`,
  level, name, equation, condition, phenomenon
}));

const chemistryData = [...elements, ...valences, ...formulas, ...equations];
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
  valence: "化合价", element: "元素", formulaType: "化学式", equation: "方程式"
};
const STORAGE = {
  mistakes: "chem-memory-mistakes-v2",
  stats: "chem-memory-stats-v2",
  equations: "chem-memory-equation-progress-v1",
  chat: "chem-memory-chat-history-v1",
  mastery: "chem-memory-mastery-v1",
  mode: "chem-memory-study-mode-v1"
};
const MODE_LABELS = {
  element: "元素顺序", valence: "化合价", radical: "原子团",
  formula: "化学式", equation: "化学方程式", mixed: "混合挑战"
};
const EQUATION_UNLOCK_ATTEMPTS = 8;
const EQUATION_UNLOCK_ACCURACY = 0.8;
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
let equationProgress = StorageService.load(STORAGE.equations, {
  unlockedLevel: 1,
  levels: { 1: { attempts: 0, correct: 0 }, 2: { attempts: 0, correct: 0 }, 3: { attempts: 0, correct: 0 } }
});
if (localStorage.getItem("devUnlockAll") === "true") equationProgress.unlockedLevel = 3;
const storedChatHistory = StorageService.load(STORAGE.chat, []);
let chatHistory = Array.isArray(storedChatHistory) ? storedChatHistory : [];
let mastery = StorageService.load(STORAGE.mastery, {});
let studyMode = localStorage.getItem(STORAGE.mode) || "mixed";
if (!MODE_LABELS[studyMode]) studyMode = "mixed";

function todayKey() {
  const date = new Date();
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

/* ------------------------- Questions and evaluation ----------------------- */
function valenceQuestion(item) {
  return {
    id: `quiz-valence-${item.symbol}`, type: "valence", category: item.subgroup === "radical" ? "radical" : "valence",
    subtype: item.subgroup, itemId: item.id,
    prompt: `请填写 ${item.symbol}（${item.name}）的常见化合价`,
    answers: item.valences, displayAnswer: item.valences.join(" / "),
    help: "可变价可用 “/”、逗号或空格分隔"
  };
}

function buildQuizBank() {
  const valenceQuestions = valences.map(valenceQuestion);
  const elementQuestions = elements.flatMap((item) => [
    {
      id: `quiz-element-number-${item.atomicNumber}`, type: "element", category: "element", subtype: "number", itemId: item.id,
      prompt: `第 ${item.atomicNumber} 号元素是？`, answers: [item.symbol, item.name],
      displayAnswer: `${item.symbol}（${item.name}）`, help: "元素符号或中文名称均可"
    },
    {
      id: `quiz-element-name-${item.symbol}`, type: "element", category: "element", subtype: "name", itemId: item.id,
      prompt: `${item.symbol} 的中文名是？`, answers: [item.name],
      displayAnswer: item.name, answerKind: "chinese-name", help: "请填写中文名称"
    },
    {
      id: `quiz-element-symbol-${item.symbol}`, type: "element", category: "element", subtype: "symbol", itemId: item.id,
      prompt: `${item.name}的元素符号是？`, answers: [item.symbol],
      displayAnswer: item.symbol, help: "元素符号大小写必须正确"
    }
  ]);
  const formulaQuestions = formulas.flatMap((item) => [
    {
      id: `quiz-formula-forward-${item.symbol}`, type: "formula", category: "formula", subtype: "forward", itemId: item.id,
      prompt: `${randomSubstanceName(item)}的化学式是？`, answers: [item.symbol],
      displayAnswer: item.symbol, help: "请正确填写元素符号和数字"
    },
    {
      id: `quiz-formula-reverse-${item.symbol}`, type: "formula", category: "formula", subtype: "reverse", itemId: item.id,
      prompt: `${item.symbol} 是什么物质？`, answers: substanceNames(item),
      displayAnswer: item.name, answerKind: "chinese-name", help: "请填写物质的中文名称"
    }
  ]);
  const equationQuestions = equations.map((item) => ({
    id: `quiz-${item.id}`, type: "equation", category: "equation", subtype: `level-${item.level}`, itemId: item.id, level: item.level,
    prompt: `请写出“${equationPromptName(item)}”的化学方程式`,
    answers: [item.equation], displayAnswer: item.equation,
    help: `条件：${item.condition}`
  }));
  return [...valenceQuestions, ...elementQuestions, ...formulaQuestions, ...equationQuestions];
}

function equationPromptName(equation) {
  let name = equation.name;
  const eligible = formulas.filter((item) =>
    ["CaCO3", "CaO", "Ca(OH)2", "HCl"].includes(item.formula));
  eligible.forEach((item) => {
    item.aliases.forEach((alias) => {
      if (name.includes(alias)) name = name.replace(alias, item.name);
    });
    if (name.includes(item.name)) name = name.replace(item.name, randomSubstanceName(item));
  });
  return name;
}

const quizBank = buildQuizBank();
const questionMap = new Map(quizBank.map((question) => [question.id, question]));

function normalizeText(value) {
  return value.trim().replace(/\s+/g, "").toLowerCase();
}

function normalizeChineseNameAnswer(value) {
  const chineseNumbers = {
    一: "1", 二: "2", 三: "3", 四: "4", 五: "5",
    六: "6", 七: "7", 八: "8", 九: "9", 十: "10"
  };
  return normalizeText(value).replace(/[一二三四五六七八九十]/g, (number) => chineseNumbers[number]);
}

function normalizeEquation(value) {
  return normalizeText(value)
    .replace(/(?:->|=>|=)/g, "→")
    .replace(/[↑↓]/g, "");
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
  if (question.type === "equation") {
    return normalizeEquation(answer) === normalizeEquation(question.answers[0]) ? "correct" : "incorrect";
  }
  if (question.category === "formula") {
    const submittedSubstance = findSubstance(answer);
    const expectedSubstance = findSubstance(question.answers[0]);
    if (submittedSubstance && expectedSubstance && submittedSubstance.id === expectedSubstance.id) {
      return "correct";
    }
  }
  if (question.answerKind === "chinese-name") {
    const normalized = normalizeChineseNameAnswer(answer);
    return question.answers.some((value) => normalizeChineseNameAnswer(value) === normalized) ? "correct" : "incorrect";
  }
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

function explainWrongAnswer(input, correctAnswer = "") {
  const original = input.trim();
  if (!original) return { found: false, explanation: "" };
  const normalized = normalizeQuestion(original).replace(/0/g, "O");
  const normalizedCorrect = normalizeQuestion(correctAnswer).replace(/0/g, "O");

  if (normalized === "CU2O") {
    return {
      found: true,
      explanation: normalizedCorrect === "CUO"
        ? "你可能混淆了：\nCuO：氧化铜\nCu2O：氧化亚铜"
        : `你写的 ${original} 是氧化亚铜。`
    };
  }

  const formula = findSubstance(original);
  if (formula) {
    const aliasText = formula.aliases.length ? `，俗名有${formula.aliases.join("、")}` : "";
    return {
      found: true,
      explanation: `你写的 ${original} 是${formula.name}（${formula.formula}）${aliasText}。`
    };
  }

  const radical = valences.find((item) => item.subgroup === "radical" &&
    (normalizeQuestion(item.symbol) === normalized || normalizeQuestion(item.name) === normalized));
  if (radical) {
    return {
      found: true,
      explanation: `你写的 ${original} 是${radical.name}，化合价 ${radical.valences.join(" / ")}。`
    };
  }

  const valence = valences.find((item) =>
    normalizeQuestion(item.symbol) === normalized || normalizeQuestion(item.name) === normalized);
  if (valence) {
    return {
      found: true,
      explanation: `你写的 ${original} 是${valence.name}，常见化合价 ${valence.valences.join(" / ")}。`
    };
  }

  const element = elements.find((item) =>
    normalizeQuestion(item.symbol) === normalized || normalizeQuestion(item.name) === normalized);
  if (element) {
    return {
      found: true,
      explanation: `你写的 ${original} 是${element.name}，是第 ${element.atomicNumber} 号元素。`
    };
  }

  const equation = equations.find((item) => {
    const equationText = normalizeQuestion(item.equation).replace(/0/g, "O");
    const name = normalizeQuestion(item.name);
    const phenomenon = normalizeQuestion(item.phenomenon);
    return equationText === normalized || name === normalized ||
      (normalized.length >= 4 && (name.includes(normalized) || phenomenon.includes(normalized)));
  });
  if (equation) {
    return {
      found: true,
      explanation: `你写的内容是“${equation.name}”对应的化学方程式：${equation.equation}。`
    };
  }

  return { found: false, explanation: "" };
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

function createQueue(getItems, shouldShuffle = true) {
  let items = [];
  let total = 0;
  return {
    next() {
      if (!items.length) {
        const nextItems = getItems();
        items = shouldShuffle ? shuffle(nextItems) : nextItems;
        total = items.length;
      }
      return { item: items.shift(), done: total - items.length, total };
    },
    reset() { items = []; total = 0; },
    remove(id) { items = items.filter((item) => item.id !== id); }
  };
}

const flashcards = [
  ...elements.map((item) => ({
    id: `flash-${item.id}`, front: `${item.atomicNumber} · ${item.symbol}`, hint: "前 20 号元素",
    answer: item.name, label: "元素顺序", category: "element",
    reviewQuestionId: `quiz-element-number-${item.atomicNumber}`
  })),
  ...valences.map((item) => ({
    id: `flash-${item.id}`, front: item.symbol, hint: item.name,
    answer: item.valences.join(" / "), label: item.subgroup === "radical" ? "原子团" : "化合价",
    category: item.subgroup === "radical" ? "radical" : "valence",
    reviewQuestionId: `quiz-valence-${item.symbol}`
  })),
  ...formulas.map((item) => ({
    id: `flash-${item.id}`, front: randomSubstanceName(item), hint: "常见名称 / 俗名",
    answer: item.symbol, label: "化学式", category: "formula",
    reviewQuestionId: `quiz-formula-forward-${item.symbol}`
  })),
  ...equations.map((item) => ({
    id: `flash-${item.id}`, front: item.name, hint: `Level ${item.level}`,
    answer: item.equation, label: "化学方程式", category: "equation", level: item.level,
    reviewQuestionId: `quiz-${item.id}`
  }))
];

function matchesStudyMode(item) {
  if (studyMode === "mixed") return true;
  return (item.category || item.type) === studyMode;
}

const flashcardQueue = createQueue(() => {
  const filtered = flashcards.filter((item) =>
    matchesStudyMode(item) && (item.category !== "equation" || item.level <= equationProgress.unlockedLevel));
  return filtered.length ? filtered : flashcards;
});
const quizQueue = createQueue(() => {
  const available = quizBank.filter((question) =>
    !dueQuestionIds().has(question.id) &&
    (question.type !== "equation" || question.level <= equationProgress.unlockedLevel) &&
    matchesStudyMode(question)
  );
  const priorityEquations = shuffle(available.filter((question) =>
    question.type === "equation" && question.level === equationProgress.unlockedLevel
  ));
  const remaining = shuffle(available.filter((question) => !priorityEquations.includes(question)));
  return [...priorityEquations, ...remaining];
}, false);
const reviewQueue = createQueue(() => {
  const dueQuestions = dueRecords().map((record) => questionMap.get(record.id)).filter(Boolean);
  return [
    ...shuffle(dueQuestions.filter(matchesStudyMode)),
    ...shuffle(dueQuestions.filter((question) => !matchesStudyMode(question)))
  ];
}, false);
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

function updateMastery(question, isCorrect) {
  const record = mastery[question.id] || {
    id: question.id,
    category: question.category || question.type,
    label: question.prompt,
    correctCount: 0,
    wrongCount: 0,
    reviewLevel: 0,
    lastReviewedAt: null,
    nextReviewAt: null
  };
  record.lastReviewedAt = Date.now();
  if (isCorrect) {
    record.correctCount += 1;
    record.reviewLevel = Math.min(5, record.reviewLevel + 1);
    record.nextReviewAt = Date.now() + REVIEW_INTERVALS[Math.min(record.reviewLevel, 5)];
  } else {
    record.wrongCount += 1;
    record.reviewLevel = 0;
    record.nextReviewAt = Date.now() + REVIEW_INTERVALS[0];
  }
  mastery[question.id] = record;
  StorageService.save(STORAGE.mastery, mastery);
}

function masteryStars(record) {
  if (!record) return 0;
  if (record.reviewLevel >= 5 && record.correctCount >= record.wrongCount + 3) return 5;
  if (record.reviewLevel >= 4) return 4;
  if (record.reviewLevel >= 3) return 3;
  if (record.correctCount >= 1 && record.correctCount >= record.wrongCount) return 2;
  if (record.correctCount || record.wrongCount) return 1;
  return 0;
}

function starsText(record) {
  const stars = masteryStars(record);
  return `${"★".repeat(stars)}${"☆".repeat(5 - stars)}`;
}

function markWrong(question) {
  updateMastery(question, false);
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
  updateMastery(question, true);
  const record = mistakes[question.id];
  if (!record || record.mastered) {
    updateDashboard();
    return;
  }
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
    const textMatch = !query || normalizeText(
      `${item.symbol}${item.name}${item.aliases?.join("") || ""}`
    ).includes(query);
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
        ${items.map((item) => {
          const progressId = item.category === "formula"
            ? `quiz-formula-forward-${item.symbol}` : `quiz-valence-${item.symbol}`;
          return `<article class="reference-card ${group}">
            <span class="reference-tag">${group === "frequent" ? "易错" : LABELS[item.subgroup]}</span>
            <div class="reference-symbol">${item.symbol}</div>
            <div class="reference-name">${item.name}</div>
            ${item.aliases?.length
              ? `<div class="reference-aliases">俗名：${item.aliases.join("、")}</div>`
              : ""}
            <div class="valence">${item.category === "formula" ? item.symbol : item.valences.join(" / ")}</div>
            <div class="mastery-stars" title="熟练度">${starsText(mastery[progressId])}</div>
          </article>`;
        }).join("")}
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
  const records = Object.values(mastery);
  const masteredCount = records.filter((record) => masteryStars(record) >= 4).length;
  const weakest = [...records].sort((a, b) =>
    masteryStars(a) - masteryStars(b) || b.wrongCount - a.wrongCount)[0];
  const recommended = due.find((record) => matchesStudyMode(questionMap.get(record.id) || record)) || due[0];
  const streak = learningStreak();
  document.querySelector("#home-streak").textContent = `${streak} 天`;
  document.querySelector("#today-completion").textContent = today.total >= 10 ? "今日已完成 ✓" : `今日 ${today.total} / 10 题`;
  document.querySelector("#home-mastered").textContent = masteredCount;
  document.querySelector("#home-weakest").textContent = weakest?.label || "暂无";
  document.querySelector("#home-recommended").textContent = recommended?.question || "暂无";
  document.querySelector("#home-recommended-note").textContent = recommended ? "已到复习时间" : "暂无到期内容";
  renderStatistics();
}

function localDateKey(date) {
  return `${date.getFullYear()}-${String(date.getMonth() + 1).padStart(2, "0")}-${String(date.getDate()).padStart(2, "0")}`;
}

function learningStreak() {
  const cursor = new Date();
  if ((stats[todayKey()]?.total || 0) < 10) cursor.setDate(cursor.getDate() - 1);
  let streak = 0;
  while ((stats[localDateKey(cursor)]?.total || 0) >= 10) {
    streak += 1;
    cursor.setDate(cursor.getDate() - 1);
  }
  return streak;
}

function renderStatistics() {
  const allDays = Object.values(stats);
  const total = allDays.reduce((sum, day) => sum + day.total, 0);
  const correct = allDays.reduce((sum, day) => sum + day.correct, 0);
  const today = stats[todayKey()] || { total: 0, correct: 0 };
  document.querySelector("#stats-total").textContent = total;
  document.querySelector("#stats-accuracy").textContent = total ? `${Math.round(correct / total * 100)}%` : "0%";
  document.querySelector("#stats-today").textContent = today.total;
  document.querySelector("#stats-streak").textContent = `${learningStreak()} 天`;

  const categories = ["element", "valence", "radical", "formula", "equation"];
  document.querySelector("#category-mastery").innerHTML = categories.map((category) => {
    const records = Object.values(mastery).filter((record) => record.category === category);
    const average = records.length
      ? records.reduce((sum, record) => sum + masteryStars(record), 0) / records.length : 0;
    return `<div class="stat-list-row"><span>${MODE_LABELS[category]}</span><strong>${"★".repeat(Math.round(average))}${"☆".repeat(5 - Math.round(average))}</strong></div>`;
  }).join("");

  const mostWrong = Object.values(mastery).filter((record) => record.wrongCount)
    .sort((a, b) => b.wrongCount - a.wrongCount).slice(0, 5);
  document.querySelector("#top-mistakes").innerHTML = mostWrong.length
    ? mostWrong.map((record) => `<div class="stat-list-row"><span>${record.label}</span><strong>错 ${record.wrongCount} 次</strong></div>`).join("")
    : '<p class="muted-text">暂无错题记录</p>';

  const recent = Object.values(mastery).filter((record) => record.lastReviewedAt)
    .sort((a, b) => b.lastReviewedAt - a.lastReviewedAt).slice(0, 8);
  document.querySelector("#recent-reviews").innerHTML = recent.length
    ? recent.map((record) => `<div class="stat-list-row"><span>${record.label}</span><strong>${starsText(record)}</strong></div>`).join("")
    : '<p class="muted-text">暂无复习记录</p>';
}

function setStudyMode(mode) {
  studyMode = MODE_LABELS[mode] ? mode : "mixed";
  localStorage.setItem(STORAGE.mode, studyMode);
  document.querySelector("#active-mode-label").textContent = MODE_LABELS[studyMode];
  document.querySelectorAll(".mode-card").forEach((button) =>
    button.classList.toggle("active", button.dataset.mode === studyMode));
  flashcardQueue.reset();
  quizQueue.reset();
  reviewQueue.reset();
  quizHistory = [];
  quizCursor = -1;
  currentQuizQuestion = null;
  nextFlashcard();
  updateDashboard();
}

/* -------------------------- Equation level learning ----------------------- */
let selectedEquationLevel = 1;

function levelStats(level) {
  equationProgress.levels ||= {};
  equationProgress.levels[level] ||= { attempts: 0, correct: 0 };
  return equationProgress.levels[level];
}

function equationAccuracy(level) {
  const levelData = levelStats(level);
  return levelData.attempts ? levelData.correct / levelData.attempts : 0;
}

function recordEquationResult(question, result) {
  if (question.type !== "equation") return;
  const levelData = levelStats(question.level);
  levelData.attempts += 1;
  if (result === "correct") levelData.correct += 1;

  const canUnlock = question.level === equationProgress.unlockedLevel &&
    question.level < 3 &&
    levelData.attempts >= EQUATION_UNLOCK_ATTEMPTS &&
    equationAccuracy(question.level) >= EQUATION_UNLOCK_ACCURACY;
  if (canUnlock) {
    equationProgress.unlockedLevel += 1;
    quizQueue.reset();
  }
  StorageService.save(STORAGE.equations, equationProgress);
  renderEquationModule();
}

function renderEquationModule() {
  document.querySelector("#equation-levels").innerHTML = [1, 2, 3].map((level) => {
    const statsForLevel = levelStats(level);
    const accuracy = Math.round(equationAccuracy(level) * 100);
    const unlocked = level <= equationProgress.unlockedLevel;
    const completed = level < equationProgress.unlockedLevel || (level === 3 && statsForLevel.attempts >= EQUATION_UNLOCK_ATTEMPTS && accuracy >= 80);
    return `
      <article class="level-card card ${unlocked ? "unlocked" : "locked"}">
        <div class="level-card-top">
          <span class="level-badge">Level ${level}</span>
          <span>${completed ? "✓ 已达标" : unlocked ? "学习中" : "🔒 未解锁"}</span>
        </div>
        <strong>${level === 1 ? "基础必背" : level === 2 ? "常见反应" : "提高训练"}</strong>
        <p>${unlocked ? `已答 ${statsForLevel.attempts} 题 · 正确率 ${accuracy}%` : "完成上一级后解锁"}</p>
        <div class="unlock-bar"><i style="width:${unlocked ? Math.min(accuracy, 100) : 0}%"></i></div>
      </article>`;
  }).join("");

  const unlocked = selectedEquationLevel <= equationProgress.unlockedLevel;
  document.querySelector("#equation-list").hidden = !unlocked;
  document.querySelector("#equation-locked").hidden = unlocked;
  document.querySelector("#equation-filter-note").textContent =
    selectedEquationLevel === 1 ? "基础必背" : selectedEquationLevel === 2 ? "常见反应" : "提高训练";
  document.querySelectorAll("#equation-filters .filter").forEach((button) => {
    const level = Number(button.dataset.level);
    button.classList.toggle("active", level === selectedEquationLevel);
    button.classList.toggle("is-locked", level > equationProgress.unlockedLevel);
  });
  if (!unlocked) {
    document.querySelector("#equation-lock-message").textContent =
      `先完成 Level ${selectedEquationLevel - 1} 至少 ${EQUATION_UNLOCK_ATTEMPTS} 道测验，并达到 80% 正确率。`;
    return;
  }
  document.querySelector("#equation-list").innerHTML = equations
    .filter((item) => item.level === selectedEquationLevel)
    .map((item, index) => `
      <article class="equation-card card">
        <div class="equation-heading">
          <span class="equation-index">${index + 1}</span>
          <div><span class="level-badge">Level ${item.level}</span><h3>${item.name}</h3></div>
        </div>
        <div class="equation-expression">${item.equation}</div>
        <dl>
          <div><dt>条件</dt><dd>${item.condition}</dd></div>
          <div><dt>现象</dt><dd>${item.phenomenon}</dd></div>
        </dl>
      </article>`).join("");
}

function startEquationQuiz() {
  selectedEquationLevel = equationProgress.unlockedLevel;
  quizQueue.reset();
  currentQuizQuestion = null;
  quizHistory = [];
  quizCursor = -1;
  switchTab("quiz");
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
  input.readOnly = false;
  document.querySelector(`#${kind}-feedback`).hidden = true;
  document.querySelector(`#${kind}-submit`).hidden = false;
  document.querySelector(`#${kind}-next`).hidden = true;
  setTimeout(() => input.focus(), 50);
}

function submitMiniQuestion(kind) {
  const question = kind === "element" ? elementCurrent : sequenceCurrent;
  const input = document.querySelector(`#${kind}-answer`);
  const correct = question.answers.some((answer) => normalizeText(answer) === normalizeText(input.value));
  const feedback = document.querySelector(`#${kind}-feedback`);
  const wrongExplanation = correct ? null : explainWrongAnswer(input.value, question.display);
  feedback.textContent = correct
    ? "回答正确！"
    : `回答错误。\n正确答案是：${question.display}。${wrongExplanation.found ? `\n${wrongExplanation.explanation}` : ""}`;
  feedback.className = `feedback ${correct ? "correct" : "incorrect"}`;
  feedback.hidden = false;
  input.readOnly = true;
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
let quizHistory = [];
let quizCursor = -1;

function formatChemicalInput(value) {
  const trimmed = value.trim();
  if (!/^[a-zA-Z0-9]+$/.test(trimmed)) return value;
  const knownSymbols = [...formulas, ...valences, ...elements].map((item) => item.symbol);
  return knownSymbols.find((symbol) => symbol.toLowerCase() === trimmed.toLowerCase()) || value;
}

function takeNextQuizQuestion() {
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
  return {
    question: result.item,
    source,
    queueDone: result.done,
    queueTotal: result.total,
    answered: false,
    userAnswer: "",
    displayInput: "",
    result: null,
    feedbackText: ""
  };
}

function renderQuizHistoryEntry() {
  const entry = quizHistory[quizCursor];
  if (!entry) return;
  currentQuizQuestion = entry.question;
  quizAnswered = entry.answered;
  document.querySelector("#quiz-round-label").textContent =
    entry.source === "review" ? "到期复习" : entry.source === "forced" ? "立即复习" : "普通测验";
  document.querySelector("#quiz-progress").textContent = `${entry.queueDone} / ${entry.queueTotal}`;
  document.querySelector("#quiz-position").textContent =
    `第 ${quizCursor + 1} / ${Math.max(quizHistory.length, entry.queueTotal)} 题`;
  document.querySelector("#quiz-source").textContent =
    entry.answered && quizCursor < quizHistory.length - 1
      ? "正在回看已答题目，回看不会重复计分。"
      : entry.source === "review" ? "正在优先完成到期错题。" : "每轮覆盖全部题型，同一题不会重复。";
  document.querySelector("#quiz-type").textContent = LABELS[currentQuizQuestion.type === "formula" ? "formulaType" : currentQuizQuestion.type];
  document.querySelector("#quiz-question").textContent = currentQuizQuestion.prompt;
  document.querySelector("#quiz-help").textContent = currentQuizQuestion.help;
  const input = document.querySelector("#quiz-input");
  input.value = entry.displayInput || entry.userAnswer;
  input.dataset.rawInput = "";
  input.disabled = false;
  input.readOnly = entry.answered;
  const feedback = document.querySelector("#quiz-feedback");
  feedback.textContent = entry.feedbackText;
  feedback.className = `feedback ${entry.result || ""}`;
  feedback.hidden = !entry.answered;
  document.querySelector("#submit-answer").hidden = entry.answered;
  document.querySelector("#previous-question").disabled = quizCursor === 0;
  document.querySelector("#next-question").hidden = !entry.answered;
  setTimeout(() => input.focus(), 50);
}

function nextQuizQuestion() {
  if (quizCursor < quizHistory.length - 1) {
    quizCursor += 1;
  } else {
    quizHistory.push(takeNextQuizQuestion());
    quizCursor = quizHistory.length - 1;
  }
  renderQuizHistoryEntry();
}

function previousQuizQuestion() {
  if (quizCursor <= 0) return;
  quizCursor -= 1;
  renderQuizHistoryEntry();
}

function submitQuiz() {
  const entry = quizHistory[quizCursor];
  if (!entry || entry.answered) return;
  const quizInput = document.querySelector("#quiz-input");
  const userAnswer = quizInput.dataset.rawInput || quizInput.value;
  quizInput.dataset.rawInput = "";
  const result = evaluate(currentQuizQuestion, userAnswer);
  quizAnswered = true;
  entry.answered = true;
  entry.userAnswer = userAnswer;
  entry.displayInput = formatChemicalInput(userAnswer);
  entry.result = result;
  quizSession.total += 1;
  if (result === "correct") {
    const substance = findSubstanceByQuestion(currentQuizQuestion);
    entry.feedbackText = currentQuizQuestion.answerKind === "chinese-name"
      ? `回答正确！\n${substance ? substanceDetails(substance) : `标准名称：${currentQuizQuestion.displayAnswer}`}`
      : `回答正确！\n你的答案：${userAnswer}\n正确答案：${currentQuizQuestion.displayAnswer}`;
    quizSession.correct += 1;
    quizSession.streak += 1;
    markCorrect(currentQuizQuestion);
  } else if (result === "partial") {
    const submitted = parseValences(document.querySelector("#quiz-input").value);
    const missing = currentQuizQuestion.answers.filter((answer) => !submitted.includes(answer));
    entry.feedbackText = `部分正确，常见化合价还有 ${missing.join("、")}\n你的答案：${userAnswer}\n正确答案：${currentQuizQuestion.displayAnswer}`;
    quizSession.streak = 0;
    markWrong(currentQuizQuestion);
  } else {
    const wrongExplanation = explainWrongAnswer(userAnswer, currentQuizQuestion.displayAnswer);
    entry.feedbackText =
      `回答错误。\n正确答案是：${currentQuizQuestion.displayAnswer}。` +
      (wrongExplanation.found ? `\n${wrongExplanation.explanation}` : "");
    quizSession.streak = 0;
    markWrong(currentQuizQuestion);
  }
  recordEquationResult(currentQuizQuestion, result);
  recordDaily(result);
  document.querySelector("#quiz-streak").textContent = quizSession.streak;
  document.querySelector("#quiz-total").textContent = quizSession.total;
  document.querySelector("#quiz-accuracy").textContent =
    `${Math.round(quizSession.correct / quizSession.total * 100)}%`;
  renderQuizHistoryEntry();
}

function findSubstanceByQuestion(question) {
  return question?.category === "formula"
    ? formulas.find((item) => item.id === question.itemId) || null
    : null;
}

/* -------------------------- Offline question answer ----------------------- */
function normalizeQuestion(value) {
  return value
    .trim()
    .replace(/\s+/g, "")
    .replace(/[？?。！!，,；;：:“”"'（）()]/g, "")
    .toUpperCase();
}

function extractQuestionCore(input) {
  return normalizeQuestion(input)
    .replace(/^(请问|请告诉我|我想知道)/, "")
    .replace(/(是什么反应|是何反应|的化合价|常见化合价|是什么|是啥|叫啥|反应)$/g, "");
}

function canonicalizeSubstanceTerms(value) {
  let result = normalizeQuestion(value);
  formulas.forEach((item) => {
    item.aliases.forEach((alias) => {
      result = result.replaceAll(normalizeQuestion(alias), normalizeQuestion(item.name));
    });
  });
  return result;
}

function formatValences(values) {
  return values.join(" 和 ");
}

function formulaAnswer(item, suggestion = false, matchedText = "") {
  const prefix = suggestion ? `你可能想问的是 ${item.symbol}。\n` : "";
  const matchedAlias = item.aliases.find((alias) =>
    normalizeQuestion(alias) === normalizeQuestion(matchedText));
  if (matchedAlias === "干冰") {
    return `${prefix}干冰是二氧化碳（CO2）的固体形式。`;
  }
  if (matchedAlias) {
    return `${prefix}${matchedAlias}是${item.name}（${item.formula}）。` +
      (item.aliases.length > 1
        ? `\n其他常见俗名：${item.aliases.filter((alias) => alias !== matchedAlias).join("、")}。`
        : "");
  }
  return `${prefix}${item.formula} 是${item.name}。` +
    (item.aliases.length ? `\n俗名或生活名称：${item.aliases.join("、")}。` : "");
}

function valenceAnswer(item, askValenceOnly = false) {
  const values = formatValences(item.valences);
  if (item.subgroup === "radical") {
    return `${item.symbol} 是${item.name}。\n常见化合价是 ${values}。`;
  }
  return askValenceOnly
    ? `${item.symbol} ${item.name}的常见化合价是 ${values}。`
    : `${item.symbol} 是${item.name}。\n常见化合价是 ${values}。`;
}

function equationAnswer(item) {
  return `对应反应是：\n${item.equation}\n条件：${item.condition}\n现象：${item.phenomenon}。`;
}

function levenshtein(left, right) {
  const rows = Array.from({ length: left.length + 1 }, () => Array(right.length + 1).fill(0));
  for (let row = 0; row <= left.length; row += 1) rows[row][0] = row;
  for (let column = 0; column <= right.length; column += 1) rows[0][column] = column;
  for (let row = 1; row <= left.length; row += 1) {
    for (let column = 1; column <= right.length; column += 1) {
      rows[row][column] = Math.min(
        rows[row - 1][column] + 1,
        rows[row][column - 1] + 1,
        rows[row - 1][column - 1] + (left[row - 1] === right[column - 1] ? 0 : 1)
      );
    }
  }
  return rows[left.length][right.length];
}

function commonPrefixLength(left, right) {
  let length = 0;
  while (length < left.length && length < right.length && left[length] === right[length]) length += 1;
  return length;
}

function fuzzyFormula(core) {
  if (!core || core.length < 2) return null;
  const correctedCore = core.replace(/0/g, "O");
  const ranked = formulas.map((item) => {
    const candidate = normalizeQuestion(item.symbol);
    const distance = levenshtein(correctedCore, candidate);
    const score = distance - commonPrefixLength(correctedCore, candidate) * 0.2;
    return { item, distance, score };
  }).sort((left, right) => left.score - right.score);
  const best = ranked[0];
  const limit = Math.max(1, Math.floor(Math.max(correctedCore.length, normalizeQuestion(best.item.symbol).length) * 0.4));
  return best.distance <= limit ? best.item : null;
}

function enableTestMode() {
  if (localStorage.getItem("devUnlockAll") !== "true") {
    localStorage.setItem("devUnlockPreviousLevel", String(equationProgress.unlockedLevel));
  }
  localStorage.setItem("devUnlockAll", "true");
  equationProgress.unlockedLevel = 3;
  StorageService.save(STORAGE.equations, equationProgress);
  flashcardQueue.reset();
  quizQueue.reset();
  reviewQueue.reset();
  renderEquationModule();
}

function unlockedLevelFromLearningProgress() {
  let level = 1;
  for (let current = 1; current < 3; current += 1) {
    const progress = equationProgress.levels?.[current] || { attempts: 0, correct: 0 };
    const accuracy = progress.attempts ? progress.correct / progress.attempts : 0;
    if (progress.attempts >= EQUATION_UNLOCK_ATTEMPTS && accuracy >= EQUATION_UNLOCK_ACCURACY) {
      level = current + 1;
    } else {
      break;
    }
  }
  return level;
}

function disableTestMode() {
  if (localStorage.getItem("devUnlockAll") !== "true") return false;
  const previousLevel = Number(localStorage.getItem("devUnlockPreviousLevel"));
  equationProgress.unlockedLevel = [1, 2, 3].includes(previousLevel)
    ? previousLevel
    : unlockedLevelFromLearningProgress();
  localStorage.removeItem("devUnlockAll");
  localStorage.removeItem("devUnlockPreviousLevel");
  StorageService.save(STORAGE.equations, equationProgress);
  flashcardQueue.reset();
  quizQueue.reset();
  reviewQueue.reset();
  renderEquationModule();
  return true;
}

function answerQuestion(input) {
  const normalized = normalizeQuestion(input);
  if (normalized === "OLO") {
    enableTestMode();
    return {
      found: true,
      type: "dev-unlock",
      answer: "测试模式已开启，所有关卡已解锁。"
    };
  }
  if (normalized === "GG") {
    const disabled = disableTestMode();
    return {
      found: true,
      type: "dev-lock",
      answer: disabled
        ? "测试模式已关闭，关卡已重新上锁。"
        : "当前已经是正常学习模式。"
    };
  }
  const core = extractQuestionCore(input);
  if (!core) {
    return { found: false, type: "empty", answer: "请先输入一个想了解的化学问题。" };
  }

  const asksValence = normalized.includes("化合价");
  const asksReaction = normalized.includes("反应") || normalized.includes("浑浊") || normalized.includes("现象");
  const canonicalCore = canonicalizeSubstanceTerms(core);
  const equation = equations.find((item) => {
    const name = canonicalizeSubstanceTerms(item.name);
    const phenomenon = normalizeQuestion(item.phenomenon);
    return name === canonicalCore || name.includes(canonicalCore) || phenomenon.includes(core);
  });
  if (equation && (asksReaction || core.length >= 4)) {
    return { found: true, type: "equation", answer: equationAnswer(equation) };
  }

  const formula = findSubstance(core);
  if (formula) {
    return { found: true, type: "formula", answer: formulaAnswer(formula, false, core) };
  }

  const radical = valences.find((item) => item.subgroup === "radical" &&
    (normalizeQuestion(item.symbol) === core || normalizeQuestion(item.name) === core));
  if (radical) return { found: true, type: "radical", answer: valenceAnswer(radical, asksValence) };

  const valence = valences.find((item) =>
    normalizeQuestion(item.symbol) === core || normalizeQuestion(item.name) === core);
  if (valence) return { found: true, type: "element", answer: valenceAnswer(valence, asksValence) };

  const element = elements.find((item) =>
    normalizeQuestion(item.symbol) === core || normalizeQuestion(item.name) === core);
  if (element) {
    return {
      found: true,
      type: "element",
      answer: `${element.symbol} 是${element.name}，是第 ${element.atomicNumber} 号元素。`
    };
  }

  const correctedFormula = fuzzyFormula(core);
  if (correctedFormula) {
    return { found: true, type: "suggestion", answer: formulaAnswer(correctedFormula, true) };
  }

  return {
    found: false,
    type: "unknown",
    answer: "我暂时没有在本地知识库找到这个内容，可以先检查拼写，或以后扩展知识库。"
  };
}

function renderChat() {
  const container = document.querySelector("#chat-history");
  container.replaceChildren();
  const messages = chatHistory.length ? chatHistory : [{
    role: "assistant",
    text: "你好！我只使用网页内置的化学知识库回答问题。\n你可以问我元素、化合价、原子团、化学式或常见反应。"
  }];
  messages.forEach((message) => {
    const row = document.createElement("div");
    row.className = `chat-message ${message.role}`;
    const bubble = document.createElement("div");
    bubble.className = "chat-bubble";
    bubble.textContent = message.text;
    row.appendChild(bubble);
    container.appendChild(row);
  });
  container.scrollTop = container.scrollHeight;
}

function submitQuestion(prefilledQuestion) {
  const input = document.querySelector("#ask-input");
  const question = typeof prefilledQuestion === "string" ? prefilledQuestion : input.value;
  if (!question.trim()) return;
  const response = answerQuestion(question);
  chatHistory.push({ role: "user", text: question.trim() });
  chatHistory.push({ role: "assistant", text: response.answer, type: response.type });
  chatHistory = chatHistory.slice(-40);
  StorageService.save(STORAGE.chat, chatHistory);
  input.value = "";
  renderChat();
  input.focus();
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
        <div class="mastery-stars">${starsText(mastery[record.id])}</div>
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
  document.querySelector("#study-mode-selector").addEventListener("click", (event) => {
    const button = event.target.closest("[data-mode]");
    if (button) setStudyMode(button.dataset.mode);
  });
  document.querySelector("#toggle-focus").addEventListener("click", () => {
    document.body.classList.add("focus-mode");
    document.querySelector("#exit-focus").hidden = false;
    document.querySelector("#quiz-input").focus();
  });
  document.querySelector("#exit-focus").addEventListener("click", () => {
    document.body.classList.remove("focus-mode");
    document.querySelector("#exit-focus").hidden = true;
  });

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
      if (event.key !== "Enter" || event.isComposing) return;
      event.preventDefault();
      const input = document.querySelector(`#${kind}-answer`);
      input.readOnly ? showMiniQuestion(kind) : submitMiniQuestion(kind);
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

  document.querySelector("#equation-filters").addEventListener("click", (event) => {
    const button = event.target.closest(".filter");
    if (!button) return;
    selectedEquationLevel = Number(button.dataset.level);
    renderEquationModule();
  });
  document.querySelector("#start-equation-quiz").addEventListener("click", startEquationQuiz);
  document.querySelector("#practice-unlocked-level").addEventListener("click", startEquationQuiz);

  document.querySelector("#send-question").addEventListener("click", () => submitQuestion());
  document.querySelector("#ask-input").addEventListener("keydown", (event) => {
    if (event.key === "Enter" && !event.isComposing) submitQuestion();
  });
  document.querySelector(".question-examples").addEventListener("click", (event) => {
    const button = event.target.closest("[data-question]");
    if (button) submitQuestion(button.dataset.question);
  });
  document.querySelector("#clear-chat").addEventListener("click", () => {
    chatHistory = [];
    StorageService.save(STORAGE.chat, chatHistory);
    renderChat();
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
  document.querySelector("#previous-question").addEventListener("click", previousQuizQuestion);
  document.querySelector("#next-question").addEventListener("click", nextQuizQuestion);
  document.querySelector("#quiz-input").addEventListener("keydown", (event) => {
    if (event.key !== "Enter" || event.isComposing) return;
    event.preventDefault();
    if (!quizAnswered) {
      submitQuiz();
    } else if (quizCursor === quizHistory.length - 1) {
      nextQuizQuestion();
    }
  });
  document.querySelector("#quiz-input").addEventListener("input", (event) => {
    event.currentTarget.dataset.rawInput = "";
  });
  document.querySelector("#quiz-input").addEventListener("blur", (event) => {
    const input = event.currentTarget;
    if (input.readOnly) return;
    const formatted = formatChemicalInput(input.value);
    if (formatted !== input.value) {
      input.dataset.rawInput = input.value;
      input.value = formatted;
    }
  });
  document.querySelector("#mistakes-list").addEventListener("click", (event) => {
    const review = event.target.closest(".review-now");
    const master = event.target.closest(".master-now");
    if (review) {
      forcedQuestion = questionMap.get(review.dataset.id);
      currentQuizQuestion = null;
      quizCursor = quizHistory.length - 1;
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
  renderEquationModule();
  renderChat();
  bindEvents();
  document.querySelector("#active-mode-label").textContent = MODE_LABELS[studyMode];
  document.querySelectorAll(".mode-card").forEach((button) =>
    button.classList.toggle("active", button.dataset.mode === studyMode));
  showMiniQuestion("element");
  showMiniQuestion("sequence");
  nextFlashcard();
  updateDashboard();
  document.querySelector("#today-date").textContent =
    new Intl.DateTimeFormat("zh-CN", { month: "long", day: "numeric", weekday: "short" }).format(new Date());
  setInterval(updateDashboard, 60000);
}

initialize();
