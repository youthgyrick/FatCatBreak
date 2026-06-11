const slides=[...document.querySelectorAll('.slide')];
const current=document.getElementById('current');
const total=document.getElementById('total');
const progress=document.getElementById('progress');
const sectionName=document.getElementById('sectionName');
const prev=document.getElementById('prev');
const next=document.getElementById('next');
let index=0,startX=0,startY=0;
const pad=n=>String(n).padStart(2,'0');
const highlightSelector=['article','.node','.arch-box','.layer','.agent','.top-node','.question','.validator','.system-band span','.service-map span','.path span','.path strong','.result-strip span','.feature-grid article','.value-list article','.code-tree>div','tbody tr','.detail-card','.takeaway'].join(',');
document.querySelectorAll(highlightSelector).forEach(element=>element.classList.add('click-highlightable'));
function clearHighlight(){document.querySelector('.is-highlighted')?.classList.remove('is-highlighted')}
function show(i,hash=true){
  index=Math.max(0,Math.min(slides.length-1,i));
  slides.forEach((slide,n)=>slide.classList.toggle('active',n===index));
  clearHighlight();
  current.textContent=pad(index+1); total.textContent=pad(slides.length);
  progress.style.width=`${(index+1)/slides.length*100}%`;
  sectionName.textContent=slides[index].dataset.section.toUpperCase();
  prev.disabled=index===0; next.disabled=index===slides.length-1;
  if(hash) history.replaceState(null,'',`#${index+1}`);
}
document.addEventListener('click',event=>{
  if(event.target.closest('.controls'))return;
  const target=event.target.closest('.click-highlightable');
  if(target&&target.closest('.slide.active')){const active=target.classList.contains('is-highlighted');clearHighlight();if(!active)target.classList.add('is-highlighted');event.stopPropagation();return}
  if(event.target.closest('.slide.active'))clearHighlight();
});
prev.addEventListener('click',()=>show(index-1));next.addEventListener('click',()=>show(index+1));
document.getElementById('fullscreen').addEventListener('click',()=>document.fullscreenElement?document.exitFullscreen():document.documentElement.requestFullscreen?.());
document.addEventListener('keydown',event=>{if(['ArrowRight','PageDown',' '].includes(event.key)){event.preventDefault();show(index+1)}if(['ArrowLeft','PageUp'].includes(event.key)){event.preventDefault();show(index-1)}if(event.key==='Home')show(0);if(event.key==='End')show(slides.length-1);if(event.key==='Escape')clearHighlight();if(event.key.toLowerCase()==='f')document.getElementById('fullscreen').click()});
document.addEventListener('touchstart',event=>{startX=event.changedTouches[0].screenX;startY=event.changedTouches[0].screenY},{passive:true});
document.addEventListener('touchend',event=>{const dx=event.changedTouches[0].screenX-startX,dy=event.changedTouches[0].screenY-startY;if(Math.abs(dx)>50&&Math.abs(dx)>Math.abs(dy))show(index+(dx<0?1:-1))},{passive:true});
window.addEventListener('hashchange',()=>{const n=Number(location.hash.slice(1));if(n)show(n-1,false)});
show(Math.max(0,(Number(location.hash.slice(1))||1)-1),false);
