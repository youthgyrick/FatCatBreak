/** Lightweight presentation controls: no dependencies, works from file:// and static servers. */
const slides = [...document.querySelectorAll('.slide')];
const deck = document.getElementById('deck');
const chapter = document.getElementById('chapter');
const progress = document.getElementById('progress');
const current = document.getElementById('current');
const total = document.getElementById('total');
const prevBtn = document.getElementById('prevBtn');
const nextBtn = document.getElementById('nextBtn');
const fullscreenBtn = document.getElementById('fullscreenBtn');
const overviewBtn = document.getElementById('overviewBtn');
const overview = document.getElementById('overview');
const overviewGrid = document.getElementById('overviewGrid');
const closeOverview = document.getElementById('closeOverview');
const keyboardHint = document.getElementById('keyboardHint');
let index = 0;
let touchStartX = 0;
let touchStartY = 0;

const pad = value => String(value).padStart(2, '0');

total.textContent = pad(slides.length);
slides.forEach((slide, slideIndex) => {
  const button = document.createElement('button');
  button.type = 'button';
  button.className = 'overview-item';
  button.innerHTML = `<span>${pad(slideIndex + 1)}</span><strong>${slide.dataset.title}</strong>`;
  button.addEventListener('click', () => {
    setSlide(slideIndex);
    toggleOverview(false);
  });
  overviewGrid.appendChild(button);
});

function setSlide(nextIndex, updateHash = true) {
  const bounded = Math.max(0, Math.min(slides.length - 1, nextIndex));
  slides[index].classList.remove('active');
  index = bounded;
  slides[index].classList.add('active');
  current.textContent = pad(index + 1);
  chapter.textContent = slides[index].dataset.title.toUpperCase();
  progress.style.width = `${((index + 1) / slides.length) * 100}%`;
  prevBtn.disabled = index === 0;
  nextBtn.disabled = index === slides.length - 1;
  document.title = `${slides[index].dataset.title} | AWS AI/ML Specialist BD`;
  if (updateHash) history.replaceState(null, '', `#${index + 1}`);
}

function toggleOverview(force) {
  const open = typeof force === 'boolean' ? force : !overview.classList.contains('open');
  overview.classList.toggle('open', open);
  overview.setAttribute('aria-hidden', String(!open));
  deck.classList.toggle('overview-open', open);
}

async function toggleFullscreen() {
  if (!document.fullscreenElement) {
    await document.documentElement.requestFullscreen?.();
  } else {
    await document.exitFullscreen?.();
  }
}

prevBtn.addEventListener('click', () => setSlide(index - 1));
nextBtn.addEventListener('click', () => setSlide(index + 1));
fullscreenBtn.addEventListener('click', toggleFullscreen);
overviewBtn.addEventListener('click', () => toggleOverview());
closeOverview.addEventListener('click', () => toggleOverview(false));

document.addEventListener('keydown', event => {
  if (overview.classList.contains('open') && event.key === 'Escape') return toggleOverview(false);
  if (['ArrowRight', 'PageDown', ' '].includes(event.key)) { event.preventDefault(); setSlide(index + 1); }
  if (['ArrowLeft', 'PageUp'].includes(event.key)) { event.preventDefault(); setSlide(index - 1); }
  if (event.key === 'Home') setSlide(0);
  if (event.key === 'End') setSlide(slides.length - 1);
  if (event.key.toLowerCase() === 'f') toggleFullscreen();
  if (event.key.toLowerCase() === 'o') toggleOverview();
});

document.addEventListener('touchstart', event => {
  touchStartX = event.changedTouches[0].screenX;
  touchStartY = event.changedTouches[0].screenY;
}, { passive: true });

document.addEventListener('touchend', event => {
  const dx = event.changedTouches[0].screenX - touchStartX;
  const dy = event.changedTouches[0].screenY - touchStartY;
  if (Math.abs(dx) > 50 && Math.abs(dx) > Math.abs(dy)) setSlide(index + (dx < 0 ? 1 : -1));
}, { passive: true });

window.addEventListener('hashchange', () => {
  const hashIndex = Number(location.hash.slice(1)) - 1;
  if (Number.isInteger(hashIndex)) setSlide(hashIndex, false);
});

window.setTimeout(() => keyboardHint.classList.add('hidden'), 4500);
const initialIndex = Number(location.hash.slice(1)) - 1;
setSlide(Number.isInteger(initialIndex) ? initialIndex : 0, false);
