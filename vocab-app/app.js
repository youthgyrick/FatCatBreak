(function(){
  const STORAGE_WRONG='vocabAppWrongBook';
  const STORAGE_UNIT='vocabAppLastUnit';
  const STORAGE_MODE='vocabAppLastMode';
  const MODES=['英译中','中译英','拼写','听写'];
  const $=id=>document.getElementById(id);
  const data=window.VOCAB_DATA||[];
  let session={className:'',unitName:'',mode:'',words:[],index:0,correct:0,wrong:0,current:null,fromWrong:false};

  function show(id){['homeView','practiceView','resultView','wrongBookView'].forEach(v=>$(v).classList.toggle('hidden',v!==id));}
  function normalize(s){return String(s||'').trim().replace(/\s+/g,' ').toLowerCase();}
  function shuffle(arr){const a=arr.slice();for(let i=a.length-1;i>0;i--){const j=Math.floor(Math.random()*(i+1));[a[i],a[j]]=[a[j],a[i]];}return a;}
  function getWrongBook(){try{return JSON.parse(localStorage.getItem(STORAGE_WRONG)||'[]');}catch(e){return []}}
  function saveWrongBook(list){localStorage.setItem(STORAGE_WRONG,JSON.stringify(list));}
  function addWrong(word,mode){const list=getWrongBook();const className=word.className||session.className;const unitName=word.unitName||session.unitName;const key=`${className}__${unitName}__${word.word}`;let item=list.find(x=>x.key===key);if(!item){item={key,className,unitName,word:word.word,meaning:word.meaning,wrongModes:[],wrongCount:0,lastWrongAt:''};list.push(item);}item.wrongCount+=1;if(!item.wrongModes.includes(mode))item.wrongModes.push(mode);item.lastWrongAt=new Date().toISOString();saveWrongBook(list);}
  function removeWrong(key){saveWrongBook(getWrongBook().filter(x=>x.key!==key));renderWrongBook();}
  function speak(word){if(!('speechSynthesis'in window)){alert('当前浏览器不支持 SpeechSynthesis 发音。');return;}window.speechSynthesis.cancel();const u=new SpeechSynthesisUtterance(word);u.lang='en-US';u.rate=.85;window.speechSynthesis.speak(u);}
  function makeHint(word){let firstShown=false;return word.split('').map(ch=>{if(/[a-zA-Z]/.test(ch)){if(!firstShown){firstShown=true;return ch;}return '_';}return ch;}).join(' ');}

  function initHome(){
    $('classSelect').innerHTML=data.map((c,i)=>`<option value="${i}">${c.className}</option>`).join('');
    fillUnits();
    const lastUnit=localStorage.getItem(STORAGE_UNIT); const lastMode=localStorage.getItem(STORAGE_MODE);
    if(lastUnit) $('unitSelect').value=lastUnit; if(lastMode&&MODES.includes(lastMode)) $('modeSelect').value=lastMode;
  }
  function fillUnits(){const cls=data[$('classSelect').value];$('unitSelect').innerHTML=cls.units.map((u,i)=>`<option value="${i}">${u.unitName}（${u.words.length}词）</option>`).join('');}
  function startPractice(words, className, unitName, mode, fromWrong=false){
    if(!words.length){alert('没有可练习的单词。');return;} localStorage.setItem(STORAGE_UNIT,$('unitSelect').value); localStorage.setItem(STORAGE_MODE,mode);
    session={className,unitName,mode,words:shuffle(words),index:0,correct:0,wrong:0,current:null,fromWrong};show('practiceView');renderQuestion();
  }
  function startSelected(){const cls=data[$('classSelect').value], unit=cls.units[$('unitSelect').value], mode=$('modeSelect').value;startPractice(unit.words,cls.className,unit.unitName,mode);}
  function renderQuestion(){
    if(session.index>=session.words.length){return renderResult();}
    session.current=session.words[session.index];$('feedbackArea').classList.add('hidden');$('feedbackArea').innerHTML='';
    $('practiceTitle').textContent=`${session.className} / ${session.unitName} / ${session.mode}`;$('progressText').textContent=`第 ${session.index+1} / ${session.words.length} 题`;
    const w=session.current;let html='';
    if(session.mode==='英译中') html=`<div class="prompt">${w.word}</div><button id="showAnswerBtn" class="primary">显示答案</button><div id="selfCheck" class="hidden"><div class="meaning">${w.meaning}</div><div class="actions"><button id="selfRight" class="primary">我答对了</button><button id="selfWrong" class="danger">我答错了</button></div></div>`;
    if(session.mode==='中译英') html=`<div class="meaning">${w.meaning}</div><label>请输入英文：<input id="answerInput" autocomplete="off" autofocus></label><button id="submitBtn" class="primary">提交</button>`;
    if(session.mode==='拼写') html=`<div class="meaning">${w.meaning}</div><p>提示：<span class="hint">${makeHint(w.word)}</span></p><label>请输入完整单词：<input id="answerInput" autocomplete="off" autofocus></label><button id="submitBtn" class="primary">提交</button>`;
    if(session.mode==='听写') html=`<p class="prompt">点击播放单词</p><button id="playBtn" class="primary">播放 / 重复播放</button><label>请输入听到的单词：<input id="answerInput" autocomplete="off" autofocus></label><button id="submitBtn" class="primary">提交</button>`;
    $('questionArea').innerHTML=html;
    if($('showAnswerBtn')) $('showAnswerBtn').onclick=()=>$('selfCheck').classList.remove('hidden');
    if($('selfRight')) $('selfRight').onclick=()=>answer(true,'');
    if($('selfWrong')) $('selfWrong').onclick=()=>answer(false,'');
    if($('submitBtn')) $('submitBtn').onclick=()=>answer(normalize($('answerInput').value)===normalize(w.word),$('answerInput').value);
    if($('answerInput')) $('answerInput').onkeydown=e=>{if(e.key==='Enter')$('submitBtn').click();};
    if($('playBtn')) {$('playBtn').onclick=()=>speak(w.word); setTimeout(()=>speak(w.word),250);}
  }
  function answer(ok,userAnswer){const w=session.current;if(ok)session.correct++;else{session.wrong++;addWrong(w,session.mode);}showFeedback(ok,w,userAnswer);}
  function showFeedback(ok,w,userAnswer){$('feedbackArea').classList.remove('hidden');$('feedbackArea').innerHTML=`<p class="${ok?'correct':'wrong'}">${ok?'正确':'错误'}</p>${userAnswer?`<p>你的答案：${userAnswer}</p>`:''}<p>正确答案：<strong>${w.word}</strong></p><p>中文释义：${w.meaning}</p><button id="nextBtn" class="primary">下一题</button>`;$('nextBtn').onclick=()=>{session.index++;renderQuestion();};}
  function renderResult(){show('resultView');$('resultStats').innerHTML=`<p>总题数：${session.words.length}</p><p class="correct">正确数：${session.correct}</p><p class="wrong">错误数：${session.wrong}</p>`;}
  function renderWrongBook(){show('wrongBookView');const list=getWrongBook();$('wrongCount').textContent=`错题总数：${list.length}`;const units=['全部',...new Set(list.map(x=>x.unitName))];const old=$('wrongUnitFilter').value;$('wrongUnitFilter').innerHTML=units.map(u=>`<option>${u}</option>`).join('');if(units.includes(old))$('wrongUnitFilter').value=old;const filter=$('wrongUnitFilter').value||'全部';const shown=filter==='全部'?list:list.filter(x=>x.unitName===filter);$('wrongList').innerHTML=shown.length?shown.map(item=>`<div class="wrong-item"><h3>${item.word}</h3><p>${item.meaning}</p><p>${item.unitName}</p><p>错误次数：${item.wrongCount}</p><p>错误模式：${item.wrongModes.join('、')||'无'}</p><p class="small">最后错误：${new Date(item.lastWrongAt).toLocaleString()}</p><button data-remove="${item.key}">移除错题</button></div>`).join(''):'<p class="muted">暂无错题。</p>';$('wrongList').querySelectorAll('[data-remove]').forEach(b=>b.onclick=()=>removeWrong(b.dataset.remove));}
  function practiceWrong(){const list=getWrongBook();const filter=$('wrongUnitFilter').value||'全部';const chosen=filter==='全部'?list:list.filter(x=>x.unitName===filter);const words=chosen.map(x=>({id:x.key,word:x.word,meaning:x.meaning,className:x.className,unitName:x.unitName}));startPractice(words,'Class 8 下',filter==='全部'?'全部错题':filter,$('wrongModeSelect').value,true);}

  $('classSelect').onchange=fillUnits;$('startBtn').onclick=startSelected;$('wrongBookBtn').onclick=renderWrongBook;$('homeBtn').onclick=()=>show('homeView');$('resultHomeBtn').onclick=()=>show('homeView');$('wrongHomeBtn').onclick=()=>show('homeView');$('wrongUnitFilter').onchange=renderWrongBook;$('practiceAllWrongBtn').onclick=practiceWrong;$('practiceWrongBtn').onclick=renderWrongBook;$('clearWrongBtn').onclick=()=>{if(confirm('确定清空错题本吗？')){saveWrongBook([]);renderWrongBook();}};
  initHome();show('homeView');
})();
